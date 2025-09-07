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
    def __init__(self, base_dir: str = "modular", lang: str = "ja", use_concise: bool = True):
        self.base_dir = Path(base_dir)
        self.lang = lang
        self.modules_dir = self.base_dir / lang / "modules"
        self.templates_dir = self.base_dir / lang / "templates"
        self.cache_dir = self.base_dir / "cache"
        self.cache_dir.mkdir(exist_ok=True)
        self.use_concise = use_concise  # 簡潔版の使用フラグ
        
    def load_module(self, module_id: str) -> Dict[str, Any]:
        """モジュールを読み込む"""
        # モジュールのパスを探す
        category_map = {
            "core": "core",
            "task": "tasks",
            "skill": "skills",
            "quality": "quality",
            "expertise": "expertise",
            "role": "roles",
            "method": "methods"
        }
        
        for prefix, category in category_map.items():
            if module_id.startswith(f"{prefix}_"):
                # プレフィックスを削除してファイル名を作成
                file_name = module_id.replace(f"{prefix}_", "")
                
                # 新しいロジック：デフォルト（簡潔版）と詳細版の選択
                if self.use_concise:
                    # デフォルトパス（簡潔版）
                    module_path = self.modules_dir / category / f"{file_name}.md"
                else:
                    # 詳細版を探す
                    detailed_path = self.modules_dir / category / f"{file_name}_detailed.md"
                    if detailed_path.exists():
                        module_path = detailed_path
                    else:
                        # 詳細版がない場合はデフォルトを使用（後方互換性）
                        module_path = self.modules_dir / category / f"{file_name}.md"
                
                meta_path = self.modules_dir / category / f"{file_name}.yaml"
                
                if module_path.exists() and meta_path.exists():
                    with open(module_path, 'r', encoding='utf-8') as f:
                        content = f.read()
                    with open(meta_path, 'r', encoding='utf-8') as f:
                        metadata = yaml.safe_load(f)
                    
                    # 使用しているバージョンの情報をメタデータに追加
                    if not self.use_concise and module_path.name.endswith('_detailed.md'):
                        metadata['is_detailed'] = True
                    else:
                        metadata['is_concise'] = True
                    
                    return {
                        'id': module_id,
                        'content': content,
                        'metadata': metadata
                    }
        
        raise FileNotFoundError(f"Module not found: {module_id}")
    
    def load_preset(self, preset_name: str) -> Dict[str, Any]:
        """プリセットを読み込む（言語別対応）"""
        preset_path = self.base_dir / self.lang / "presets" / f"{preset_name}.yaml"
        
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
            
        # すべてのモジュールから変数情報を収集
        all_defaults = {}
        required_variables = {}  # 必須変数を追跡
        applied_defaults = {}  # 実際に適用されたデフォルト値を追跡
        
        for module_id in module_ids:
            try:
                module = self.load_module(module_id)
                metadata = module.get('metadata', {})
                
                # 変数定義から情報を抽出
                if 'variables' in metadata:
                    for var in metadata['variables']:
                        if isinstance(var, dict):
                            var_name = var.get('name', '')
                            if var_name:
                                # デフォルト値の抽出
                                if 'default' in var and var_name not in all_defaults:
                                    all_defaults[var_name] = var['default']
                                
                                # 必須フィールドの追跡
                                if var.get('required', False):
                                    required_variables[var_name] = {
                                        'module': module_id,
                                        'description': var.get('description', '')
                                    }
                
            except FileNotFoundError:
                continue
        
        # デフォルト値をマージ（ユーザー指定の値が優先）
        effective_variables = {**all_defaults, **variables}
        
        # 必須フィールドの検証
        missing_required = []
        for var_name, var_info in required_variables.items():
            if var_name not in effective_variables or not effective_variables[var_name]:
                missing_required.append(f"  - {var_name} ({var_info['description']}) - モジュール: {var_info['module']}")
        
        if missing_required:
            if self.lang == 'ja':
                error_msg = "エラー: 以下の必須変数が指定されていません:\n"
                error_msg += "\n".join(missing_required)
                error_msg += "\n\n使用例:\n"
                error_msg += "  ./scripts/generate-instruction.sh --modules " + " ".join(module_ids)
                for var_name in required_variables:
                    if var_name not in effective_variables or not effective_variables[var_name]:
                        error_msg += f" --variable {var_name}=\"値\""
            else:
                error_msg = "Error: The following required variables are not specified:\n"
                error_msg += "\n".join(missing_required)
                error_msg += "\n\nUsage example:\n"
                error_msg += "  ./scripts/generate-instruction.sh --modules " + " ".join(module_ids)
                for var_name in required_variables:
                    if var_name not in effective_variables or not effective_variables[var_name]:
                        error_msg += f" --variable {var_name}=\"value\""
            raise ValueError(error_msg)
        
        # 実際に適用されたデフォルト値を特定
        for key, value in effective_variables.items():
            if key in all_defaults and key not in variables:
                applied_defaults[key] = value
            
        sections = []
        
        # ヘッダー
        if self.lang == 'ja':
            sections.append("# AI指示書\n")
            sections.append("*この指示書はモジュラーシステムによって自動生成されました*\n")
        else:
            sections.append("# AI Instructions\n")
            sections.append("*This instruction was automatically generated by the modular system*\n")
        
        # 変数適用情報を表示
        if effective_variables:
            if self.lang == 'ja':
                sections.append("## 適用された変数\n")
                for key, value in sorted(effective_variables.items()):
                    if key in applied_defaults:
                        sections.append(f"- **{key}**: {value} *(デフォルト値)*")
                    else:
                        sections.append(f"- **{key}**: {value} *(ユーザー指定)*")
            else:
                sections.append("## Applied Variables\n")
                for key, value in sorted(effective_variables.items()):
                    if key in applied_defaults:
                        sections.append(f"- **{key}**: {value} *(default)*")
                    else:
                        sections.append(f"- **{key}**: {value} *(user specified)*")
            sections.append("")  # 空行
        
        # 各モジュールを読み込んで結合
        for module_id in module_ids:
            try:
                module = self.load_module(module_id)
                content = module['content']
                
                # 変数を置換
                content = self.replace_variables(content, effective_variables)
                
                sections.append(content)
                sections.append("\n---\n")  # セクション区切り
                
            except FileNotFoundError as e:
                if self.lang == 'ja':
                    print(f"警告: {e}")
                else:
                    print(f"Warning: {e}")
                continue
        
        # 最後の区切り線を削除
        if sections and sections[-1] == "\n---\n":
            sections.pop()
        
        return '\n'.join(sections)
    
    def generate_from_preset(self, preset_name: str, overrides: Dict[str, str] = None) -> str:
        """プリセットから指示書を生成（blueprint + variables対応）"""
        preset = self.load_preset(preset_name)
        
        # 変数をマージ
        variables = preset.get('variables', {})
        if 'defaults' in preset:
            variables = {**preset['defaults'], **variables}
        if overrides:
            variables = {**variables, **overrides}
        
        # 新仕様: blueprint + variables + capabilities
        if 'blueprint' in preset or 'capabilities' in preset:
            return self._generate_from_blueprint_preset(preset, variables)
        
        # 従来仕様: modules配列
        if 'modules' in preset:
            return self.compose_modules(preset['modules'], variables)
        
        # 新型仕様: category配列（後方互換性のため）
        module_ids = self._extract_modules_from_categories(preset)
        if module_ids:
            return self.compose_modules(module_ids, variables)
        
        raise ValueError(f"Invalid preset format: {preset_name}")
    
    def _generate_from_blueprint_preset(self, preset: Dict[str, Any], variables: Dict[str, str]) -> str:
        """blueprint + variables仕様のプリセットから指示書を生成"""
        sections = []
        
        # ヘッダー
        if self.lang == 'ja':
            sections.append("# AI指示書")
            sections.append("*この指示書はモジュラーシステム v2.0 によって自動生成されました*\n")
        else:
            sections.append("# AI Instructions")
            sections.append("*This instruction was automatically generated by modular system v2.0*\n")
        
        # メタデータ表示
        if 'name' in preset:
            if self.lang == 'ja':
                sections.append(f"**プリセット**: {preset['name']}")
            else:
                sections.append(f"**Preset**: {preset['name']}")
        
        if 'description' in preset:
            if self.lang == 'ja':
                sections.append(f"**説明**: {preset['description']}")
            else:
                sections.append(f"**Description**: {preset['description']}")
        
        sections.append("")  # 空行
        
        # 変数適用情報
        if variables:
            if self.lang == 'ja':
                sections.append("## 適用設定\n")
                for key, value in sorted(variables.items()):
                    sections.append(f"- **{key}**: {value}")
            else:
                sections.append("## Applied Settings\n")
                for key, value in sorted(variables.items()):
                    sections.append(f"- **{key}**: {value}")
            sections.append("")
        
        # capabilities から基本モジュールを読み込み
        if 'capabilities' in preset:
            capability_content = self._render_capabilities(preset['capabilities'], variables)
            if capability_content:
                sections.append(capability_content)
                sections.append("")
        
        # blueprint を展開
        if 'blueprint' in preset:
            blueprint_content = self._render_blueprint(preset['blueprint'], variables)
            if blueprint_content:
                sections.append(blueprint_content)
        
        return '\n'.join(sections)
    
    def _render_capabilities(self, capabilities: Dict[str, List[str]], variables: Dict[str, str]) -> str:
        """capabilities セクションから基本モジュールを読み込み"""
        sections = []
        
        # capabilities から対応するモジュールを特定して読み込み
        module_ids = []
        for category, items in capabilities.items():
            for item in items:
                # カテゴリに応じた正しいプレフィックスを追加
                if category == 'expertise':
                    module_ids.append(f'expertise_{item}')
                elif category == 'roles':
                    module_ids.append(f'role_{item}')
                elif category == 'tasks':
                    module_ids.append(f'task_{item}')
                elif category == 'skills':
                    module_ids.append(f'skill_{item}')
                elif category == 'methods':
                    module_ids.append(f'method_{item}')
                elif category == 'quality':
                    module_ids.append(f'quality_{item}')
                else:
                    # その他の場合はそのまま使用
                    module_ids.append(item)
        
        # モジュールが存在する場合のみ読み込み
        for module_id in module_ids:
            try:
                module = self.load_module(module_id)
                content = module['content']
                content = self.replace_variables(content, variables)
                sections.append(content)
                sections.append("---")
            except FileNotFoundError:
                # モジュールが見つからない場合はスキップ
                if self.lang == 'ja':
                    print(f"警告: モジュールが見つかりません: {module_id}")
                else:
                    print(f"Warning: Module not found: {module_id}")
                continue
        
        # 最後の区切り線を削除
        if sections and sections[-1] == "---":
            sections.pop()
        
        return '\n'.join(sections)
    
    def _render_blueprint(self, blueprint: Dict[str, Any], variables: Dict[str, str]) -> str:
        """blueprint セクションを展開してセクション形式で出力"""
        sections = []
        
        if self.lang == 'ja':
            sections.append("## 実行指示")
        else:
            sections.append("## Execution Instructions")
        
        for section_name, section_content in blueprint.items():
            # セクション名を整形
            formatted_name = self._format_section_name(section_name)
            sections.append(f"\n### {formatted_name}")
            
            if isinstance(section_content, dict):
                # ネストした構造を処理
                for key, value in section_content.items():
                    formatted_key = self._format_section_name(key)
                    sections.append(f"\n**{formatted_key}**:")
                    
                    if isinstance(value, list):
                        for item in value:
                            item_with_vars = self.replace_variables(str(item), variables)
                            sections.append(f"- {item_with_vars}")
                    else:
                        value_with_vars = self.replace_variables(str(value), variables)
                        sections.append(f"- {value_with_vars}")
            
            elif isinstance(section_content, list):
                # リスト形式
                for item in section_content:
                    item_with_vars = self.replace_variables(str(item), variables)
                    sections.append(f"- {item_with_vars}")
            
            else:
                # 単一値
                value_with_vars = self.replace_variables(str(section_content), variables)
                sections.append(f"- {value_with_vars}")
        
        return '\n'.join(sections)
    
    def _format_section_name(self, name: str) -> str:
        """セクション名を見出し用に整形"""
        # スネークケースをスペース区切りに変換し、タイトルケースに
        formatted = name.replace('_', ' ').title()
        
        # 日本語の場合の変換
        if self.lang == 'ja':
            translations = {
                'Communication Framework': 'コミュニケーション方針',
                'Research Capabilities': '研究機能',
                'Citation Management': '引用管理',
                'Methodology Support': '方法論サポート',
                'Output Standards': '出力基準',
                'Specialized Features': '専門機能'
            }
            return translations.get(formatted, formatted)
        
        return formatted
    
    def _extract_modules_from_categories(self, preset: Dict[str, Any]) -> List[str]:
        """カテゴリ配列形式からモジュールIDを抽出（後方互換性用）"""
        module_ids = []
        
        category_mappings = {
            'expertise': lambda x: f'expertise_{x}',
            'roles': lambda x: x,
            'tasks': lambda x: x,
            'skills': lambda x: x,
            'methods': lambda x: x,
            'quality': lambda x: x,
        }
        
        for category, mapper in category_mappings.items():
            if category in preset and isinstance(preset[category], list):
                for item in preset[category]:
                    module_ids.append(mapper(item))
        
        return module_ids
    
    def merge_modules(self, base_modules: List[str], additional_modules: List[str]) -> List[str]:
        """
        Merge base modules with additional modules, handling deduplication
        
        Args:
            base_modules: Modules from preset
            additional_modules: User-specified additional modules
            
        Returns:
            Merged list of unique module IDs preserving order
        """
        # Use dict to preserve order while deduplicating
        seen = {}
        result = []
        
        # Add base modules first
        for module in base_modules:
            if module not in seen:
                seen[module] = True
                result.append(module)
        
        # Add additional modules
        for module in additional_modules:
            if module not in seen:
                seen[module] = True
                result.append(module)
        
        return result
    
    def generate_from_preset_with_modules(
        self, 
        preset_name: str, 
        additional_modules: List[str] = None,
        overrides: Dict[str, str] = None
    ) -> str:
        """
        Generate instruction from preset with optional additional modules
        
        Priority: preset < additional modules < variable overrides
        """
        preset = self.load_preset(preset_name)
        
        # Initialize variables with preset defaults
        variables = preset.get('variables', {})
        if 'defaults' in preset:
            variables = {**preset['defaults'], **variables}
        
        # Handle blueprint format presets
        if 'blueprint' in preset or 'capabilities' in preset:
            return self._generate_from_blueprint_preset_with_modules(
                preset, additional_modules, variables, overrides
            )
        
        # Handle legacy module array format
        if 'modules' in preset:
            base_modules = preset['modules']
            if additional_modules:
                merged_modules = self.merge_modules(base_modules, additional_modules)
            else:
                merged_modules = base_modules
            
            # Apply variable overrides last
            if overrides:
                variables = {**variables, **overrides}
                
            return self.compose_modules(merged_modules, variables)
        
        # Handle category array format (deprecated)
        module_ids = self._extract_modules_from_categories(preset)
        if module_ids:
            if additional_modules:
                merged_modules = self.merge_modules(module_ids, additional_modules)
            else:
                merged_modules = module_ids
                
            if overrides:
                variables = {**variables, **overrides}
                
            return self.compose_modules(merged_modules, variables)
        
        raise ValueError(f"Invalid preset format: {preset_name}")
    
    def _generate_from_blueprint_preset_with_modules(
        self,
        preset: Dict[str, Any],
        additional_modules: List[str],
        variables: Dict[str, str],
        overrides: Dict[str, str]
    ) -> str:
        """Generate from blueprint preset with additional modules support"""
        sections = []
        
        # Header with enhanced info
        if self.lang == 'ja':
            sections.append("# AI指示書")
            sections.append("*この指示書はモジュラーシステム v2.0 によって自動生成されました*\n")
        else:
            sections.append("# AI Instructions")
            sections.append("*This instruction was automatically generated by modular system v2.0*\n")
        
        # Show preset info
        if 'name' in preset:
            if self.lang == 'ja':
                sections.append(f"**プリセット**: {preset['name']}")
            else:
                sections.append(f"**Preset**: {preset['name']}")
        
        if 'description' in preset:
            if self.lang == 'ja':
                sections.append(f"**説明**: {preset['description']}")
            else:
                sections.append(f"**Description**: {preset['description']}")
        
        # Show if additional modules were added
        if additional_modules:
            if self.lang == 'ja':
                sections.append(f"**追加モジュール**: {', '.join(additional_modules)}")
            else:
                sections.append(f"**Additional Modules**: {', '.join(additional_modules)}")
        
        sections.append("")  # 空行
        
        # Apply variable overrides
        if overrides:
            variables = {**variables, **overrides}
        
        # 変数適用情報
        if variables:
            if self.lang == 'ja':
                sections.append("## 適用設定\n")
                for key, value in sorted(variables.items()):
                    sections.append(f"- **{key}**: {value}")
            else:
                sections.append("## Applied Settings\n")
                for key, value in sorted(variables.items()):
                    sections.append(f"- **{key}**: {value}")
            sections.append("")
        
        # capabilities から基本モジュールを読み込み
        if 'capabilities' in preset:
            capability_content = self._render_capabilities(preset['capabilities'], variables)
            if capability_content:
                sections.append(capability_content)
                sections.append("")
        
        # 追加モジュールを読み込み
        if additional_modules:
            if self.lang == 'ja':
                sections.append("## 追加機能\n")
            else:
                sections.append("## Additional Features\n")
            
            for module_id in additional_modules:
                try:
                    module = self.load_module(module_id)
                    content = module['content']
                    content = self.replace_variables(content, variables)
                    sections.append(content)
                    sections.append("---")
                except FileNotFoundError:
                    if self.lang == 'ja':
                        print(f"警告: 追加モジュールが見つかりません: {module_id}")
                    else:
                        print(f"Warning: Additional module not found: {module_id}")
                    continue
            
            # 最後の区切り線を削除
            if sections and sections[-1] == "---":
                sections.pop()
            sections.append("")
        
        # blueprint を展開
        if 'blueprint' in preset:
            blueprint_content = self._render_blueprint(preset['blueprint'], variables)
            if blueprint_content:
                sections.append(blueprint_content)
        
        return '\n'.join(sections)
    
    def save_instruction(self, content: str, filename: str) -> Path:
        """生成した指示書を保存"""
        output_path = self.cache_dir / filename
        
        with open(output_path, 'w', encoding='utf-8') as f:
            f.write(content)
        
        return output_path
    
    def get_metadata_summary(self) -> str:
        """AIが判断するためのメタデータサマリーを生成"""
        if self.lang == 'ja':
            summary_lines = ["# 利用可能なモジュール一覧\n"]
            category_names = {
                "core": "コア（基本設定）",
                "tasks": "タスク（実行内容）",
                "skills": "スキル（追加能力）",
                "quality": "品質（品質基準）"
            }
        else:
            summary_lines = ["# Available Modules\n"]
            category_names = {
                "core": "Core (Basic Settings)",
                "tasks": "Tasks (Execution Content)",
                "skills": "Skills (Additional Abilities)",
                "quality": "Quality (Quality Standards)"
            }
        
        for category, display_name in category_names.items():
            category_dir = self.modules_dir / category
            if category_dir.exists():
                summary_lines.append(f"\n## {display_name}\n")
                
                for yaml_file in sorted(category_dir.glob("*.yaml")):
                    with open(yaml_file, 'r', encoding='utf-8') as f:
                        meta = yaml.safe_load(f)
                    
                    summary_lines.append(f"### {meta['id']}")
                    if self.lang == 'ja':
                        summary_lines.append(f"- **名前**: {meta['name']}")
                        summary_lines.append(f"- **説明**: {meta['description']}")
                        
                        if 'tags' in meta:
                            summary_lines.append(f"- **タグ**: {', '.join(meta['tags'])}")
                    else:
                        summary_lines.append(f"- **Name**: {meta['name']}")
                        summary_lines.append(f"- **Description**: {meta['description']}")
                        
                        if 'tags' in meta:
                            summary_lines.append(f"- **Tags**: {', '.join(meta['tags'])}")
                    
                    # 変数情報を追加（デフォルト値付き）
                    if 'variables' in meta and meta['variables']:
                        var_info = []
                        for var in meta['variables']:
                            if isinstance(var, dict):
                                var_str = var.get('name', '')
                                if 'default' in var:
                                    var_str += f"={var['default']}"
                                var_info.append(var_str)
                        if var_info:
                            if self.lang == 'ja':
                                summary_lines.append(f"- **変数**: {', '.join(var_info)}")
                            else:
                                summary_lines.append(f"- **Variables**: {', '.join(var_info)}")
                    
                    if 'dependencies' in meta:
                        deps = meta['dependencies']
                        if isinstance(deps, dict):
                            # Object format: {required: [...], optional: [...]}
                            dep_parts = []
                            if 'required' in deps and deps['required']:
                                if self.lang == 'ja':
                                    dep_parts.append(f"必須: {', '.join(deps['required'])}")
                                else:
                                    dep_parts.append(f"required: {', '.join(deps['required'])}")
                            if 'optional' in deps and deps['optional']:
                                if self.lang == 'ja':
                                    dep_parts.append(f"オプション: {', '.join(deps['optional'])}")
                                else:
                                    dep_parts.append(f"optional: {', '.join(deps['optional'])}")
                            if dep_parts:
                                if self.lang == 'ja':
                                    summary_lines.append(f"- **依存関係**: {'; '.join(dep_parts)}")
                                else:
                                    summary_lines.append(f"- **Dependencies**: {'; '.join(dep_parts)}")
                        elif isinstance(deps, list):
                            # Array format (legacy)
                            if self.lang == 'ja':
                                summary_lines.append(f"- **依存関係**: {', '.join(deps)}")
                            else:
                                summary_lines.append(f"- **Dependencies**: {', '.join(deps)}")
                    
                    if 'compatible_with' in meta or 'compatible_modules' in meta or 'compatible_skills' in meta:
                        compat = meta.get('compatible_with', meta.get('compatible_modules', meta.get('compatible_skills', [])))
                        if compat:
                            if self.lang == 'ja':
                                summary_lines.append(f"- **推奨組み合わせ**: {', '.join(compat)}")
                            else:
                                summary_lines.append(f"- **Recommended Combinations**: {', '.join(compat)}")
                    
                    summary_lines.append("")  # 空行
        
        return '\n'.join(summary_lines)


