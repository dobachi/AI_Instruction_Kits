#!/bin/bash

# AI指示書メタデータ生成スクリプト / AI Instruction Metadata Generation Script
# 各指示書ファイルから.yamlファイルを生成し、分散型メタデータシステムを構築
# Generate .yaml files from each instruction file to build a distributed metadata system

# i18nライブラリをソース
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/i18n.sh"

# set -e

# 色の定義
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 設定
INSTRUCTIONS_DIR="${1:-instructions}"
METADATA_EXT=".yaml"

# ヘルプ表示
show_help() {
    MSG_USAGE=$(get_message "usage" "Usage" "使用法")
    MSG_GENERATE_DESC=$(get_message "generate_desc" "Generate distributed metadata files (.yaml) from each instruction file" "各指示書ファイルから分散型メタデータファイル(.yaml)を生成します")
    MSG_ARGUMENTS=$(get_message "arguments" "Arguments" "引数")
    MSG_INSTRUCTIONS_DIR=$(get_message "instructions_dir" "Instructions directory (default: instructions)" "指示書ディレクトリ (デフォルト: instructions)")
    MSG_EXAMPLES=$(get_message "examples" "Examples" "例")
    MSG_PROCESS_DEFAULT=$(get_message "process_default" "Process instructions directory" "instructionsディレクトリを処理")
    MSG_PROCESS_CUSTOM=$(get_message "process_custom" "Process custom directory" "カスタムディレクトリを処理")
    
    echo "$MSG_USAGE: $0 [INSTRUCTIONS_DIR]"
    echo ""
    echo "$MSG_GENERATE_DESC."
    echo ""
    echo "$MSG_ARGUMENTS:"
    echo "  INSTRUCTIONS_DIR  $MSG_INSTRUCTIONS_DIR"
    echo ""
    echo "$MSG_EXAMPLES:"
    echo "  $0                    # $MSG_PROCESS_DEFAULT"
    echo "  $0 /path/to/custom    # $MSG_PROCESS_CUSTOM"
}

# メタデータ抽出関数
extract_metadata() {
    local file="$1"
    local basename_no_ext="${file%.md}"
    local meta_file="${basename_no_ext}.yaml"
    
    # ファイルの基本情報
    local filename=$(basename "$file")
    local relative_path="${file#$INSTRUCTIONS_DIR/}"
    # パスがinstructions/から始まる場合の対応
    relative_path="${relative_path#instructions/}"
    local language=$(echo "$relative_path" | cut -d'/' -f1)
    local category=$(echo "$relative_path" | cut -d'/' -f2)
    local title=$(head -n 1 "$file" | sed 's/^# *//')
    
    # IDを生成（category_filename形式）
    local id="${language}_${category}_${filename%.md}"
    
    # 既存のメタデータを抽出（末尾のライセンス情報セクション）
    local license_info=$(awk '/^---$/{p=1} p' "$file" | tail -n +2)
    local license=""
    local reference=""
    local author=""
    local created_date=""
    
    if [[ -n "$license_info" ]]; then
        license=$(echo "$license_info" | grep -E "^- \*\*ライセンス\*\*:|^- \*\*License\*\*:" | sed 's/.*: *//')
        reference=$(echo "$license_info" | grep -E "^- \*\*参照元\*\*:|^- \*\*Reference\*\*:" | sed 's/.*: *//')
        author=$(echo "$license_info" | grep -E "^- \*\*原著者\*\*:|^- \*\*Author\*\*:" | sed 's/.*: *//')
        created_date=$(echo "$license_info" | grep -E "^- \*\*作成日\*\*:|^- \*\*Created\*\*:" | sed 's/.*: *//')
    fi
    
    # デフォルト値
    license="${license:-Apache-2.0}"
    author="${author:-AI Instruction Kits Project}"
    created_date="${created_date:-$(date +%Y-%m-%d)}"
    
    # 説明文を最初の段落から抽出
    local description=$(awk '/^#[^#]/ {p=1; next} /^$/ {if(p) exit} p' "$file" | head -5 | tr '\n' ' ' | sed 's/  */ /g' | sed 's/^ *//;s/ *$//')
    if [[ -z "$description" ]]; then
        description="AI指示書: $title"
    fi
    
    # タグを生成（ファイル名とカテゴリから）
    local tags=""
    case "$category" in
        "coding")
            tags="  - programming\n  - development"
            ;;
        "writing")
            tags="  - documentation\n  - content"
            ;;
        "agent")
            tags="  - agent\n  - specialist"
            ;;
        "presentation")
            tags="  - presentation\n  - slides"
            ;;
        *)
            tags="  - $category"
            ;;
    esac
    
    # タイトルからも追加のタグを生成
    if [[ "$title" =~ "Marp" ]]; then
        tags="$tags\n  - marp"
    fi
    if [[ "$title" =~ "Python" ]]; then
        tags="$tags\n  - python"
    fi
    
    # YAMLファイルを生成
    cat > "$meta_file" << EOF
