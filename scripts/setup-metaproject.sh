#!/bin/bash
# AI指示書キット メタプロジェクト化スクリプト
# 使用方法:
#   bash scripts/setup-metaproject.sh [OPTIONS]
#
# オプション:
#   --project-name <name>  対象プロジェクト名
#   --project-url <url>    対象プロジェクトのGitリポジトリURL（クローンする場合）
#   --project-path <path>  既存プロジェクトのパス（移動する場合）
#   --force               確認をスキップ

set -e

# カラー定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# デフォルト設定
PROJECT_NAME=""
PROJECT_URL=""
PROJECT_PATH=""
FORCE_MODE=false

# ヘルプ表示
show_help() {
    cat << HELP
AI指示書キット メタプロジェクト化セットアップツール

このツールは現在のプロジェクトをメタプロジェクト化し、
他のソフトウェア開発プロジェクトをAI支援できる構造に変換します。

使用方法:
    bash scripts/setup-metaproject.sh [OPTIONS]

オプション:
    --project-name <name>   対象プロジェクト名（必須）
    --project-url <url>     クローンするGitリポジトリURL
    --project-path <path>   移動する既存プロジェクトのパス
    --force                 確認をスキップ
    --help                  このヘルプを表示

例:
    # 新しいプロジェクトをクローン
    bash scripts/setup-metaproject.sh --project-name myapp --project-url https://github.com/user/myapp.git

    # 既存プロジェクトを移動
    bash scripts/setup-metaproject.sh --project-name myapp --project-path ../myapp

    # 空のメタプロジェクトを作成
    bash scripts/setup-metaproject.sh --project-name myapp --force

構造:
    プロジェクトルート/
    ├── sources/              # 対象プロジェクトを配置
    │   └── <project-name>/   # 開発対象のプロジェクト
    ├── docs/                 # メタプロジェクトのドキュメント
    ├── analysis/             # 分析結果やレポート
    ├── README.md             # メタプロジェクトの説明
    ├── CLAUDE.md             # AI用の指示書（更新）
    └── .gitignore            # sourcesを適切に管理

HELP
}

# 引数解析
while [[ $# -gt 0 ]]; do
    case $1 in
        --project-name)
            PROJECT_NAME="$2"
            shift 2
            ;;
        --project-url)
            PROJECT_URL="$2"
            shift 2
            ;;
        --project-path)
            PROJECT_PATH="$2"
            shift 2
            ;;
        --force)
            FORCE_MODE=true
            shift
            ;;
        --help)
            show_help
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            show_help
            exit 1
            ;;
    esac
done

# 必須パラメータチェック
check_parameters() {
    if [ -z "$PROJECT_NAME" ]; then
        echo -e "${RED}❌ エラー: --project-name は必須です${NC}"
        show_help
        exit 1
    fi

    if [ -n "$PROJECT_URL" ] && [ -n "$PROJECT_PATH" ]; then
        echo -e "${RED}❌ エラー: --project-url と --project-path は同時に指定できません${NC}"
        exit 1
    fi
}

# 既存構造チェック
check_existing_structure() {
    echo -e "${BLUE}🔍 既存構造をチェック中...${NC}"

    if [ -d "sources" ]; then
        echo -e "${YELLOW}⚠️  sourcesディレクトリが既に存在します${NC}"
        if [ "$FORCE_MODE" = false ]; then
            echo -n "続行しますか？ [y/N]: "
            read -r confirm
            case "$confirm" in
                [yY][eE][sS]|[yY])
                    ;;
                *)
                    echo "中止しました"
                    exit 0
                    ;;
            esac
        fi
    fi
}

# ディレクトリ構造作成
create_structure() {
    echo -e "${BLUE}📁 メタプロジェクト構造を作成中...${NC}"

    # 必要なディレクトリを作成
    mkdir -p sources
    mkdir -p docs
    mkdir -p analysis

    echo -e "${GREEN}✅ ディレクトリ構造を作成しました${NC}"
}

