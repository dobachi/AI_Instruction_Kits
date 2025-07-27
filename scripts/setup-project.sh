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
SYNC_CLAUDE_COMMANDS_ONLY=false

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
        --sync-claude-commands|--sync-claude)
            SYNC_CLAUDE_COMMANDS_ONLY=true
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
  --sync-claude-commands, --sync-claude
                   $(get_message "sync_claude_commands" "Sync Claude Code custom commands only" "Claude Codeカスタムコマンドの同期のみ実行")
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

# Claude Codeコマンドの同期
sync_claude_commands() {
    MSG_SYNC_CLAUDE=$(get_message "sync_claude_commands_msg" "Syncing Claude Code custom commands" "Claude Codeカスタムコマンドを同期中")
    echo "🔄 $MSG_SYNC_CLAUDE..."
    
    # .claudeディレクトリの存在確認
    if [ ! -d ".claude/commands" ]; then
        MSG_NO_CLAUDE_DIR=$(get_message "no_claude_dir" ".claude/commands directory not found" ".claude/commandsディレクトリが見つかりません")
        echo "⚠️  $MSG_NO_CLAUDE_DIR"
        
        MSG_CREATE_CLAUDE_DIR=$(get_message "create_claude_dir" "Create .claude/commands directory?" ".claude/commandsディレクトリを作成しますか？")
        if confirm "$MSG_CREATE_CLAUDE_DIR"; then
            mkdir -p .claude/commands
            MSG_CLAUDE_DIR_CREATED=$(get_message "claude_dir_created" ".claude/commands directory created" ".claude/commandsディレクトリを作成しました")
            echo "✅ $MSG_CLAUDE_DIR_CREATED"
        else
            return
        fi
    fi
    
    local claude_commands=("commit-and-report.md" "checkpoint.md" "reload-instructions.md")
    local updated_count=0
    local skipped_count=0
    
    for cmd_file in "${claude_commands[@]}"; do
        local src=""
        local dst=".claude/commands/$cmd_file"
        local lang=$(get_current_language)
        
        # 言語別ファイルを優先的に検索
        if [ -f "instructions/ai_instruction_kits/templates/claude-commands/$lang/$cmd_file" ]; then
            src="instructions/ai_instruction_kits/templates/claude-commands/$lang/$cmd_file"
        elif [ -f "${SCRIPT_DIR}/../templates/claude-commands/$lang/$cmd_file" ]; then
            src="${SCRIPT_DIR}/../templates/claude-commands/$lang/$cmd_file"
        elif [ -f "instructions/ai_instruction_kits/templates/claude-commands/$cmd_file" ]; then
            src="instructions/ai_instruction_kits/templates/claude-commands/$cmd_file"
        elif [ -f "${SCRIPT_DIR}/../templates/claude-commands/$cmd_file" ]; then
            src="${SCRIPT_DIR}/../templates/claude-commands/$cmd_file"
        else
            MSG_SRC_NOT_FOUND=$(get_message "src_not_found" "Source file not found" "ソースファイルが見つかりません")
            echo "⚠️  $MSG_SRC_NOT_FOUND: $cmd_file"
            continue
        fi
        
        # 差分チェック（シンボリックリンクチェック含む）
        if [ -e "$dst" ] || [ -L "$dst" ]; then
            if [ -L "$dst" ]; then
                MSG_MIGRATE_SYMLINK=$(get_message "migrate_symlink" "Migrate symbolic link to file?" "シンボリックリンクをファイルに移行しますか？")
                echo "🔄 $cmd_file はシンボリックリンクです"
                if confirm "$MSG_MIGRATE_SYMLINK"; then
                    if [ "$DRY_RUN" = true ]; then
                        dry_echo "rm $dst && cp $src $dst"
                    else
                        rm "$dst"
                        cp "$src" "$dst"
                    fi
                    MSG_MIGRATED=$(get_message "migrated" "migrated to file" "をファイルに移行しました")
                    echo "✅ $cmd_file $MSG_MIGRATED"
                    updated_count=$((updated_count + 1))
                else
                    skipped_count=$((skipped_count + 1))
                fi
                continue
            fi
            
            if diff -q "$src" "$dst" > /dev/null 2>&1; then
                MSG_UP_TO_DATE=$(get_message "up_to_date" "is up to date" "は最新です")
                echo "✓ $cmd_file $MSG_UP_TO_DATE"
                skipped_count=$((skipped_count + 1))
                continue
            fi
            
            # 更新確認
            echo ""
            MSG_UPDATE_AVAILABLE=$(get_message "update_available" "has updates" "に更新があります")
            echo "📝 $cmd_file $MSG_UPDATE_AVAILABLE"
            MSG_UPDATE_FILE=$(get_message "update_file" "Update?" "更新しますか？")
            if confirm "$MSG_UPDATE_FILE"; then
                backup_file "$dst"
                if [ "$DRY_RUN" = true ]; then
                    dry_echo "cp $src $dst"
                else
                    cp "$src" "$dst"
                fi
                MSG_UPDATED=$(get_message "updated" "updated" "を更新しました")
                echo "✅ $cmd_file $MSG_UPDATED"
                updated_count=$((updated_count + 1))
            else
                MSG_UPDATE_SKIPPED=$(get_message "update_skipped" "update skipped" "の更新をスキップしました")
                echo "⏭️  $cmd_file $MSG_UPDATE_SKIPPED"
                skipped_count=$((skipped_count + 1))
            fi
        else
            MSG_NOT_EXISTS=$(get_message "not_exists" "does not exist" "が存在しません")
            echo "📝 $cmd_file $MSG_NOT_EXISTS"
            MSG_CREATE_FILE=$(get_message "create_file" "Create?" "作成しますか？")
            if confirm "$MSG_CREATE_FILE"; then
                if [ "$DRY_RUN" = true ]; then
                    dry_echo "cp $src $dst"
                else
                    cp "$src" "$dst"
                fi
                MSG_CREATED=$(get_message "created" "created" "を作成しました")
                echo "✅ $cmd_file $MSG_CREATED"
                updated_count=$((updated_count + 1))
            fi
        fi
    done
    
    echo ""
    MSG_SYNC_COMPLETE=$(get_message "sync_complete" "Sync complete" "同期完了")
    MSG_UPDATED_COUNT=$(get_message "updated_count" "updated" "更新")
    MSG_SKIPPED_COUNT=$(get_message "skipped_count" "skipped" "スキップ")
    echo "📊 $MSG_SYNC_COMPLETE: $MSG_UPDATED_COUNT $updated_count 件、$MSG_SKIPPED_COUNT $skipped_count 件"
}

