# モジュラーシステム詳細設計

**作成日**: 2025-07-27  
**概要**: 動的な指示書生成と管理に特化した独立システムの設計

## システム概要

モジュラーシステムは、再利用可能なモジュールを組み合わせて、タスクに最適化された指示書を動的に生成する独立システムです。プリセット管理も含み、高速なアクセスと柔軟なカスタマイゼーションを両立します。

## アーキテクチャ

### コアコンセプト
- **モジュール性**: 小さく独立した機能単位
- **合成可能性**: モジュールの自由な組み合わせ
- **キャッシング**: 生成結果の高速アクセス
- **バージョニング**: モジュールとプリセットのバージョン管理

### ディレクトリ構造
```
modular_system/
├── bin/                           # 実行可能ファイル
│   ├── modular                   # メインコマンド
│   └── preset                    # プリセット管理コマンド
├── core/
│   ├── generator/
│   │   ├── engine.sh            # 生成エンジン
│   │   ├── composer.sh          # モジュール合成器
│   │   ├── validator.sh         # 検証器
│   │   └── optimizer.sh         # 最適化器
│   ├── modules/                  # コアモジュール
│   │   ├── base/
│   │   │   ├── metadata.yaml    # モジュールメタデータ
│   │   │   └── *.md            # 基本モジュール
│   │   ├── development/
│   │   │   ├── metadata.yaml
│   │   │   ├── web_frontend.md
│   │   │   ├── web_backend.md
│   │   │   ├── cli_tool.md
│   │   │   └── api_design.md
│   │   ├── analysis/
│   │   │   ├── metadata.yaml
│   │   │   ├── data_analysis.md
│   │   │   ├── code_review.md
│   │   │   └── performance.md
│   │   ├── documentation/
│   │   │   ├── metadata.yaml
│   │   │   ├── technical_docs.md
│   │   │   ├── api_docs.md
│   │   │   └── user_guide.md
│   │   └── skills/
│   │       ├── metadata.yaml
│   │       ├── testing.md
│   │       ├── security.md
│   │       └── optimization.md
│   ├── registry/
│   │   ├── modules.json         # モジュールレジストリ
│   │   ├── dependencies.json    # 依存関係グラフ
│   │   └── compatibility.json   # 互換性マトリックス
│   └── lib/
│       ├── parser.sh            # メタデータパーサー
│       ├── merger.sh            # モジュールマージャー
│       └── cache_manager.sh     # キャッシュ管理
├── presets/                      # 事前生成プリセット
│   ├── official/                # 公式プリセット
│   │   ├── web_app_modern.md
│   │   ├── rest_api_production.md
│   │   ├── cli_tool_advanced.md
│   │   ├── data_pipeline.md
│   │   └── ml_project.md
│   ├── community/               # コミュニティプリセット
│   └── custom/                  # カスタムプリセット
├── cache/                       # 生成キャッシュ
│   ├── generated/              # 動的生成結果
│   ├── compiled/               # コンパイル済み
│   └── index.db                # キャッシュインデックス
├── templates/                   # ベーステンプレート
│   ├── instruction_base.md     # 指示書ベース
│   ├── section_templates/      # セクションテンプレート
│   └── output_formats/         # 出力フォーマット
├── config/
│   ├── default.yaml            # デフォルト設定
│   ├── profiles/               # 使用プロファイル
│   └── rules/                  # 合成ルール
└── plugins/                    # 拡張プラグイン
```

## データモデル

### モジュールメタデータ
```yaml
# modules/development/metadata.yaml
version: "1.0"
modules:
  web_frontend:
    id: "dev_web_frontend"
    name: "Webフロントエンド開発"
    description: "モダンなWebフロントエンド開発のベストプラクティス"
    tags: ["web", "frontend", "javascript", "react", "vue"]
    dependencies:
      required: ["base_development"]
      optional: ["testing", "security"]
    compatibility:
      combines_well: ["web_backend", "api_design"]
      conflicts: []
    parameters:
      framework:
        type: "enum"
        options: ["react", "vue", "angular", "vanilla"]
        default: "react"
      styling:
        type: "enum"
        options: ["css", "sass", "tailwind", "styled-components"]
        default: "tailwind"
```

