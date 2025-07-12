#!/bin/bash

# AI指示書カタログ検索スクリプト / AI Instruction Catalog Search Script
# 分散型メタデータを使用した高速検索 / Fast search using distributed metadata

# i18nライブラリをソース
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/i18n.sh"

# set -euo pipefail

# 色の定義
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 設定
INSTRUCTIONS_DIR="${INSTRUCTIONS_DIR:-instructions}"
METADATA_EXT=".yaml"

# ヘルプ表示
show_help() {
    MSG_USAGE=$(get_message "usage" "Usage" "使用法")
    MSG_OPTIONS=$(get_message "options" "Options" "オプション")
    MSG_SEARCH_DESC=$(get_message "search_desc" "Search AI instructions using distributed metadata" "分散型メタデータを使用してAI指示書を検索します")
    MSG_FILTER_CATEGORY=$(get_message "filter_category" "Filter by category" "カテゴリで絞り込み")
    MSG_FILTER_LANGUAGE=$(get_message "filter_language" "Filter by language (ja/en)" "言語で絞り込み (ja/en)")
    MSG_FILTER_TAG=$(get_message "filter_tag" "Filter by tag" "タグで絞り込み")
    MSG_FILTER_AUTHOR=$(get_message "filter_author" "Filter by author" "著者で絞り込み")
    MSG_OUTPUT_FORMAT=$(get_message "output_format" "Output format (list/detail/path) [default: list]" "出力形式 (list/detail/path) [デフォルト: list]")
    MSG_SHOW_HELP=$(get_message "show_help" "Show this help" "このヘルプを表示")
    MSG_EXAMPLES=$(get_message "examples" "Examples" "例")
    MSG_SEARCH_KEYWORD=$(get_message "search_keyword" "search keyword" "検索キーワード")
    MSG_SEARCH_PYTHON=$(get_message "search_python" "Search for instructions containing 'python'" "'python'を含む指示書を検索")
    MSG_SHOW_CATEGORY=$(get_message "show_category" "Show instructions in coding category" "codingカテゴリの指示書を表示")
    MSG_SHOW_DETAIL=$(get_message "show_detail" "Show detailed info for 'marp' tag" "'marp'タグの詳細情報を表示")
    MSG_SEARCH_JA_AGENT=$(get_message "search_ja_agent" "Search Japanese agent category" "日本語のagentカテゴリを検索")
    
    echo "$MSG_USAGE: $0 [$MSG_OPTIONS] [$MSG_SEARCH_KEYWORD]"
    echo ""
    echo "$MSG_SEARCH_DESC."
    echo ""
    echo "$MSG_OPTIONS:"
    echo "  -c, --category CATEGORY    $MSG_FILTER_CATEGORY"
    echo "  -l, --language LANG        $MSG_FILTER_LANGUAGE"
    echo "  -t, --tag TAG              $MSG_FILTER_TAG"
    echo "  -a, --author AUTHOR        $MSG_FILTER_AUTHOR"
    echo "  -f, --format FORMAT        $MSG_OUTPUT_FORMAT"
    echo "  -h, --help                 $MSG_SHOW_HELP"
    echo ""
    echo "$MSG_EXAMPLES:"
    echo "  $0 python                  # $MSG_SEARCH_PYTHON"
    echo "  $0 -c coding               # $MSG_SHOW_CATEGORY"
    echo "  $0 -t marp -f detail       # $MSG_SHOW_DETAIL"
    echo "  $0 -l ja -c agent          # $MSG_SEARCH_JA_AGENT"
}

# YAMLから値を取得（簡易パーサー）
get_yaml_value() {
    local yaml="$1"
    local key="$2"
    echo "$yaml" | grep "^$key:" | sed "s/^$key: *//" | sed 's/^"//;s/"$//' | head -1
}

# YAMLからタグリストを取得
get_yaml_tags() {
    local yaml="$1"
    # tags:セクションから次のセクションまでを抽出
    echo "$yaml" | awk '/^tags:/{flag=1;next}/^[a-z_]+:/{flag=0}flag' | grep '^ *- ' | sed 's/^ *- *//'
}