# --sync-claude-commands が指定された場合
if [ "$SYNC_CLAUDE_COMMANDS_ONLY" = true ]; then
    sync_claude_commands
    exit 0
fi

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

# OpenHands用の設定
echo ""
MSG_CREATE_OPENHANDS_DIR=$(get_message "create_openhands_dir" "Creating OpenHands configuration directory" "OpenHands設定ディレクトリを作成")
echo "📁 $MSG_CREATE_OPENHANDS_DIR..."
OPENHANDS_DIR_CREATED=false
if [ ! -d ".openhands/microagents" ]; then
    MSG_CREATE_OPENHANDS_MICROAGENTS=$(get_message "create_openhands_microagents" "Create .openhands/microagents directory for OpenHands?" "OpenHands用の.openhands/microagentsディレクトリを作成しますか？")
    if confirm "$MSG_CREATE_OPENHANDS_MICROAGENTS"; then
        if [ "$DRY_RUN" = true ]; then
            dry_echo "mkdir -p .openhands/microagents"
            OPENHANDS_DIR_CREATED=true
        else
            mkdir -p .openhands/microagents
            MSG_OPENHANDS_DIR_CREATED=$(get_message "openhands_dir_created" "OpenHands directory created" "OpenHandsディレクトリを作成しました")
            echo "✅ $MSG_OPENHANDS_DIR_CREATED"
            OPENHANDS_DIR_CREATED=true
        fi
    fi
else
    MSG_OPENHANDS_DIR_EXISTS=$(get_message "openhands_dir_exists" ".openhands/microagents directory already exists" ".openhands/microagentsディレクトリは既に存在します")
    echo "✓ $MSG_OPENHANDS_DIR_EXISTS"
    OPENHANDS_DIR_CREATED=true
fi