### 生成リクエスト
```json
{
  "request_id": "req_20250727_abc123",
  "type": "web_application",
  "modules": [
    "web_frontend",
    "web_backend",
    "database",
    "testing",
    "deployment"
  ],
  "parameters": {
    "frontend_framework": "react",
    "backend_framework": "fastapi",
    "database": "postgresql",
    "testing_coverage": "high"
  },
  "output": {
    "name": "modern_web_app",
    "format": "markdown",
    "language": "ja"
  }
}
```

## API仕様

### コマンドラインインターフェース

#### モジュール操作
```bash
# モジュール一覧
modular list-modules [--category <category>] [--tags <tags>]

# モジュール詳細
modular show-module <module-id>

# モジュール検索
modular search-modules --query <query>

# 依存関係表示
modular deps <module-id> [--tree]
```

#### 指示書生成
```bash
# 基本生成
modular generate --modules <mod1,mod2> --output <name>

# パラメータ付き生成
modular generate \
  --modules web_frontend,web_backend \
  --params frontend.framework=vue,backend.framework=django \
  --output fullstack_app

# プロファイル使用
modular generate --profile modern_web --output my_app

# ドライラン（プレビュー）
modular generate --modules <modules> --dry-run
```

#### プリセット管理
```bash
# プリセット一覧
preset list [--category <category>]

# プリセット使用
preset use <preset-name> [--output <name>]

# カスタムプリセット作成
preset create --from-modules <modules> --name <name>

# プリセット共有
preset share <preset-name> [--public]
```

#### キャッシュ管理
```bash
# キャッシュ状態
modular cache status

# キャッシュクリア
modular cache clear [--older-than <days>]

# キャッシュ再構築
modular cache rebuild
```

### プログラマティックAPI
```bash
#!/bin/bash
source modular_system/core/lib/api.sh

# モジュール組み合わせ検証
if validate_module_combination "web_frontend" "cli_tool"; then
  echo "Warning: Unusual combination"
fi

# 動的生成
instruction=$(generate_instruction \
  --modules "api_design,security,testing" \
  --params "api.style=rest,security.level=high")

echo "$instruction" > custom_api_guide.md
```

## 生成プロセス

### 1. 要求分析
```mermaid
graph LR
    A[生成要求] --> B[モジュール解決]
    B --> C[依存関係チェック]
    C --> D[互換性検証]
    D --> E[パラメータ検証]
```

### 2. モジュール合成
```bash
# 合成アルゴリズム
1. ベーステンプレート読み込み
2. 必須モジュールの挿入
3. オプショナルモジュールの条件付き挿入
4. パラメータの適用
5. セクションの最適化
6. 重複の除去
7. 参照の解決
```

### 3. 最適化
```yaml
optimization_rules:
  - merge_similar_sections: true
  - remove_duplicates: true
  - order_by_workflow: true
  - compress_examples: false
  - inline_references: true
```

## モジュール開発

### モジュール構造
```markdown
<!-- modules/development/api_design.md -->
---
module_id: api_design
version: 1.2
dependencies: [base_development]
---

# API設計モジュール

## 提供する機能
- RESTful API設計原則
- エンドポイント命名規則
- エラーハンドリング標準

## 必須セクション
### ${SECTION:api_principles}
[API設計の原則をここに記述]

## 条件付きセクション
{{if params.api_style == "graphql"}}
### GraphQL特有の考慮事項
[GraphQL固有の内容]
{{endif}}

## 組み込み変数
- ${PROJECT_NAME}: プロジェクト名
- ${API_VERSION}: APIバージョン
- ${BASE_URL}: ベースURL
```

