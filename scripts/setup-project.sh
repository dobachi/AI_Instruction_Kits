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
SYNC_CODEX_COMMANDS_ONLY=false
SYNC_GEMINI_COMMANDS_ONLY=false
AUTO_SETUP=false
SKIP_INSTRUCTIONS=false

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
        --sync-codex-commands|--sync-codex)
            SYNC_CODEX_COMMANDS_ONLY=true
            ;;
        --sync-gemini-commands|--sync-gemini)
            SYNC_GEMINI_COMMANDS_ONLY=true
            ;; 
        --auto|--auto-setup)
            AUTO_SETUP=true
            ;; 
        --skip-instructions)
            SKIP_INSTRUCTIONS=true
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
  --auto           $(get_message "auto_setup" "Auto-setup mode: only confirm PROJECT.md, auto-install everything else" "自動セットアップモード: PROJECT.mdのみ確認、他は自動配置")
  --skip-instructions
                   $(get_message "skip_instructions" "Skip PROJECT.md installation (can combine with --auto)" "PROJECT.mdをスキップ（--autoと組み合わせ可能）")
  --sync-claude-commands, --sync-claude
                   $(get_message "sync_claude_commands" "Sync Claude Code custom commands only" "Claude Codeカスタムコマンドの同期のみ実行")
  --sync-codex-commands, --sync-codex
                   $(get_message "sync_codex_commands" "Sync Codex CLI custom prompts only" "Codex CLIカスタムプロンプトの同期のみ実行")
  --sync-gemini-commands, --sync-gemini
                   $(get_message "sync_gemini_commands" "Sync Gemini CLI custom commands only" "Gemini CLIカスタムコマンドの同期のみ実行")
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
  # $(get_message "ex_normal" "Normal mode: confirm all groups" "通常モード: 全グループを確認")
  setup-project.sh --submodule

  # $(get_message "ex_auto" "Auto mode: only confirm PROJECT.md" "自動モード: PROJECT.mdのみ確認")
  setup-project.sh --auto --submodule

  # $(get_message "ex_skip" "Skip instructions: confirm other groups" "指示書スキップ: 他のグループを確認")
  setup-project.sh --skip-instructions --submodule

  # $(get_message "ex_full_auto" "Full auto: skip instructions, no prompts" "完全自動: 指示書スキップ、確認なし")
  setup-project.sh --auto --skip-instructions --submodule

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

    # AUTO_SETUPモードでは自動承認
    if [ "$AUTO_SETUP" = true ]; then
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

# グループ化確認プロンプト関数
confirm_group() {
    local group_name="$1"
    shift
    local items=($@)

    # SKIP_INSTRUCTIONSモードで指示書グループはスキップ
    if [ "$SKIP_INSTRUCTIONS" = true ] && [ "$group_name" = "instructions" ]; then
        return 1
    fi

    # AUTO_SETUPモードで指示書以外のグループは自動承認
    if [ "$AUTO_SETUP" = true ] && [ "$group_name" != "instructions" ]; then
        return 0
    fi

    # FORCE_MODEは全て自動承認
    if [ "$FORCE_MODE" = true ]; then
        return 0
    fi

    # 通常モード：グループ内容を表示して確認
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    case "$group_name" in
        instructions)
            MSG_GROUP_TITLE=$(get_message "group_instructions" "Project Instructions" "プロジェクト指示書")
            ;; 
        directories)
            MSG_GROUP_TITLE=$(get_message "group_directories" "Basic Directories" "基本ディレクトリ")
            ;; 
        ai_symlinks)
            MSG_GROUP_TITLE=$(get_message "group_ai_symlinks" "AI Product Symbolic Links" "AI製品別シンボリックリンク")
            ;; 
        scripts)
            MSG_GROUP_TITLE=$(get_message "group_scripts" "Script Tools" "スクリプトツール")
            ;; 
        openhands)
            MSG_GROUP_TITLE=$(get_message "group_openhands" "OpenHands Configuration" "OpenHands設定")
            ;; 
        claude)
            MSG_GROUP_TITLE=$(get_message "group_claude" "Claude Code Configuration" "Claude Code設定")
            ;;
        skills)
            MSG_GROUP_TITLE=$(get_message "group_skills" "Claude Code Skills" "Claude Codeスキル")
            ;;
        gemini)
            MSG_GROUP_TITLE=$(get_message "group_gemini" "Gemini CLI Configuration" "Gemini CLI設定")
            ;;
        codex)
            MSG_GROUP_TITLE=$(get_message "group_codex" "Codex CLI Configuration" "Codex CLI設定")
            ;;
        git)
            MSG_GROUP_TITLE=$(get_message "group_git" "Git Configuration" "Git設定")
            ;;
        *)
            MSG_GROUP_TITLE="$group_name"
            ;; 
    esac

    echo "📦 $MSG_GROUP_TITLE"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

    for item in "${items[@]}"; do
        echo "  • $item"
    done

    echo ""
    MSG_INSTALL_GROUP=$(get_message "install_group" "Install this group?" "このグループをインストールしますか？")

    local response
    read -r -p "$MSG_INSTALL_GROUP [Y/n]: " response
    case "$response" in
        [nN][oO]|[nN])
            return 1
            ;; 
        *)
            return 0
            ;; 
    esac
}