# repo.mdへのシンボリックリンク作成
if [ "$OPENHANDS_DIR_CREATED" = true ] || [ -d ".openhands/microagents" ]; then
    echo ""
    MSG_CREATE_REPO_MD_LINK=$(get_message "create_repo_md_link" "Creating symbolic link for OpenHands repo.md" "OpenHands repo.mdへのシンボリックリンクを作成")
    echo "🔗 $MSG_CREATE_REPO_MD_LINK..."
    if [ -e ".openhands/microagents/repo.md" ]; then
        if [ -L ".openhands/microagents/repo.md" ]; then
            MSG_REPO_MD_LINK_EXISTS=$(get_message "repo_md_link_exists" "repo.md symbolic link already exists" "repo.mdシンボリックリンクは既に存在します")
            echo "✓ $MSG_REPO_MD_LINK_EXISTS"
        else
            MSG_REPO_MD_EXISTS_NOT_LINK=$(get_message "repo_md_exists_not_link" ".openhands/microagents/repo.md already exists (not a symbolic link)" ".openhands/microagents/repo.mdが既に存在します（シンボリックリンクではありません）")
            MSG_BACKUP_AND_REPLACE=$(get_message "backup_and_replace" "Backup existing file and replace with symbolic link?" "既存のファイルをバックアップして、シンボリックリンクに置き換えますか？")
            echo "⚠️  $MSG_REPO_MD_EXISTS_NOT_LINK"
            if confirm "$MSG_BACKUP_AND_REPLACE"; then
                backup_file ".openhands/microagents/repo.md"
                if [ "$DRY_RUN" = true ]; then
                    dry_echo "rm .openhands/microagents/repo.md && ln -sf ../../instructions/PROJECT.md .openhands/microagents/repo.md"
                else
                    rm .openhands/microagents/repo.md
                    ln -sf ../../instructions/PROJECT.md .openhands/microagents/repo.md
                fi
            fi
        fi
    else
        MSG_CREATE_OPENHANDS_REPO_LINK=$(get_message "create_openhands_repo_link" "Create symbolic link to PROJECT.md for OpenHands?" "OpenHands用にPROJECT.mdへのシンボリックリンクを作成しますか？")
        if confirm "$MSG_CREATE_OPENHANDS_REPO_LINK"; then
            # OPENHANDS_ROOT.mdが存在する場合はそれを優先、なければPROJECT.mdへリンク
            if [ "$DRY_RUN" = true ]; then
                if [ -f "instructions/ja/system/OPENHANDS_ROOT.md" ]; then
                    dry_echo "ln -sf ../../instructions/ja/system/OPENHANDS_ROOT.md .openhands/microagents/repo.md"
                elif [ -f "instructions/ai_instruction_kits/instructions/ja/system/OPENHANDS_ROOT.md" ]; then
                    dry_echo "ln -sf ../../instructions/ai_instruction_kits/instructions/ja/system/OPENHANDS_ROOT.md .openhands/microagents/repo.md"
                else
                    dry_echo "ln -sf ../../instructions/PROJECT.md .openhands/microagents/repo.md"
                fi
            else
                if [ -f "instructions/ja/system/OPENHANDS_ROOT.md" ]; then
                    # AI指示書キット自体の開発時
                    ln -sf ../../instructions/ja/system/OPENHANDS_ROOT.md .openhands/microagents/repo.md
                    MSG_OPENHANDS_ROOT_LINKED=$(get_message "openhands_root_linked" "OpenHands repo.md linked to OPENHANDS_ROOT.md" "OpenHands repo.mdをOPENHANDS_ROOT.mdにリンクしました")
                    echo "✅ $MSG_OPENHANDS_ROOT_LINKED"
                elif [ -f "instructions/ai_instruction_kits/instructions/ja/system/OPENHANDS_ROOT.md" ]; then
                    # 通常のプロジェクト（サブモジュール使用時）
                    ln -sf ../../instructions/ai_instruction_kits/instructions/ja/system/OPENHANDS_ROOT.md .openhands/microagents/repo.md
                    MSG_OPENHANDS_ROOT_LINKED=$(get_message "openhands_root_linked" "OpenHands repo.md linked to OPENHANDS_ROOT.md" "OpenHands repo.mdをOPENHANDS_ROOT.mdにリンクしました")
                    echo "✅ $MSG_OPENHANDS_ROOT_LINKED"
                else
                    # OPENHANDS_ROOT.mdが存在しない場合は従来のPROJECT.mdへリンク
                    ln -sf ../../instructions/PROJECT.md .openhands/microagents/repo.md
                    MSG_OPENHANDS_LINK_CREATED=$(get_message "openhands_link_created" "OpenHands repo.md link created" "OpenHands repo.mdリンクを作成しました")
                    echo "✅ $MSG_OPENHANDS_LINK_CREATED"
                fi
            fi
        fi
    fi