# Metadata for $filename
id: "$id"
title: "$title"
description: "$description"
category: "$category"
language: "$language"
tags:
$(echo -e "$tags")
author: "$author"
license: "$license"
created: "$created_date"
updated: "$(date +%Y-%m-%d)"
version: "1.0.0"
EOF
    
    return 0
}

# メイン処理
main() {
    # 引数処理
    if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
        show_help
        exit 0
    fi
    
    MSG_METADATA_GEN_START=$(get_message "metadata_gen_start" "Starting metadata generation" "メタデータ生成開始")
    echo -e "${GREEN}$MSG_METADATA_GEN_START${NC}"
    echo "Directory: $INSTRUCTIONS_DIR"
    
    # ディレクトリ存在確認
    if [[ ! -d "$INSTRUCTIONS_DIR" ]]; then
        MSG_ERROR_DIR_NOT_FOUND=$(get_message "error_dir_not_found" "Error: Directory not found" "エラー: ディレクトリが見つかりません")
        echo -e "${RED}$MSG_ERROR_DIR_NOT_FOUND: $INSTRUCTIONS_DIR${NC}"
        exit 1
    fi
    
    # 進捗表示用
    local total_files=$(find "$INSTRUCTIONS_DIR" -name "*.md" -type f | wc -l)
    local processed=0
    local generated=0
    local skipped=0
    
    MSG_PROCESSING=$(get_message "processing" "Processing" "処理中")
    MSG_GENERATED=$(get_message "generated" "Generated" "生成")
    MSG_SKIPPED=$(get_message "skipped" "Skipped" "スキップ")
    MSG_COMPLETED=$(get_message "completed" "Completed" "完了")
    
    # 各.mdファイルを処理
    while IFS= read -r file; do
        ((processed++))
        echo -n -e "\r$MSG_PROCESSING: $processed/$total_files"
        
        # メタデータファイルのパス
        local meta_file="${file%.md}.yaml"
        
        # 既存のメタデータファイルがある場合はスキップ
        if [[ -f "$meta_file" ]]; then
            ((skipped++))
            continue
        fi
        
        # メタデータを抽出・生成
        if extract_metadata "$file"; then
            ((generated++))
        fi
    done < <(find "$INSTRUCTIONS_DIR" -name "*.md" -type f)
    
    # 最終結果
    echo -e "\r${GREEN}$MSG_COMPLETED!${NC}"
    echo "----------------------------------------"
    MSG_TOTAL_FILES=$(get_message "total_files" "Total files" "総ファイル数")
    MSG_GENERATED_COUNT=$(get_message "generated_count" "Generated" "生成済み")
    MSG_SKIPPED_COUNT=$(get_message "skipped_count" "Skipped (already exists)" "スキップ (既存)")
    
    echo "$MSG_TOTAL_FILES: $total_files"
    echo -e "${GREEN}$MSG_GENERATED_COUNT: $generated${NC}"
    echo -e "${YELLOW}$MSG_SKIPPED_COUNT: $skipped${NC}"
    
    MSG_NEXT_STEP=$(get_message "next_step" "You can now search using" "次のコマンドで検索できます")
    echo -e "\n$MSG_NEXT_STEP: ./scripts/search-instructions.sh"
}

# スクリプトが直接実行された場合のみmainを実行
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi