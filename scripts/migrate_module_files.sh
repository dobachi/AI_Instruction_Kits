#!/bin/bash
# モジュールファイルを新しい命名規則に移行するスクリプト

set -e

# カラー出力の設定
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 引数チェック
if [ $# -eq 0 ]; then
    echo "使用方法: $0 <モジュールパス> [言語(ja/en)]"
    echo "例: $0 modular/ja/modules/expertise/machine_learning.md"
    echo "    $0 modular/ja/modules/expertise/ ja  # ディレクトリ内全体"
    exit 1
fi

MODULE_PATH="$1"
LANG="${2:-ja}"

# 単一ファイルの移行処理
migrate_single_module() {
    local module_file="$1"
    local module_dir=$(dirname "$module_file")
    local module_base=$(basename "$module_file" .md)
    
    # 既に_detailed.mdの場合はスキップ
    if [[ "$module_base" == *"_detailed" ]]; then
        echo -e "${YELLOW}スキップ: $module_file (既に詳細版)${NC}"
        return
    fi
    
    # _concise.mdの場合
    if [[ "$module_base" == *"_concise" ]]; then
        local base_name="${module_base%_concise}"
        local original_file="${module_dir}/${base_name}.md"
        local concise_file="$module_file"
        local detailed_file="${module_dir}/${base_name}_detailed.md"
        
        if [ -f "$original_file" ]; then
            # バックアップ作成
            echo -e "${GREEN}バックアップ作成: ${original_file}.backup${NC}"
            cp "$original_file" "${original_file}.backup"
            
            # ファイル移動
            echo -e "${GREEN}移動: $original_file → $detailed_file${NC}"
            mv "$original_file" "$detailed_file"
            
            echo -e "${GREEN}移動: $concise_file → $original_file${NC}"
            mv "$concise_file" "$original_file"
            
            echo -e "${GREEN}✓ 移行完了: $base_name${NC}"
        else
            echo -e "${RED}エラー: 元ファイルが見つかりません: $original_file${NC}"
        fi
    else
        # 通常のファイル（_concise版が存在するか確認）
        local concise_file="${module_dir}/${module_base}_concise.md"
        if [ -f "$concise_file" ]; then
            # このファイルは元の詳細版なので、後で処理される
            echo -e "${YELLOW}保留: $module_file (対応する簡潔版が存在)${NC}"
        else
            echo -e "${YELLOW}スキップ: $module_file (簡潔版なし)${NC}"
        fi
    fi
}

# ディレクトリ内の全モジュールを移行
migrate_directory() {
    local dir_path="$1"
    
    echo -e "${GREEN}ディレクトリ内のモジュールを移行: $dir_path${NC}"
    echo "=========================="
    
    # _concise.mdファイルを先に処理
    for file in "$dir_path"/*_concise.md; do
        if [ -f "$file" ]; then
            migrate_single_module "$file"
        fi
    done
}

# メイン処理
if [ -f "$MODULE_PATH" ]; then
    # 単一ファイルの処理
    migrate_single_module "$MODULE_PATH"
elif [ -d "$MODULE_PATH" ]; then
    # ディレクトリの処理
    migrate_directory "$MODULE_PATH"
else
    echo -e "${RED}エラー: パスが見つかりません: $MODULE_PATH${NC}"
    exit 1
fi

# 移行後の確認
echo ""
echo "=========================="
echo -e "${GREEN}移行結果の確認:${NC}"

if [ -d "$MODULE_PATH" ]; then
    echo "新しいファイル構造:"
    ls -la "$MODULE_PATH"/*.md 2>/dev/null | grep -E "(_detailed\.md|\.md)$" | grep -v "_concise.md" | grep -v ".backup"
else
    dir_path=$(dirname "$MODULE_PATH")
    base_name=$(basename "$MODULE_PATH" .md | sed 's/_concise$//')
    echo "移行されたファイル:"
    ls -la "$dir_path/${base_name}.md" "$dir_path/${base_name}_detailed.md" 2>/dev/null || true
fi

echo ""
echo -e "${GREEN}移行が完了しました。${NC}"
echo "バックアップファイル（.backup）は手動で削除してください。"