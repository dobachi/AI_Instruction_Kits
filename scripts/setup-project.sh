#!/bin/bash

# AI指示書を柔軟な構成でセットアップするスクリプト（モード選択版）
# scripts/とinstructions/ディレクトリ構成に対応

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DEFAULT_REPO_URL="https://github.com/dobachi/AI_Instruction_Kits.git"
REPO_URL="$DEFAULT_REPO_URL"

# オプション解析
FORCE_MODE=false
DRY_RUN=false
BACKUP_MODE=true
INTEGRATION_MODE=""

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --mode)
            INTEGRATION_MODE="$2"
            shift
            ;;
        --copy)
            INTEGRATION_MODE="copy"
            ;;
        --clone)
            INTEGRATION_MODE="clone"
            ;;
        --submodule)
            INTEGRATION_MODE="submodule"
            ;;
        --url)
            REPO_URL="$2"
            shift
            ;;
        --force|-f)
            FORCE_MODE=true
            ;;
        --dry-run|-n)
            DRY_RUN=true
            ;;
        --no-backup)
            BACKUP_MODE=false
            ;;
        --help|-h)
            cat << 'HELP'
使用方法: setup-project.sh [オプション]

AI指示書をプロジェクトに安全にセットアップします。

統合モード:
  --mode <モード>  統合モードを指定 (copy|clone|submodule)
  --copy          コピーモード（シンプルなファイルコピー）
  --clone         クローンモード（独立したGitリポジトリ）
  --submodule     サブモジュールモード（推奨、デフォルト）

オプション:
  --url <URL>      カスタムGitリポジトリURL (デフォルト: $DEFAULT_REPO_URL)
  -f, --force      確認なしで実行（従来の動作）
  -n, --dry-run    実行内容を表示するだけで実際には実行しない
  --no-backup      既存ファイルのバックアップを作成しない
  -h, --help       このヘルプを表示

モードの説明:
  copy:       最新版のファイルを直接コピー（Gitなし）
              - 最もシンプル
              - オフラインでも利用可能
              - 更新は手動

  clone:      独立したGitリポジトリとして管理
              - 自由に変更可能
              - git pullで更新
              - 履歴を保持

  submodule:  Gitサブモジュールとして管理（推奨）
              - バージョン固定可能
              - 本体リポジトリとの関係を保持
              - git submodule updateで更新

デフォルトでは、モード選択プロンプトが表示されます。

使用例:
  # デフォルトリポジトリを使用
  setup-project.sh --submodule
  
  # フォークしたリポジトリを使用
  setup-project.sh --url https://github.com/myname/AI_Instruction_Kits.git --clone
  
  # プライベートリポジトリを使用
  setup-project.sh --url git@github.com:mycompany/private-instructions.git --submodule
HELP
            exit 0
            ;;
        *)
            echo "❌ 不明なオプション: $1"
            echo "詳細は setup-project.sh --help を参照してください"
            exit 1
            ;;
    esac
    shift
done

# ドライラン時の出力関数
dry_echo() {
    if [ "$DRY_RUN" = true ]; then
        echo "[DRY-RUN] $1"
    fi
}

# 確認プロンプト関数
confirm() {
    if [ "$FORCE_MODE" = true ]; then
        return 0
    fi
    
    local prompt="$1 [y/N]: "
    local response
    
    read -r -p "$prompt" response
    case "$response" in
        [yY][eE][sS]|[yY])
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# バックアップ関数
backup_file() {
    local file="$1"
    if [ -f "$file" ] && [ "$BACKUP_MODE" = true ]; then
        local backup="${file}.backup.$(date +%Y%m%d_%H%M%S)"
        if [ "$DRY_RUN" = true ]; then
            dry_echo "バックアップ作成: $file → $backup"
        else
            cp "$file" "$backup"
            echo "📋 バックアップ作成: $backup"
        fi
    fi
}