fi

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

# scripts/libディレクトリのリンク作成（commit.shが依存するi18n.shのため）
echo ""
echo "🔗 $MSG_CREATE_SYMLINK scripts/lib..."
if [ -e "scripts/lib" ]; then
    if [ -L "scripts/lib" ]; then
        MSG_LIB_SYMLINK_EXISTS=$(get_message "lib_symlink_exists" "scripts/lib symbolic link already exists" "scripts/libシンボリックリンクは既に存在します")
        echo "✓ $MSG_LIB_SYMLINK_EXISTS"
    else
        MSG_LIB_EXISTS_NOT_LINK=$(get_message "lib_exists_not_link" "scripts/lib already exists (not a symbolic link)" "scripts/libが既に存在します（シンボリックリンクではありません）")
        MSG_BACKUP_AND_REPLACE=$(get_message "backup_and_replace" "Backup existing directory and replace with symbolic link?" "既存のディレクトリをバックアップして、シンボリックリンクに置き換えますか？")
        echo "⚠️  $MSG_LIB_EXISTS_NOT_LINK"
        if confirm "$MSG_BACKUP_AND_REPLACE"; then
            backup_file "scripts/lib"
            if [ "$DRY_RUN" = true ]; then
                dry_echo "rm -rf scripts/lib && ln -sf ../instructions/ai_instruction_kits/scripts/lib scripts/lib"
            else
                rm -rf scripts/lib
                ln -sf ../instructions/ai_instruction_kits/scripts/lib scripts/lib
            fi
        fi
    fi
else
    MSG_CREATE_LIB_LINK=$(get_message "create_lib_link" "Create symbolic link to scripts/lib?" "scripts/libへのシンボリックリンクを作成しますか？")
    if confirm "$MSG_CREATE_LIB_LINK"; then
        if [ "$DRY_RUN" = true ]; then
            dry_echo "ln -sf ../instructions/ai_instruction_kits/scripts/lib scripts/lib"
        else
            ln -sf ../instructions/ai_instruction_kits/scripts/lib scripts/lib
        fi
    fi
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

# generate-instruction.shのリンク作成
echo ""
echo "🔗 $MSG_CREATE_SYMLINK generate-instruction.sh..."
if [ -e "scripts/generate-instruction.sh" ]; then
    if [ -L "scripts/generate-instruction.sh" ]; then
        MSG_GENERATE_SYMLINK_EXISTS=$(get_message "generate_symlink_exists" "generate-instruction.sh symbolic link already exists" "generate-instruction.shシンボリックリンクは既に存在します")
        echo "✓ $MSG_GENERATE_SYMLINK_EXISTS"
    else
        MSG_GENERATE_EXISTS_NOT_LINK=$(get_message "generate_exists_not_link" "scripts/generate-instruction.sh already exists (not a symbolic link)" "scripts/generate-instruction.shが既に存在します（シンボリックリンクではありません）")
        MSG_BACKUP_AND_REPLACE=$(get_message "backup_and_replace" "Backup existing file and replace with symbolic link?" "既存のファイルをバックアップして、シンボリックリンクに置き換えますか？")
        echo "⚠️  $MSG_GENERATE_EXISTS_NOT_LINK"
        if confirm "$MSG_BACKUP_AND_REPLACE"; then
            backup_file "scripts/generate-instruction.sh"
            if [ "$DRY_RUN" = true ]; then
                dry_echo "rm scripts/generate-instruction.sh && ln -sf ../instructions/ai_instruction_kits/scripts/generate-instruction.sh scripts/generate-instruction.sh"
            else
                rm scripts/generate-instruction.sh
                ln -sf ../instructions/ai_instruction_kits/scripts/generate-instruction.sh scripts/generate-instruction.sh
            fi
        fi
    fi
else
    MSG_CREATE_GENERATE_LINK=$(get_message "create_generate_link" "Create symbolic link to generate-instruction.sh?" "generate-instruction.shへのシンボリックリンクを作成しますか？")
    if confirm "$MSG_CREATE_GENERATE_LINK"; then
        if [ "$DRY_RUN" = true ]; then
            dry_echo "ln -sf ../instructions/ai_instruction_kits/scripts/generate-instruction.sh scripts/generate-instruction.sh"
        else
            ln -sf ../instructions/ai_instruction_kits/scripts/generate-instruction.sh scripts/generate-instruction.sh
        fi
    fi
