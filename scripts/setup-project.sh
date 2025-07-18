#!/bin/bash

# AI指示書を柔軟な構成でセットアップするスクリプト（モード選択版）
# scripts/とinstructions/ディレクトリ構成に対応

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DEFAULT_REPO_URL="https://github.com/dobachi/AI_Instruction_Kits.git"
REPO_URL="$DEFAULT_REPO_URL"

# i18nライブラリをソース
source "$SCRIPT_DIR/lib/i18n.sh"

# オプション解析
FORCE_MODE=false
DRY_RUN=false
BACKUP_MODE=true
INTEGRATION_MODE=""
SELECTED_MODE=""

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
            MSG_USAGE=$(get_message "usage" "Usage" "使用方法")
            MSG_DESC=$(get_message "desc" "Safely set up AI instructions in your project" "AI指示書をプロジェクトに安全にセットアップします")
            MSG_INTEGRATION_MODES=$(get_message "integration_modes" "Integration modes" "統合モード")
            MSG_MODE_DESC=$(get_message "mode_desc" "Specify integration mode (copy|clone|submodule)" "統合モードを指定 (copy|clone|submodule)")
            MSG_COPY_MODE=$(get_message "copy_mode" "Copy mode (simple file copy)" "コピーモード（シンプルなファイルコピー）")
            MSG_CLONE_MODE=$(get_message "clone_mode" "Clone mode (independent Git repository)" "クローンモード（独立したGitリポジトリ）")
            MSG_SUBMODULE_MODE=$(get_message "submodule_mode" "Submodule mode (recommended, default)" "サブモジュールモード（推奨、デフォルト）")
            MSG_OPTIONS=$(get_message "options" "Options" "オプション")
            MSG_CUSTOM_URL=$(get_message "custom_url" "Custom Git repository URL" "カスタムGitリポジトリURL")
            MSG_NO_CONFIRM=$(get_message "no_confirm" "Run without confirmation (legacy behavior)" "確認なしで実行（従来の動作）")
            MSG_DRY_RUN=$(get_message "dry_run" "Show what would be done without doing it" "実行内容を表示するだけで実際には実行しない")
            MSG_NO_BACKUP=$(get_message "no_backup" "Don't create backups of existing files" "既存ファイルのバックアップを作成しない")
            MSG_SHOW_HELP=$(get_message "show_help" "Show this help" "このヘルプを表示")
            MSG_MODE_DETAILS=$(get_message "mode_details" "Mode details" "モードの説明")
            MSG_COPY_DETAILS=$(get_message "copy_details" "Direct copy of latest files (no Git)" "最新版のファイルを直接コピー（Gitなし）")
            MSG_SIMPLEST=$(get_message "simplest" "Simplest" "最もシンプル")
            MSG_OFFLINE_OK=$(get_message "offline_ok" "Works offline" "オフラインでも利用可能")
            MSG_MANUAL_UPDATE=$(get_message "manual_update" "Manual updates" "更新は手動")
            MSG_CLONE_DETAILS=$(get_message "clone_details" "Manage as independent Git repository" "独立したGitリポジトリとして管理")
            MSG_FREE_MODIFY=$(get_message "free_modify" "Can be modified freely" "自由に変更可能")
            MSG_GIT_PULL=$(get_message "git_pull" "Update with git pull" "git pullで更新")
            MSG_KEEP_HISTORY=$(get_message "keep_history" "Keeps history" "履歴を保持")
            MSG_SUBMODULE_DETAILS=$(get_message "submodule_details" "Manage as Git submodule (recommended)" "Gitサブモジュールとして管理（推奨）")
            MSG_VERSION_FIX=$(get_message "version_fix" "Can fix version" "バージョン固定可能")
            MSG_MAIN_REPO_REL=$(get_message "main_repo_rel" "Maintains relationship with main repo" "本体リポジトリとの関係を保持")
            MSG_SUBMODULE_UPDATE=$(get_message "submodule_update" "Update with git submodule update" "git submodule updateで更新")
            MSG_DEFAULT_PROMPT=$(get_message "default_prompt" "By default, mode selection prompt is shown" "デフォルトでは、モード選択プロンプトが表示されます")
            MSG_EXAMPLES=$(get_message "examples" "Examples" "使用例")
            MSG_USE_DEFAULT_REPO=$(get_message "use_default_repo" "Use default repository" "デフォルトリポジトリを使用")
            MSG_USE_FORK=$(get_message "use_fork" "Use forked repository" "フォークしたリポジトリを使用")
            MSG_USE_PRIVATE=$(get_message "use_private" "Use private repository" "プライベートリポジトリを使用")
            
            cat << HELP
$MSG_USAGE: setup-project.sh [$(get_message "options" "OPTIONS" "オプション")]

$MSG_DESC。

$MSG_INTEGRATION_MODES:
  --mode <mode>  $MSG_MODE_DESC
  --copy          $MSG_COPY_MODE
  --clone         $MSG_CLONE_MODE
  --submodule     $MSG_SUBMODULE_MODE

$MSG_OPTIONS:
  --url <URL>      $MSG_CUSTOM_URL (default: $DEFAULT_REPO_URL)
  -f, --force      $MSG_NO_CONFIRM
  -n, --dry-run    $MSG_DRY_RUN
  --no-backup      $MSG_NO_BACKUP
  -h, --help       $MSG_SHOW_HELP