# モード選択関数
select_mode() {
    if [ -n "$INTEGRATION_MODE" ]; then
        case "$INTEGRATION_MODE" in
            copy|clone|submodule)
                echo "$INTEGRATION_MODE"
                return 0
                ;;
            *)
                echo "❌ 不明なモード: $INTEGRATION_MODE"
                echo "使用可能なモード: copy, clone, submodule"
                exit 1
                ;;
        esac
    fi
    
    if [ "$FORCE_MODE" = true ]; then
        # forceモードではデフォルトでsubmodule
        echo "submodule"
        return 0
    fi
    
    echo ""
    echo "🎯 AI指示書の統合モードを選択してください:"
    echo ""
    echo "1) copy      - シンプルなファイルコピー（Gitなし）"
    echo "2) clone     - 独立したGitリポジトリ（自由に変更可能）"
    echo "3) submodule - Gitサブモジュール（推奨）"
    echo ""
    
    local choice
    read -r -p "選択してください [1-3] (デフォルト: 3): " choice
    
    case "$choice" in
        1|copy)
            echo "copy"
            ;;
        2|clone)
            echo "clone"
            ;;
        3|submodule|"")
            echo "submodule"
            ;;
        *)
            echo "❌ 無効な選択です"
            exit 1
            ;;
    esac
}

# コピーモードの実装
setup_copy_mode() {
    echo "📦 コピーモードでAI指示書を設定..."
    
    if [ -d "instructions/ai_instruction_kits" ]; then
        echo "⚠️  instructions/ai_instruction_kitsが既に存在します"
        if confirm "既存のディレクトリをバックアップして、新しいファイルをコピーしますか？"; then
            backup_file "instructions/ai_instruction_kits"
            if [ "$DRY_RUN" = true ]; then
                dry_echo "rm -rf instructions/ai_instruction_kits"
            else
                rm -rf instructions/ai_instruction_kits
            fi
        else
            return 1
        fi
    fi
    
    if [ "$DRY_RUN" = true ]; then
        dry_echo "cp -r ${SCRIPT_DIR}/.. instructions/ai_instruction_kits"
    else
        # AI_Instruction_Kitsのローカルコピーを作成
        cp -r "${SCRIPT_DIR}/.." instructions/ai_instruction_kits
        # .gitディレクトリを削除
        rm -rf instructions/ai_instruction_kits/.git
        echo "✅ AI指示書をコピーしました"
    fi
}

# クローンモードの実装
setup_clone_mode() {
    echo "📦 クローンモードでAI指示書を設定..."
    
    if [ -d "instructions/ai_instruction_kits" ]; then
        echo "⚠️  instructions/ai_instruction_kitsが既に存在します"
        if confirm "既存のディレクトリをバックアップして、新しくクローンしますか？"; then
            backup_file "instructions/ai_instruction_kits"
            if [ "$DRY_RUN" = true ]; then
                dry_echo "rm -rf instructions/ai_instruction_kits"
            else
                rm -rf instructions/ai_instruction_kits
            fi
        else
            return 1
        fi
    fi
    
    if [ "$DRY_RUN" = true ]; then
        dry_echo "cd instructions && git clone $REPO_URL ai_instruction_kits"
    else
        cd instructions
        git clone "$REPO_URL" ai_instruction_kits
        cd ..
        echo "✅ AI指示書をクローンしました"
    fi
}

# サブモジュールモードの実装
setup_submodule_mode() {
    echo "📦 サブモジュールモードでAI指示書を設定..."
    
    if [ -d "instructions/ai_instruction_kits" ]; then
        echo "✓ サブモジュールは既に存在します"
        return 0
    fi
    
    if [ "$DRY_RUN" = true ]; then
        dry_echo "cd instructions && git submodule add $REPO_URL ai_instruction_kits"
    else
        cd instructions
        git submodule add "$REPO_URL" ai_instruction_kits
        cd ..
        echo "✅ AI指示書をサブモジュールとして追加しました"
    fi
}

echo "🚀 AI指示書を柔軟な構成でセットアップします..."

