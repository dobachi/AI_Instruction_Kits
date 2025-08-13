#!/usr/bin/env python3
"""
AI指示書キット用Claude Codeエージェントタスク集

このスクリプトは、Claude CodeのTask tool (エージェント機能)を活用して
AI指示書の分析・最適化・品質管理を行うためのタスク定義を提供します。
"""

import json
import yaml
from pathlib import Path
from typing import Dict, List, Any, Optional
from dataclasses import dataclass
from enum import Enum


class AnalysisMode(Enum):
    """分析モードの定義"""
    QUALITY = "quality"
    DUPLICATE = "duplicate"
    OPTIMIZE = "optimize"
    COVERAGE = "coverage"
    DEPENDENCY = "dependency"


@dataclass
class AgentTask:
    """エージェントタスクの定義"""
    description: str
    prompt: str
    subagent_type: str = "general-purpose"
    
    def to_dict(self) -> Dict[str, str]:
        """辞書形式に変換"""
        return {
            "description": self.description,
            "prompt": self.prompt,
            "subagent_type": self.subagent_type
        }


class InstructionAnalyzer:
    """AI指示書分析エージェントタスク生成クラス"""
    
    def __init__(self, base_path: Path = Path("instructions")):
        self.base_path = base_path
        
    def create_quality_check_task(self, lang: str = "ja") -> AgentTask:
        """品質チェックタスクの生成"""
        prompt = f"""
AI指示書キットの包括的な品質チェックを実行してください。

## 対象ディレクトリ
- instructions/{lang}/

## チェック項目

### 1. 構造的完全性
- 必須セクション（目的、使用方法、例）の有無
- Markdownフォーマットの正確性
- ヘッダー階層の一貫性
- リンクの有効性

### 2. 内容の品質
- 指示の明確性と具体性
- 曖昧な表現の検出
- 論理的な流れ
- 誤字脱字のチェック

### 3. コード例の検証
- シンタックスの正確性
- 実行可能性の確認
- ベストプラクティスへの準拠
- エラーハンドリングの有無

### 4. メタデータ整合性
- YAMLファイルとの一致性
- カテゴリ分類の適切性
- タグの一貫性
- バージョン情報の有無

### 5. 相互参照の検証
- 他の指示書への参照の有効性
- 循環参照の検出
- 依存関係の明確化

## 出力形式
以下のJSON構造で結果を返してください：

```json
{{
  "summary": {{
    "total_files": 0,
    "passed": 0,
    "failed": 0,
    "warnings": 0,
    "quality_score": 0.0,
    "execution_time": "00:00:00"
  }},
  "issues": {{
    "critical": [
      {{
        "file": "path/to/file.md",
        "line": 0,
        "type": "missing_section",
        "message": "必須セクション '目的' が見つかりません",
        "suggestion": "## 目的 セクションを追加してください"
      }}
    ],
    "warning": [],
    "info": []
  }},
  "statistics": {{
    "sections": {{}},
    "code_blocks": {{}},
    "links": {{}}
  }},
  "recommendations": []
}}
```

## 実行要件
- すべてのMarkdownファイルを再帰的に検査
- エラーは即座に報告せず、最後にまとめて出力
- 処理の進捗を適宜報告
- メモリ効率を考慮した実装
"""
        return AgentTask(
            description=f"品質チェック-{lang}",
            prompt=prompt
        )
    
    def create_duplicate_detection_task(self, lang: str = "ja") -> AgentTask:
        """重複検出タスクの生成"""
        prompt = f"""
AI指示書キットの重複検出と統合提案を実行してください。

## 対象ディレクトリ
- instructions/{lang}/

## 検出アルゴリズム

### 1. テキスト類似度分析
- コサイン類似度による比較
- レーベンシュタイン距離の計算
- N-gram分析
- 閾値: 70%以上を重複候補とする

### 2. 意味的類似度分析
- 主要機能の抽出と比較
- 目的文の意味解析
- 使用例の類似性評価
- コンテキストベースの判定

### 3. 構造的類似度分析
- セクション構成の比較
- コードパターンの検出
- メタデータの類似性
- 依存関係の重複

## 検出カテゴリ
1. **完全重複**: 90%以上の一致
2. **部分重複**: 70-90%の一致
3. **機能重複**: 異なる実装で同じ目的
4. **統合候補**: 関連性の高い複数ファイル

## 出力形式
以下のJSON構造で結果を返してください：

```json
{{
  "summary": {{
    "total_comparisons": 0,
    "duplicate_groups": 0,
    "consolidation_opportunities": 0,
    "estimated_reduction": "0%"
  }},
  "duplicates": [
    {{
      "group_id": "dup_001",
      "similarity_score": 0.85,
      "type": "partial",
      "files": [
        {{
          "path": "path/to/file1.md",
          "sections": ["purpose", "usage"],
          "unique_content": ["specific_feature"]
        }}
      ],
      "recommendation": {{
        "action": "merge",
        "target": "consolidated_instruction.md",
        "rationale": "機能が重複しており、統合により管理が簡素化されます"
      }}
    }}
  ],
  "similarity_matrix": {{}},
  "action_plan": [
    {{
      "priority": "high",
      "action": "merge files",
      "files": [],
      "estimated_effort": "2 hours"
    }}
  ]
}}
```

## 実行要件
- ペアワイズ比較の効率的な実装
- 大規模ファイルセットに対応
- 誤検出を最小化
- 具体的な統合手順の提供
"""
        return AgentTask(
            description=f"重複検出-{lang}",
            prompt=prompt
        )
    
    def create_optimization_task(self, lang: str = "ja") -> AgentTask:
        """最適化提案タスクの生成"""
        prompt = f"""
AI指示書キットの包括的な最適化分析と改善提案を生成してください。

## 対象ディレクトリ
- instructions/{lang}/

## 最適化の観点

### 1. 構造最適化
- ディレクトリ階層の評価
- カテゴリ分類の妥当性
- ファイル命名規則の一貫性
- モジュール化の機会

### 2. 内容最適化
- 冗長な説明の削減
- 不足情報の特定
- 例示の充実度
- クロスリファレンスの最適化

### 3. パフォーマンス最適化
- ファイルサイズの分析
- 読み込み順序の最適化
- キャッシュ戦略の提案
- 依存関係の最小化

### 4. 使いやすさの最適化
- ナビゲーション構造
- 検索性の向上
- インデックスの生成
- クイックスタートガイドの必要性

### 5. 保守性の最適化
- 更新頻度の分析
- バージョン管理戦略
- テンプレート化の機会
- 自動化可能なプロセス

## 分析手法
- 複雑度メトリクスの計算
- 依存関係グラフの生成
- 使用頻度分析
- ユーザーパス分析

## 出力形式
以下のJSON構造で結果を返してください：

```json
{{
  "summary": {{
    "current_state": {{
      "total_files": 0,
      "total_size": "0 KB",
      "complexity_score": 0.0,
      "maintainability_index": 0.0
    }},
    "proposed_state": {{
      "estimated_files": 0,
      "estimated_size": "0 KB",
      "complexity_score": 0.0,
      "maintainability_index": 0.0
    }},
    "improvement_potential": "0%"
  }},
  "optimizations": [
    {{
      "id": "opt_001",
      "category": "structure",
      "priority": "high",
      "title": "カテゴリ再編成",
      "description": "詳細な説明",
      "current_state": "現状の説明",
      "proposed_state": "提案する状態",
      "benefits": [
        "メリット1",
        "メリット2"
      ],
      "risks": [
        "リスク1"
      ],
      "effort": {{
        "hours": 4,
        "complexity": "medium"
      }},
      "implementation_steps": [
        "ステップ1",
        "ステップ2"
      ]
    }}
  ],
  "roadmap": [
    {{
      "phase": 1,
      "duration": "1 week",
      "tasks": ["opt_001", "opt_002"],
      "deliverables": ["最適化されたディレクトリ構造"],
      "dependencies": []
    }}
  ],
  "metrics": {{
    "before": {{}},
    "after": {{}},
    "improvement": {{}}
  }}
}}
```

## 実行要件
- データドリブンな提案
- 実装可能性の高い提案
- ROIの明確な提示
- 段階的な実装計画
"""
        return AgentTask(
            description=f"最適化提案-{lang}",
            prompt=prompt
        )
    
    def create_coverage_analysis_task(self) -> AgentTask:
        """カバレッジ分析タスクの生成"""
        prompt = """
AI指示書キットのカバレッジ分析を実行し、不足している領域を特定してください。

## 分析対象

### 1. プログラミング言語カバレッジ
- 主要言語（Python, JavaScript, Java, Go, Rust等）
- フレームワーク（React, Django, Spring等）
- ツール（Docker, Kubernetes, Git等）

### 2. 開発プロセスカバレッジ
- 設計フェーズ
- 実装フェーズ
- テストフェーズ
- デプロイフェーズ
- 保守フェーズ

### 3. ドメインカバレッジ
- Web開発
- モバイル開発
- データサイエンス
- DevOps
- セキュリティ

### 4. スキルレベルカバレッジ
- 初級者向け
- 中級者向け
- 上級者向け
- エキスパート向け

## 分析手法
- 既存指示書のタグ分析
- キーワード頻度分析
- ギャップ分析
- 競合比較（他のAI指示書システム）

## 出力形式
以下のJSON構造で結果を返してください：

```json
{{
  "coverage_summary": {{
    "total_coverage": "65%",
    "strengths": ["Web開発", "Python"],
    "weaknesses": ["モバイル開発", "Rust"],
    "opportunities": ["AI/ML", "クラウドネイティブ"]
  }},
  "detailed_coverage": {{
    "languages": {{
      "covered": ["Python", "JavaScript"],
      "partial": ["Java"],
      "missing": ["Rust", "Swift"]
    }},
    "domains": {{}},
    "skill_levels": {{}}
  }},
  "gap_analysis": [
    {{
      "area": "Mobile Development",
      "current_coverage": "20%",
      "target_coverage": "80%",
      "priority": "high",
      "suggested_instructions": [
        "iOS開発ガイド",
        "Android開発ガイド",
        "React Native実装"
      ]
    }}
  ],
  "recommendations": [
    {{
      "title": "モバイル開発指示書の追加",
      "rationale": "需要が高いが現在のカバレッジが低い",
      "expected_impact": "ユーザー満足度20%向上",
      "implementation_effort": "40 hours"
    }}
  ]
}}
```

## 実行要件
- 包括的なカバレッジマップの生成
- 優先順位付けされた改善提案
- 市場需要との整合性評価
- 実装ロードマップの提供
"""
        return AgentTask(
            description="カバレッジ分析",
            prompt=prompt
        )
    
    def create_dependency_analysis_task(self) -> AgentTask:
        """依存関係分析タスクの生成"""
        prompt = """
AI指示書キット内の依存関係を分析し、構造を可視化してください。

## 分析対象

### 1. 指示書間の依存関係
- 直接参照（明示的なリンク）
- 暗黙的参照（コンテキスト依存）
- 前提条件の連鎖
- 共通モジュールの使用

### 2. カテゴリ間の関係
- 階層構造
- 横断的な関連
- 循環依存の検出

### 3. 外部依存
- 外部ツール要件
- ライブラリ依存
- システム要件

## 分析手法
- 静的解析（ファイル内容のパース）
- グラフ理論による構造分析
- 強連結成分の検出
- クリティカルパスの特定

## 出力形式
以下のJSON構造で結果を返してください：

```json
{{
  "summary": {{
    "total_nodes": 0,
    "total_edges": 0,
    "max_depth": 0,
    "circular_dependencies": 0,
    "isolated_nodes": 0
  }},
  "dependency_graph": {{
    "nodes": [
      {{
        "id": "instruction_001",
        "path": "path/to/file.md",
        "category": "development",
        "in_degree": 2,
        "out_degree": 3
      }}
    ],
    "edges": [
      {{
        "source": "instruction_001",
        "target": "instruction_002",
        "type": "requires",
        "weight": 1.0
      }}
    ]
  }},
  "issues": [
    {{
      "type": "circular_dependency",
      "severity": "high",
      "nodes": ["file1.md", "file2.md", "file3.md"],
      "description": "循環依存が検出されました",
      "resolution": "file2.mdの依存を削除することで解決可能"
    }}
  ],
  "critical_path": [
    "setup.md",
    "configuration.md",
    "deployment.md"
  ],
  "recommendations": [
    {{
      "action": "モジュール化",
      "targets": ["group1", "group2"],
      "benefit": "依存関係の簡素化"
    }}
  ]
}}
```

## 実行要件
- 大規模グラフの効率的な処理
- 視覚化可能なデータ構造
- 問題の自動検出と解決提案
- インパクト分析の提供
"""
        return AgentTask(
            description="依存関係分析",
            prompt=prompt
        )
    
    def create_comprehensive_analysis_task(self) -> AgentTask:
        """包括的分析タスクの生成"""
        all_analyses = [
            self.create_quality_check_task(),
            self.create_duplicate_detection_task(),
            self.create_optimization_task(),
            self.create_coverage_analysis_task(),
            self.create_dependency_analysis_task()
        ]
        
        combined_prompt = """
AI指示書キットの包括的な分析を実行してください。
以下のすべての分析を順次実行し、統合レポートを生成してください：

1. 品質チェック
2. 重複検出
3. 最適化提案
4. カバレッジ分析
5. 依存関係分析

各分析の詳細は個別のタスク定義を参照してください。
最終的に、すべての分析結果を統合した実行可能な改善計画を提供してください。

## 統合レポート形式
```json
{
  "executive_summary": {
    "overall_health_score": 0.0,
    "key_findings": [],
    "top_priorities": [],
    "estimated_improvement_effort": "0 hours"
  },
  "detailed_results": {
    "quality": {},
    "duplicates": {},
    "optimizations": {},
    "coverage": {},
    "dependencies": {}
  },
  "action_plan": {
    "immediate": [],
    "short_term": [],
    "long_term": []
  }
}
```
"""
        return AgentTask(
            description="包括的分析",
            prompt=combined_prompt
        )


