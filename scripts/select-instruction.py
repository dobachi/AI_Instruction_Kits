#!/usr/bin/env python3
"""
AI指示書選択ツール
分散型YAMLメタデータを基に適切な指示書を選択するためのツール
"""

import os
import yaml
import argparse
from pathlib import Path
from typing import List, Dict, Optional

class InstructionSelector:
    def __init__(self, instructions_dir: str = "instructions"):
        self.instructions_dir = Path(instructions_dir)
        self.metadata_cache = {}
        self._load_all_metadata()
    
    def _load_all_metadata(self):
        """すべてのメタデータファイルを読み込む"""
        # 新しい命名規則: instruction_name.yaml
        for yaml_file in self.instructions_dir.rglob("*.yaml"):
            # YAMLファイルと同名のMDファイルが存在する場合のみ処理
            md_file = yaml_file.with_suffix('.md')
            if md_file.exists():
                try:
                    with open(yaml_file, 'r', encoding='utf-8') as f:
                        metadata = yaml.safe_load(f)
                        if metadata and 'id' in metadata:
                            self.metadata_cache[metadata['id']] = {
                                'metadata': metadata,
                                'path': md_file
                            }
                except Exception as e:
                    print(f"警告: メタデータ読み込みエラー {yaml_file}: {e}")
    
    def search_by_keywords(self, keywords: List[str]) -> List[Dict]:
        """キーワードでマッチする指示書を検索"""
        results = []
        for id, data in self.metadata_cache.items():
            metadata = data['metadata']
            score = 0
            
            # キーワードマッチングのスコア計算
            all_text = ' '.join([
                metadata.get('name', ''),
                metadata.get('description', ''),
                ' '.join(metadata.get('tags', []))
            ]).lower()
            
            for keyword in keywords:
                if keyword.lower() in all_text:
                    score += 1
            
            if score > 0:
                results.append({
                    'id': id,
                    'score': score,
                    'metadata': metadata,
                    'path': data['path']
                })
        
        # スコアの高い順にソート
        return sorted(results, key=lambda x: x['score'], reverse=True)
    
    def get_by_category(self, category: str) -> List[Dict]:
        """カテゴリで指示書を取得"""
        results = []
        for id, data in self.metadata_cache.items():
            if data['metadata'].get('category') == category:
                results.append({
                    'id': id,
                    'metadata': data['metadata'],
                    'path': data['path']
                })
        return results
    
    def get_by_id(self, instruction_id: str) -> Optional[Dict]:
        """IDで指示書を取得"""
        if instruction_id in self.metadata_cache:
            data = self.metadata_cache[instruction_id]
            return {
                'id': instruction_id,
                'metadata': data['metadata'],
                'path': data['path']
            }
        return None
    
    def get_dependencies(self, instruction_id: str) -> List[Dict]:
        """指定した指示書の依存関係を取得"""
        instruction = self.get_by_id(instruction_id)
        if not instruction:
            return []
        
        dependencies = []
        for dep_id in instruction['metadata'].get('dependencies', []):
            dep = self.get_by_id(dep_id)
            if dep:
                dependencies.append(dep)
        
        return dependencies

def main():
    parser = argparse.ArgumentParser(description='AI指示書選択ツール')
    parser.add_argument('--search', nargs='+', help='キーワードで検索')
    parser.add_argument('--category', help='カテゴリで絞り込み')
    parser.add_argument('--id', help='IDで指定')
    parser.add_argument('--show-deps', action='store_true', help='依存関係も表示')
    parser.add_argument('--format', choices=['simple', 'detailed', 'path'], default='simple', help='出力形式')
    
    args = parser.parse_args()
    selector = InstructionSelector()
    
    results = []
    
    if args.search:
        results = selector.search_by_keywords(args.search)
    elif args.category:
        results = selector.get_by_category(args.category)
    elif args.id:
        result = selector.get_by_id(args.id)
        if result:
            results = [result]
    else:
        # すべての指示書を表示
        results = [{'id': id, 'metadata': data['metadata'], 'path': data['path']} 
                  for id, data in selector.metadata_cache.items()]
    
    # 結果の表示
    for result in results:
        if args.format == 'path':
            print(result['path'])
        elif args.format == 'detailed':
            print(f"ID: {result['id']}")
            print(f"名前: {result['metadata']['name']}")
            print(f"説明: {result['metadata']['description']}")
            print(f"カテゴリ: {result['metadata']['category']}")
            print(f"言語: {result['metadata']['language']}")
            print(f"パス: {result['path']}")
            if result['metadata'].get('tags'):
                print(f"タグ: {', '.join(result['metadata']['tags'])}")
            if args.show_deps and result['metadata'].get('dependencies'):
                print(f"依存関係: {', '.join(result['metadata']['dependencies'])}")
            print("-" * 50)
        else:
            print(f"{result['id']}: {result['metadata']['name']}")
    
    # 依存関係の表示
    if args.show_deps and args.id:
        deps = selector.get_dependencies(args.id)
        if deps:
            print("\n依存する指示書:")
            for dep in deps:
                print(f"  - {dep['id']}: {dep['metadata']['name']}")

if __name__ == "__main__":
    main()