# カスタムURLが指定された場合の通知
if [ "$REPO_URL" != "$DEFAULT_REPO_URL" ]; then
    echo "📌 カスタムリポジトリURL: $REPO_URL"
fi

if [ "$DRY_RUN" = true ]; then
    echo "🔍 ドライランモード: 実際の変更は行いません"
    echo ""
fi

# プロジェクトルートで実行されているか確認
if [ ! -d ".git" ] && [ "$INTEGRATION_MODE" != "copy" ]; then
    echo "❌ エラー: このスクリプトはGitプロジェクトのルートディレクトリで実行してください"
    echo "（コピーモードを使用する場合は --copy オプションを指定してください）"
    exit 1
fi

# モード選択
SELECTED_MODE=$(select_mode)
echo ""
echo "📌 選択されたモード: $SELECTED_MODE"

# ディレクトリ作成
echo ""
echo "📁 必要なディレクトリを作成..."
if [ ! -d "scripts" ]; then
    if confirm "scriptsディレクトリを作成しますか？"; then
        if [ "$DRY_RUN" = true ]; then
            dry_echo "mkdir -p scripts"
        else
            mkdir -p scripts
        fi
    else
        echo "⏭️  scriptsディレクトリの作成をスキップ"
    fi
else
    echo "✓ scriptsディレクトリは既に存在します"
fi

if [ ! -d "instructions" ]; then
    if confirm "instructionsディレクトリを作成しますか？"; then
        if [ "$DRY_RUN" = true ]; then
            dry_echo "mkdir -p instructions"
        else
            mkdir -p instructions
        fi
    else
        echo "⏭️  instructionsディレクトリの作成をスキップ"
    fi
else
    echo "✓ instructionsディレクトリは既に存在します"
fi

# 選択されたモードに応じてセットアップ
echo ""
case "$SELECTED_MODE" in
    copy)
        setup_copy_mode
        ;;
    clone)
        setup_clone_mode
        ;;
    submodule)
        setup_submodule_mode
        ;;
esac

# checkpoint.shへのシンボリックリンク
echo ""
echo "🔗 checkpoint.shへのシンボリックリンクを作成..."
if [ -e "scripts/checkpoint.sh" ]; then
    if [ -L "scripts/checkpoint.sh" ]; then
        echo "✓ シンボリックリンクは既に存在します"
    else
        echo "⚠️  scripts/checkpoint.shが既に存在します（シンボリックリンクではありません）"
        if confirm "既存のファイルをバックアップして、シンボリックリンクに置き換えますか？"; then
            backup_file "scripts/checkpoint.sh"
            if [ "$DRY_RUN" = true ]; then
                dry_echo "rm scripts/checkpoint.sh && ln -sf ../instructions/ai_instruction_kits/scripts/checkpoint.sh scripts/checkpoint.sh"
            else
                rm scripts/checkpoint.sh
                ln -sf ../instructions/ai_instruction_kits/scripts/checkpoint.sh scripts/checkpoint.sh
            fi
        fi
    fi
else
    if confirm "checkpoint.shへのシンボリックリンクを作成しますか？"; then
        if [ "$DRY_RUN" = true ]; then
            dry_echo "ln -sf ../instructions/ai_instruction_kits/scripts/checkpoint.sh scripts/checkpoint.sh"
        else
            ln -sf ../instructions/ai_instruction_kits/scripts/checkpoint.sh scripts/checkpoint.sh
        fi
    fi
fi

# テンプレートのパスを決定
PROJECT_TEMPLATE_JA=""
if [ -f "${SCRIPT_DIR}/../templates/ja/PROJECT_TEMPLATE.md" ]; then
    PROJECT_TEMPLATE_JA="${SCRIPT_DIR}/../templates/ja/PROJECT_TEMPLATE.md"
elif [ -f "instructions/ai_instruction_kits/templates/ja/PROJECT_TEMPLATE.md" ]; then
    PROJECT_TEMPLATE_JA="instructions/ai_instruction_kits/templates/ja/PROJECT_TEMPLATE.md"
