#!/bin/bash
# AI指示書キット ワンライナーインストーラー
# 使用方法:
#   curl -sSL https://raw.githubusercontent.com/dobachi/AI_Instruction_Kits/main/scripts/install.sh | bash
#   または
#   wget -qO- https://raw.githubusercontent.com/dobachi/AI_Instruction_Kits/main/scripts/install.sh | bash
#
# オプション:
#   curl -sSL ... | bash -s -- --mode submodule --lang ja
#   curl -sSL ... | bash -s -- --preset web_api --force

set -e

# カラー定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# デフォルト設定
DEFAULT_REPO="https://github.com/dobachi/AI_Instruction_Kits.git"
DEFAULT_MODE="submodule"
DEFAULT_LANG="ja"
FORCE_MODE=false
PRESET=""
CUSTOM_REPO=""
SKIP_INTERACTIVE=false

# ロゴ表示
show_logo() {
    echo -e "${BLUE}"
    cat << 'LOGO'
    ╔═══════════════════════════════════════╗
    ║     AI Instruction Kits Installer     ║
    ║         AI指示書キット installer      ║
    ╚═══════════════════════════════════════╝
LOGO
    echo -e "${NC}"
}

# ヘルプ表示
show_help() {
    cat << HELP
Usage: curl -sSL <URL> | bash [OPTIONS]

Options:
    --mode <mode>     Installation mode (copy|clone|submodule) [default: submodule]
    --lang <lang>     Language (ja|en) [default: ja]
    --preset <name>   Use preset configuration
                      (web_api|cli_tool|data_analyst|technical_writer)
    --repo <url>      Custom repository URL
    --force           Skip all confirmations
    --skip-claude     Skip Claude Code commands setup
    --skip-git-hooks  Skip Git hooks setup
    --help            Show this help

Examples:
    # Basic installation (interactive)
    curl -sSL <URL> | bash

    # Quick setup with Web API preset
    curl -sSL <URL> | bash -s -- --preset web_api --force

    # Custom repository with English
    curl -sSL <URL> | bash -s -- --repo https://github.com/yourname/fork.git --lang en

HELP
}

# 引数解析
while [[ $# -gt 0 ]]; do
    case $1 in
        --mode)
            MODE="$2"
            SKIP_INTERACTIVE=true
            shift 2
            ;;
        --lang)
            LANG="$2"
            shift 2
            ;;
        --preset)
            PRESET="$2"
            SKIP_INTERACTIVE=true
            shift 2
            ;;
        --repo)
            CUSTOM_REPO="$2"
            shift 2
            ;;
        --force)
            FORCE_MODE=true
            SKIP_INTERACTIVE=true
            shift
            ;;
        --skip-claude)
            SKIP_CLAUDE=true
            shift
            ;;
        --skip-git-hooks)
            SKIP_GIT_HOOKS=true
            shift
            ;;
        --help)
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

# 環境チェック
check_environment() {
    echo -e "${BLUE}🔍 Checking environment...${NC}"
    
    # Git確認
    if ! command -v git &> /dev/null; then
        echo -e "${RED}❌ Git is not installed${NC}"
        echo "Please install Git first: https://git-scm.com/"
        exit 1
    fi
    
    # curl/wget確認
    if ! command -v curl &> /dev/null && ! command -v wget &> /dev/null; then
        echo -e "${RED}❌ Neither curl nor wget is installed${NC}"
        exit 1
    fi
    
    # プロジェクトディレクトリ確認
    if [ ! -d ".git" ] && [ "$MODE" != "copy" ]; then
        echo -e "${YELLOW}⚠️  Not in a Git repository${NC}"
        echo "Initializing new Git repository..."
        git init
    fi
    
    echo -e "${GREEN}✅ Environment check passed${NC}"
}

# インタラクティブモード選択
select_mode_interactive() {
    if [ "$SKIP_INTERACTIVE" = true ]; then
        MODE="${MODE:-$DEFAULT_MODE}"
        return
    fi
    
    # TTYが利用可能かチェック（パイプ経由実行を検出）
    if [ ! -t 0 ]; then
        echo -e "${YELLOW}⚠️  Non-interactive mode detected (piped input). Using defaults.${NC}"
        echo -e "${YELLOW}   To customize, use: curl ... | bash -s -- --mode <mode> --preset <preset>${NC}"
        MODE="${MODE:-$DEFAULT_MODE}"
        return
    fi
    
    echo -e "\n${BLUE}📦 Select installation mode:${NC}"
    echo "1) Submodule (Recommended) - Easy updates with git"
    echo "2) Clone - Independent copy you can modify"
    echo "3) Copy - Simple file copy without git"
    echo -n "Choice [1-3] (default: 1): "
    read -r choice    
    case "$choice" in
        1|"")
            MODE="submodule"
            ;;
        2)
            MODE="clone"
            ;;
        3)
            MODE="copy"
            ;;
        *)
            echo -e "${RED}Invalid choice${NC}"
            exit 1
            ;;
    esac
}

