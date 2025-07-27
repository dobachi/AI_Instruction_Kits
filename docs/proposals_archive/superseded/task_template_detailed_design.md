# タスクテンプレート詳細設計

**作成日**: 2025-07-27  
**概要**: AI中立的なタスク実行のためのテンプレートシステムの詳細設計

## タスクテンプレートとは

タスクテンプレートは、**AIの実装詳細に依存せずにタスクを宣言的に記述する仕組み**です。「何をすべきか」を構造化して記述し、「どのように実行するか」は各AIが自身の能力に応じて決定します。

### 基本的な考え方

```yaml
# 従来の指示（実装依存）
"Taskツールを使用してサブエージェントを起動し、
 すべてのファイルを分析してください"

# タスクテンプレート（実装非依存）
task:
  goal: "すべてのファイルを分析"
  method: "最適な方法で実行"
```

## ディレクトリ構造と保存場所

```
AI_Instruction_Kits/
├── task_templates/                 # タスクテンプレート格納場所
│   ├── analysis/                  # 分析系タスク
│   │   ├── quality_check.yaml
│   │   ├── duplicate_detection.yaml
│   │   └── dependency_analysis.yaml
│   ├── generation/                # 生成系タスク
│   │   ├── documentation.yaml
│   │   └── code_scaffold.yaml
│   ├── validation/                # 検証系タスク
│   │   └── test_coverage.yaml
│   └── README.md                  # テンプレート使用ガイド
├── instructions/
│   └── ja/
│       └── tasks/                 # タスクテンプレートを参照する指示書
│           └── quality_checker.md
```

## タスクテンプレートの構造

### 完全な例: quality_check.yaml

```yaml
# task_templates/analysis/quality_check.yaml
version: "1.0"
metadata:
  id: "quality_check_v1"
  name: "指示書品質チェック"
  description: "AI指示書の品質を包括的に分析"
  category: "analysis"
  complexity: "high"
  estimated_time: "10-30min"

# 入力定義
inputs:
  files:
    type: "file_pattern"
    description: "分析対象のファイルパターン"
    default: "instructions/**/*.md"
    required: true
  
  config:
    type: "object"
    properties:
      language:
        type: "string"
        default: "ja"
      depth:
        type: "enum"
        values: ["basic", "standard", "detailed"]
        default: "standard"

# 処理ステップ
processing:
  - id: "collect"
    name: "ファイル収集"
    description: "対象ファイルのリストアップ"
    parallel: true
    output: "file_list"
    
  - id: "analyze"
    name: "個別分析"
    description: "各ファイルの品質チェック"
    input: "file_list"
    parallel: true
    checks:
      - id: "structure"
        name: "構造チェック"
        rules:
          - "必須セクション（目的、手順、例）の存在"
          - "見出しレベルの適切性"
          - "セクション順序の論理性"
      
      - id: "content"
        name: "内容チェック"
        rules:
          - "説明の明確性"
          - "例の具体性"
          - "用語の一貫性"
      
      - id: "code"
        name: "コード品質"
        rules:
          - "シンタックスの正確性"
          - "実行可能性"
          - "ベストプラクティス準拠"
    
  - id: "aggregate"
    name: "結果集約"
    description: "分析結果の統合"
    input: "analyze.results"
    operations:
      - "severity分類"
      - "パターン検出"
      - "改善提案生成"

# 出力定義
outputs:
  report:
    type: "structured_report"
    format: "yaml"
    schema:
      summary:
        total_files: "integer"
        pass_rate: "percentage"
        critical_issues: "integer"
      
      issues:
        type: "array"
        items:
          file: "string"
          severity: "enum[high, medium, low]"
          category: "string"
          description: "string"
          suggestion: "string"
      
      patterns:
        type: "array"
        items:
          pattern: "string"
          frequency: "integer"
          affected_files: "array[string]"
      
      recommendations:
        type: "array"
        items:
          priority: "enum[high, medium, low]"
          action: "string"
          expected_impact: "string"

# 実行ヒント（AI向けのガイダンス）
execution_hints:
  optimization:
    - "ファイル数が多い場合はバッチ処理を検討"
    - "類似パターンは一度の分析でまとめて検出"
  
  performance:
    batch_size: 10
    timeout_per_file: 30
  
  fallback:
    - "並列処理が不可能な場合は逐次実行"
    - "メモリ制限がある場合は結果を段階的に出力"
```