fi

# PROJECT.md（日本語版）の作成
echo ""
echo "📝 instructions/PROJECT.md（日本語版）を作成..."
if [ -f "instructions/PROJECT.md" ]; then
    echo "⚠️  instructions/PROJECT.mdが既に存在します"
    if confirm "既存のファイルをバックアップして、新しいテンプレートで上書きしますか？"; then
        backup_file "instructions/PROJECT.md"
        if [ "$DRY_RUN" = false ]; then
            if [ -n "$PROJECT_TEMPLATE_JA" ] && [ -f "$PROJECT_TEMPLATE_JA" ]; then
                cp "$PROJECT_TEMPLATE_JA" instructions/PROJECT.md
            else
                # テンプレートが見つからない場合はインライン定義
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

## プロジェクト固有の追加指示
<!-- ここにプロジェクト固有の指示を追加してください -->

### 例：
- コーディング規約: 
- テストフレームワーク: 
- ビルドコマンド: 
- リントコマンド: 
- その他の制約事項: 
EOF
            fi
        else
            dry_echo "PROJECT.mdテンプレートをコピー"
        fi
    fi
else
    if confirm "instructions/PROJECT.md（日本語版）を作成しますか？"; then
        if [ "$DRY_RUN" = false ]; then
            if [ -n "$PROJECT_TEMPLATE_JA" ] && [ -f "$PROJECT_TEMPLATE_JA" ]; then
                cp "$PROJECT_TEMPLATE_JA" instructions/PROJECT.md
            else
                # テンプレートが見つからない場合はインライン定義
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

## プロジェクト固有の追加指示
<!-- ここにプロジェクト固有の指示を追加してください -->

### 例：
- コーディング規約: 
- テストフレームワーク: 
- ビルドコマンド: 
- リントコマンド: 
- その他の制約事項: 
EOF
            fi
        else
            dry_echo "PROJECT.mdテンプレートをコピー"
        fi
    fi
fi

# テンプレートのパスを決定（英語版）
PROJECT_TEMPLATE_EN=""
if [ -f "${SCRIPT_DIR}/../templates/en/PROJECT_TEMPLATE.md" ]; then
    PROJECT_TEMPLATE_EN="${SCRIPT_DIR}/../templates/en/PROJECT_TEMPLATE.md"
elif [ -f "instructions/ai_instruction_kits/templates/en/PROJECT_TEMPLATE.md" ]; then
    PROJECT_TEMPLATE_EN="instructions/ai_instruction_kits/templates/en/PROJECT_TEMPLATE.md"
fi

# PROJECT.en.md（英語版）の作成
echo ""
echo "📝 instructions/PROJECT.en.md（英語版）を作成..."
if [ -f "instructions/PROJECT.en.md" ]; then
    echo "⚠️  instructions/PROJECT.en.mdが既に存在します"
    if confirm "既存のファイルをバックアップして、新しいテンプレートで上書きしますか？"; then
        backup_file "instructions/PROJECT.en.md"
        if [ "$DRY_RUN" = false ]; then
            if [ -n "$PROJECT_TEMPLATE_EN" ] && [ -f "$PROJECT_TEMPLATE_EN" ]; then
                cp "$PROJECT_TEMPLATE_EN" instructions/PROJECT.en.md
            else
                # テンプレートが見つからない場合はインライン定義
                cat > instructions/PROJECT.en.md << 'EOF'
# AI Development Support Configuration

This project uses the AI instruction system in `instructions/ai_instruction_kits/`.
Please load `instructions/ai_instruction_kits/instructions/en/system/ROOT_INSTRUCTION.md` when starting a task.

## Project Settings
- Language: English (en)
- Checkpoint Management: Enabled
- Checkpoint Script: scripts/checkpoint.sh
- Log File: checkpoint.log

