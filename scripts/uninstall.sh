#!/bin/bash
# AI指示書キット アンインストーラー
# install.sh/setup-project.sh でインストールされたファイルを削除します
#
# 使用方法:
#   bash scripts/uninstall.sh
#   または
#   curl -sSL https://raw.githubusercontent.com/dobachi/AI_Instruction_Kits/main/scripts/uninstall.sh | bash
#
# オプション:
#   --force         確認なしで実行
#   --keep-backup   バックアップファイルを保持
#   --dry-run       実行内容を表示するだけで実際には実行しない
#   --help          ヘルプを表示

# set -e を削除（remove_symlinkのreturn 1でスクリプトが終了しないように）
# アンインストールスクリプトでは、存在しないファイルをスキップするのが正常動作

# カラー定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# デフォルト設定
FORCE_MODE=false
KEEP_BACKUP=false
DRY_RUN=false

# パイプ経由実行を検出
IS_PIPED=false
if [ ! -t 0 ]; then
    IS_PIPED=true
fi

# ロゴ表示
show_logo() {
    echo -e "${BLUE}"
    cat << 'LOGO'
    ╔═══════════════════════════════════════╗
    ║   AI Instruction Kits Uninstaller     ║
    ║      AI指示書キット アンインストーラー ║
    ╚═══════════════════════════════════════╝
LOGO
    echo -e "${NC}"
}

# ヘルプ表示
show_help() {
    cat << HELP
Usage: bash scripts/uninstall.sh [OPTIONS]

Options:
    --force         Skip all confirmations
    --keep-backup   Keep backup files created during installation
    --dry-run       Show what would be removed without actually removing
    --help          Show this help

Description:
    このスクリプトは install.sh/setup-project.sh によってインストールされた
    AI指示書キットのファイルとシンボリックリンクを削除します。

Removed items:
    - instructions/ai_instruction_kits/ (サブモジュール/クローン/コピー)
    - scripts/checkpoint.sh (シンボリックリンク)
    - scripts/commit.sh (シンボリックリンク)
    - scripts/lib/ (シンボリックリンク)
    - scripts/worktree-manager.sh (シンボリックリンク)
    - CLAUDE.md, GEMINI.md, CURSOR.md (シンボリックリンク)
    - .claude/skills/ (スキル設定)
    - .openhands/microagents/repo.md (シンボリックリンク)
    - .git/hooks/prepare-commit-msg (Gitフック)

Kept items (プロジェクト固有のファイルは保持):
    - instructions/PROJECT.md (プロジェクト設定)
    - instructions/PROJECT.en.md (英語版プロジェクト設定)
    - checkpoint.log (チェックポイントログ)
    - .gitignore (変更を元に戻さない)

Examples:
    # 通常のアンインストール (確認あり)
    bash scripts/uninstall.sh

    # 確認なしで実行
    bash scripts/uninstall.sh --force

    # 実行内容を確認 (実際には削除しない)
    bash scripts/uninstall.sh --dry-run

    # リモートから直接実行 (--force必須)
    curl -sSL https://raw.githubusercontent.com/dobachi/AI_Instruction_Kits/main/scripts/uninstall.sh | bash -s -- --force

    # ダウンロードしてから実行 (推奨)
    curl -sSL https://raw.githubusercontent.com/dobachi/AI_Instruction_Kits/main/scripts/uninstall.sh -o uninstall.sh
    bash uninstall.sh
    rm uninstall.sh

HELP
}

# 引数解析
while [[ $# -gt 0 ]]; do
    case $1 in
        --force|-f)
            FORCE_MODE=true
            shift
            ;;
        --keep-backup)
            KEEP_BACKUP=true
            shift
            ;;
        --dry-run|-n)
            DRY_RUN=true
            shift
            ;;
        --help|-h)
            show_help
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# ロゴ表示
show_logo

# Dry-runモードのecho
dry_echo() {
    if [ "$DRY_RUN" = true ]; then
        echo -e "${YELLOW}[DRY-RUN]${NC} $1"
    else
        eval "$1"
    fi
}

# ファイル/ディレクトリの削除
remove_item() {
    local item="$1"
    local description="$2"

    if [ -e "$item" ] || [ -L "$item" ]; then
        echo -e "${BLUE}🗑️  Removing: $description${NC}"
        echo "    $item"
        dry_echo "rm -rf \"$item\""
        return 0
    else
        return 1
    fi
}

# シンボリックリンクの削除
remove_symlink() {
    local link="$1"
    local description="$2"

    if [ -L "$link" ]; then
        echo -e "${BLUE}🔗 Removing symbolic link: $description${NC}"
        echo "    $link -> $(readlink "$link")"
        dry_echo "rm \"$link\""
        return 0
    else
        return 1
    fi
}

