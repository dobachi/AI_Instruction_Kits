#!/usr/bin/env python3
"""
モジュラー指示書コンポーザー
モジュールを組み合わせて指示書を生成する
"""

import os
import yaml
import argparse
from pathlib import Path
from typing import Dict, List, Any, Optional
import re


class ModuleComposer:
    def __init__(self, base_dir: str = "modular"):
        self.base_dir = Path(base_dir)
        self.modules_dir = self.base_dir / "modules"
        self.templates_dir = self.base_dir / "templates"
        self.cache_dir = self.base_dir / "cache"
        self.cache_dir.mkdir(exist_ok=True)
        
    def load_module(self, module_id: str) -> Dict[str, Any]:
        """モジュールを読み込む"""
        # モジュールのパスを探す
        category_map = {
            "core": "core",
            "task": "tasks",
            "skill": "skills",
            "quality": "quality"
        }
        
        for prefix, category in category_map.items():
            if module_id.startswith(f"{prefix}_"):
                # プレフィックスを削除してファイル名を作成
                file_name = module_id.replace(f"{prefix}_", "")
                module_path = self.modules_dir / category / f"{file_name}.md"
                meta_path = module_path.with_suffix('.yaml')
                
                if module_path.exists() and meta_path.exists():
                    with open(module_path, 'r', encoding='utf-8') as f:
                        content = f.read()
                    with open(meta_path, 'r', encoding='utf-8') as f:
                        metadata = yaml.safe_load(f)
                    
                    return {
                        'id': module_id,
                        'content': content,
                        'metadata': metadata
                    }
        
        raise FileNotFoundError(f"Module not found: {module_id}")
    
    def load_preset(self, preset_name: str) -> Dict[str, Any]:
        """プリセットを読み込む"""
        preset_path = self.templates_dir / "presets" / f"{preset_name}.yaml"
        
        if not preset_path.exists():
            raise FileNotFoundError(f"Preset not found: {preset_name}")
        
        with open(preset_path, 'r', encoding='utf-8') as f:
            return yaml.safe_load(f)
    
    def replace_variables(self, content: str, variables: Dict[str, str]) -> str:
        """変数を置換する"""
        # 通常の変数置換
        for key, value in variables.items():
            # {{variable}} 形式の変数を置換
            pattern = r'\{\{' + re.escape(key) + r'\}\}'
            content = re.sub(pattern, str(value), content)
        
        # 条件付きセクションの処理 {{#if variable}}...{{/if}}
        if_pattern = r'\{\{#if\s+(\w+)\}\}(.*?)\{\{/if\}\}'
        def replace_if(match):
            var_name = match.group(1)
            section_content = match.group(2)
            if var_name in variables and variables[var_name]:
                return section_content
            return ''
        content = re.sub(if_pattern, replace_if, content, flags=re.DOTALL)
        
        # 未置換の変数を削除（空文字列に置換）
        remaining_vars = r'\{\{[^}]+\}\}'
        content = re.sub(remaining_vars, '', content)
        
        # 連続する空行を1つに削減
        content = re.sub(r'\n\n\n+', '\n\n', content)
        
        return content
    
    def compose_modules(self, module_ids: List[str], variables: Dict[str, str] = None) -> str:
        """モジュールを結合して指示書を生成"""
        if variables is None:
            variables = {}
            
        sections = []
        
        # ヘッダー
        sections.append("# AI指示書\n")
        sections.append("*この指示書はモジュラーシステムによって自動生成されました*\n")
        
        # 各モジュールを読み込んで結合
        for module_id in module_ids:
            try:
                module = self.load_module(module_id)
                content = module['content']
                
                # 変数を置換
                content = self.replace_variables(content, variables)
                
                sections.append(content)
                sections.append("\n---\n")  # セクション区切り
                
            except FileNotFoundError as e:
                print(f"警告: {e}")
                continue
        
        # 最後の区切り線を削除
        if sections and sections[-1] == "\n---\n":
            sections.pop()
        
        return '\n'.join(sections)
    
    def generate_from_preset(self, preset_name: str, overrides: Dict[str, str] = None) -> str:
        """プリセットから指示書を生成"""
        preset = self.load_preset(preset_name)
        
        # 変数をマージ
        variables = preset.get('variables', {})
        if 'defaults' in preset:
            variables = {**preset['defaults'], **variables}
        if overrides:
            variables = {**variables, **overrides}
        
        # モジュールを結合
        return self.compose_modules(preset['modules'], variables)
    
    def save_instruction(self, content: str, filename: str) -> Path:
        """生成した指示書を保存"""
        output_path = self.cache_dir / filename
        
        with open(output_path, 'w', encoding='utf-8') as f:
            f.write(content)
        
        return output_path
    
    def get_metadata_summary(self) -> str:
        """AIが判断するためのメタデータサマリーを生成"""
        summary_lines = ["# 利用可能なモジュール一覧\n"]
        
        category_names = {
            "core": "コア（基本設定）",
            "tasks": "タスク（実行内容）",
            "skills": "スキル（追加能力）",
            "quality": "品質（品質基準）"
        }
        
        for category, display_name in category_names.items():
            category_dir = self.modules_dir / category
            if category_dir.exists():
                summary_lines.append(f"\n## {display_name}\n")
                
                for yaml_file in sorted(category_dir.glob("*.yaml")):
                    with open(yaml_file, 'r', encoding='utf-8') as f:
                        meta = yaml.safe_load(f)
                    
                    summary_lines.append(f"### {meta['id']}")
                    summary_lines.append(f"- **名前**: {meta['name']}")
                    summary_lines.append(f"- **説明**: {meta['description']}")
                    
                    if 'tags' in meta:
                        summary_lines.append(f"- **タグ**: {', '.join(meta['tags'])}")
                    
                    if 'dependencies' in meta:
                        summary_lines.append(f"- **依存関係**: {', '.join(meta['dependencies'])}")
                    
                    if 'compatible_with' in meta or 'compatible_modules' in meta:
                        compat = meta.get('compatible_with', meta.get('compatible_modules', []))
                        summary_lines.append(f"- **互換性**: {', '.join(compat)}")
                    
                    summary_lines.append("")  # 空行
        
        return '\n'.join(summary_lines)