# OpenHands設定のセットアップ（グループ化）
setup_openhands() {
    local openhands_items=(
        ".openhands/microagents/"
        ".openhands/microagents/repo.md"
    )

    # グループ確認
    if ! confirm_group "openhands" "${openhands_items[@]}"; then
        MSG_SKIP_OPENHANDS=$(get_message "skip_openhands" "Skipping OpenHands configuration" "OpenHands設定をスキップ")
        echo "⏭️  $MSG_SKIP_OPENHANDS"
        return 1
    fi

    # .openhands/microagents/ディレクトリ作成
    if [ ! -d ".openhands/microagents" ]; then
        if [ "$DRY_RUN" = true ]; then
            dry_echo "mkdir -p .openhands/microagents"
        else
            mkdir -p .openhands/microagents
        fi
    fi

    # repo.mdシンボリックリンク作成
    if [ -e ".openhands/microagents/repo.md" ] && [ ! -L ".openhands/microagents/repo.md" ]; then
        backup_file ".openhands/microagents/repo.md"
        [ "$DRY_RUN" = false ] && rm ".openhands/microagents/repo.md"
    fi

    if [ ! -e ".openhands/microagents/repo.md" ]; then
        local target=""
        if [ -f "instructions/ja/system/OPENHANDS_ROOT.md" ]; then
            target="../../instructions/ja/system/OPENHANDS_ROOT.md"
        elif [ -f "instructions/ai_instruction_kits/instructions/ja/system/OPENHANDS_ROOT.md" ]; then
            target="../../instructions/ai_instruction_kits/instructions/ja/system/OPENHANDS_ROOT.md"
        else
            target="../../instructions/PROJECT.md"
        fi

        if [ "$DRY_RUN" = true ]; then
            dry_echo "ln -sf $target .openhands/microagents/repo.md"
        else
            ln -sf "$target" .openhands/microagents/repo.md
        fi
    fi

    MSG_OPENHANDS_CREATED=$(get_message "openhands_created" "OpenHands configuration installed" "OpenHands設定をインストールしました")
    echo "✅ $MSG_OPENHANDS_CREATED"
}

# Claude Code設定のセットアップ（グループ化）
setup_claude_code() {
    local claude_items=(
        ".claude/skills/"
        ".claude/skills/commit-and-report.md"
        ".claude/skills/commit-safe.md"
        ".claude/skills/checkpoint.md"
        ".claude/skills/reload-instructions.md"
        ".claude/skills/github-issues.md"
        ".claude/skills/reload-and-reset.md"
        ".claude/skills/build.md"
        ".claude/skills/evidence-check.md"
    )

    # グループ確認
    if ! confirm_group "claude" "${claude_items[@]}"; then
        MSG_SKIP_CLAUDE=$(get_message "skip_claude" "Skipping Claude Code configuration" "Claude Code設定をスキップ")
        echo "⏭️  $MSG_SKIP_CLAUDE"
        return 1
    fi

    # .claude/skillsディレクトリ作成
    if [ ! -d ".claude/skills" ]; then
        if [ "$DRY_RUN" = true ]; then
            dry_echo "mkdir -p .claude/skills"
        else
            mkdir -p .claude/skills
        fi
    fi

    # コマンドファイルをコピー
    local commands=("commit-and-report.md" "commit-safe.md" "checkpoint.md" "reload-instructions.md" "github-issues.md" "reload-and-reset.md" "build.md" "evidence-check.md")
    local lang=$(get_current_language)

    for cmd_file in "${commands[@]}"; do
        local src=""
        local dst=".claude/skills/$cmd_file"

        # ソースファイルの検索（言語別ファイルを優先）
        if [ -f "instructions/ai_instruction_kits/templates/claude-skills/$lang/$cmd_file" ]; then
            src="instructions/ai_instruction_kits/templates/claude-skills/$lang/$cmd_file"
        elif [ -f "$SCRIPT_DIR/../templates/claude-skills/$lang/$cmd_file" ]; then
            src="$SCRIPT_DIR/../templates/claude-skills/$lang/$cmd_file"
        elif [ -f "instructions/ai_instruction_kits/templates/claude-skills/$cmd_file" ]; then
            src="instructions/ai_instruction_kits/templates/claude-skills/$cmd_file"
        elif [ -f "$SCRIPT_DIR/../templates/claude-skills/$cmd_file" ]; then
            src="$SCRIPT_DIR/../templates/claude-skills/$cmd_file"
        fi

        if [ -n "$src" ] && [ -f "$src" ]; then
            # 既存ファイルのバックアップ
            if [ -e "$dst" ] && [ ! -L "$dst" ]; then
                backup_file "$dst"
                [ "$DRY_RUN" = false ] && rm "$dst"
            fi

            # シンボリックリンクの場合は削除してファイルコピー
            if [ -L "$dst" ]; then
                [ "$DRY_RUN" = false ] && rm "$dst"
            fi

            # コピー
            if [ ! -e "$dst" ]; then
                if [ "$DRY_RUN" = true ]; then
                    dry_echo "cp $src $dst"
                else
                    cp "$src" "$dst"
                fi
            fi
        fi
    done

    # gh-setup.shスクリプトのコピー
    local gh_setup_src=""
    if [ -f "instructions/ai_instruction_kits/scripts/gh-setup.sh" ]; then
        gh_setup_src="instructions/ai_instruction_kits/scripts/gh-setup.sh"
    elif [ -f "$SCRIPT_DIR/gh-setup.sh" ]; then
        gh_setup_src="$SCRIPT_DIR/gh-setup.sh"
    fi

    if [ -n "$gh_setup_src" ] && [ -f "$gh_setup_src" ]; then
        if [ ! -d "scripts" ]; then
            if [ "$DRY_RUN" = true ]; then
                dry_echo "mkdir -p scripts"
            else
                mkdir -p scripts
            fi
        fi

        if [ ! -f "scripts/gh-setup.sh" ]; then
            if [ "$DRY_RUN" = true ]; then
                dry_echo "cp $gh_setup_src scripts/gh-setup.sh"
                dry_echo "chmod +x scripts/gh-setup.sh"
            else
                cp "$gh_setup_src" scripts/gh-setup.sh
                chmod +x scripts/gh-setup.sh
            fi
            MSG_GH_SETUP_COPIED=$(get_message "gh_setup_copied" "GitHub CLI auto-setup script installed" "GitHub CLI自動セットアップスクリプトをインストールしました")
            echo "  ✅ $MSG_GH_SETUP_COPIED"
        fi
    fi

    # settings.jsonの配備
    local settings_src=""
    if [ -f "instructions/ai_instruction_kits/.claude/settings.json" ]; then
        settings_src="instructions/ai_instruction_kits/.claude/settings.json"
    elif [ -f "$SCRIPT_DIR/../.claude/settings.json" ]; then
        settings_src="$SCRIPT_DIR/../.claude/settings.json"
    fi

    if [ -n "$settings_src" ] && [ -f "$settings_src" ]; then
        local settings_dst=".claude/settings.json"

        if [ ! -f "$settings_dst" ]; then
            if [ "$DRY_RUN" = true ]; then
                dry_echo "cp $settings_src $settings_dst"
            else
                cp "$settings_src" "$settings_dst"
            fi
            MSG_SETTINGS_CREATED=$(get_message "settings_created" "Claude settings.json created (includes GitHub CLI setup hook)" "Claude settings.jsonを作成しました（GitHub CLIセットアップフックを含む）")
            echo "  ✅ $MSG_SETTINGS_CREATED"
        else
            MSG_SETTINGS_EXISTS=$(get_message "settings_exists" "⚠️  .claude/settings.json already exists. To enable GitHub CLI auto-setup, add SessionStart hook manually." "⚠️  .claude/settings.jsonが既に存在します。GitHub CLI自動セットアップを有効にするには、SessionStartフックを手動で追加してください。")
            echo "  $MSG_SETTINGS_EXISTS"
            echo "  Reference: $settings_src"
        fi
    fi

    MSG_CLAUDE_CREATED=$(get_message "claude_created" "Claude Code configuration installed" "Claude Code設定をインストールしました")
    echo "✅ $MSG_CLAUDE_CREATED"
}