# プリセット選択
select_preset_interactive() {
    if [ -n "$PRESET" ] || [ "$SKIP_INTERACTIVE" = true ]; then
        return
    fi
    
    # TTYが利用可能かチェック（パイプ経由実行を検出）
    if [ ! -t 0 ]; then
        PRESET=""
        return
    fi
    
    echo -e "\n${BLUE}🎯 Select project type (or skip for custom):${NC}"
    echo "1) Web API Development"
    echo "2) CLI Tool Development"
    echo "3) Data Analysis"
    echo "4) Technical Writing"
    echo "5) Skip (Custom configuration)"
    echo -n "Choice [1-5] (default: 5): "
    read -r choice    
    case "$choice" in
        1)
            PRESET="web_api"
            ;;
        2)
            PRESET="cli_tool"
            ;;
        3)
            PRESET="data_analyst"
            ;;
        4)
            PRESET="technical_writer"
            ;;
        5|"")
            PRESET=""
            ;;
        *)
            echo -e "${RED}Invalid choice${NC}"
            exit 1
            ;;
    esac
}

# 言語選択
select_language_interactive() {
    if [ -n "$LANG" ] || [ "$SKIP_INTERACTIVE" = true ]; then
        LANG="${LANG:-$DEFAULT_LANG}"
        return
    fi
    
    # TTYが利用可能かチェック（パイプ経由実行を検出）
    if [ ! -t 0 ]; then
        LANG="${LANG:-$DEFAULT_LANG}"
        return
    fi
    
    echo -e "\n${BLUE}🌐 Select language:${NC}"
    echo "1) Japanese (日本語)"
    echo "2) English"
    echo -n "Choice [1-2] (default: 1): "
    read -r choice    
    case "$choice" in
        1|"")
            LANG="ja"
            ;;
        2)
            LANG="en"
            ;;
        *)
            echo -e "${RED}Invalid choice${NC}"
            exit 1
            ;;
    esac
}

# 設定確認
confirm_settings() {
    if [ "$FORCE_MODE" = true ]; then
        return 0
    fi
    
    # TTYが利用可能かチェック（パイプ経由実行を検出）
    if [ ! -t 0 ]; then
        echo -e "\n${BLUE}📋 Installation settings:${NC}"
        echo "  Mode: $MODE"
        echo "  Language: $LANG"
        [ -n "$PRESET" ] && echo "  Preset: $PRESET"
        [ -n "$CUSTOM_REPO" ] && echo "  Repository: $CUSTOM_REPO"
        echo -e "\n${YELLOW}⚠️  Non-interactive mode. Proceeding with defaults...${NC}"
        return 0
    fi
    
    echo -e "\n${BLUE}📋 Installation settings:${NC}"
    echo "  Mode: $MODE"
    echo "  Language: $LANG"
    [ -n "$PRESET" ] && echo "  Preset: $PRESET"
    [ -n "$CUSTOM_REPO" ] && echo "  Repository: $CUSTOM_REPO"
    
    echo -n -e "\n${YELLOW}Proceed with installation? [Y/n]: ${NC}"
    read -r confirm    
    case "$confirm" in
        [nN][oO]|[nN])
            echo "Installation cancelled"
            exit 0
            ;;
    esac
}

# setup-project.shをダウンロードして実行
run_setup() {
    echo -e "\n${BLUE}🚀 Starting installation...${NC}"
    
    # 既存のインストールをチェック
    if [ -d "ai_instruction_kits" ] || [ -d "instructions/ai_instruction_kits" ]; then
        echo -e "${YELLOW}⚠️  Existing AI Instruction Kits installation detected.${NC}"
        echo -e "${YELLOW}   Consider removing it first or use --force to override.${NC}"
    fi
    
    # リポジトリURL決定
    REPO_URL="${CUSTOM_REPO:-$DEFAULT_REPO}"
    
    # 一時ディレクトリ作成
    TEMP_DIR=$(mktemp -d)
    trap "rm -rf $TEMP_DIR" EXIT
    
    # copyモードの場合はリポジトリ全体をダウンロード
    if [ "$MODE" = "copy" ]; then
        echo -e "${BLUE}📦 Copy mode detected. Downloading full repository...${NC}"
        
        # GitHubのtarballをダウンロード
        if command -v curl &> /dev/null; then
            curl -sSL "https://github.com/dobachi/AI_Instruction_Kits/archive/refs/heads/main.tar.gz" \
                -o "$TEMP_DIR/repo.tar.gz"
        else
            wget -q "https://github.com/dobachi/AI_Instruction_Kits/archive/refs/heads/main.tar.gz" \
                -O "$TEMP_DIR/repo.tar.gz"
        fi
        
        # tarballを展開
        tar -xzf "$TEMP_DIR/repo.tar.gz" -C "$TEMP_DIR"
        
        # setup-project.shを実行可能な状態にする
        SETUP_SCRIPT="$TEMP_DIR/AI_Instruction_Kits-main/scripts/setup-project.sh"
        chmod +x "$SETUP_SCRIPT"
        
        # カレントディレクトリから実行（copyモードが正しく動作するため）
        cp -r "$TEMP_DIR/AI_Instruction_Kits-main/"* "$TEMP_DIR/"
        SETUP_SCRIPT="$TEMP_DIR/scripts/setup-project.sh"
    else
        # clone/submoduleモードの場合は軽量ダウンロード
        echo -e "${BLUE}📥 Downloading setup script...${NC}"
        if command -v curl &> /dev/null; then
            curl -sSL "https://raw.githubusercontent.com/dobachi/AI_Instruction_Kits/main/scripts/setup-project.sh" \
                -o "$TEMP_DIR/setup-project.sh"
            # lib/i18n.shもダウンロード
            mkdir -p "$TEMP_DIR/lib"
            curl -sSL "https://raw.githubusercontent.com/dobachi/AI_Instruction_Kits/main/scripts/lib/i18n.sh" \
                -o "$TEMP_DIR/lib/i18n.sh"
        else
            wget -q "https://raw.githubusercontent.com/dobachi/AI_Instruction_Kits/main/scripts/setup-project.sh" \
                -O "$TEMP_DIR/setup-project.sh"
            mkdir -p "$TEMP_DIR/lib"
            wget -q "https://raw.githubusercontent.com/dobachi/AI_Instruction_Kits/main/scripts/lib/i18n.sh" \
                -O "$TEMP_DIR/lib/i18n.sh"
        fi
        
        SETUP_SCRIPT="$TEMP_DIR/setup-project.sh"
        chmod +x "$SETUP_SCRIPT"
    fi
    
    # setup-project.shのオプション構築
    SETUP_OPTS="--mode $MODE"
    [ -n "$CUSTOM_REPO" ] && SETUP_OPTS="$SETUP_OPTS --url $CUSTOM_REPO"
    
    # 非インタラクティブモード時は自動的に--forceを追加
    if [ "$FORCE_MODE" = true ] || [ ! -t 0 ]; then
        SETUP_OPTS="$SETUP_OPTS --force"
    fi
    
    # 環境変数で言語設定
    export AI_INSTRUCTION_LANG="$LANG"
    
    # setup-project.sh実行
    echo -e "${BLUE}🔧 Running setup with options: $SETUP_OPTS${NC}"
    bash "$SETUP_SCRIPT" $SETUP_OPTS
    
    # セットアップの結果を確認
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Setup failed. Please check the error messages above.${NC}"
        exit 1
    fi
    
    # プリセット適用
    if [ -n "$PRESET" ]; then
        echo -e "\n${BLUE}🎨 Applying preset: $PRESET${NC}"
        if [ -f "scripts/generate-instruction.sh" ]; then
            bash scripts/generate-instruction.sh --preset "$PRESET" --output "instructions/CURRENT_INSTRUCTION.md"
            echo -e "${GREEN}✅ Preset applied${NC}"
        fi
    fi
}

# 完了メッセージ
show_completion() {
    echo -e "\n${GREEN}🎉 Installation completed successfully!${NC}"
    echo -e "\n${BLUE}📖 Next steps:${NC}"
    
    if [ "$LANG" = "ja" ]; then
        echo "1. instructions/PROJECT.md を編集してプロジェクト固有の設定を追加"
        echo "2. AIツールに「CLAUDE.mdを参照して作業を開始」と伝える"
        if [ -n "$PRESET" ]; then
            echo "3. instructions/CURRENT_INSTRUCTION.md にプリセット設定済み"
        fi
    else
        echo "1. Edit instructions/PROJECT.en.md for project-specific settings"
        echo "2. Tell AI tools to 'Refer to CLAUDE.en.md and start working'"
        if [ -n "$PRESET" ]; then
            echo "3. Preset configuration saved to instructions/CURRENT_INSTRUCTION.md"
        fi
    fi
    
    echo -e "\n${BLUE}⚡ Quick commands:${NC}"
    echo "  scripts/checkpoint.sh start \"task-name\" 3"
    echo "  scripts/generate-instruction.sh --preset web_api"
    echo "  scripts/commit.sh \"your commit message\""
}

# メイン処理
main() {
    check_environment
    select_mode_interactive
    select_preset_interactive
    select_language_interactive
    confirm_settings
    run_setup
    show_completion
}

# 実行
main