### メタデータスキーマ
```yaml
$schema: "https://ai-instruction-kits.org/schemas/module/v1"
module:
  id: string (required)
  version: semver (required)
  name: string (required)
  description: string
  author: string
  license: string
  tags: array[string]
  dependencies:
    required: array[module_id]
    optional: array[module_id]
  provides:
    sections: array[section_id]
    capabilities: array[string]
  parameters:
    <param_name>:
      type: string|number|boolean|enum
      default: any
      required: boolean
      description: string
```

## インテリジェント機能

### 1. 自動推奨
```bash
# 使用例
modular recommend --for "REST API with authentication"
# 出力:
# Recommended modules:
# - api_design (confidence: 95%)
# - authentication (confidence: 90%)
# - security (confidence: 85%)
# - testing (confidence: 80%)
```

### 2. 競合検出
```bash
modular check-conflicts --modules frontend_spa,server_side_rendering
# 出力:
# Warning: Potential conflict detected
# - frontend_spa assumes client-side rendering
# - server_side_rendering requires server-side setup
# Suggestion: Use hybrid_rendering module instead
```

### 3. 最適化提案
```bash
modular optimize --current-modules web_frontend,web_backend,api,database
# 出力:
# Optimization suggestions:
# 1. Merge 'api' into 'web_backend' (80% overlap)
# 2. Add 'caching' module for better performance
# 3. Consider 'monitoring' for production readiness
```

## 統合パターン

### 1. CI/CDパイプライン統合
```yaml
# .github/workflows/generate-docs.yml
steps:
  - name: Generate API Documentation
    run: |
      modular generate \
        --modules api_docs,examples \
        --params api.spec=openapi.yaml \
        --output docs/api.md
```

### 2. IDE統合
```json
// .vscode/tasks.json
{
  "label": "Generate Instruction",
  "type": "shell",
  "command": "modular",
  "args": [
    "generate",
    "--interactive"
  ]
}
```

### 3. 他システムとの連携
```bash
#!/bin/bash
# チェックポイントシステムと連携
TASK_ID=$(checkpoint create "Generate Custom Instruction")
modular generate \
  --modules $MODULES \
  --output $OUTPUT \
  --on-progress "checkpoint update $TASK_ID --status"
```

## パフォーマンスとスケーラビリティ

### キャッシング戦略
```yaml
cache_policy:
  generated:
    ttl: 7d
    max_size: 1GB
  compiled:
    ttl: 30d
    max_size: 500MB
  strategy: LRU
  
index:
  type: sqlite
  optimize_for: read_heavy
```

### 並行処理
```bash
# 大量生成時の並列化
modular batch-generate \
  --input requests.json \
  --parallel 4 \
  --output-dir generated/
```

## 拡張機能

### プラグインシステム
```bash
# プラグイン構造
plugins/
├── translators/          # 多言語対応
│   └── deepl.sh
├── validators/          # カスタム検証
│   └── company_style.sh
├── processors/          # 後処理
│   └── markdown_to_pdf.sh
└── sources/            # 外部ソース
    └── github_modules.sh
```

### WebUIインターフェース
```
将来計画:
- Reactベースの管理画面
- ドラッグ&ドロップでモジュール選択
- リアルタイムプレビュー
- コラボレーション機能
```

## セキュリティとガバナンス

### アクセス制御
```yaml
permissions:
  modules:
    create: [admin, developer]
    modify: [admin, module_owner]
    delete: [admin]
  presets:
    create: [all]
    share: [verified_users]
    modify: [owner]
```

### 監査ログ
```log
2025-07-27T10:00:00Z ACTION=generate USER=alice MODULES=[web_frontend,security] OUTPUT=secure_webapp
2025-07-27T10:05:00Z ACTION=create_preset USER=bob PRESET=custom_api FROM_MODULES=[api_design,testing]
```

## まとめ

モジュラーシステムは、AI指示書の動的生成と管理を効率化する独立したシステムです。モジュールの組み合わせによる柔軟性と、プリセットによる即座の利用可能性を両立し、開発者の生産性を大幅に向上させます。