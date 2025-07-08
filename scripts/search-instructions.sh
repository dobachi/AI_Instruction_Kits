#!/bin/bash

# AI指示書カタログ検索スクリプト
# 分散型メタデータを使用した高速検索

set -e

# 色の定義
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 設定
INSTRUCTIONS_DIR="${INSTRUCTIONS_DIR:-instructions}"
METADATA_EXT=".meta"

# ヘルプ表示
show_help() {
    echo "使用法: $0 [オプション] [検索キーワード]"
    echo ""
    echo "分散型メタデータを使用してAI指示書を検索します。"
    echo ""
    echo "オプション:"
    echo "  -c, --category CATEGORY    カテゴリで絞り込み"
    echo "  -l, --language LANG        言語で絞り込み (ja/en)"
    echo "  -t, --tag TAG              タグで絞り込み"
    echo "  -a, --author AUTHOR        著者で絞り込み"
    echo "  -f, --format FORMAT        出力形式 (list/detail/path) [デフォルト: list]"
    echo "  -h, --help                 このヘルプを表示"
    echo ""
    echo "例:"
    echo "  $0 python                  # 'python'を含む指示書を検索"
    echo "  $0 -c coding               # codingカテゴリの指示書を表示"
    echo "  $0 -t marp -f detail       # 'marp'タグの詳細情報を表示"
    echo "  $0 -l ja -c agent          # 日本語のagentカテゴリを検索"
}

# JSONから値を取得（簡易パーサー）
get_json_value() {
    local json="$1"
    local key="$2"
    echo "$json" | grep "\"$key\":" | sed -E "s/.*\"$key\": *\"([^\"]*)\".*/\1/" | head -1
}

# 検索実行
search_instructions() {
    local keyword="$1"
    local category_filter="$2"
    local language_filter="$3"
    local tag_filter="$4"
    local author_filter="$5"
    local format="$6"
    
    local found_count=0
    local results=()
    
    # メタデータファイルを検索
    while IFS= read -r -d '' meta_file; do
        if [[ -f "$meta_file" ]]; then
            local content=$(cat "$meta_file")
            local match=true
            
            # フィルタリング
            if [[ -n "$category_filter" ]]; then
                local category=$(get_json_value "$content" "category")
                [[ "$category" != "$category_filter" ]] && match=false
            fi
            
            if [[ -n "$language_filter" ]]; then
                local language=$(get_json_value "$content" "language")
                [[ "$language" != "$language_filter" ]] && match=false
            fi
            
            if [[ -n "$tag_filter" ]]; then
                local tags=$(get_json_value "$content" "tags")
                [[ ! "$tags" =~ "$tag_filter" ]] && match=false
            fi
            
            if [[ -n "$author_filter" ]]; then
                local author=$(get_json_value "$content" "author")
                [[ "$author" != "$author_filter" ]] && match=false
            fi
            
            # キーワード検索
            if [[ -n "$keyword" ]] && [[ "$match" == "true" ]]; then
                if ! grep -qi "$keyword" "$meta_file" 2>/dev/null; then
                    match=false
                fi
            fi
            
            # マッチした場合
            if [[ "$match" == "true" ]]; then
                ((found_count++))
                results+=("$meta_file")
            fi
        fi
    done < <(find "$INSTRUCTIONS_DIR" -name "*${METADATA_EXT}" -print0 2>/dev/null)
    
    # 結果表示
    if [[ $found_count -eq 0 ]]; then
        echo -e "${YELLOW}検索結果が見つかりませんでした。${NC}"
        echo ""
        echo "ヒント: メタデータが生成されていない可能性があります。"
        echo "  ./scripts/generate-metadata.sh を実行してメタデータを生成してください。"
        return
    fi
    
    echo -e "${GREEN}検索結果: ${found_count}件${NC}"
    echo ""
    
    # フォーマットに応じて表示
    for meta_file in "${results[@]}"; do
        local content=$(cat "$meta_file")
        local path=$(get_json_value "$content" "path")
        local title=$(get_json_value "$content" "title")
        local category=$(get_json_value "$content" "category")
        local language=$(get_json_value "$content" "language")
        
        case "$format" in
            "detail")
                echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
                echo -e "${GREEN}タイトル:${NC} $title"
                echo -e "${GREEN}パス:${NC} $INSTRUCTIONS_DIR/$path"
                echo -e "${GREEN}カテゴリ:${NC} $category"
                echo -e "${GREEN}言語:${NC} $language"
                local description=$(get_json_value "$content" "description")
                echo -e "${GREEN}説明:${NC} $description"
                local tags=$(get_json_value "$content" "tags")
                echo -e "${GREEN}タグ:${NC} $tags"
                local author=$(get_json_value "$content" "author")
                [[ -n "$author" ]] && echo -e "${GREEN}著者:${NC} $author"
                local license=$(get_json_value "$content" "license")
                [[ -n "$license" ]] && echo -e "${GREEN}ライセンス:${NC} $license"
                echo ""
                ;;
            "path")
                echo "$INSTRUCTIONS_DIR/$path"
                ;;
            *)  # list format
                printf "%-50s [%s/%s]\n" "$title" "$language" "$category"
                ;;
        esac
    done
}

# メイン処理
main() {
    local keyword=""
    local category_filter=""
    local language_filter=""
    local tag_filter=""
    local author_filter=""
    local format="list"
    
    # 引数解析
    while [[ $# -gt 0 ]]; do
        case $1 in
            -c|--category)
                category_filter="$2"
                shift 2
                ;;
            -l|--language)
                language_filter="$2"
                shift 2
                ;;
            -t|--tag)
                tag_filter="$2"
                shift 2
                ;;
            -a|--author)
                author_filter="$2"
                shift 2
                ;;
            -f|--format)
                format="$2"
                shift 2
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            *)
                keyword="$1"
                shift
                ;;
        esac
    done
    
    # 検索実行
    search_instructions "$keyword" "$category_filter" "$language_filter" "$tag_filter" "$author_filter" "$format"
}

# スクリプト実行
main "$@"