def main():
    parser = argparse.ArgumentParser(description='モジュラー指示書コンポーザー')
    
    # グローバルオプション
    parser.add_argument('-l', '--lang', default='ja', choices=['ja', 'en'],
                       help='言語を指定 (デフォルト: ja)')
    parser.add_argument('--verbose', action='store_true',
                       help='詳細版モジュールを使用 (デフォルト: 簡潔版)')
    
    # サブコマンド
    subparsers = parser.add_subparsers(dest='command', help='コマンド')
    
    # プリセットから生成
    preset_parser = subparsers.add_parser('preset', help='プリセットから生成')
    preset_parser.add_argument('name', help='プリセット名')
    preset_parser.add_argument('-o', '--output', help='出力ファイル名')
    preset_parser.add_argument('-v', '--variable', action='append', 
                              help='変数のオーバーライド (key=value形式)')
    preset_parser.add_argument('--modules', nargs='+', 
                              help='プリセットに追加するモジュール')
    
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
    
    # 言語パラメータを取得
    lang = getattr(args, 'lang', 'ja')
    # verboseフラグがある場合は詳細版を使用（デフォルトは簡潔版）
    use_concise = not getattr(args, 'verbose', False)
    # スクリプトの場所に関係なく絶対パスでmodularディレクトリを特定
    script_dir = Path(__file__).parent
    # composer.pyがmodular/内にある場合は、modular/がbase_dir
    modular_dir = script_dir if script_dir.name == "modular" else script_dir / "modular"
    composer = ModuleComposer(base_dir=str(modular_dir), lang=lang, use_concise=use_concise)
    
    if args.command == 'preset':
        # 変数のパース
        overrides = {}
        if args.variable:
            for var in args.variable:
                key, value = var.split('=', 1)
                overrides[key] = value
        
        # 生成 - 追加モジュールがある場合は新しいメソッドを使用
        if hasattr(args, 'modules') and args.modules:
            content = composer.generate_from_preset_with_modules(
                args.name, args.modules, overrides
            )
        else:
            content = composer.generate_from_preset(args.name, overrides)
        
        # 保存
        output_name = args.output or f"{args.name}_generated.md"
        output_path = composer.save_instruction(content, output_name)
        
        if lang == 'ja':
            print(f"指示書を生成しました: {output_path}")
        else:
            print(f"Instruction generated: {output_path}")
        
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
        
        if lang == 'ja':
            print(f"指示書を生成しました: {output_path}")
        else:
            print(f"Instruction generated: {output_path}")
        
    elif args.command == 'list':
        if args.type == 'presets':
            presets_dir = composer.base_dir / lang / "presets"
            if lang == 'ja':
                print("利用可能なプリセット:")
            else:
                print("Available presets:")
            if presets_dir.exists():
                for preset_file in presets_dir.glob("*.yaml"):
                    print(f"  - {preset_file.stem}")
                
        elif args.type == 'modules':
            if lang == 'ja':
                print("利用可能なモジュール:")
            else:
                print("Available modules:")
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