fi

# validate-modules.shのリンク作成
echo ""
echo "🔗 $MSG_CREATE_SYMLINK validate-modules.sh..."
if [ -e "scripts/validate-modules.sh" ]; then
    if [ -L "scripts/validate-modules.sh" ]; then
        MSG_VALIDATE_SYMLINK_EXISTS=$(get_message "validate_symlink_exists" "validate-modules.sh symbolic link already exists" "validate-modules.shシンボリックリンクは既に存在します")
        echo "✓ $MSG_VALIDATE_SYMLINK_EXISTS"
    else
        MSG_VALIDATE_EXISTS_NOT_LINK=$(get_message "validate_exists_not_link" "scripts/validate-modules.sh already exists (not a symbolic link)" "scripts/validate-modules.shが既に存在します（シンボリックリンクではありません）")
        MSG_BACKUP_AND_REPLACE=$(get_message "backup_and_replace" "Backup existing file and replace with symbolic link?" "既存のファイルをバックアップして、シンボリックリンクに置き換えますか？")
        echo "⚠️  $MSG_VALIDATE_EXISTS_NOT_LINK"
        if confirm "$MSG_BACKUP_AND_REPLACE"; then
            backup_file "scripts/validate-modules.sh"
            if [ "$DRY_RUN" = true ]; then
                dry_echo "rm scripts/validate-modules.sh && ln -sf ../instructions/ai_instruction_kits/scripts/validate-modules.sh scripts/validate-modules.sh"
            else
                rm scripts/validate-modules.sh
                ln -sf ../instructions/ai_instruction_kits/scripts/validate-modules.sh scripts/validate-modules.sh
            fi
        fi
    fi
else
    MSG_CREATE_VALIDATE_LINK=$(get_message "create_validate_link" "Create symbolic link to validate-modules.sh?" "validate-modules.shへのシンボリックリンクを作成しますか？")
    if confirm "$MSG_CREATE_VALIDATE_LINK"; then
        if [ "$DRY_RUN" = true ]; then
            dry_echo "ln -sf ../instructions/ai_instruction_kits/scripts/validate-modules.sh scripts/validate-modules.sh"
        else
            ln -sf ../instructions/ai_instruction_kits/scripts/validate-modules.sh scripts/validate-modules.sh
        fi
    fi
fi

# search-instructions.shのリンク作成
echo ""
echo "🔗 $MSG_CREATE_SYMLINK search-instructions.sh..."
if [ -e "scripts/search-instructions.sh" ]; then
    if [ -L "scripts/search-instructions.sh" ]; then
        MSG_SEARCH_SYMLINK_EXISTS=$(get_message "search_symlink_exists" "search-instructions.sh symbolic link already exists" "search-instructions.shシンボリックリンクは既に存在します")
        echo "✓ $MSG_SEARCH_SYMLINK_EXISTS"
    else
        MSG_SEARCH_EXISTS_NOT_LINK=$(get_message "search_exists_not_link" "scripts/search-instructions.sh already exists (not a symbolic link)" "scripts/search-instructions.shが既に存在します（シンボリックリンクではありません）")
        MSG_BACKUP_AND_REPLACE=$(get_message "backup_and_replace" "Backup existing file and replace with symbolic link?" "既存のファイルをバックアップして、シンボリックリンクに置き換えますか？")
        echo "⚠️  $MSG_SEARCH_EXISTS_NOT_LINK"
        if confirm "$MSG_BACKUP_AND_REPLACE"; then
            backup_file "scripts/search-instructions.sh"
            if [ "$DRY_RUN" = true ]; then
                dry_echo "rm scripts/search-instructions.sh && ln -sf ../instructions/ai_instruction_kits/scripts/search-instructions.sh scripts/search-instructions.sh"
            else
                rm scripts/search-instructions.sh
                ln -sf ../instructions/ai_instruction_kits/scripts/search-instructions.sh scripts/search-instructions.sh
            fi
        fi
    fi
else
    MSG_CREATE_SEARCH_LINK=$(get_message "create_search_link" "Create symbolic link to search-instructions.sh?" "search-instructions.shへのシンボリックリンクを作成しますか？")
    if confirm "$MSG_CREATE_SEARCH_LINK"; then
        if [ "$DRY_RUN" = true ]; then
            dry_echo "ln -sf ../instructions/ai_instruction_kits/scripts/search-instructions.sh scripts/search-instructions.sh"
        else
            ln -sf ../instructions/ai_instruction_kits/scripts/search-instructions.sh scripts/search-instructions.sh
        fi
    fi