# 対象プロジェクトのセットアップ
setup_target_project() {
    if [ -n "$PROJECT_URL" ]; then
        echo -e "${BLUE}📥 プロジェクトをクローン中: $PROJECT_URL${NC}"
        git clone "$PROJECT_URL" "sources/$PROJECT_NAME"
        echo -e "${GREEN}✅ プロジェクトをクローンしました${NC}"
    elif [ -n "$PROJECT_PATH" ]; then
        echo -e "${BLUE}📦 プロジェクトを移動中: $PROJECT_PATH${NC}"
        if [ ! -d "$PROJECT_PATH" ]; then
            echo -e "${RED}❌ エラー: $PROJECT_PATH が存在しません${NC}"
            exit 1
        fi
        cp -r "$PROJECT_PATH" "sources/$PROJECT_NAME"
        echo -e "${GREEN}✅ プロジェクトをコピーしました${NC}"
    else
        echo -e "${YELLOW}📝 空のプロジェクトディレクトリを作成${NC}"
        mkdir -p "sources/$PROJECT_NAME"
    fi
}

# README.md作成
create_readme() {
    echo -e "${BLUE}📝 README.mdを作成中...${NC}"

    cat > README.md << 'EOF'
# AI開発支援メタプロジェクト

このプロジェクトは、AI（Claude等）を使用してソフトウェア開発を支援するためのメタプロジェクトです。

## 概要

`sources/`ディレクトリ内の開発プロジェクトに対して、外側からAI支援を提供します。

## ディレクトリ構造

```
./
├── sources/              # 開発対象プロジェクト（git管理外）
│   └── PROJECT_NAME/     # 実際の開発プロジェクト
├── docs/                 # メタプロジェクトのドキュメント
├── analysis/             # 分析結果やレポート
├── instructions/         # プロジェクト固有のAI指示書
│   ├── ai_instruction_kits/  # AI指示書キット（サブモジュール）
│   └── PROJECT.md        # プロジェクト固有設定
├── scripts/              # 支援スクリプト
├── README.md             # このファイル
└── CLAUDE.md             # AI用の初回読み込み指示（自動生成）
```

## 使い方

### 1. AI（Claude）での作業開始

```
「CLAUDE.mdを読み込んで、sources/PROJECT_NAMEの開発を支援してください」
```

CLAUDE.mdは自動的にinstructions/PROJECT.mdを参照するよう設定されています。

### 2. チェックポイント管理

```bash
# タスク開始
scripts/checkpoint.sh start "機能開発" 5

# 指示書使用開始
scripts/checkpoint.sh instruction-start "指示書パス" "目的" TASK-ID

# 進捗報告
scripts/checkpoint.sh progress TASK-ID 2 5 "実装中" "テスト作成"

# 完了
scripts/checkpoint.sh complete TASK-ID "完了"
```

### 3. Git管理

このメタプロジェクト自体のGit管理：
- `sources/`内のプロジェクトは`.gitignore`で除外（独立したリポジトリとして管理）
- メタプロジェクトの成果物（分析結果、ドキュメント等）はコミット
- コミットは`scripts/commit.sh "メッセージ"`を使用

## 対象プロジェクト

- **プロジェクト名**: PROJECT_NAME
- **場所**: sources/PROJECT_NAME/
- **説明**: [プロジェクトの説明をここに記載]

## AI支援の範囲

- コードレビューと改善提案
- ドキュメント生成
- テストケース作成
- リファクタリング提案
- バグ修正支援
- 新機能の実装支援

## 注意事項

- `sources/`内のプロジェクトは独立したGitリポジトリとして管理
- AI生成物は`analysis/`や`docs/`に保存
- AI指示書キットのルール（チェックポイント管理など）に従う

---
生成日: $(date +%Y-%m-%d)
EOF

    # PROJECT_NAMEを実際の名前に置換
    sed -i "s/PROJECT_NAME/$PROJECT_NAME/g" README.md

    echo -e "${GREEN}✅ README.mdを作成しました${NC}"
}