# 確認プロンプト
confirm_removal() {
    # パイプ経由実行の場合は--forceが必須
    if [ "$IS_PIPED" = true ] && [ "$FORCE_MODE" != true ]; then
        echo -e "\n${YELLOW}⚠️  この操作により以下のアイテムが削除されます:${NC}"
        echo ""
        echo "【削除されるもの】"
        echo "  - instructions/ai_instruction_kits/ (AI指示書システム本体)"
        echo "  - scripts/配下のシンボリックリンク"
        echo "  - CLAUDE.md, GEMINI.md, CURSOR.md (シンボリックリンク)"
        echo "  - .claude/skills/ (スキル設定)"
        echo "  - .openhands/microagents/repo.md"
        echo "  - .git/hooks/prepare-commit-msg"
        if [ "$KEEP_BACKUP" = false ]; then
            echo "  - *.backup ファイル"
        fi
        echo ""
        echo "【保持されるもの】"
        echo "  - instructions/PROJECT.md (プロジェクト固有設定)"
        echo "  - instructions/PROJECT.en.md"
        echo "  - checkpoint.log (チェックポイントログ)"
        echo "  - instructions/CURRENT_INSTRUCTION.md (生成された指示書)"
        echo ""
        echo -e "${RED}❌ パイプ経由での対話的実行は安全のためサポートされていません${NC}"
        echo -e "${YELLOW}   以下のいずれかの方法で実行してください:${NC}"
        echo ""
        echo -e "${YELLOW}   1. 確認なしで実行:${NC}"
        echo -e "${YELLOW}      curl ... | bash -s -- --force${NC}"
        echo ""
        echo -e "${YELLOW}   2. ダウンロードしてから実行:${NC}"
        echo -e "${YELLOW}      curl -sSL <URL> -o uninstall.sh${NC}"
        echo -e "${YELLOW}      bash uninstall.sh${NC}"
        echo -e "${YELLOW}      rm uninstall.sh${NC}"
        echo ""
        echo -e "${YELLOW}   3. プロセス置換を使用 (bash 4.0以降):${NC}"
        echo -e "${YELLOW}      bash <(curl -sSL <URL>)${NC}"
        exit 1
    fi

    # --forceモードの場合は確認をスキップ
    if [ "$FORCE_MODE" = true ]; then
        return 0
    fi

    # 通常の確認プロンプト
    echo -e "\n${YELLOW}⚠️  この操作により以下のアイテムが削除されます:${NC}"
    echo ""
    echo "【削除されるもの】"
    echo "  - instructions/ai_instruction_kits/ (AI指示書システム本体)"
    echo "  - scripts/配下のシンボリックリンク"
    echo "  - CLAUDE.md, GEMINI.md, CURSOR.md (シンボリックリンク)"
    echo "  - .claude/skills/ (スキル設定)"
    echo "  - .openhands/microagents/repo.md"
    echo "  - .git/hooks/prepare-commit-msg"

    if [ "$KEEP_BACKUP" = false ]; then
        echo "  - *.backup ファイル"
    fi

    echo ""
    echo "【保持されるもの】"
    echo "  - instructions/PROJECT.md (プロジェクト固有設定)"
    echo "  - instructions/PROJECT.en.md"
    echo "  - checkpoint.log (チェックポイントログ)"
    echo "  - instructions/CURRENT_INSTRUCTION.md (生成された指示書)"
    echo ""

    echo -n -e "${YELLOW}本当にアンインストールしますか? [y/N]: ${NC}"
    read -r confirm

    case "$confirm" in
        [yY][eE][sS]|[yY])
            return 0
            ;;
        *)
            echo -e "${GREEN}アンインストールをキャンセルしました${NC}"
            exit 0
            ;;
    esac
}

# アンインストール実行
perform_uninstall() {
    echo -e "\n${BLUE}🚀 Starting uninstallation...${NC}\n"

    local removed_count=0

    # 1. instructions/ai_instruction_kits/ の削除（サブモジュール、クローン、コピーすべて）
    if [ -d "instructions/ai_instruction_kits" ]; then
        # サブモジュールかチェック
        if git submodule status instructions/ai_instruction_kits &>/dev/null; then
            echo -e "${BLUE}📦 Removing Git submodule: instructions/ai_instruction_kits${NC}"
            if [ "$DRY_RUN" = true ]; then
                echo -e "${YELLOW}[DRY-RUN]${NC} git submodule deinit -f instructions/ai_instruction_kits"
                echo -e "${YELLOW}[DRY-RUN]${NC} git rm -f instructions/ai_instruction_kits"
                echo -e "${YELLOW}[DRY-RUN]${NC} rm -rf .git/modules/instructions/ai_instruction_kits"
            else
                git submodule deinit -f instructions/ai_instruction_kits 2>/dev/null || true
                git rm -f instructions/ai_instruction_kits 2>/dev/null || true
                rm -rf .git/modules/instructions/ai_instruction_kits 2>/dev/null || true
            fi
            ((removed_count++))
        else
            # サブモジュールでない場合は通常の削除
            if remove_item "instructions/ai_instruction_kits" "AI Instruction Kits (clone/copy)"; then
                ((removed_count++))
            fi
        fi
    fi

    # 2. scripts/ 配下のシンボリックリンク
    if remove_symlink "scripts/checkpoint.sh" "Checkpoint manager"; then ((removed_count++)); fi
    if remove_symlink "scripts/commit.sh" "Commit script"; then ((removed_count++)); fi
    if remove_symlink "scripts/lib" "Library directory"; then ((removed_count++)); fi
    if remove_symlink "scripts/worktree-manager.sh" "Worktree manager"; then ((removed_count++)); fi

    # 3. ルートディレクトリのシンボリックリンク
    if remove_symlink "CLAUDE.md" "Claude AI configuration"; then ((removed_count++)); fi
    if remove_symlink "GEMINI.md" "Gemini AI configuration"; then ((removed_count++)); fi
    if remove_symlink "CURSOR.md" "Cursor AI configuration"; then ((removed_count++)); fi
    if remove_symlink "CLAUDE.en.md" "Claude AI configuration (English)"; then ((removed_count++)); fi
    if remove_symlink "GEMINI.en.md" "Gemini AI configuration (English)"; then ((removed_count++)); fi
    if remove_symlink "CURSOR.en.md" "Cursor AI configuration (English)"; then ((removed_count++)); fi

    # 4. Claude Codeスキル設定
    if remove_item ".claude/skills" "Claude Code skills"; then ((removed_count++)); fi

    # 5. OpenHandsマイクロエージェント設定
    if remove_symlink ".openhands/microagents/repo.md" "OpenHands microagent config"; then ((removed_count++)); fi

    # 6. Gitフック
    if [ -f ".git/hooks/prepare-commit-msg" ]; then
        # AI指示書キット由来のフックかチェック（先頭にマーカーがあるか）
        if grep -q "AI_INSTRUCTION_KITS" ".git/hooks/prepare-commit-msg" 2>/dev/null; then
            if remove_item ".git/hooks/prepare-commit-msg" "Git commit message hook"; then
                ((removed_count++))
            fi
        else
            echo -e "${YELLOW}⚠️  .git/hooks/prepare-commit-msg exists but not from AI Instruction Kits${NC}"
            echo "    Skipping (manual removal required if needed)"
        fi
    fi

    # 7. バックアップファイルの削除
    if [ "$KEEP_BACKUP" = false ]; then
        echo -e "\n${BLUE}🗑️  Removing backup files...${NC}"
        for backup in instructions/PROJECT.md.backup* CLAUDE.md.backup* scripts/*.backup*; do
            if [ -e "$backup" ]; then
                dry_echo "rm -f \"$backup\""
                ((removed_count++))
            fi
        done
    fi

    echo -e "\n${GREEN}✅ Removed $removed_count items${NC}"
}

# 完了メッセージ
show_completion() {
    echo -e "\n${GREEN}🎉 Uninstallation completed successfully!${NC}"

    if [ "$DRY_RUN" = true ]; then
        echo -e "\n${YELLOW}⚠️  This was a dry-run. No files were actually removed.${NC}"
        echo -e "${YELLOW}   Run without --dry-run to perform actual uninstallation.${NC}"
    fi

    echo -e "\n${BLUE}📋 Kept files (プロジェクト固有のファイルは保持されました):${NC}"

    local kept_files=()
    [ -f "instructions/PROJECT.md" ] && kept_files+=("instructions/PROJECT.md")
    [ -f "instructions/PROJECT.en.md" ] && kept_files+=("instructions/PROJECT.en.md")
    [ -f "checkpoint.log" ] && kept_files+=("checkpoint.log")
    [ -f "instructions/CURRENT_INSTRUCTION.md" ] && kept_files+=("instructions/CURRENT_INSTRUCTION.md")
    [ -d "instructions/modular/cache" ] && kept_files+=("instructions/modular/cache/")

    if [ ${#kept_files[@]} -gt 0 ]; then
        for file in "${kept_files[@]}"; do
            echo "  - $file"
        done
    else
        echo "  (None)"
    fi

    if [ "$KEEP_BACKUP" = true ]; then
        echo -e "\n${BLUE}💾 Backup files were kept${NC}"
        echo "  You can manually remove *.backup files if needed"
    fi

    echo -e "\n${BLUE}🔄 To reinstall:${NC}"
    echo "  curl -sSL https://raw.githubusercontent.com/dobachi/AI_Instruction_Kits/main/scripts/install.sh | bash"

    echo -e "\n${YELLOW}Note: .gitignore entries were not modified${NC}"
    echo "  You may want to manually remove 'instructions/ai_instruction_kits/' from .gitignore"
}

# メイン処理
main() {
    # 環境チェック
    if [ ! -d ".git" ] && [ -d "instructions/ai_instruction_kits" ]; then
        echo -e "${YELLOW}⚠️  Not in a Git repository, but AI Instruction Kits directory exists${NC}"
        echo "Continuing with uninstallation..."
    fi

    # インストール検出
    if [ ! -d "instructions/ai_instruction_kits" ] && \
       [ ! -L "scripts/checkpoint.sh" ] && \
       [ ! -L "CLAUDE.md" ]; then
        echo -e "${YELLOW}⚠️  AI Instruction Kits installation not detected${NC}"
        echo "Nothing to uninstall."
        exit 0
    fi

    # 確認
    confirm_removal

    # アンインストール実行
    perform_uninstall

    # 完了メッセージ
    show_completion
}

# 実行
main