fi

# generate-metadata.shのリンク作成
echo ""
echo "🔗 $MSG_CREATE_SYMLINK generate-metadata.sh..."
if [ -e "scripts/generate-metadata.sh" ]; then
    if [ -L "scripts/generate-metadata.sh" ]; then
        MSG_METADATA_SYMLINK_EXISTS=$(get_message "metadata_symlink_exists" "generate-metadata.sh symbolic link already exists" "generate-metadata.shシンボリックリンクは既に存在します")
        echo "✓ $MSG_METADATA_SYMLINK_EXISTS"
    else
        MSG_METADATA_EXISTS_NOT_LINK=$(get_message "metadata_exists_not_link" "scripts/generate-metadata.sh already exists (not a symbolic link)" "scripts/generate-metadata.shが既に存在します（シンボリックリンクではありません）")
        MSG_BACKUP_AND_REPLACE=$(get_message "backup_and_replace" "Backup existing file and replace with symbolic link?" "既存のファイルをバックアップして、シンボリックリンクに置き換えますか？")
        echo "⚠️  $MSG_METADATA_EXISTS_NOT_LINK"
        if confirm "$MSG_BACKUP_AND_REPLACE"; then
            backup_file "scripts/generate-metadata.sh"
            if [ "$DRY_RUN" = true ]; then
                dry_echo "rm scripts/generate-metadata.sh && ln -sf ../instructions/ai_instruction_kits/scripts/generate-metadata.sh scripts/generate-metadata.sh"
            else
                rm scripts/generate-metadata.sh
                ln -sf ../instructions/ai_instruction_kits/scripts/generate-metadata.sh scripts/generate-metadata.sh
            fi
        fi
    fi
else
    MSG_CREATE_METADATA_LINK=$(get_message "create_metadata_link" "Create symbolic link to generate-metadata.sh?" "generate-metadata.shへのシンボリックリンクを作成しますか？")
    if confirm "$MSG_CREATE_METADATA_LINK"; then
        if [ "$DRY_RUN" = true ]; then
            dry_echo "ln -sf ../instructions/ai_instruction_kits/scripts/generate-metadata.sh scripts/generate-metadata.sh"
        else
            ln -sf ../instructions/ai_instruction_kits/scripts/generate-metadata.sh scripts/generate-metadata.sh
        fi
    fi
fi

# Claude Codeカスタムコマンドの設定
echo ""
MSG_SETUP_CLAUDE_COMMANDS=$(get_message "setup_claude_commands" "Setting up Claude Code custom commands" "Claude Codeカスタムコマンドを設定")
echo "⚡ $MSG_SETUP_CLAUDE_COMMANDS..."

# .claude/commands ディレクトリ作成
if [ ! -d ".claude/commands" ]; then
    MSG_CREATE_CLAUDE_COMMANDS_DIR=$(get_message "create_claude_commands_dir" "Create .claude/commands directory for Claude Code?" "Claude Code用の.claude/commandsディレクトリを作成しますか？")
    if confirm "$MSG_CREATE_CLAUDE_COMMANDS_DIR"; then
        if [ "$DRY_RUN" = true ]; then
            dry_echo "mkdir -p .claude/commands"
        else
            mkdir -p .claude/commands
            MSG_CLAUDE_COMMANDS_DIR_CREATED=$(get_message "claude_commands_dir_created" ".claude/commands directory created" ".claude/commandsディレクトリを作成しました")
            echo "✅ $MSG_CLAUDE_COMMANDS_DIR_CREATED"
        fi
    fi
else
    MSG_CLAUDE_COMMANDS_DIR_EXISTS=$(get_message "claude_commands_dir_exists" ".claude/commands directory already exists" ".claude/commandsディレクトリは既に存在します")
    echo "✓ $MSG_CLAUDE_COMMANDS_DIR_EXISTS"
fi