# PROJECT.md作成
create_project_md() {
    echo -e "${BLUE}📝 instructions/PROJECT.mdを作成中...${NC}"

    mkdir -p instructions

    cat > instructions/PROJECT.md << 'EOF'
# AI開発支援設定

このプロジェクトでは`instructions/ai_instruction_kits/`のAI指示書システムを使用します。
タスク開始時は`instructions/ai_instruction_kits/instructions/ja/system/ROOT_INSTRUCTION.md`を読み込んでください。

## プロジェクト設定
- 言語: 日本語 (ja)
- チェックポイント管理: 有効
- チェックポイントスクリプト: scripts/checkpoint.sh
- ログファイル: checkpoint.log

## 重要なパス
- AI指示書システム: `instructions/ai_instruction_kits/`
- チェックポイントスクリプト: `scripts/checkpoint.sh`
- プロジェクト固有の設定: このファイル（`instructions/PROJECT.md`）

## コミットルール
- **必須**: `bash scripts/commit.sh "メッセージ"` または `git commit -m "メッセージ"`
- **禁止**: AI署名付きコミット（自動検出・拒否されます）

## プロジェクト固有の追加指示

### プロジェクト概要
- **目的**: PROJECT_NAMEの開発・改善
- **構成**: 開発支援環境と実際のソースコードを分離管理

### ディレクトリ構造と用語
- **メタプロジェクト**: このディレクトリ（プロジェクトルート）
  - AI指示書システムと開発支援環境を管理
  - git管理対象
- **ソースプロジェクト**: `sources/PROJECT_NAME/`
  - 実際の開発対象コード
  - **意図的にgit管理外**（`.gitignore`で除外）
  - 別リポジトリとして独立管理

### 開発時の注意事項
- `sources/`以下は別のgitリポジトリとして管理されるため、メタプロジェクトのコミットには含めない
- 開発作業は`sources/PROJECT_NAME/`内で行う
- AI指示書やチェックポイント管理はメタプロジェクトで行う

### プロジェクト固有設定
- コーディング規約: [プロジェクトに応じて記載]
- テストフレームワーク: [プロジェクトに応じて記載]
- ビルドコマンド: [プロジェクトに応じて記載]
- リントコマンド: [プロジェクトに応じて記載]
- その他の制約事項: [プロジェクトに応じて記載]

---
生成日: $(date +%Y-%m-%d)
EOF

    # PROJECT_NAMEを実際の名前に置換
    sed -i "s/PROJECT_NAME/$PROJECT_NAME/g" instructions/PROJECT.md

    echo -e "${GREEN}✅ instructions/PROJECT.mdを作成しました${NC}"
}

# CLAUDE.mdの作成（シンプル版）
create_claude_md() {
    echo -e "${BLUE}📝 CLAUDE.mdを作成中...${NC}"

    cat > CLAUDE.md << 'EOF'
# AI開発支援プロジェクト

このプロジェクトの設定は`instructions/PROJECT.md`に記載されています。
必ずそちらを読み込んでから作業を開始してください。

```
instructions/PROJECT.md を読み込んでください
```

---
生成日: $(date +%Y-%m-%d)
EOF

    echo -e "${GREEN}✅ CLAUDE.mdを作成しました${NC}"
}

# .gitignore更新
update_gitignore() {
    echo -e "${BLUE}📝 .gitignoreを更新中...${NC}"

    # .gitignoreが存在しない場合は作成
    if [ ! -f ".gitignore" ]; then
        touch .gitignore
    fi

    # メタプロジェクト設定を追加（重複チェック付き）
    if ! grep -q "^# AI開発支援ツール関連" .gitignore && ! grep -q "^# Meta-project" .gitignore; then
        cat >> .gitignore << 'EOF'

# AI開発支援ツール関連
instructions/ai_instruction_kits/
.openhands/
.claude/

# Git worktree directories
.gitworktrees/
gitworktrees/

# 開発対象のソースコード（別リポジトリで管理）
sources/

# チェックポイントログ
checkpoint.log
*.checkpoint.log

# Analysis outputs
analysis/*.tmp
analysis/*.log

# Backup files
*.bak

# IDE/エディタ設定
.vscode/
.idea/
*.swp
*.swo
*~
.DS_Store

# 環境変数
.env
.env.local
.env.*.local

# 一時ファイル
*.tmp
tmp/
temp/
EOF
        echo -e "${GREEN}✅ .gitignoreを更新しました${NC}"
    else
        echo -e "${YELLOW}📋 .gitignoreには既にメタプロジェクト設定があります${NC}"
    fi
}

# docs/README.md作成
create_docs_readme() {
    echo -e "${BLUE}📝 docs/README.mdを作成中...${NC}"

    cat > docs/README.md << 'EOF'
# メタプロジェクト ドキュメント

このディレクトリには、メタプロジェクトで生成されたドキュメントを格納します。

## ディレクトリ構造

```
docs/
├── architecture/     # アーキテクチャドキュメント
├── api/              # API仕様書
├── guides/           # 開発ガイド
└── reports/          # 分析レポート
```

## ドキュメント一覧

### 自動生成ドキュメント
- [作成されたドキュメントをここにリスト]

### 手動作成ドキュメント
- [手動で作成したドキュメントをここにリスト]

---
生成日: $(date +%Y-%m-%d)
EOF

    echo -e "${GREEN}✅ docs/README.mdを作成しました${NC}"
}

# analysis/README.md作成
create_analysis_readme() {
    echo -e "${BLUE}📝 analysis/README.mdを作成中...${NC}"

    cat > analysis/README.md << 'EOF'
# 分析結果

このディレクトリには、AIによる分析結果やレポートを格納します。

## ディレクトリ構造

```
analysis/
├── code-review/      # コードレビュー結果
├── performance/      # パフォーマンス分析
├── security/         # セキュリティ分析
└── quality/          # 品質分析
```

## 分析レポート

### 実施済み分析
- [日付] [分析タイプ] - [概要]

### 予定されている分析
- [分析タイプ] - [目的]

---
生成日: $(date +%Y-%m-%d)
EOF

    echo -e "${GREEN}✅ analysis/README.mdを作成しました${NC}"
}

# 完了メッセージ
show_completion() {
    echo -e "\n${GREEN}🎉 メタプロジェクト化が完了しました！${NC}"
    echo -e "\n${BLUE}📖 セットアップ完了:${NC}"
    echo "  ✅ sources/$PROJECT_NAME/ - 対象プロジェクト配置"
    echo "  ✅ docs/ - ドキュメント用ディレクトリ"
    echo "  ✅ analysis/ - 分析結果用ディレクトリ"
    echo "  ✅ README.md - メタプロジェクトの説明"
    echo "  ✅ CLAUDE.md - AI用指示書（更新済み）"
    echo "  ✅ .gitignore - Git管理設定"

    echo -e "\n${BLUE}🚀 次のステップ:${NC}"
    echo "1. sources/$PROJECT_NAME/ に開発対象プロジェクトを配置（未設定の場合）"
    echo "2. CLAUDE.md の「環境固有の設定」セクションをカスタマイズ"
    echo "3. AIに以下を伝えて作業開始："
    echo "   「CLAUDE.mdを読み込んで、sources/$PROJECT_NAME/の開発を支援してください」"

    echo -e "\n${BLUE}💡 便利なコマンド:${NC}"
    echo "  # タスク開始"
    echo "  scripts/checkpoint.sh start \"タスク名\" 5"
    echo ""
    echo "  # コミット"
    echo "  scripts/commit.sh \"メタプロジェクト初期設定\""
}

# AI指示書キットのサブモジュール設定
setup_ai_instruction_kits() {
    echo -e "${BLUE}🔧 AI指示書キットをサブモジュールとして設定中...${NC}"

    if [ ! -d "instructions/ai_instruction_kits" ]; then
        git submodule add https://github.com/dobachi/AI_Instruction_Kits.git instructions/ai_instruction_kits
        echo -e "${GREEN}✅ AI指示書キットをサブモジュールとして追加しました${NC}"
    else
        echo -e "${YELLOW}📋 AI指示書キットは既に存在します${NC}"
    fi
}

# メイン処理
main() {
    check_parameters
    check_existing_structure
    create_structure
    setup_target_project
    create_readme
    create_project_md
    create_claude_md
    update_gitignore
    create_docs_readme
    create_analysis_readme
    setup_ai_instruction_kits
    show_completion
}

# 実行
main