## 指示書でのタスクテンプレート使用方法

### 例: quality_checker.md

```markdown
# 指示書品質チェッカー

## 概要
この指示書は、AI指示書キット内のすべての指示書の品質を自動的にチェックします。

## タスク実行

### タスクテンプレートを使用した実行

以下のタスクテンプレートを読み込んで実行してください：

```yaml
task_template: "task_templates/analysis/quality_check.yaml"
parameters:
  files: "instructions/ja/**/*.md"
  config:
    language: "ja"
    depth: "detailed"
```

### 実行方法の選択

あなたの能力に応じて、以下のいずれかの方法で実行してください：

1. **統合実行**（推奨）
   - テンプレートのすべてのステップを一度に実行
   - 並列処理により高速化
   - 横断的な分析が可能

2. **段階的実行**
   - 各ステップを順次実行
   - 中間結果の確認が可能
   - リソース使用量を抑制

3. **簡易実行**
   - 基本的なチェックのみ実行
   - 高速だが詳細度は低い

### 期待される出力

実行後、以下の形式でレポートを生成してください：

```yaml
quality_report:
  summary:
    # サマリー情報
  issues:
    # 発見された問題
  recommendations:
    # 改善提案
```
```

## タスクテンプレートの利点

### 1. AI非依存性
```yaml
# Claude Code
# → Taskツールで自動的に並列実行

# ChatGPT
# → 利用可能なプラグインで最適化

# その他のAI
# → 標準的な逐次処理で実行
```

### 2. 再利用性
一度作成したテンプレートは、異なる指示書から何度でも参照可能：

```markdown
<!-- 指示書A -->
`task_template: "analysis/quality_check.yaml"`
parameters:
  files: "docs/**/*.md"

<!-- 指示書B -->
`task_template: "analysis/quality_check.yaml"`
parameters:
  files: "playground/**/*.js"
```

### 3. バージョン管理
```yaml
# task_templates/analysis/quality_check_v2.yaml
version: "2.0"
changes:
  - "新しいチェック項目追加"
  - "パフォーマンス最適化"
backward_compatible: true
```

## 実装例：品質チェックの実行フロー

### Step 1: テンプレート読み込み
AIがタスクテンプレートを読み込み、実行計画を立てる

### Step 2: 能力評価
```python
# 疑似コード
capabilities = self.evaluate_capabilities()
if capabilities.has_parallel_processing:
    execution_plan = "parallel"
elif capabilities.has_batch_processing:
    execution_plan = "batch"
else:
    execution_plan = "sequential"
```

### Step 3: 実行
選択した実行計画に基づいてタスクを処理

### Step 4: 結果生成
テンプレートで定義された出力形式に従ってレポート生成

## ベストプラクティス

### 1. テンプレート設計
- **単一責任**: 1つのテンプレートは1つの明確な目的を持つ
- **構成可能**: 小さなテンプレートを組み合わせて複雑なタスクを構築
- **拡張可能**: オプションパラメータで柔軟性を提供

### 2. 命名規則
```
<action>_<target>.yaml
例:
- analyze_code.yaml
- generate_documentation.yaml
- validate_structure.yaml
```

### 3. ドキュメント
各テンプレートには以下を含める：
- 目的と使用場面
- 必須/オプションパラメータ
- 期待される出力
- 実行例

## 今後の拡張可能性

### 1. テンプレート合成
```yaml
composite_task:
  templates:
    - "analysis/quality_check.yaml"
    - "generation/report.yaml"
  pipeline:
    - quality_check -> report.input
```

### 2. 条件付き実行
```yaml
conditional:
  if: "file_count > 100"
  then: "use_batch_processing"
  else: "use_direct_processing"
```

### 3. 外部ツール連携
```yaml
external_tools:
  optional:
    - name: "eslint"
      purpose: "JavaScript構文チェック"
      fallback: "basic_syntax_check"
```

## まとめ

タスクテンプレートは、AI指示書キットを真にAI中立的にするための重要な仕組みです。宣言的な記述により、各AIが自身の能力を最大限活用しながら、同じ結果を達成できるようになります。