## Important Paths
- AI Instruction System: `instructions/ai_instruction_kits/`
- Checkpoint Script: `scripts/checkpoint.sh`
- Project-Specific Configuration: This file (`instructions/PROJECT.en.md`)

## Project-Specific Instructions
<!-- Add your project-specific instructions here -->

### Examples:
- Coding Standards: 
- Test Framework: 
- Build Commands: 
- Lint Commands: 
- Other Constraints: 
EOF
            fi
        else
            dry_echo "PROJECT.en.mdテンプレートをコピー"
        fi
    fi
else
    if confirm "instructions/PROJECT.en.md（英語版）を作成しますか？"; then
        if [ "$DRY_RUN" = false ]; then
            if [ -n "$PROJECT_TEMPLATE_EN" ] && [ -f "$PROJECT_TEMPLATE_EN" ]; then
                cp "$PROJECT_TEMPLATE_EN" instructions/PROJECT.en.md
            else
                # テンプレートが見つからない場合はインライン定義
                cat > instructions/PROJECT.en.md << 'EOF'
# AI Development Support Configuration

This project uses the AI instruction system in `instructions/ai_instruction_kits/`.
Please load `instructions/ai_instruction_kits/instructions/en/system/ROOT_INSTRUCTION.md` when starting a task.

## Project Settings
- Language: English (en)
- Checkpoint Management: Enabled
- Checkpoint Script: scripts/checkpoint.sh
- Log File: checkpoint.log

## Important Paths
- AI Instruction System: `instructions/ai_instruction_kits/`
- Checkpoint Script: `scripts/checkpoint.sh`
- Project-Specific Configuration: This file (`instructions/PROJECT.en.md`)

## Project-Specific Instructions
<!-- Add your project-specific instructions here -->

### Examples:
- Coding Standards: 
- Test Framework: 
- Build Commands: 
- Lint Commands: 
- Other Constraints: 
EOF
            fi
        else
            dry_echo "PROJECT.en.mdテンプレートをコピー"
        fi
    fi
fi

# AI製品別のシンボリックリンク作成
echo ""
echo "🔗 AI製品別のシンボリックリンクを作成..."
ai_files=("CLAUDE.md" "GEMINI.md" "CURSOR.md")
ai_files_en=("CLAUDE.en.md" "GEMINI.en.md" "CURSOR.en.md")

for file in "${ai_files[@]}"; do
    if [ -e "$file" ]; then
        if [ -L "$file" ]; then
            echo "✓ $file シンボリックリンクは既に存在します"
        else
            echo "⚠️  $file が既に存在します（シンボリックリンクではありません）"
            if confirm "既存のファイルをバックアップして、シンボリックリンクに置き換えますか？"; then
                backup_file "$file"
                if [ "$DRY_RUN" = true ]; then
                    dry_echo "rm $file && ln -sf instructions/PROJECT.md $file"
                else
                    rm "$file"
                    ln -sf instructions/PROJECT.md "$file"
                fi
            fi
        fi
    else
        if confirm "$file シンボリックリンクを作成しますか？"; then
            if [ "$DRY_RUN" = true ]; then
                dry_echo "ln -sf instructions/PROJECT.md $file"
            else
                ln -sf instructions/PROJECT.md "$file"
            fi
        fi
    fi
done

for file in "${ai_files_en[@]}"; do
    if [ -e "$file" ]; then
        if [ -L "$file" ]; then
            echo "✓ $file シンボリックリンクは既に存在します"
        else
            echo "⚠️  $file が既に存在します（シンボリックリンクではありません）"
            if confirm "既存のファイルをバックアップして、シンボリックリンクに置き換えますか？"; then
                backup_file "$file"
                if [ "$DRY_RUN" = true ]; then
                    dry_echo "rm $file && ln -sf instructions/PROJECT.en.md $file"
                else
                    rm "$file"
                    ln -sf instructions/PROJECT.en.md "$file"
                fi
            fi
        fi
    else
        if confirm "$file シンボリックリンクを作成しますか？"; then
            if [ "$DRY_RUN" = true ]; then
                dry_echo "ln -sf instructions/PROJECT.en.md $file"
            else
                ln -sf instructions/PROJECT.en.md "$file"
            fi
        fi
    fi
done

# .gitignoreに追加（サブモジュールモードの場合のみ）
if [ "$SELECTED_MODE" = "submodule" ]; then
    echo ""
    echo "📄 .gitignoreを更新..."
    if [ -f ".gitignore" ]; then
        if ! grep -q "^instructions/ai_instruction_kits/$" .gitignore 2>/dev/null; then
            if confirm ".gitignoreに'instructions/ai_instruction_kits/'を追加しますか？"; then
                backup_file ".gitignore"
                if [ "$DRY_RUN" = true ]; then
                    dry_echo "echo 'instructions/ai_instruction_kits/' >> .gitignore"
                else
                    echo "instructions/ai_instruction_kits/" >> .gitignore
                fi
            fi
        else
            echo "✓ .gitignoreには既にエントリが存在します"
        fi
    else
        if confirm ".gitignoreファイルを作成して'instructions/ai_instruction_kits/'を追加しますか？"; then
            if [ "$DRY_RUN" = true ]; then
                dry_echo "echo 'instructions/ai_instruction_kits/' > .gitignore"
            else
                echo "instructions/ai_instruction_kits/" > .gitignore
            fi
        fi
    fi
fi

if [ "$DRY_RUN" = true ]; then
    echo ""
    echo "🔍 ドライラン完了"
    echo "実際に実行するには、--dry-run オプションなしで再度実行してください"
else
    echo ""
    echo "✅ セットアップが完了しました！"
    echo ""
    echo "📖 使い方 / Usage:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "🇯🇵 日本語:"
    echo "  AIに作業を依頼する際は「CLAUDE.mdを参照して、[タスク内容]」と伝えてください"
    echo "  （GEMINI.md、CURSOR.mdも同様に使用可能）"
    echo ""
    echo "🇺🇸 English:"
    echo "  When requesting AI assistance, say \"Please refer to CLAUDE.en.md and [task description]\""
    echo "  (GEMINI.en.md, CURSOR.en.md also available)"
    echo ""
    echo "📁 作成された構成:"
    echo "  scripts/"
    echo "    └── checkpoint.sh → ../instructions/ai_instruction_kits/scripts/checkpoint.sh"
    echo "  instructions/"
    echo "    ├── ai_instruction_kits/ ($SELECTED_MODE モード)"
    echo "    ├── PROJECT.md (プロジェクト設定)"
    echo "    └── PROJECT.en.md (Project configuration)"
    echo "  CLAUDE.md → instructions/PROJECT.md"
    echo "  GEMINI.md → instructions/PROJECT.md"
    echo "  CURSOR.md → instructions/PROJECT.md"
    echo ""
    
    # モード別の次のステップ
    echo "🔗 次のステップ:"
    case "$SELECTED_MODE" in
        copy)
            echo "  1. instructions/PROJECT.mdを編集してプロジェクト固有の設定を追加"
            echo "  2. 定期的に最新版に更新（手動でダウンロード）"
            ;;
        clone)
            echo "  1. instructions/PROJECT.mdを編集してプロジェクト固有の設定を追加"
            echo "  2. 更新: cd instructions/ai_instruction_kits && git pull"
            echo "  3. 独自の変更: cd instructions/ai_instruction_kits && git commit"
            ;;
        submodule)
            echo "  1. instructions/PROJECT.mdを編集してプロジェクト固有の設定を追加"
            echo "  2. git add -A"
            echo "  3. git commit -m \"Add AI instruction configuration with flexible structure\""
            echo "  4. 更新: git submodule update --remote"
            ;;
    esac
    echo ""
    echo "⚠️  重要:"
    echo "  • チェックポイントは scripts/checkpoint.sh から実行されます"
    echo "  • AIは自動的に正しいパスを使用します"
fi