$MSG_MODE_DETAILS:
  copy:       $MSG_COPY_DETAILS
              - $MSG_SIMPLEST
              - $MSG_OFFLINE_OK
              - $MSG_MANUAL_UPDATE

  clone:      $MSG_CLONE_DETAILS
              - $MSG_FREE_MODIFY
              - $MSG_GIT_PULL
              - $MSG_KEEP_HISTORY

  submodule:  $MSG_SUBMODULE_DETAILS
              - $MSG_VERSION_FIX
              - $MSG_MAIN_REPO_REL
              - $MSG_SUBMODULE_UPDATE

$MSG_DEFAULT_PROMPT。

$MSG_EXAMPLES:
  # $MSG_USE_DEFAULT_REPO
  setup-project.sh --submodule
  
  # $MSG_USE_FORK
  setup-project.sh --url https://github.com/myname/AI_Instruction_Kits.git --clone
  
  # $MSG_USE_PRIVATE
  setup-project.sh --url git@github.com:mycompany/private-instructions.git --submodule
HELP
            exit 0
            ;;
        *)
            MSG_UNKNOWN_OPTION=$(get_message "unknown_option" "Unknown option" "不明なオプション")
            MSG_SEE_HELP=$(get_message "see_help" "See setup-project.sh --help for details" "詳細は setup-project.sh --help を参照してください")
            echo "❌ $MSG_UNKNOWN_OPTION: $1"
            echo "$MSG_SEE_HELP"
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
            MSG_BACKUP_CREATE=$(get_message "backup_create" "Creating backup" "バックアップ作成")
            dry_echo "$MSG_BACKUP_CREATE: $file → $backup"
        else
            cp "$file" "$backup"
            MSG_BACKUP_CREATED=$(get_message "backup_created" "Backup created" "バックアップ作成")
            echo "📋 $MSG_BACKUP_CREATED: $backup"
        fi
    fi
}

# モード選択関数
select_mode() {
    if [ -n "$INTEGRATION_MODE" ]; then
        case "$INTEGRATION_MODE" in
            copy|clone|submodule)
                SELECTED_MODE="$INTEGRATION_MODE"
                return 0
                ;;
            *)
                MSG_UNKNOWN_MODE=$(get_message "unknown_mode" "Unknown mode" "不明なモード")
                MSG_AVAILABLE_MODES=$(get_message "available_modes" "Available modes" "使用可能なモード")
                echo "❌ $MSG_UNKNOWN_MODE: $INTEGRATION_MODE"
                echo "$MSG_AVAILABLE_MODES: copy, clone, submodule"
                exit 1
                ;;
        esac
    fi
    
    if [ "$FORCE_MODE" = true ]; then
        # forceモードではデフォルトでsubmodule
        SELECTED_MODE="submodule"
        return 0
    fi
    
    MSG_SELECT_MODE=$(get_message "select_mode" "Select AI instruction integration mode" "AI指示書の統合モードを選択してください")
    MSG_SIMPLE_COPY=$(get_message "simple_copy" "Simple file copy (no Git)" "シンプルなファイルコピー（Gitなし）")
    MSG_INDEPENDENT_REPO=$(get_message "independent_repo" "Independent Git repository (freely modifiable)" "独立したGitリポジトリ（自由に変更可能）")
    MSG_GIT_SUBMODULE=$(get_message "git_submodule" "Git submodule (recommended)" "Gitサブモジュール（推奨）")
    MSG_CHOOSE=$(get_message "choose" "Choose" "選択してください")
    MSG_DEFAULT=$(get_message "default" "default" "デフォルト")
    MSG_INVALID_CHOICE=$(get_message "invalid_choice" "Invalid choice" "無効な選択です")
    MSG_APPROACH_TITLE=$(get_message "approach_title" "Available Setup Approaches" "利用可能なセットアップ方法")
    MSG_APPROACH_DESC=$(get_message "approach_desc" "Each approach has different characteristics suited for different use cases" "それぞれの方法には異なる用途に適した特徴があります")
    
    echo ""
    echo "═══════════════════════════════════════════════════════════════════"
    echo "📋 $MSG_APPROACH_TITLE"
    echo "═══════════════════════════════════════════════════════════════════"
    echo ""
    echo "$MSG_APPROACH_DESC:"
    echo ""
    echo "1️⃣  Copy Mode (copy)"
    echo "   ├─ 📄 $(get_message "copy_desc1" "Simply copies files to your project" "ファイルをプロジェクトに単純コピー")"
    echo "   ├─ ✅ $(get_message "copy_desc2" "No Git dependency, works offline" "Git不要、オフラインで動作")"
    echo "   ├─ ✅ $(get_message "copy_desc3" "Easiest to understand and modify" "最も理解・変更しやすい")"
    echo "   └─ ⚠️  $(get_message "copy_desc4" "Manual updates required" "更新は手動で行う必要")"
    echo ""
    echo "2️⃣  Clone Mode (clone)"
    echo "   ├─ 📦 $(get_message "clone_desc1" "Creates independent Git repository" "独立したGitリポジトリを作成")"
    echo "   ├─ ✅ $(get_message "clone_desc2" "Can track your own changes with Git" "独自の変更をGitで追跡可能")"
    echo "   ├─ ✅ $(get_message "clone_desc3" "Updates via git pull" "git pullで更新")"
    echo "   └─ ⚠️  $(get_message "clone_desc4" "Harder to merge upstream changes" "上流の変更のマージが困難")"
    echo ""
    echo "3️⃣  Submodule Mode (submodule) 🌟 RECOMMENDED"
    echo "   ├─ 🔗 $(get_message "submodule_desc1" "Links to official repository" "公式リポジトリにリンク")"
    echo "   ├─ ✅ $(get_message "submodule_desc2" "Easy updates with git submodule update" "git submodule updateで簡単更新")"
    echo "   ├─ ✅ $(get_message "submodule_desc3" "Version control integration" "バージョン管理との統合")"
    echo "   └─ ✅ $(get_message "submodule_desc4" "Best practice for dependency management" "依存関係管理のベストプラクティス")"
    echo ""
    echo "───────────────────────────────────────────────────────────────────"
    echo ""
    echo "🎯 $MSG_SELECT_MODE:"
    echo "1) copy      - $MSG_SIMPLE_COPY"
    echo "2) clone     - $MSG_INDEPENDENT_REPO"
    echo "3) submodule - $MSG_GIT_SUBMODULE"
    echo ""
    
    local choice
    read -r -p "$MSG_CHOOSE [1-3] ($MSG_DEFAULT: 3): " choice
    
    case "$choice" in
        1|copy)
            SELECTED_MODE="copy"
            ;;
        2|clone)
            SELECTED_MODE="clone"
            ;;
        3|submodule|"")
            SELECTED_MODE="submodule"
            ;;
        *)
            echo "❌ $MSG_INVALID_CHOICE"
            exit 1
            ;;
    esac
}