class TaskExecutor:
    """エージェントタスク実行クラス"""
    
    @staticmethod
    def format_for_claude_code(task: AgentTask) -> str:
        """Claude Code用のフォーマットに変換"""
        return f"""
# Claude Code Agent Task

## Task Configuration
- **Description**: {task.description}
- **Subagent Type**: {task.subagent_type}

## Task Prompt
{task.prompt}

## Execution
This task should be executed using Claude Code's Task tool:
```javascript
Task({{
    description: "{task.description}",
    prompt: `{task.prompt}`,
    subagent_type: "{task.subagent_type}"
}})
```
"""
    
    @staticmethod
    def save_task_definition(task: AgentTask, filepath: Path) -> None:
        """タスク定義をファイルに保存"""
        filepath.parent.mkdir(parents=True, exist_ok=True)
        
        if filepath.suffix == ".json":
            with open(filepath, "w", encoding="utf-8") as f:
                json.dump(task.to_dict(), f, ensure_ascii=False, indent=2)
        elif filepath.suffix == ".yaml":
            with open(filepath, "w", encoding="utf-8") as f:
                yaml.dump(task.to_dict(), f, allow_unicode=True, default_flow_style=False)
        else:
            with open(filepath, "w", encoding="utf-8") as f:
                f.write(TaskExecutor.format_for_claude_code(task))