# Claude Code Skillsのセットアップ（グループ化）
setup_claude_skills() {
    # 利用可能なスキルを検索
    local skills_src_dir=""
    local lang=$(get_current_language)

    if [ -d "instructions/ai_instruction_kits/templates/claude-skills/$lang" ]; then
        skills_src_dir="instructions/ai_instruction_kits/templates/claude-skills/$lang"
    elif [ -d "${SCRIPT_DIR}/../templates/claude-skills/$lang" ]; then
        skills_src_dir="${SCRIPT_DIR}/../templates/claude-skills/$lang"
    elif [ -d "instructions/ai_instruction_kits/templates/claude-skills/en" ]; then
        skills_src_dir="instructions/ai_instruction_kits/templates/claude-skills/en"
    elif [ -d "${SCRIPT_DIR}/../templates/claude-skills/en" ]; then
        skills_src_dir="${SCRIPT_DIR}/../templates/claude-skills/en"
    fi

    # スキルディレクトリが見つからない場合はスキップ
    if [ -z "$skills_src_dir" ] || [ ! -d "$skills_src_dir" ]; then
        MSG_NO_SKILLS=$(get_message "no_skills" "No skills templates found, skipping" "スキルテンプレートが見つかりません、スキップします")
        echo "⏭️  $MSG_NO_SKILLS"
        return 1
    fi

    # 利用可能なスキルをリストアップ
    local skill_items=(".claude/skills/")
    local available_skills=()
    for skill_dir in "$skills_src_dir"/*/; do
        if [ -d "$skill_dir" ] && [ -f "$skill_dir/SKILL.md" ]; then
            local skill_name=$(basename "$skill_dir")
            available_skills+=("$skill_name")
            skill_items+=(".claude/skills/$skill_name/")
        fi
    done

    # スキルがない場合はスキップ
    if [ ${#available_skills[@]} -eq 0 ]; then
        MSG_NO_SKILLS=$(get_message "no_skills" "No skills templates found, skipping" "スキルテンプレートが見つかりません、スキップします")
        echo "⏭️  $MSG_NO_SKILLS"
        return 1
    fi

    # グループ確認
    if ! confirm_group "skills" "${skill_items[@]}"; then
        MSG_SKIP_SKILLS=$(get_message "skip_skills" "Skipping Claude Code Skills" "Claude Codeスキルをスキップ")
        echo "⏭️  $MSG_SKIP_SKILLS"
        return 1
    fi

    # .claude/skillsディレクトリ作成
    if [ ! -d ".claude/skills" ]; then
        if [ "$DRY_RUN" = true ]; then
            dry_echo "mkdir -p .claude/skills"
        else
            mkdir -p .claude/skills
        fi
    fi

    # 各スキルをコピー
    for skill_name in "${available_skills[@]}"; do
        local src="$skills_src_dir/$skill_name"
        local dst=".claude/skills/$skill_name"

        # 既存ディレクトリのバックアップ
        if [ -d "$dst" ] && [ ! -L "$dst" ]; then
            backup_file "$dst"
            [ "$DRY_RUN" = false ] && rm -rf "$dst"
        fi

        # シンボリックリンクの場合は削除
        if [ -L "$dst" ]; then
            [ "$DRY_RUN" = false ] && rm "$dst"
        fi

        # コピー
        if [ ! -e "$dst" ]; then
            if [ "$DRY_RUN" = true ]; then
                dry_echo "cp -r $src $dst"
            else
                cp -r "$src" "$dst"
            fi
        fi
    done

    MSG_SKILLS_CREATED=$(get_message "skills_created" "Claude Code Skills installed" "Claude Codeスキルをインストールしました")
    echo "✅ $MSG_SKILLS_CREATED"
}

# Git設定のセットアップ（グループ化）
setup_git_config() {
    local git_items=(
        ".git/hooks/prepare-commit-msg"
        ".gitignore (AI instructions entries)"
    )

    # グループ確認
    if ! confirm_group "git" "${git_items[@]}"; then
        MSG_SKIP_GIT=$(get_message "skip_git" "Skipping Git configuration" "Git設定をスキップ")
        echo "⏭️  $MSG_SKIP_GIT"
        return 1
    fi

    # Gitフックの設定
    if [ -d ".git/hooks" ]; then
        local hook_source=""
        if [ -f "${SCRIPT_DIR}/../templates/git-hooks/prepare-commit-msg" ]; then
            hook_source="${SCRIPT_DIR}/../templates/git-hooks/prepare-commit-msg"
        elif [ -f "instructions/ai_instruction_kits/templates/git-hooks/prepare-commit-msg" ]; then
            hook_source="instructions/ai_instruction_kits/templates/git-hooks/prepare-commit-msg"
        fi

        if [ -n "$hook_source" ]; then
            if [ -e ".git/hooks/prepare-commit-msg" ] && [ ! -L ".git/hooks/prepare-commit-msg" ]; then
                backup_file ".git/hooks/prepare-commit-msg"
            fi

            if [ "$DRY_RUN" = true ]; then
                dry_echo "cp $hook_source .git/hooks/prepare-commit-msg && chmod +x .git/hooks/prepare-commit-msg"
            else
                cp "$hook_source" .git/hooks/prepare-commit-msg
                chmod +x .git/hooks/prepare-commit-msg
            fi
        fi
    fi

    # .gitignore更新
    local gitignore_entries=()
    [ "$SELECTED_MODE" = "submodule" ] && gitignore_entries+=("instructions/ai_instruction_kits/")
    gitignore_entries+=(".openhands/" ".claude/" ".gemini/" ".gitworktrees/" "gitworktrees/")

    for entry in "${gitignore_entries[@]}"; do
        if [ -f ".gitignore" ]; then
            if ! grep -q "^${entry}$" .gitignore 2>/dev/null;
 then
                if [ "$DRY_RUN" = true ]; then
                    dry_echo "echo '$entry' >> .gitignore"
                else
                    echo "$entry" >> .gitignore
                fi
            fi
        else
            if [ "$DRY_RUN" = true ]; then
                dry_echo "echo '$entry' > .gitignore"
            else
                echo "$entry" > .gitignore
            fi
        fi
    done

    MSG_GIT_CREATED=$(get_message "git_created" "Git configuration installed" "Git設定をインストールしました")
    echo "✅ $MSG_GIT_CREATED"
}

# スクリプトツールのシンボリックリンク作成（グループ化）
setup_script_tools() {
    local script_items=(
        "scripts/lib/"
        "scripts/gemini/"
        "scripts/checkpoint.sh"
        "scripts/commit.sh"
        "scripts/worktree-manager.sh"
        "scripts/submodule-update-check.sh"
    )

    # グループ確認
    if ! confirm_group "scripts" "${script_items[@]}"; then
        MSG_SKIP_SCRIPTS=$(get_message "skip_scripts" "Skipping script tools" "スクリプトツールをスキップ")
        echo "⏭️  $MSG_SKIP_SCRIPTS"
        return 1
    fi
    
    local base_script_path="../instructions/ai_instruction_kits/scripts"
    
    # copyモードの場合は直接コピー
    if [ "$SELECTED_MODE" = "copy" ]; then
        local copy_source_path="instructions/ai_instruction_kits/scripts"
        
        # ディレクトリ
        cp -r "$copy_source_path/lib" "scripts/"
        cp -r "$copy_source_path/gemini" "scripts/"
        
        # ファイル
        local scripts_to_copy=("checkpoint.sh" "commit.sh" "worktree-manager.sh" "submodule-update-check.sh")
        for script in "${scripts_to_copy[@]}"; do
            cp "$copy_source_path/$script" "scripts/"
        done

        MSG_SCRIPTS_COPIED=$(get_message "scripts_copied" "Script tools copied" "スクリプトツールをコピーしました")
        echo "✅ $MSG_SCRIPTS_COPIED"
        return 0
    fi

    # clone, submoduleモードの場合はシンボリックリンク
    # scripts/lib/
    if [ -e "scripts/lib" ] && [ ! -L "scripts/lib" ]; then
        backup_file "scripts/lib"
        [ "$DRY_RUN" = false ] && rm -rf scripts/lib
    fi
    if [ ! -e "scripts/lib" ]; then
        if [ "$DRY_RUN" = true ]; then
            dry_echo "ln -sf $base_script_path/lib scripts/lib"
        else
            ln -sf "$base_script_path/lib" scripts/lib
        fi
    fi

    # scripts/gemini/
    if [ -e "scripts/gemini" ] && [ ! -L "scripts/gemini" ]; then
        backup_file "scripts/gemini"
        [ "$DRY_RUN" = false ] && rm -rf scripts/gemini
    fi
    if [ ! -e "scripts/gemini" ]; then
        if [ "$DRY_RUN" = true ]; then
            dry_echo "ln -sf $base_script_path/gemini scripts/gemini"
        else
            ln -sf "$base_script_path/gemini" scripts/gemini
        fi
    fi

    # スクリプトファイルのシンボリックリンク作成
    local scripts=("checkpoint.sh" "commit.sh" "worktree-manager.sh" "submodule-update-check.sh")
    for script in "${scripts[@]}"; do
        if [ -e "scripts/$script" ] && [ ! -L "scripts/$script" ]; then
            backup_file "scripts/$script"
            [ "$DRY_RUN" = false ] && rm "scripts/$script"
        fi
        if [ ! -e "scripts/$script" ]; then
            if [ "$DRY_RUN" = true ]; then
                dry_echo "ln -sf $base_script_path/$script scripts/$script"
            else
                ln -sf "$base_script_path/$script" scripts/$script
            fi
        fi
    done

    MSG_SCRIPTS_CREATED=$(get_message "scripts_created" "Script tools installed" "スクリプトツールをインストールしました")
    echo "✅ $MSG_SCRIPTS_CREATED"
}

# バックアップ関数
backup_file() {
    local file="$1"
    local target_path="$file"
    
    # ディレクトリの場合は再帰的にバックアップ
    if [ -d "$file" ]; then
        target_path="$file"
    fi

    if [ -e "$target_path" ] && [ "$BACKUP_MODE" = true ]; then
        local backup_ext=".backup.$(date +%Y%m%d_%H%M%S)"
        local backup_path="${target_path}${backup_ext}"

        if [ "$DRY_RUN" = true ]; then
            MSG_BACKUP_CREATE=$(get_message "backup_create" "Creating backup" "バックアップ作成")
            dry_echo "$MSG_BACKUP_CREATE: $target_path → $backup_path"
        else
            # mvを使ってアトミックにリネーム
            mv "$target_path" "$backup_path"
            MSG_BACKUP_CREATED=$(get_message "backup_created" "Backup created" "バックアップ作成")
            echo "📋 $MSG_BACKUP_CREATED: $backup_path"
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

# sync_claude_commands() は v2.0 で削除（スキルに統合済み）

# Gemini CLIコマンドの同期
sync_gemini_commands() {
    MSG_SYNC_GEMINI=$(get_message "sync_gemini_commands_msg" "Syncing Gemini CLI custom commands" "Gemini CLIカスタムコマンドを同期中")
    echo "♊ $MSG_SYNC_GEMINI..."
    
    if [ ! -d ".gemini/commands" ]; then
        MSG_CREATE_GEMINI_DIR=$(get_message "create_gemini_dir" "Create .gemini/commands directory for Gemini CLI?" "Gemini CLI用の.gemini/commandsディレクトリを作成しますか？")
        if confirm "$MSG_CREATE_GEMINI_DIR"; then
            if [ "$DRY_RUN" = true ]; then
                dry_echo "mkdir -p .gemini/commands"
            else
                mkdir -p .gemini/commands
                MSG_GEMINI_DIR_CREATED=$(get_message "gemini_dir_created" ".gemini/commands directory created" ".gemini/commandsディレクトリを作成しました")
                echo "✅ $MSG_GEMINI_DIR_CREATED"
            fi
        else
            return
        fi
    fi
    
    local gemini_commands_src=""
    if [ -d "instructions/ai_instruction_kits/.gemini/commands" ]; then
        gemini_commands_src="instructions/ai_instruction_kits/.gemini/commands"
    elif [ -d "$SCRIPT_DIR/../.gemini/commands" ]; then
        gemini_commands_src="$SCRIPT_DIR/../.gemini/commands"
    else
        MSG_GEMINI_SRC_NOT_FOUND=$(get_message "gemini_src_not_found" "Gemini command source directory not found" "Geminiコマンドのソースディレクトリが見つかりません")
        echo "⚠️  $MSG_GEMINI_SRC_NOT_FOUND"
        return
    fi
    
    # ls と xargs を使って .toml ファイルのみを対象にする
    local gemini_commands=()
    if [ -d "$gemini_commands_src" ]; then
        gemini_commands=($(ls "$gemini_commands_src"/*.toml 2>/dev/null | xargs -n 1 basename))
    fi

    if [ ${#gemini_commands[@]} -eq 0 ]; then
        MSG_NO_GEMINI_COMMANDS=$(get_message "no_gemini_commands" "No Gemini command templates found to sync" "同期するGeminiコマンドテンプレートが見つかりません")
        echo "ℹ️ $MSG_NO_GEMINI_COMMANDS"
        return
    fi
    
    local updated_count=0
    local skipped_count=0
    
    for cmd_file in "${gemini_commands[@]}"; do
        local src="$gemini_commands_src/$cmd_file"
        local dst=".gemini/commands/$cmd_file"
        
        if [ ! -f "$src" ]; then continue; fi

        if [ -e "$dst" ]; then
            if diff -q "$src" "$dst" > /dev/null 2>&1; then
                MSG_UP_TO_DATE=$(get_message "up_to_date" "is up to date" "は最新です")
                echo "✓ $cmd_file $MSG_UP_TO_DATE"
                skipped_count=$((skipped_count + 1))
                continue
            fi
            
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

# Gemini CLI設定のセットアップ（グループ化）
setup_gemini_cli() {
    local gemini_items=(
        ".gemini/commands/"
        "scripts/gemini/"
    )

    if ! confirm_group "gemini" "${gemini_items[@]}"; then
        MSG_SKIP_GEMINI=$(get_message "skip_gemini" "Skipping Gemini CLI configuration" "Gemini CLI設定をスキップ")
        echo "⏭️  $MSG_SKIP_GEMINI"
        return 1
    fi
    
    # .gemini/commandsディレクトリ作成と同期
    sync_gemini_commands

    # .gemini/ディレクトリをgitignoreに追加
    if [ -f ".gitignore" ]; then
        if ! grep -q "^\.gemini/$" .gitignore 2>/dev/null;
 then
             if [ "$DRY_RUN" = true ]; then
                dry_echo "echo '.gemini/' >> .gitignore"
            else
                echo '.gemini/' >> .gitignore
            fi
        fi
    fi

    MSG_GEMINI_CREATED=$(get_message "gemini_created" "Gemini CLI configuration installed" "Gemini CLI設定をインストールしました")
    echo "✅ $MSG_GEMINI_CREATED"
}

# Codex CLIコマンドの同期
sync_codex_commands() {
    MSG_SYNC_CODEX=$(get_message "sync_codex_commands_msg" "Syncing Codex CLI custom prompts" "Codex CLIカスタムプロンプトを同期中")
    echo "📦 $MSG_SYNC_CODEX..."

    if [ ! -d ".codex/prompts" ]; then
        MSG_CREATE_CODEX_DIR=$(get_message "create_codex_dir" "Create .codex/prompts directory for Codex CLI?" "Codex CLI用の.codex/promptsディレクトリを作成しますか？")
        if confirm "$MSG_CREATE_CODEX_DIR"; then
            if [ "$DRY_RUN" = true ]; then
                dry_echo "mkdir -p .codex/prompts"
            else
                mkdir -p .codex/prompts
                MSG_CODEX_DIR_CREATED=$(get_message "codex_dir_created" ".codex/prompts directory created" ".codex/promptsディレクトリを作成しました")
                echo "✅ $MSG_CODEX_DIR_CREATED"
            fi
        else
            return
        fi
    fi

    local codex_prompts_src=""
    if [ -d "instructions/ai_instruction_kits/.codex/prompts" ]; then
        codex_prompts_src="instructions/ai_instruction_kits/.codex/prompts"
    elif [ -d "$SCRIPT_DIR/../.codex/prompts" ]; then
        codex_prompts_src="$SCRIPT_DIR/../.codex/prompts"
    else
        MSG_CODEX_SRC_NOT_FOUND=$(get_message "codex_src_not_found" "Codex prompts source directory not found" "Codexプロンプトのソースディレクトリが見つかりません")
        echo "⚠️  $MSG_CODEX_SRC_NOT_FOUND"
        return
    fi

    # ls と xargs を使って .md ファイルのみを対象にする
    local codex_prompts=()
    if [ -d "$codex_prompts_src" ]; then
        codex_prompts=($(ls "$codex_prompts_src"/*.md 2>/dev/null | xargs -n 1 basename))
    fi

    if [ ${#codex_prompts[@]} -eq 0 ]; then
        MSG_NO_CODEX_PROMPTS=$(get_message "no_codex_prompts" "No Codex prompt templates found to sync" "同期するCodexプロンプトテンプレートが見つかりません")
        echo "ℹ️ $MSG_NO_CODEX_PROMPTS"
        return
    fi

    local updated_count=0
    local skipped_count=0

    for prompt_file in "${codex_prompts[@]}"; do
        local src="$codex_prompts_src/$prompt_file"
        local dst=".codex/prompts/$prompt_file"

        if [ ! -f "$src" ]; then continue; fi

        if [ -e "$dst" ]; then
            if diff -q "$src" "$dst" > /dev/null 2>&1; then
                MSG_UP_TO_DATE=$(get_message "up_to_date" "is up to date" "は最新です")
                echo "✓ $prompt_file $MSG_UP_TO_DATE"
                skipped_count=$((skipped_count + 1))
                continue
            fi

            echo ""
            MSG_UPDATE_AVAILABLE=$(get_message "update_available" "has updates" "に更新があります")
            echo "📝 $prompt_file $MSG_UPDATE_AVAILABLE"
            MSG_UPDATE_FILE=$(get_message "update_file" "Update?" "更新しますか？")
            if confirm "$MSG_UPDATE_FILE"; then
                backup_file "$dst"
                if [ "$DRY_RUN" = true ]; then
                    dry_echo "cp $src $dst"
                else
                    cp "$src" "$dst"
                fi
                MSG_UPDATED=$(get_message "updated" "updated" "を更新しました")
                echo "✅ $prompt_file $MSG_UPDATED"
                updated_count=$((updated_count + 1))
            else
                MSG_UPDATE_SKIPPED=$(get_message "update_skipped" "update skipped" "の更新をスキップしました")
                echo "⏭️  $prompt_file $MSG_UPDATE_SKIPPED"
                skipped_count=$((skipped_count + 1))
            fi
        else
            MSG_NOT_EXISTS=$(get_message "not_exists" "does not exist" "が存在しません")
            echo "📝 $prompt_file $MSG_NOT_EXISTS"
            MSG_CREATE_FILE=$(get_message "create_file" "Create?" "作成しますか？")
            if confirm "$MSG_CREATE_FILE"; then
                if [ "$DRY_RUN" = true ]; then
                    dry_echo "cp $src $dst"
                else
                    cp "$src" "$dst"
                fi
                MSG_CREATED=$(get_message "created" "created" "を作成しました")
                echo "✅ $prompt_file $MSG_CREATED"
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

# Codex CLI設定のセットアップ（グループ化）
setup_codex_cli() {
    local codex_items=(
        ".codex/prompts/"
    )

    if ! confirm_group "codex" "${codex_items[@]}"; then
        MSG_SKIP_CODEX=$(get_message "skip_codex" "Skipping Codex CLI configuration" "Codex CLI設定をスキップ")
        echo "⏭️  $MSG_SKIP_CODEX"
        return 1
    fi

    # .codex/promptsディレクトリ作成と同期
    sync_codex_commands

    # .codex/ディレクトリをgitignoreに追加
    if [ -f ".gitignore" ]; then
        if ! grep -q "^\.codex/$" .gitignore 2>/dev/null; then
            if [ "$DRY_RUN" = true ]; then
                dry_echo "echo '.codex/' >> .gitignore"
            else
                echo '.codex/' >> .gitignore
            fi
        fi
    fi

    MSG_CODEX_CREATED=$(get_message "codex_created" "Codex CLI configuration installed" "Codex CLI設定をインストールしました")
    echo "✅ $MSG_CODEX_CREATED"
}

# --sync-claude-commands は v2.0 で廃止（スキルに統合済み）
if [ "$SYNC_CLAUDE_COMMANDS_ONLY" = true ]; then
    echo "⚠️  --sync-claude-commands は廃止されました。スキルは .claude/skills/ で管理されます。"
    exit 0
fi

# --sync-codex-commands が指定された場合
if [ "$SYNC_CODEX_COMMANDS_ONLY" = true ]; then
    sync_codex_commands
    exit 0
fi

# --sync-gemini-commands が指定された場合
if [ "$SYNC_GEMINI_COMMANDS_ONLY" = true ]; then
    sync_gemini_commands
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

# ディレクトリ作成（グループ化）
echo ""
MSG_CREATE_DIRS=$(get_message "create_dirs" "Creating required directories" "必要なディレクトリを作成")

# グループ確認用の配列を準備
dir_group_items=()
[ ! -d "scripts" ] && dir_group_items+=("scripts/")
[ ! -d "instructions" ] && dir_group_items+=("instructions/")

# ディレクトリが存在する場合のメッセージ
if [ ${#dir_group_items[@]} -eq 0 ]; then
    MSG_DIRS_EXIST=$(get_message "dirs_exist" "Required directories already exist" "必要なディレクトリは既に存在します")
    echo "✓ $MSG_DIRS_EXIST"
else
    # グループ確認
    if confirm_group "directories" "${dir_group_items[@]}"; then
        [ ! -d "scripts" ] && mkdir -p scripts
        [ ! -d "instructions" ] && mkdir -p instructions
        MSG_DIRS_CREATED=$(get_message "dirs_created" "Directories created" "ディレクトリを作成しました")
        echo "✅ $MSG_DIRS_CREATED"
    else
        MSG_SKIP_DIRS=$(get_message "skip_dirs" "Skipping directory creation" "ディレクトリの作成をスキップ")
        echo "⏭️  $MSG_SKIP_DIRS"
    fi
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

# スクリプトツールのセットアップ（グループ化）
echo ""
MSG_SETUP_SCRIPTS=$(get_message "setup_scripts" "Setting up script tools" "スクリプトツールを設定")
echo "🔧 $MSG_SETUP_SCRIPTS..."
setup_script_tools
SCRIPTS_INSTALLED=$?

# テンプレートのパスを決定
PROJECT_TEMPLATE_JA=""
if [ -f "${SCRIPT_DIR}/../templates/ja/PROJECT_TEMPLATE.md" ]; then
    PROJECT_TEMPLATE_JA="${SCRIPT_DIR}/../templates/ja/PROJECT_TEMPLATE.md"
elif [ -f "instructions/ai_instruction_kits/templates/ja/PROJECT_TEMPLATE.md" ]; then
    PROJECT_TEMPLATE_JA="instructions/ai_instruction_kits/templates/ja/PROJECT_TEMPLATE.md"
fi

# SKIP_INSTRUCTIONSモードの場合は指示書セットアップをスキップ
if [ "$SKIP_INSTRUCTIONS" = true ]; then
    MSG_SKIP_INSTRUCTIONS_MODE=$(get_message "skip_instructions_mode" "Skipping PROJECT.md installation (--skip-instructions mode)" "PROJECT.mdのインストールをスキップ (--skip-instructionsモード)")
    echo "⏭️  $MSG_SKIP_INSTRUCTIONS_MODE"
else
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
fi  # SKIP_INSTRUCTIONSのif文を閉じる

# AI製品別のシンボリックリンク作成（グループ化）
echo ""
MSG_CREATE_AI_SYMLINKS=$(get_message "create_ai_symlinks" "Creating symbolic links for AI products" "AI製品別のシンボリックリンクを作成")

ai_files=("CLAUDE.md" "GEMINI.md" "CURSOR.md" "CODEX.md")
ai_files_en=("CLAUDE.en.md" "GEMINI.en.md" "CURSOR.en.md" "CODEX.en.md")

# グループ確認用の配列を準備
ai_symlink_items=()
for file in "${ai_files[@]}" "${ai_files_en[@]}"; do
    if [ ! -e "$file" ] || [ ! -L "$file" ]; then
        ai_symlink_items+=("$file")
    fi
done

# すべて存在する場合
if [ ${#ai_symlink_items[@]} -eq 0 ]; then
    MSG_AI_SYMLINKS_EXIST=$(get_message "ai_symlinks_exist" "AI product symbolic links already exist" "AI製品別シンボリックリンクは既に存在します")
    echo "✓ $MSG_AI_SYMLINKS_EXIST"
else
    # グループ確認
    if confirm_group "ai_symlinks" "${ai_symlink_items[@]}"; then
        # 日本語版シンボリックリンク作成
        for file in "${ai_files[@]}"; do
            if [ -e "$file" ] && [ ! -L "$file" ]; then
                backup_file "$file"
                [ "$DRY_RUN" = false ] && rm "$file"
            fi
            if [ ! -e "$file" ]; then
                if [ "$DRY_RUN" = true ]; then
                    dry_echo "ln -sf instructions/PROJECT.md $file"
                else
                    ln -sf instructions/PROJECT.md "$file"
                fi
            fi
        done

        # 英語版シンボリックリンク作成
        for file in "${ai_files_en[@]}"; do
            if [ -e "$file" ] && [ ! -L "$file" ]; then
                backup_file "$file"
                [ "$DRY_RUN" = false ] && rm "$file"
            fi
            if [ ! -e "$file" ]; then
                if [ "$DRY_RUN" = true ]; then
                    dry_echo "ln -sf instructions/PROJECT.en.md $file"
                else
                    ln -sf instructions/PROJECT.en.md "$file"
                fi
            fi
        done

        MSG_AI_SYMLINKS_CREATED=$(get_message "ai_symlinks_created" "AI product symbolic links created" "AI製品別シンボリックリンクを作成しました")
        echo "✅ $MSG_AI_SYMLINKS_CREATED"
    else
        MSG_SKIP_AI_SYMLINKS=$(get_message "skip_ai_symlinks" "Skipping AI symbolic links" "AIシンボリックリンクをスキップ")
        echo "⏭️  $MSG_SKIP_AI_SYMLINKS"
    fi
fi

# OpenHands設定のセットアップ（グループ化）
echo ""
MSG_SETUP_OPENHANDS=$(get_message "setup_openhands" "Setting up OpenHands configuration" "OpenHands設定を設定")
echo "🌐 $MSG_SETUP_OPENHANDS..."
setup_openhands
OPENHANDS_INSTALLED=$?

# Claude Code設定のセットアップ（グループ化）
echo ""
MSG_SETUP_CLAUDE=$(get_message "setup_claude" "Setting up Claude Code configuration" "Claude Code設定を設定")
echo "⚡ $MSG_SETUP_CLAUDE..."
setup_claude_code
CLAUDE_INSTALLED=$?

# Claude Codeスキルのセットアップ（グループ化）
echo ""
MSG_SETUP_SKILLS=$(get_message "setup_skills" "Setting up Claude Code Skills" "Claude Codeスキルを設定")
echo "🎯 $MSG_SETUP_SKILLS..."
setup_claude_skills
SKILLS_INSTALLED=$?

# Gemini CLI設定のセットアップ（グループ化）
echo ""
MSG_SETUP_GEMINI=$(get_message "setup_gemini" "Setting up Gemini CLI configuration" "Gemini CLI設定を設定")
echo "♊ $MSG_SETUP_GEMINI..."
setup_gemini_cli
GEMINI_INSTALLED=$?

# Codex CLI設定のセットアップ（グループ化）
echo ""
MSG_SETUP_CODEX=$(get_message "setup_codex" "Setting up Codex CLI configuration" "Codex CLI設定を設定")
echo "📦 $MSG_SETUP_CODEX..."
setup_codex_cli
CODEX_INSTALLED=$?

# Git設定のセットアップ（グループ化）
echo ""
MSG_SETUP_GIT=$(get_message "setup_git" "Setting up Git configuration" "Git設定を設定")
echo "📝 $MSG_SETUP_GIT..."
setup_git_config
GIT_INSTALLED=$?

# 完了メッセージ
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
    echo "🇯🇵 $(get_message "japanese" "Japanese" "日本語"):";
    MSG_JA_USAGE=$(get_message "ja_usage" 'When requesting AI assistance, say "Please refer to CLAUDE.md and [task description]"' 'AIに作業を依頼する際は「CLAUDE.mdを参照して、[タスク内容]」と伝えてください')
    MSG_JA_ALSO_AVAILABLE=$(get_message "ja_also_available" "(GEMINI.md, CURSOR.md, CODEX.md also available)" "（GEMINI.md、CURSOR.md、CODEX.mdも同様に使用可能）")
    echo "  $MSG_JA_USAGE"
    echo "  $MSG_JA_ALSO_AVAILABLE"
    echo ""
    echo "🇺🇸 English:"
    echo "  When requesting AI assistance, say \"Please refer to CLAUDE.en.md and [task description]\""
    echo "  (GEMINI.en.md, CURSOR.en.md, CODEX.en.md also available)"
    echo ""
    MSG_CREATED_STRUCTURE=$(get_message "created_structure" "Created structure" "作成された構成")
    echo "📁 $MSG_CREATED_STRUCTURE:"
    echo "  scripts/"
    echo "    ├── lib/"
    echo "    ├── checkpoint.sh"
    echo "    ├── commit.sh"
    echo "    └── worktree-manager.sh"
    echo "  instructions/"
    echo "    ├── ai_instruction_kits/ ($SELECTED_MODE $(get_message "mode" "mode" "モード"))"
    MSG_PROJECT_CONFIG=$(get_message "project_config" "Project configuration" "プロジェクト設定")
    echo "    ├── PROJECT.md ($MSG_PROJECT_CONFIG)"
    echo "    └── PROJECT.en.md (Project configuration)"
    echo "  CLAUDE.md → instructions/PROJECT.md"
    echo "  GEMINI.md → instructions/PROJECT.md"
    echo "  CURSOR.md → instructions/PROJECT.md"
    echo "  CODEX.md → instructions/PROJECT.md"

    # OpenHandsが実際にインストールされた場合のみ表示
    if [ "${OPENHANDS_INSTALLED:-1}" -eq 0 ]; then
        echo "  .openhands/"
        echo "    └── microagents/"
        echo "        └── repo.md → ../../instructions/PROJECT.md"
    fi

    # スキルが実際にインストールされた場合のみ表示
    if [ "${SKILLS_INSTALLED:-1}" -eq 0 ]; then
        echo "  .claude/"
        echo "    └── skills/"
        echo "        ├── checkpoint-manager/"
        echo "        │   ├── SKILL.md, workflow.md"
        echo "        ├── worktree-manager/"
        echo "        │   └── SKILL.md"
        echo "        ├── auto-build/"
        echo "        │   └── SKILL.md"
        echo "        └── commit-safe/"
        echo "            └── SKILL.md"
        echo ""

        MSG_SKILLS_AVAILABLE=$(get_message "skills_available" "Available Claude Code Skills (auto-invoked)" "利用可能なClaude Codeスキル（自動呼び出し）")
        echo "🎯 $MSG_SKILLS_AVAILABLE:"
        echo "  checkpoint-manager  - $(get_message "skill_checkpoint_manager" "Task progress tracking (auto-suggest start/progress/complete)" "タスク進捗管理（開始/進捗/完了を自動提案）")"
        echo "  worktree-manager    - $(get_message "skill_worktree_manager" "Git worktree management (create/merge/cleanup)" "Git worktree管理（作成/マージ/クリーンアップ）")"
        echo "  auto-build          - $(get_message "skill_auto_build" "Auto-detect project type and build (Node.js/Rust/Python/Go)" "プロジェクト自動検出とビルド（Node.js/Rust/Python/Go）")"
        echo "  commit-safe         - $(get_message "skill_commit_safe" "Safe file-specific commits" "ファイル指定の安全なコミット")"
        echo ""
        echo "🛒 $(get_message "marketplace_info" "Additional skills available at" "追加スキルは以下から入手可能"):"
        echo "  https://github.com/dobachi/claude-skills-marketplace"
        echo ""
    fi

    # Codex CLIが実際にインストールされた場合のみ表示
    if [ "${CODEX_INSTALLED:-1}" -eq 0 ]; then
        echo "  .codex/"
        echo "    └── prompts/"
        echo "        ├── checkpoint.md"
        echo "        ├── commit-and-report.md"
        echo "        ├── commit-safe.md"
        echo "        ├── github-issues.md"
        echo "        ├── reload-instructions.md"
        echo "        ├── reload-and-reset.md"
        echo "        ├── build.md"
        echo "        └── evidence-check.md"
        echo ""

        MSG_CODEX_COMMANDS_AVAILABLE=$(get_message "codex_commands_available" "Available Codex CLI commands" "利用可能なCodex CLIコマンド")
        echo "📦 $MSG_CODEX_COMMANDS_AVAILABLE:"
        echo "  /checkpoint [start <task-id> <task-name> <steps>]"
        echo "  /commit-and-report \"$(get_message "commit_message" "commit message" "コミットメッセージ")\" [Issue$(get_message "number" "number" "番号")]"
        echo "  /commit-safe \"$(get_message "commit_message" "commit message" "コミットメッセージ")\""
        echo "  /github-issues"
        echo "  /reload-instructions"
        echo "  /reload-and-reset"
        echo "  /build [--clean|--prod|--test]"
        echo "  /evidence-check [file-path]"
        echo ""
    fi

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