# コピーモードの実装
setup_copy_mode() {
    MSG_COPY_MODE_SETUP=$(get_message "copy_mode_setup" "Setting up AI instructions in copy mode" "コピーモードでAI指示書を設定")
    echo "📦 $MSG_COPY_MODE_SETUP..."
    
    if [ -d "instructions/ai_instruction_kits" ]; then
        MSG_DIR_EXISTS=$(get_message "dir_exists" "instructions/ai_instruction_kits already exists" "instructions/ai_instruction_kitsが既に存在します")
        MSG_BACKUP_AND_COPY=$(get_message "backup_and_copy" "Backup existing directory and copy new files?" "既存のディレクトリをバックアップして、新しいファイルをコピーしますか？")
        echo "⚠️  $MSG_DIR_EXISTS"
        if confirm "$MSG_BACKUP_AND_COPY"; then
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
        MSG_COPIED=$(get_message "copied" "AI instructions copied" "AI指示書をコピーしました")
        echo "✅ $MSG_COPIED"
    fi
}

# クローンモードの実装
setup_clone_mode() {
    MSG_CLONE_MODE_SETUP=$(get_message "clone_mode_setup" "Setting up AI instructions in clone mode" "クローンモードでAI指示書を設定")
    echo "📦 $MSG_CLONE_MODE_SETUP..."
    
    if [ -d "instructions/ai_instruction_kits" ]; then
        MSG_DIR_EXISTS=$(get_message "dir_exists" "instructions/ai_instruction_kits already exists" "instructions/ai_instruction_kitsが既に存在します")
        MSG_BACKUP_AND_CLONE=$(get_message "backup_and_clone" "Backup existing directory and clone new one?" "既存のディレクトリをバックアップして、新しくクローンしますか？")
        echo "⚠️  $MSG_DIR_EXISTS"
        if confirm "$MSG_BACKUP_AND_CLONE"; then
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
        MSG_CLONED=$(get_message "cloned" "AI instructions cloned" "AI指示書をクローンしました")
        echo "✅ $MSG_CLONED"
    fi
}

# サブモジュールモードの実装
setup_submodule_mode() {
    MSG_SUBMODULE_MODE_SETUP=$(get_message "submodule_mode_setup" "Setting up AI instructions in submodule mode" "サブモジュールモードでAI指示書を設定")
    echo "📦 $MSG_SUBMODULE_MODE_SETUP..."
    
    if [ -d "instructions/ai_instruction_kits" ]; then
        MSG_SUBMODULE_EXISTS=$(get_message "submodule_exists" "Submodule already exists" "サブモジュールは既に存在します")
        echo "✓ $MSG_SUBMODULE_EXISTS"
        return 0
    fi
    
    if [ "$DRY_RUN" = true ]; then
        dry_echo "cd instructions && git submodule add $REPO_URL ai_instruction_kits"
    else
        cd instructions
        git submodule add "$REPO_URL" ai_instruction_kits
        cd ..
        MSG_SUBMODULE_ADDED=$(get_message "submodule_added" "AI instructions added as submodule" "AI指示書をサブモジュールとして追加しました")
        echo "✅ $MSG_SUBMODULE_ADDED"
    fi
}

MSG_SETUP_START=$(get_message "setup_start" "Setting up AI instructions with flexible configuration" "AI指示書を柔軟な構成でセットアップします")
echo "🚀 $MSG_SETUP_START..."

# カスタムURLが指定された場合の通知
if [ "$REPO_URL" != "$DEFAULT_REPO_URL" ]; then
    MSG_CUSTOM_REPO_URL=$(get_message "custom_repo_url" "Custom repository URL" "カスタムリポジトリURL")
    echo "📌 $MSG_CUSTOM_REPO_URL: $REPO_URL"
fi

