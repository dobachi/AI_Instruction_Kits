# AI指示書キット - 3システム分離設計

**作成日**: 2025-07-27  
**概要**: チェックポイントシステム、モジュラーシステム、並列処理システムの構造的分離

## 背景

現在のAI指示書キットは、複数の機能が混在している状態です。ユーザーの提案に基づき、以下の3つの独立したシステムに分離することで、より明確で保守性の高い構造を実現します。

## 3システムの概要

### 1. チェックポイントシステム（Task Tracking System）
**目的**: タスクの進捗管理と状態追跡  
**責任範囲**: タスクの開始、進捗報告、完了管理

### 2. モジュラーシステム（Instruction Generation System）
**目的**: 動的な指示書の生成と管理  
**責任範囲**: モジュールの組み合わせ、指示書の動的生成

### 3. 並列処理システム（Parallel Processing System）
**目的**: タスクの効率的な実行と最適化  
**責任範囲**: AI中立的な実行最適化、並列処理の抽象化

## 詳細設計

### 1. チェックポイントシステム

#### ディレクトリ構造
```
checkpoint_system/
├── core/
│   ├── checkpoint.sh              # メインスクリプト
│   ├── lib/
│   │   ├── task_manager.sh       # タスク管理機能
│   │   ├── state_handler.sh      # 状態管理
│   │   └── log_writer.sh         # ログ出力
│   └── templates/
│       └── task_template.json    # タスク定義テンプレート
├── instructions/
│   └── CHECKPOINT_MANAGER.md     # チェックポイント管理指示書
└── logs/
    └── .gitkeep                  # ログディレクトリ
```

#### 主要機能
- タスクIDの生成と管理
- 進捗状態の追跡（pending, in_progress, completed）
- ログファイルへの記録
- タスクサマリーの生成

#### インターフェース
```bash
# タスク開始
checkpoint_system/checkpoint.sh start <task-name> <steps>

# 進捗報告
checkpoint_system/checkpoint.sh progress <task-id> <step> <total> <status> <next>

# タスク完了
checkpoint_system/checkpoint.sh complete <task-id> <result>
```

### 2. モジュラーシステム

#### ディレクトリ構造
```
modular_system/
├── core/
│   ├── generate-instruction.sh    # 指示書生成スクリプト
│   ├── modules/                   # 基本モジュール
│   │   ├── base/
│   │   ├── development/
│   │   ├── analysis/
│   │   └── documentation/
│   └── templates/
│       └── instruction_base.md    # 指示書ベーステンプレート
├── instructions/
│   ├── MODULE_COMPOSER.md        # モジュール構成指示書
│   └── MODULE_REGISTRY.md        # モジュール一覧
├── cache/                        # 生成された指示書のキャッシュ
└── presets/                      # 事前生成プリセット
    ├── web_api_production.md
    ├── cli_tool_basic.md
    └── data_analyst.md
```

#### 主要機能
- モジュールの動的組み合わせ
- 指示書の自動生成
- プリセットの管理
- キャッシュメカニズム

#### インターフェース
```bash
# 指示書生成
modular_system/generate-instruction.sh --type <type> --modules <modules> --output <name>

# プリセット利用
modular_system/use-preset.sh <preset-name>
```

### 3. 並列処理システム

#### ディレクトリ構造
```
parallel_system/
├── core/
│   ├── task_optimizer.sh         # タスク最適化エンジン
│   ├── execution_planner.sh      # 実行計画生成
│   └── lib/
│       ├── capability_detector.sh # AI能力検出
│       └── fallback_handler.sh   # フォールバック処理
├── instructions/
│   ├── PARALLEL_PROCESSOR.md     # 並列処理指示書
│   └── OPTIMIZATION_GUIDE.md     # 最適化ガイド
├── task_templates/               # タスクテンプレート
│   ├── analysis/
│   │   ├── quality_check.yaml
│   │   └── dependency_scan.yaml
│   ├── generation/
│   │   └── documentation.yaml
│   └── validation/
│       └── test_coverage.yaml
└── task_definitions/            # AI生成タスク定義
    └── .gitkeep
```

#### 主要機能
- AI中立的なタスク定義
- 実行最適化ヒントの提供
- 並列処理の抽象化
- フォールバック戦略

#### インターフェース
```yaml
# タスクテンプレート定義
task_template:
  id: "quality_check"
  processing:
    - id: "analyze"
      parallel: true
      optimization_hint: "高度な実行機能を活用"

# タスク実行
parallel_system/execute_task.sh --template <template> --params <params>
```

## システム間の連携

### 1. 疎結合の原則
各システムは独立して動作可能で、必要に応じて連携します。

### 2. 標準インターフェース
```bash
# チェックポイント → モジュラー
checkpoint_system/checkpoint.sh instruction-start <path> <purpose> <task-id>

# モジュラー → 並列処理
modular_system/generate-instruction.sh --with-parallel-tasks

# 並列処理 → チェックポイント
parallel_system/report_progress.sh --task-id <id> --status <status>
```

### 3. データフロー
```
ユーザー要求
    ↓
[チェックポイント] タスク開始
    ↓
[モジュラー] 指示書生成/選択
    ↓
[並列処理] タスク最適化・実行
    ↓
[チェックポイント] 進捗報告・完了
```

## 移行計画

### Phase 1: システムディレクトリの作成
1. 3つのシステムディレクトリを作成
2. 既存ファイルを適切なシステムに移動
3. 相互参照の更新

### Phase 2: インターフェースの統一
1. 各システムの公開APIを定義
2. システム間通信プロトコルの確立
3. テストケースの作成

### Phase 3: 段階的移行
1. チェックポイントシステムの独立化
2. モジュラーシステムの分離
3. 並列処理システムの構築

## 利点

### 1. 明確な責任分離
- 各システムが単一の責任を持つ
- 機能の重複を排除
- 保守性の向上

### 2. 独立した進化
- 各システムを独立して改善可能
- 新機能の追加が容易
- バージョン管理の簡素化

### 3. 柔軟な組み合わせ
- 必要なシステムのみ使用可能
- カスタム統合が容易
- 軽量な利用が可能

## 実装例

### 統合利用
```bash
#!/bin/bash
# integrated_workflow.sh

# 1. タスク開始
TASK_ID=$(checkpoint_system/checkpoint.sh start "Web API開発" 5)

# 2. 指示書生成
modular_system/generate-instruction.sh \
  --type "web_api" \
  --modules "rest,validation,security" \
  --output "api_instruction"

# 3. 並列タスク実行
parallel_system/execute_task.sh \
  --template "api_development" \
  --task-id "$TASK_ID"

# 4. 完了報告
checkpoint_system/checkpoint.sh complete "$TASK_ID" "API実装完了"
```

### 単独利用
```bash
# チェックポイントのみ
checkpoint_system/checkpoint.sh start "簡単なタスク" 1

# モジュラーのみ
modular_system/use-preset.sh "cli_tool_basic"

# 並列処理のみ
parallel_system/execute_task.sh --template "quality_check"
```

## 今後の拡張性

### 1. プラグインシステム
各システムにプラグイン機構を追加し、サードパーティ拡張を可能に

### 2. Web API化
各システムをRESTful APIとして公開し、リモート利用を可能に

### 3. 統合ダッシュボード
3システムの状態を一元管理するダッシュボードの構築

## まとめ

3システムへの分離により、AI指示書キットはより構造的で拡張性の高いシステムになります。各システムが明確な責任を持ち、独立して進化できる設計により、長期的な保守性と使いやすさを実現します。