def main():
    """メイン実行関数"""
    import argparse
    
    parser = argparse.ArgumentParser(
        description="AI指示書キット用エージェントタスク生成"
    )
    parser.add_argument(
        "--mode",
        type=str,
        choices=["quality", "duplicate", "optimize", "coverage", "dependency", "all"],
        default="quality",
        help="分析モード"
    )
    parser.add_argument(
        "--lang",
        type=str,
        choices=["ja", "en"],
        default="ja",
        help="対象言語"
    )
    parser.add_argument(
        "--output",
        type=str,
        help="出力ファイルパス"
    )
    parser.add_argument(
        "--format",
        type=str,
        choices=["text", "json", "yaml"],
        default="text",
        help="出力形式"
    )
    parser.add_argument(
        "--execute",
        action="store_true",
        help="Claude Code内で実行可能な形式で出力"
    )
    
    args = parser.parse_args()
    
    # アナライザーの初期化
    analyzer = InstructionAnalyzer()
    
    # タスクの生成
    task = None
    if args.mode == "quality":
        task = analyzer.create_quality_check_task(args.lang)
    elif args.mode == "duplicate":
        task = analyzer.create_duplicate_detection_task(args.lang)
    elif args.mode == "optimize":
        task = analyzer.create_optimization_task(args.lang)
    elif args.mode == "coverage":
        task = analyzer.create_coverage_analysis_task()
    elif args.mode == "dependency":
        task = analyzer.create_dependency_analysis_task()
    elif args.mode == "all":
        task = analyzer.create_comprehensive_analysis_task()
    
    if task:
        if args.output:
            # ファイルに保存
            output_path = Path(args.output)
            if args.format == "json":
                output_path = output_path.with_suffix(".json")
            elif args.format == "yaml":
                output_path = output_path.with_suffix(".yaml")
            
            TaskExecutor.save_task_definition(task, output_path)
            print(f"タスク定義を保存しました: {output_path}")
        else:
            # 標準出力に表示
            if args.execute:
                print(TaskExecutor.format_for_claude_code(task))
            else:
                if args.format == "json":
                    print(json.dumps(task.to_dict(), ensure_ascii=False, indent=2))
                elif args.format == "yaml":
                    print(yaml.dump(task.to_dict(), allow_unicode=True, default_flow_style=False))
                else:
                    print(f"Description: {task.description}")
                    print(f"Subagent Type: {task.subagent_type}")
                    print(f"\nPrompt:\n{task.prompt}")


if __name__ == "__main__":
    main()