if [ "$DRY_RUN" = true ]; then
    MSG_DRY_RUN_MODE=$(get_message "dry_run_mode" "Dry run mode: No actual changes will be made" "ドライランモード: 実際の変更は行いません")
    echo "🔍 $MSG_DRY_RUN_MODE"
    echo ""
fi

# プロジェクトルートで実行されているか確認
if [ ! -d ".git" ] && [ "$INTEGRATION_MODE" != "copy" ]; then
    MSG_ERROR_NOT_GIT=$(get_message "error_not_git" "Error: Please run this script in the root directory of a Git project" "エラー: このスクリプトはGitプロジェクトのルートディレクトリで実行してください")
    MSG_USE_COPY_MODE=$(get_message "use_copy_mode" "To use copy mode, specify --copy option" "コピーモードを使用する場合は --copy オプションを指定してください")
    echo "❌ $MSG_ERROR_NOT_GIT"
    echo "（$MSG_USE_COPY_MODE）"
    exit 1
fi

# モード選択
select_mode
echo ""
MSG_SELECTED_MODE=$(get_message "selected_mode" "Selected mode" "選択されたモード")
echo "📌 $MSG_SELECTED_MODE: $SELECTED_MODE"

# ディレクトリ作成
echo ""
MSG_CREATE_DIRS=$(get_message "create_dirs" "Creating required directories" "必要なディレクトリを作成")
echo "📁 $MSG_CREATE_DIRS..."
if [ ! -d "scripts" ]; then
    MSG_CREATE_SCRIPTS_DIR=$(get_message "create_scripts_dir" "Create scripts directory?" "scriptsディレクトリを作成しますか？")
    if confirm "$MSG_CREATE_SCRIPTS_DIR"; then
        if [ "$DRY_RUN" = true ]; then
            dry_echo "mkdir -p scripts"
        else
            mkdir -p scripts
        fi
    else
        MSG_SKIP_SCRIPTS=$(get_message "skip_scripts" "Skipping scripts directory creation" "scriptsディレクトリの作成をスキップ")
        echo "⏭️  $MSG_SKIP_SCRIPTS"
    fi
else
    MSG_SCRIPTS_EXISTS=$(get_message "scripts_exists" "scripts directory already exists" "scriptsディレクトリは既に存在します")
    echo "✓ $MSG_SCRIPTS_EXISTS"
fi

if [ ! -d "instructions" ]; then
    MSG_CREATE_INSTRUCTIONS_DIR=$(get_message "create_instructions_dir" "Create instructions directory?" "instructionsディレクトリを作成しますか？")
    if confirm "$MSG_CREATE_INSTRUCTIONS_DIR"; then
        if [ "$DRY_RUN" = true ]; then
            dry_echo "mkdir -p instructions"
        else
            mkdir -p instructions
        fi
    else
        MSG_SKIP_INSTRUCTIONS=$(get_message "skip_instructions" "Skipping instructions directory creation" "instructionsディレクトリの作成をスキップ")
        echo "⏭️  $MSG_SKIP_INSTRUCTIONS"
    fi
else
    MSG_INSTRUCTIONS_EXISTS=$(get_message "instructions_exists" "instructions directory already exists" "instructionsディレクトリは既に存在します")
    echo "✓ $MSG_INSTRUCTIONS_EXISTS"
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
MSG_CREATE_SYMLINK=$(get_message "create_symlink" "Creating symbolic link to" "へのシンボリックリンクを作成")
echo "🔗 $MSG_CREATE_SYMLINK checkpoint.sh..."
if [ -e "scripts/checkpoint.sh" ]; then
    if [ -L "scripts/checkpoint.sh" ]; then
        MSG_SYMLINK_EXISTS=$(get_message "symlink_exists" "Symbolic link already exists" "シンボリックリンクは既に存在します")
        echo "✓ $MSG_SYMLINK_EXISTS"
    else
        MSG_FILE_EXISTS_NOT_LINK=$(get_message "file_exists_not_link" "already exists (not a symbolic link)" "が既に存在します（シンボリックリンクではありません）")
        MSG_BACKUP_AND_REPLACE=$(get_message "backup_and_replace" "Backup existing file and replace with symbolic link?" "既存のファイルをバックアップして、シンボリックリンクに置き換えますか？")
        echo "⚠️  scripts/checkpoint.sh$MSG_FILE_EXISTS_NOT_LINK"
        if confirm "$MSG_BACKUP_AND_REPLACE"; then
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
    MSG_CREATE_CHECKPOINT_LINK=$(get_message "create_checkpoint_link" "Create symbolic link to checkpoint.sh?" "checkpoint.shへのシンボリックリンクを作成しますか？")
    if confirm "$MSG_CREATE_CHECKPOINT_LINK"; then
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
MSG_CREATE_PROJECT_JA=$(get_message "create_project_ja" "Creating instructions/PROJECT.md (Japanese version)" "instructions/PROJECT.md（日本語版）を作成")
echo "📝 $MSG_CREATE_PROJECT_JA..."
if [ -f "instructions/PROJECT.md" ]; then
    MSG_PROJECT_EXISTS=$(get_message "project_exists" "instructions/PROJECT.md already exists" "instructions/PROJECT.mdが既に存在します")
    MSG_BACKUP_AND_OVERWRITE=$(get_message "backup_and_overwrite" "Backup existing file and overwrite with new template?" "既存のファイルをバックアップして、新しいテンプレートで上書きしますか？")
    echo "⚠️  $MSG_PROJECT_EXISTS"
    if confirm "$MSG_BACKUP_AND_OVERWRITE"; then
        backup_file "instructions/PROJECT.md"
        if [ "$DRY_RUN" = false ]; then
            if [ -n "$PROJECT_TEMPLATE_JA" ] && [ -f "$PROJECT_TEMPLATE_JA" ]; then
                cp "$PROJECT_TEMPLATE_JA" instructions/PROJECT.md
            else
                MSG_ERROR_TEMPLATE_NOT_FOUND=$(get_message "error_template_not_found" "Error: PROJECT.md template not found" "エラー: PROJECT.mdテンプレートが見つかりません")
                MSG_SEARCH_PATHS=$(get_message "search_paths" "Search paths" "探索パス")
                echo "❌ $MSG_ERROR_TEMPLATE_NOT_FOUND"
                echo "  $MSG_SEARCH_PATHS:"
                echo "    - ${SCRIPT_DIR}/../templates/ja/PROJECT_TEMPLATE.md"
                echo "    - instructions/ai_instruction_kits/templates/ja/PROJECT_TEMPLATE.md"
                exit 1
            fi
        else
            MSG_COPY_TEMPLATE=$(get_message "copy_template" "Copy PROJECT.md template" "PROJECT.mdテンプレートをコピー")
            dry_echo "$MSG_COPY_TEMPLATE"
        fi
    fi