def main():
    parser = argparse.ArgumentParser(description='モジュラー指示書コンポーザー')
    
    # サブコマンド
    subparsers = parser.add_subparsers(dest='command', help='コマンド')
    
    # プリセットから生成
    preset_parser = subparsers.add_parser('preset', help='プリセットから生成')
    preset_parser.add_argument('name', help='プリセット名')
    preset_parser.add_argument('-o', '--output', help='出力ファイル名')
    preset_parser.add_argument('-v', '--variable', action='append', 
                              help='変数のオーバーライド (key=value形式)')
    
    # モジュールを直接指定
    modules_parser = subparsers.add_parser('modules', help='モジュールを直接指定')
    modules_parser.add_argument('modules', nargs='+', help='モジュールID')
    modules_parser.add_argument('-o', '--output', help='出力ファイル名')
    modules_parser.add_argument('-v', '--variable', action='append',
                               help='変数の設定 (key=value形式)')
    
    # リスト表示
    list_parser = subparsers.add_parser('list', help='利用可能な要素を表示')
    list_parser.add_argument('type', choices=['presets', 'modules'], 
                            help='表示するタイプ')
    
    # メタデータサマリー表示（AI分析用）
    metadata_parser = subparsers.add_parser('metadata', help='AIが分析するためのメタデータサマリーを表示')
    
    args = parser.parse_args()
    
    composer = ModuleComposer()
    
    if args.command == 'preset':
        # 変数のパース
        overrides = {}
        if args.variable:
            for var in args.variable:
                key, value = var.split('=', 1)
                overrides[key] = value
        
        # 生成
        content = composer.generate_from_preset(args.name, overrides)
        
        # 保存
        output_name = args.output or f"{args.name}_generated.md"
        output_path = composer.save_instruction(content, output_name)
        
        print(f"指示書を生成しました: {output_path}")
        
    elif args.command == 'modules':
        # 変数のパース
        variables = {}
        if args.variable:
            for var in args.variable:
                key, value = var.split('=', 1)
                variables[key] = value
        
        # 生成
        content = composer.compose_modules(args.modules, variables)
        
        # 保存
        output_name = args.output or "custom_instruction.md"
        output_path = composer.save_instruction(content, output_name)
        
        print(f"指示書を生成しました: {output_path}")
        
    elif args.command == 'list':
        if args.type == 'presets':
            presets_dir = composer.templates_dir / "presets"
            print("利用可能なプリセット:")
            for preset_file in presets_dir.glob("*.yaml"):
                print(f"  - {preset_file.stem}")
                
        elif args.type == 'modules':
            print("利用可能なモジュール:")
            for category in ["core", "tasks", "skills", "quality"]:
                category_dir = composer.modules_dir / category
                if category_dir.exists():
                    print(f"\n{category}:")
                    for module_file in category_dir.glob("*.yaml"):
                        with open(module_file, 'r', encoding='utf-8') as f:
                            meta = yaml.safe_load(f)
                            print(f"  - {meta['id']}: {meta['name']}")
    
    elif args.command == 'metadata':
        # AIが分析するためのメタデータサマリーを表示
        summary = composer.get_metadata_summary()
        print(summary)
    
    else:
        parser.print_help()


if __name__ == "__main__":
    main()