# Claude Codeコマンドのファイルコピー
if [ -d ".claude/commands" ] || [ "$DRY_RUN" = true ]; then
    echo ""
    MSG_COPY_CLAUDE_COMMANDS=$(get_message "copy_claude_commands" "Copying Claude Code command files" "Claude Codeコマンドファイルをコピー")
    echo "🔗 $MSG_COPY_CLAUDE_COMMANDS..."
    
    claude_commands=("commit-and-report.md" "checkpoint.md" "reload-instructions.md")
    
    for cmd_file in "${claude_commands[@]}"; do
        local src=""
        local dst=".claude/commands/$cmd_file"
        
        # 既存ファイルチェック（シンボリックリンクの移行処理含む）
        if [ -e "$dst" ]; then
            if [ -L "$dst" ]; then
                MSG_MIGRATE_SYMLINK=$(get_message "migrate_symlink" "Migrate symbolic link to file?" "シンボリックリンクをファイルに移行しますか？")
                echo "🔄 $cmd_file はシンボリックリンクです"
                if confirm "$MSG_MIGRATE_SYMLINK"; then
                    # ソースファイルの検索
                    if [ -f "instructions/ai_instruction_kits/templates/claude-commands/$cmd_file" ]; then
                        src="instructions/ai_instruction_kits/templates/claude-commands/$cmd_file"
                    elif [ -f "${SCRIPT_DIR}/../templates/claude-commands/$cmd_file" ]; then
                        src="${SCRIPT_DIR}/../templates/claude-commands/$cmd_file"
                    fi
                    
                    if [ -n "$src" ] && [ -f "$src" ]; then
                        if [ "$DRY_RUN" = true ]; then
                            dry_echo "rm $dst && cp $src $dst"
                        else
                            rm "$dst"
                            cp "$src" "$dst"
                            MSG_MIGRATED=$(get_message "migrated" "migrated to file" "をファイルに移行しました")
                            echo "✅ $cmd_file $MSG_MIGRATED"
                        fi
                    fi
                fi
            else
                MSG_CLAUDE_COMMAND_EXISTS=$(get_message "claude_command_exists" "already exists" "は既に存在します")
                echo "✓ $cmd_file $MSG_CLAUDE_COMMAND_EXISTS"
            fi
            continue
        fi
        
        # ソースファイルの検索とコピー
        if [ -f "instructions/ai_instruction_kits/templates/claude-commands/$cmd_file" ]; then
            src="instructions/ai_instruction_kits/templates/claude-commands/$cmd_file"
        elif [ -f "${SCRIPT_DIR}/../templates/claude-commands/$cmd_file" ]; then
            src="${SCRIPT_DIR}/../templates/claude-commands/$cmd_file"
        fi
        
        if [ -n "$src" ] && [ -f "$src" ]; then
            MSG_CREATE_CLAUDE_COMMAND=$(get_message "create_claude_command" "Create Claude Code command" "Claude Codeコマンドを作成しますか？")
            if confirm "$cmd_file $MSG_CREATE_CLAUDE_COMMAND"; then
                if [ "$DRY_RUN" = true ]; then
                    dry_echo "cp $src $dst"
                else
                    cp "$src" "$dst"
                    MSG_CLAUDE_COMMAND_CREATED=$(get_message "claude_command_created" "Claude Code command created" "Claude Codeコマンドを作成しました")
                    echo "✅ $MSG_CLAUDE_COMMAND_CREATED: $cmd_file"
                fi
            fi
        else
            MSG_CLAUDE_COMMAND_TEMPLATE_NOT_FOUND=$(get_message "claude_command_template_not_found" "Claude Code command template not found" "Claude Codeコマンドテンプレートが見つかりません")
            echo "⚠️  $MSG_CLAUDE_COMMAND_TEMPLATE_NOT_FOUND: $cmd_file"
        fi
    done
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

# .openhandsディレクトリを.gitignoreに追加
echo ""
MSG_UPDATE_GITIGNORE_OPENHANDS=$(get_message "update_gitignore_openhands" "Adding .openhands to .gitignore" ".openhandsを.gitignoreに追加")
echo "📄 $MSG_UPDATE_GITIGNORE_OPENHANDS..."
if [ -f ".gitignore" ]; then
    if ! grep -q "^\.openhands/$" .gitignore 2>/dev/null; then
        MSG_ADD_OPENHANDS_TO_GITIGNORE=$(get_message "add_openhands_to_gitignore" "Add '.openhands/' to .gitignore?" ".gitignoreに'.openhands/'を追加しますか？")
        if confirm "$MSG_ADD_OPENHANDS_TO_GITIGNORE"; then
            if [ "$DRY_RUN" = true ]; then
                dry_echo "echo '.openhands/' >> .gitignore"
            else
                echo '.openhands/' >> .gitignore
                MSG_OPENHANDS_GITIGNORE_ADDED=$(get_message "openhands_gitignore_added" ".openhands added to .gitignore" ".openhandsを.gitignoreに追加しました")
                echo "✅ $MSG_OPENHANDS_GITIGNORE_ADDED"
            fi
        fi
    else
        MSG_OPENHANDS_GITIGNORE_EXISTS=$(get_message "openhands_gitignore_exists" ".gitignore already has .openhands entry" ".gitignoreには既に.openhandsエントリが存在します")
        echo "✓ $MSG_OPENHANDS_GITIGNORE_EXISTS"
    fi