else
    MSG_CREATE_PROJECT_MD_JA=$(get_message "create_project_md_ja" "Create instructions/PROJECT.md (Japanese version)?" "instructions/PROJECT.md（日本語版）を作成しますか？")
    if confirm "$MSG_CREATE_PROJECT_MD_JA"; then
        if [ "$DRY_RUN" = false ]; then
            if [ -n "$PROJECT_TEMPLATE_JA" ] && [ -f "$PROJECT_TEMPLATE_JA" ]; then
                cp "$PROJECT_TEMPLATE_JA" instructions/PROJECT.md
            else
                MSG_ERROR_TEMPLATE_NOT_FOUND=$(get_message "error_template_not_found" "Error: PROJECT.md template not found" "エラー: PROJECT.mdテンプレートが見つかりません")
                MSG_SEARCH_PATHS=$(get_message "search_paths" "Search paths" "探索パス")
                echo "❌ $MSG_ERROR_TEMPLATE_NOT_FOUND"
                echo "  $MSG_SEARCH_PATHS:"
                echo "    - ${SCRIPT_DIR}/../templates/ja/PROJECT_TEMPLATE.md"
                echo "    - instructions/ai_instruction_kits/templates/ja/PROJECT_TEMPLATE.md"
                exit 1
            fi
        else
            MSG_COPY_TEMPLATE=$(get_message "copy_template" "Copy PROJECT.md template" "PROJECT.mdテンプレートをコピー")
            dry_echo "$MSG_COPY_TEMPLATE"
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
MSG_CREATE_PROJECT_EN=$(get_message "create_project_en" "Creating instructions/PROJECT.en.md (English version)" "instructions/PROJECT.en.md（英語版）を作成")
echo "📝 $MSG_CREATE_PROJECT_EN..."
if [ -f "instructions/PROJECT.en.md" ]; then
    MSG_PROJECT_EN_EXISTS=$(get_message "project_en_exists" "instructions/PROJECT.en.md already exists" "instructions/PROJECT.en.mdが既に存在します")
    MSG_BACKUP_AND_OVERWRITE=$(get_message "backup_and_overwrite" "Backup existing file and overwrite with new template?" "既存のファイルをバックアップして、新しいテンプレートで上書きしますか？")
    echo "⚠️  $MSG_PROJECT_EN_EXISTS"
    if confirm "$MSG_BACKUP_AND_OVERWRITE"; then
        backup_file "instructions/PROJECT.en.md"
        if [ "$DRY_RUN" = false ]; then
            if [ -n "$PROJECT_TEMPLATE_EN" ] && [ -f "$PROJECT_TEMPLATE_EN" ]; then
                cp "$PROJECT_TEMPLATE_EN" instructions/PROJECT.en.md
            else
                echo "❌ Error: PROJECT.en.md template not found"
                echo "  Search paths:"
                echo "    - ${SCRIPT_DIR}/../templates/en/PROJECT_TEMPLATE.md"
                echo "    - instructions/ai_instruction_kits/templates/en/PROJECT_TEMPLATE.md"
                exit 1
            fi
        else
            MSG_COPY_TEMPLATE_EN=$(get_message "copy_template_en" "Copy PROJECT.en.md template" "PROJECT.en.mdテンプレートをコピー")
            dry_echo "$MSG_COPY_TEMPLATE_EN"
        fi
    fi