# メタデータファイルを検索
search_metadata() {
    local search_term="$1"
    local category_filter="$2"
    local language_filter="$3"
    local tag_filter="$4"
    local author_filter="$5"
    local format="$6"
    local matches=0
    
    # メタデータファイルを検索
    while IFS= read -r metadata_file; do
        # 対応する指示書ファイルのパスを構築
        instruction_file="${metadata_file%$METADATA_EXT}.md"
        
        # メタデータを読み込み
        if [[ -f "$metadata_file" ]]; then
            local content=$(cat "$metadata_file")
            
            # フィルタリング
            local match=true
            
            # カテゴリフィルタ
            if [[ -n "$category_filter" ]]; then
                local category=$(get_yaml_value "$content" "category")
                if [[ "$category" != "$category_filter" ]]; then
                    match=false
                fi
            fi
            
            # 言語フィルタ
            if [[ -n "$language_filter" ]]; then
                local language=$(get_yaml_value "$content" "language")
                if [[ "$language" != "$language_filter" ]]; then
                    match=false
                fi
            fi
            
            # タグフィルタ
            if [[ -n "$tag_filter" ]] && $match; then
                local tags=$(get_yaml_tags "$content")
                if ! echo "$tags" | grep -q "$tag_filter"; then
                    match=false
                fi
            fi
            
            # 著者フィルタ
            if [[ -n "$author_filter" ]] && $match; then
                local author=$(get_yaml_value "$content" "author")
                if [[ "$author" != *"$author_filter"* ]]; then
                    match=false
                fi
            fi
            
            # キーワード検索
            if [[ -n "$search_term" ]] && $match; then
                if ! grep -qi "$search_term" "$metadata_file" 2>/dev/null && \
                   ! grep -qi "$search_term" "$instruction_file" 2>/dev/null; then
                    match=false
                fi
            fi
            
            # マッチした場合の出力
            if $match; then
                ((matches++))
                output_result "$metadata_file" "$instruction_file" "$content" "$format"
            fi
        fi
    done < <(find "$INSTRUCTIONS_DIR" -name "*$METADATA_EXT" -type f | sort)
    
    # 結果サマリー
    if [[ $matches -eq 0 ]]; then
        MSG_NO_RESULTS=$(get_message "no_results" "No search results found." "検索結果が見つかりませんでした。")
        echo -e "${YELLOW}$MSG_NO_RESULTS${NC}"
    else
        MSG_SEARCH_RESULTS=$(get_message "search_results" "Search results" "検索結果")
        MSG_ITEMS=$(get_message "items" "items" "件")
        echo -e "\n${GREEN}$MSG_SEARCH_RESULTS: $matches$MSG_ITEMS${NC}"
    fi
}

# 結果を出力
output_result() {
    local metadata_file="$1"
    local instruction_file="$2"
    local content="$3"
    local format="$4"
    
    local title=$(get_yaml_value "$content" "title")
    local category=$(get_yaml_value "$content" "category")
    local language=$(get_yaml_value "$content" "language")
    local description=$(get_yaml_value "$content" "description")
    local tags=$(get_yaml_tags "$content" | tr '\n' ', ' | sed 's/, $//')
    
    case "$format" in
        "detail")
            MSG_TITLE=$(get_message "title" "Title" "タイトル")
            MSG_PATH=$(get_message "path" "Path" "パス")
            MSG_CATEGORY=$(get_message "category" "Category" "カテゴリ")
            MSG_LANGUAGE=$(get_message "language" "Language" "言語")
            MSG_DESCRIPTION=$(get_message "description" "Description" "説明")
            MSG_TAGS=$(get_message "tags" "Tags" "タグ")
            
            echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
            echo -e "${GREEN}$MSG_TITLE:${NC} $title"
            echo -e "${GREEN}$MSG_PATH:${NC} $instruction_file"
            echo -e "${GREEN}$MSG_CATEGORY:${NC} $category"
            echo -e "${GREEN}$MSG_LANGUAGE:${NC} $language"
            echo -e "${GREEN}$MSG_DESCRIPTION:${NC} $description"
            echo -e "${GREEN}$MSG_TAGS:${NC} $tags"
            ;;
        "path")
            echo "$instruction_file"
            ;;
        *)  # list
            echo -e "${BLUE}[$category]${NC} ${YELLOW}$title${NC} - $instruction_file"
            ;;
    esac
}

# メイン処理
main() {
    local search_term=""
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
            -*)
                MSG_ERROR_UNKNOWN_OPTION=$(get_message "error_unknown_option" "Unknown option" "不明なオプション")
                echo "$MSG_ERROR_UNKNOWN_OPTION: $1" >&2
                show_help
                exit 1
                ;;
            *)
                search_term="$1"
                shift
                ;;
        esac
    done
    
    # 検索実行
    search_metadata "$search_term" "$category_filter" "$language_filter" "$tag_filter" "$author_filter" "$format"
}

# スクリプトが直接実行された場合のみmainを実行
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi