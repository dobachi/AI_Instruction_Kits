#!/bin/bash
# AI指示書キット メタプロジェクト化ワンライナーインストーラー
# 使用方法:
#   curl -sSL https://raw.githubusercontent.com/dobachi/AI_Instruction_Kits/main/scripts/install-metaproject.sh | bash -s -- --project-name myapp
#
# AI指示書キットインストール後に実行:
#   curl -sSL .../install.sh | bash && curl -sSL .../install-metaproject.sh | bash -s -- --project-name myapp

set -e

# カラー定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# デフォルト設定
DEFAULT_REPO="https://github.com/dobachi/AI_Instruction_Kits.git"

# ロゴ表示
show_logo() {
    echo -e "${BLUE}"
    cat << 'LOGO'
    ╔═══════════════════════════════════════════╗
    ║   AI Meta-Project Setup                   ║
    ║   AI開発支援メタプロジェクト セットアップ  ║
    ╚═══════════════════════════════════════════╝
LOGO
    echo -e "${NC}"
}

# ヘルプ表示
show_help() {
    cat << HELP
メタプロジェクト化セットアップ

このツールはAI指示書キットインストール後に実行し、
現在のプロジェクトをメタプロジェクト化します。

使用方法:
    curl -sSL <URL> | bash -s -- --project-name <name> [OPTIONS]

必須オプション:
    --project-name <name>  対象プロジェクト名

オプション:
    --project-url <url>    クローンするGitリポジトリURL
    --project-path <path>  移動する既存プロジェクトのパス
    --force                確認をスキップ
    --help                 このヘルプを表示

例:
    # 基本的な使用（プロジェクト名のみ指定）
    curl -sSL <URL> | bash -s -- --project-name myapp

    # GitHubからクローン
    curl -sSL <URL> | bash -s -- --project-name myapp --project-url https://github.com/user/myapp.git

    # ローカルプロジェクトを移動
    curl -sSL <URL> | bash -s -- --project-name myapp --project-path ../myapp

前提条件:
    - AI指示書キットがインストール済み（instructions/ai_instruction_kits/が存在）
    - またはこの後インストールする

HELP
}

# 引数を転送してsetup-metaproject.shを実行
main() {
    show_logo

    # 引数チェック
    if [ "$#" -eq 0 ] || [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
        show_help
        exit 0
    fi

    # AI指示書キットの存在確認
    if [ ! -d "instructions/ai_instruction_kits" ] && [ ! -d ".git" ]; then
        echo -e "${YELLOW}⚠️  AI指示書キットが見つかりません${NC}"
        echo -e "${BLUE}📦 まずAI指示書キットをインストールします...${NC}"

        # install.shをダウンロードして実行
        echo -e "${BLUE}📥 AI指示書キットをインストール中...${NC}"
        if command -v curl &> /dev/null; then
            curl -sSL "https://raw.githubusercontent.com/dobachi/AI_Instruction_Kits/main/scripts/install.sh" | bash -s -- --mode submodule --force
        else
            wget -qO- "https://raw.githubusercontent.com/dobachi/AI_Instruction_Kits/main/scripts/install.sh" | bash -s -- --mode submodule --force
        fi
    fi

    # setup-metaproject.shをダウンロード
    echo -e "${BLUE}📥 メタプロジェクト化スクリプトをダウンロード中...${NC}"

    TEMP_DIR=$(mktemp -d)
    trap "rm -rf $TEMP_DIR" EXIT

    if command -v curl &> /dev/null; then
        curl -sSL "https://raw.githubusercontent.com/dobachi/AI_Instruction_Kits/main/scripts/setup-metaproject.sh" \
            -o "$TEMP_DIR/setup-metaproject.sh"
    else
        wget -q "https://raw.githubusercontent.com/dobachi/AI_Instruction_Kits/main/scripts/setup-metaproject.sh" \
            -O "$TEMP_DIR/setup-metaproject.sh"
    fi

    chmod +x "$TEMP_DIR/setup-metaproject.sh"

    # setup-metaproject.shを実行（引数を転送）
    echo -e "${BLUE}🔧 メタプロジェクトをセットアップ中...${NC}"
    bash "$TEMP_DIR/setup-metaproject.sh" "$@"
}

# 実行
main "$@"