else
    MSG_CREATE_PROJECT_MD_EN=$(get_message "create_project_md_en" "Create instructions/PROJECT.en.md (English version)?" "instructions/PROJECT.en.md（英語版）を作成しますか？")
    if confirm "$MSG_CREATE_PROJECT_MD_EN"; then
        if [ "$DRY_RUN" = false ]; then
            if [ -n "$PROJECT_TEMPLATE_EN" ] && [ -f "$PROJECT_TEMPLATE_EN" ]; then
                cp "$PROJECT_TEMPLATE_EN" instructions/PROJECT.en.md
            else
                echo "❌ Error: PROJECT.en.md template not found"
                echo "  Search paths:"
                echo "    - ${SCRIPT_DIR}/../templates/en/PROJECT_TEMPLATE.md"
                echo "    - instructions/ai_instruction_kits/templates/en/PROJECT_TEMPLATE.md"
                exit 1
            fi
        else
            MSG_COPY_TEMPLATE_EN=$(get_message "copy_template_en" "Copy PROJECT.en.md template" "PROJECT.en.mdテンプレートをコピー")
            dry_echo "$MSG_COPY_TEMPLATE_EN"
        fi
    fi
fi

# AI製品別のシンボリックリンク作成
echo ""
MSG_CREATE_AI_SYMLINKS=$(get_message "create_ai_symlinks" "Creating symbolic links for AI products" "AI製品別のシンボリックリンクを作成")
echo "🔗 $MSG_CREATE_AI_SYMLINKS..."
ai_files=("CLAUDE.md" "GEMINI.md" "CURSOR.md")
ai_files_en=("CLAUDE.en.md" "GEMINI.en.md" "CURSOR.en.md")

for file in "${ai_files[@]}"; do
    if [ -e "$file" ]; then
        if [ -L "$file" ]; then
            MSG_SYMLINK_EXISTS=$(get_message "symlink_exists" "symbolic link already exists" "シンボリックリンクは既に存在します")
            echo "✓ $file $MSG_SYMLINK_EXISTS"
        else
            MSG_FILE_EXISTS_NOT_LINK=$(get_message "file_exists_not_link" "already exists (not a symbolic link)" "が既に存在します（シンボリックリンクではありません）")
            MSG_BACKUP_AND_REPLACE=$(get_message "backup_and_replace" "Backup existing file and replace with symbolic link?" "既存のファイルをバックアップして、シンボリックリンクに置き換えますか？")
            echo "⚠️  $file $MSG_FILE_EXISTS_NOT_LINK"
            if confirm "$MSG_BACKUP_AND_REPLACE"; then
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
        MSG_CREATE_SYMLINK_FOR=$(get_message "create_symlink_for" "Create symbolic link" "シンボリックリンクを作成しますか？")
        if confirm "$file $MSG_CREATE_SYMLINK_FOR"; then
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
            MSG_SYMLINK_EXISTS=$(get_message "symlink_exists" "symbolic link already exists" "シンボリックリンクは既に存在します")
            echo "✓ $file $MSG_SYMLINK_EXISTS"
        else
            MSG_FILE_EXISTS_NOT_LINK=$(get_message "file_exists_not_link" "already exists (not a symbolic link)" "が既に存在します（シンボリックリンクではありません）")
            MSG_BACKUP_AND_REPLACE=$(get_message "backup_and_replace" "Backup existing file and replace with symbolic link?" "既存のファイルをバックアップして、シンボリックリンクに置き換えますか？")
            echo "⚠️  $file $MSG_FILE_EXISTS_NOT_LINK"
            if confirm "$MSG_BACKUP_AND_REPLACE"; then
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
        MSG_CREATE_SYMLINK_FOR=$(get_message "create_symlink_for" "Create symbolic link" "シンボリックリンクを作成しますか？")
        if confirm "$file $MSG_CREATE_SYMLINK_FOR"; then
            if [ "$DRY_RUN" = true ]; then
                dry_echo "ln -sf instructions/PROJECT.en.md $file"
            else
                ln -sf instructions/PROJECT.en.md "$file"
            fi
        fi
    fi
done

# Gitフックの設定
echo ""
MSG_SETUP_GIT_HOOKS=$(get_message "setup_git_hooks" "Setting up Git hooks" "Gitフックを設定")
echo "🔧 $MSG_SETUP_GIT_HOOKS..."
if [ -d ".git/hooks" ]; then
    HOOK_SOURCE=""
    if [ -f "${SCRIPT_DIR}/../templates/git-hooks/prepare-commit-msg" ]; then
        HOOK_SOURCE="${SCRIPT_DIR}/../templates/git-hooks/prepare-commit-msg"
    elif [ -f "instructions/ai_instruction_kits/templates/git-hooks/prepare-commit-msg" ]; then
        HOOK_SOURCE="instructions/ai_instruction_kits/templates/git-hooks/prepare-commit-msg"
    fi
    
    if [ -n "$HOOK_SOURCE" ]; then
        if [ -e ".git/hooks/prepare-commit-msg" ]; then
            MSG_HOOK_EXISTS=$(get_message "hook_exists" ".git/hooks/prepare-commit-msg already exists" ".git/hooks/prepare-commit-msgが既に存在します")
            MSG_INSTALL_AI_HOOK=$(get_message "install_ai_hook" "Backup existing hook and install AI detection hook?" "既存のフックをバックアップして、AI検出フックをインストールしますか？")
            echo "⚠️  $MSG_HOOK_EXISTS"
            if confirm "$MSG_INSTALL_AI_HOOK"; then
                backup_file ".git/hooks/prepare-commit-msg"
                if [ "$DRY_RUN" = true ]; then
                    dry_echo "cp $HOOK_SOURCE .git/hooks/prepare-commit-msg && chmod +x .git/hooks/prepare-commit-msg"
                else
                    cp "$HOOK_SOURCE" .git/hooks/prepare-commit-msg
                    chmod +x .git/hooks/prepare-commit-msg
                    MSG_AI_HOOK_INSTALLED=$(get_message "ai_hook_installed" "AI detection hook installed" "AI検出フックをインストールしました")
                    echo "✅ $MSG_AI_HOOK_INSTALLED"
                fi
            fi
        else
            MSG_INSTALL_AI_PREVENT_HOOK=$(get_message "install_ai_prevent_hook" "Install Git hook to prevent AI commits?" "AIコミットを防止するGitフックをインストールしますか？")
            if confirm "$MSG_INSTALL_AI_PREVENT_HOOK"; then
                if [ "$DRY_RUN" = true ]; then
                    dry_echo "cp $HOOK_SOURCE .git/hooks/prepare-commit-msg && chmod +x .git/hooks/prepare-commit-msg"
                else
                    cp "$HOOK_SOURCE" .git/hooks/prepare-commit-msg
                    chmod +x .git/hooks/prepare-commit-msg
                    MSG_AI_HOOK_INSTALLED=$(get_message "ai_hook_installed" "AI detection hook installed" "AI検出フックをインストールしました")
                    echo "✅ $MSG_AI_HOOK_INSTALLED"
                fi
            fi
        fi
    else
        MSG_HOOK_TEMPLATE_NOT_FOUND=$(get_message "hook_template_not_found" "Git hook template not found" "Gitフックテンプレートが見つかりません")
        echo "⚠️  $MSG_HOOK_TEMPLATE_NOT_FOUND"
    fi