fi

# .claudeディレクトリを.gitignoreに追加
if [ -f ".gitignore" ]; then
    if ! grep -q "^\.claude/$" .gitignore 2>/dev/null; then
        MSG_ADD_CLAUDE_TO_GITIGNORE=$(get_message "add_claude_to_gitignore" "Add '.claude/' to .gitignore?" ".gitignoreに'.claude/'を追加しますか？")
        if confirm "$MSG_ADD_CLAUDE_TO_GITIGNORE"; then
            if [ "$DRY_RUN" = true ]; then
                dry_echo "echo '.claude/' >> .gitignore"
            else
                echo '.claude/' >> .gitignore
                MSG_CLAUDE_GITIGNORE_ADDED=$(get_message "claude_gitignore_added" ".claude added to .gitignore" ".claudeを.gitignoreに追加しました")
                echo "✅ $MSG_CLAUDE_GITIGNORE_ADDED"
            fi
        fi
    else
        MSG_CLAUDE_GITIGNORE_EXISTS=$(get_message "claude_gitignore_exists" ".gitignore already has .claude entry" ".gitignoreには既に.claudeエントリが存在します")
        echo "✓ $MSG_CLAUDE_GITIGNORE_EXISTS"
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
    echo "    ├── lib/ → ../instructions/ai_instruction_kits/scripts/lib"
    echo "    ├── checkpoint.sh → ../instructions/ai_instruction_kits/scripts/checkpoint.sh"
    echo "    ├── commit.sh → ../instructions/ai_instruction_kits/scripts/commit.sh"
    echo "    ├── generate-instruction.sh → ../instructions/ai_instruction_kits/scripts/generate-instruction.sh"
    echo "    ├── validate-modules.sh → ../instructions/ai_instruction_kits/scripts/validate-modules.sh"
    echo "    ├── search-instructions.sh → ../instructions/ai_instruction_kits/scripts/search-instructions.sh"
    echo "    └── generate-metadata.sh → ../instructions/ai_instruction_kits/scripts/generate-metadata.sh"
    echo "  instructions/"
    echo "    ├── ai_instruction_kits/ ($SELECTED_MODE $(get_message "mode" "mode" "モード"))"
    MSG_PROJECT_CONFIG=$(get_message "project_config" "Project configuration" "プロジェクト設定")
    echo "    ├── PROJECT.md ($MSG_PROJECT_CONFIG)"
    echo "    └── PROJECT.en.md (Project configuration)"
    echo "  CLAUDE.md → instructions/PROJECT.md"
    echo "  GEMINI.md → instructions/PROJECT.md"
    echo "  CURSOR.md → instructions/PROJECT.md"
    echo "  .openhands/"
    echo "    └── microagents/"
    echo "        └── repo.md → ../../instructions/PROJECT.md"
    echo "  .claude/"
    echo "    └── commands/"
    echo "        ├── commit-and-report.md → ../../templates/claude-commands/commit-and-report.md"
    echo "        ├── checkpoint.md → ../../templates/claude-commands/checkpoint.md"
    echo "        └── reload-instructions.md → ../../templates/claude-commands/reload-instructions.md"
    echo ""
    
    MSG_CLAUDE_COMMANDS_AVAILABLE=$(get_message "claude_commands_available" "Available Claude Code commands" "利用可能なClaude Codeコマンド")
    echo "⚡ $MSG_CLAUDE_COMMANDS_AVAILABLE:"
    echo "  /commit-and-report \"$(get_message "commit_message" "commit message" "コミットメッセージ")\" [Issue番号]"
    echo "  /checkpoint [start <task-id> <task-name> <steps>]"
    echo "  /reload-instructions"
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