else
    MSG_HOOKS_DIR_NOT_FOUND=$(get_message "hooks_dir_not_found" ".git/hooks directory not found (may not be a Git repository)" ".git/hooksディレクトリが見つかりません（Gitリポジトリではない可能性があります）")
    echo "⚠️  $MSG_HOOKS_DIR_NOT_FOUND"
fi

# commit.shのリンク作成
echo ""
echo "🔗 $MSG_CREATE_SYMLINK commit.sh..."
if [ -e "scripts/commit.sh" ]; then
    if [ -L "scripts/commit.sh" ]; then
        MSG_COMMIT_SYMLINK_EXISTS=$(get_message "commit_symlink_exists" "commit.sh symbolic link already exists" "commit.shシンボリックリンクは既に存在します")
        echo "✓ $MSG_COMMIT_SYMLINK_EXISTS"
    else
        MSG_COMMIT_EXISTS_NOT_LINK=$(get_message "commit_exists_not_link" "scripts/commit.sh already exists (not a symbolic link)" "scripts/commit.shが既に存在します（シンボリックリンクではありません）")
        MSG_BACKUP_AND_REPLACE=$(get_message "backup_and_replace" "Backup existing file and replace with symbolic link?" "既存のファイルをバックアップして、シンボリックリンクに置き換えますか？")
        echo "⚠️  $MSG_COMMIT_EXISTS_NOT_LINK"
        if confirm "$MSG_BACKUP_AND_REPLACE"; then
            backup_file "scripts/commit.sh"
            if [ "$DRY_RUN" = true ]; then
                dry_echo "rm scripts/commit.sh && ln -sf ../instructions/ai_instruction_kits/scripts/commit.sh scripts/commit.sh"
            else
                rm scripts/commit.sh
                ln -sf ../instructions/ai_instruction_kits/scripts/commit.sh scripts/commit.sh
            fi
        fi
    fi
else
    MSG_CREATE_COMMIT_LINK=$(get_message "create_commit_link" "Create symbolic link to commit.sh?" "commit.shへのシンボリックリンクを作成しますか？")
    if confirm "$MSG_CREATE_COMMIT_LINK"; then
        if [ "$DRY_RUN" = true ]; then
            dry_echo "ln -sf ../instructions/ai_instruction_kits/scripts/commit.sh scripts/commit.sh"
        else
            ln -sf ../instructions/ai_instruction_kits/scripts/commit.sh scripts/commit.sh
        fi
    fi
fi

# .gitignoreに追加（サブモジュールモードの場合のみ）
if [ "$SELECTED_MODE" = "submodule" ]; then
    echo ""
    MSG_UPDATE_GITIGNORE=$(get_message "update_gitignore" "Updating .gitignore" ".gitignoreを更新")
    echo "📄 $MSG_UPDATE_GITIGNORE..."
    if [ -f ".gitignore" ]; then
        if ! grep -q "^instructions/ai_instruction_kits/$" .gitignore 2>/dev/null; then
            MSG_ADD_TO_GITIGNORE=$(get_message "add_to_gitignore" "Add 'instructions/ai_instruction_kits/' to .gitignore?" ".gitignoreに'instructions/ai_instruction_kits/'を追加しますか？")
            if confirm "$MSG_ADD_TO_GITIGNORE"; then
                backup_file ".gitignore"
                if [ "$DRY_RUN" = true ]; then
                    dry_echo "echo 'instructions/ai_instruction_kits/' >> .gitignore"
                else
                    echo "instructions/ai_instruction_kits/" >> .gitignore
                fi
            fi
        else
            MSG_GITIGNORE_ENTRY_EXISTS=$(get_message "gitignore_entry_exists" ".gitignore already has the entry" ".gitignoreには既にエントリが存在します")
            echo "✓ $MSG_GITIGNORE_ENTRY_EXISTS"
        fi
    else
        MSG_CREATE_GITIGNORE=$(get_message "create_gitignore" "Create .gitignore file and add 'instructions/ai_instruction_kits/'?" ".gitignoreファイルを作成して'instructions/ai_instruction_kits/'を追加しますか？")
        if confirm "$MSG_CREATE_GITIGNORE"; then
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
    MSG_DRY_RUN_COMPLETE=$(get_message "dry_run_complete" "Dry run completed" "ドライラン完了")
    MSG_RUN_WITHOUT_DRY=$(get_message "run_without_dry" "To actually run, execute again without --dry-run option" "実際に実行するには、--dry-run オプションなしで再度実行してください")
    echo "🔍 $MSG_DRY_RUN_COMPLETE"
    echo "$MSG_RUN_WITHOUT_DRY"
else
    echo ""
    MSG_SETUP_COMPLETE=$(get_message "setup_complete" "Setup completed!" "セットアップが完了しました！")
    echo "✅ $MSG_SETUP_COMPLETE"
    echo ""
    echo "📖 $(get_message "how_to_use" "How to use" "使い方") / Usage:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "🇯🇵 $(get_message "japanese" "Japanese" "日本語"):"
    MSG_JA_USAGE=$(get_message "ja_usage" 'When requesting AI assistance, say "Please refer to CLAUDE.md and [task description]"' 'AIに作業を依頼する際は「CLAUDE.mdを参照して、[タスク内容]」と伝えてください')
    MSG_JA_ALSO_AVAILABLE=$(get_message "ja_also_available" "(GEMINI.md, CURSOR.md also available)" "（GEMINI.md、CURSOR.mdも同様に使用可能）")
    echo "  $MSG_JA_USAGE"
    echo "  $MSG_JA_ALSO_AVAILABLE"
    echo ""
    echo "🇺🇸 English:"
    echo "  When requesting AI assistance, say \"Please refer to CLAUDE.en.md and [task description]\""
    echo "  (GEMINI.en.md, CURSOR.en.md also available)"
    echo ""
    MSG_CREATED_STRUCTURE=$(get_message "created_structure" "Created structure" "作成された構成")
    echo "📁 $MSG_CREATED_STRUCTURE:"
    echo "  scripts/"
    echo "    └── checkpoint.sh → ../instructions/ai_instruction_kits/scripts/checkpoint.sh"
    echo "  instructions/"
    echo "    ├── ai_instruction_kits/ ($SELECTED_MODE $(get_message "mode" "mode" "モード"))"
    MSG_PROJECT_CONFIG=$(get_message "project_config" "Project configuration" "プロジェクト設定")
    echo "    ├── PROJECT.md ($MSG_PROJECT_CONFIG)"
    echo "    └── PROJECT.en.md (Project configuration)"
    echo "  CLAUDE.md → instructions/PROJECT.md"
    echo "  GEMINI.md → instructions/PROJECT.md"
    echo "  CURSOR.md → instructions/PROJECT.md"
    echo ""
    
    # モード別の次のステップ
    MSG_NEXT_STEPS=$(get_message "next_steps" "Next steps" "次のステップ")
    echo "🔗 $MSG_NEXT_STEPS:"
    MSG_EDIT_PROJECT_SPECIFIC=$(get_message "edit_project_specific" "Edit instructions/PROJECT.md to add project-specific settings" "instructions/PROJECT.mdを編集してプロジェクト固有の設定を追加")
    MSG_UPDATE_REGULAR=$(get_message "update_regular" "Update regularly (manual download)" "定期的に最新版に更新（手動でダウンロード）")
    MSG_UPDATE_GIT_PULL=$(get_message "update_git_pull" "Update" "更新")
    MSG_CUSTOM_CHANGES=$(get_message "custom_changes" "Custom changes" "独自の変更")
    
    case "$SELECTED_MODE" in
        copy)
            echo "  1. $MSG_EDIT_PROJECT_SPECIFIC"
            echo "  2. $MSG_UPDATE_REGULAR"
            ;;
        clone)
            echo "  1. $MSG_EDIT_PROJECT_SPECIFIC"
            echo "  2. $MSG_UPDATE_GIT_PULL: cd instructions/ai_instruction_kits && git pull"
            echo "  3. $MSG_CUSTOM_CHANGES: cd instructions/ai_instruction_kits && git commit"
            ;;
        submodule)
            echo "  1. $MSG_EDIT_PROJECT_SPECIFIC"
            echo "  2. git add -A"
            echo "  3. git commit -m \"Add AI instruction configuration with flexible structure\""
            echo "  4. $MSG_UPDATE_GIT_PULL: git submodule update --remote"
            ;;
    esac
    echo ""
    MSG_IMPORTANT=$(get_message "important" "Important" "重要")
    MSG_CHECKPOINT_RUN_FROM=$(get_message "checkpoint_run_from" "Checkpoints are run from scripts/checkpoint.sh" "チェックポイントは scripts/checkpoint.sh から実行されます")
    MSG_AI_AUTO_PATH=$(get_message "ai_auto_path" "AI will automatically use the correct paths" "AIは自動的に正しいパスを使用します")
    echo "⚠️  $MSG_IMPORTANT:"
    echo "  • $MSG_CHECKPOINT_RUN_FROM"
    echo "  • $MSG_AI_AUTO_PATH"
fi