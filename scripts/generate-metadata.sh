#!/bin/bash

# AI指示書メタデータ生成スクリプト
# 各指示書ファイルから.yamlファイルを生成し、分散型メタデータシステムを構築

set -e

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
    echo "使用法: $0 [INSTRUCTIONS_DIR]"
    echo ""
    echo "各指示書ファイルから分散型メタデータファイル(.yaml)を生成します。"
    echo ""
    echo "引数:"
    echo "  INSTRUCTIONS_DIR  指示書ディレクトリ (デフォルト: instructions)"
    echo ""
    echo "例:"
    echo "  $0                    # instructionsディレクトリを処理"
    echo "  $0 /path/to/custom    # カスタムディレクトリを処理"
}

# メタデータ抽出関数
extract_metadata() {
    local file="$1"
    local basename_no_ext="${file%.md}"
    local meta_file="${basename_no_ext}.yaml"
    
    # ファイルの基本情報
    local filename=$(basename "$file")
    local relative_path="${file#$INSTRUCTIONS_DIR/}"
    local language=$(echo "$relative_path" | cut -d'/' -f1)
    local category=$(echo "$relative_path" | cut -d'/' -f2)
    local title=$(head -n 1 "$file" | sed 's/^# *//')
    
    # IDを生成（category_filename形式）
    local id="${category}_${filename%.md}"
    
    # 既存のメタデータを抽出（末尾のライセンス情報セクション）
    local license="Apache-2.0"
    local reference=""
    local author="dobachi"
    local created_date="$(date +"%Y-%m-%d")"
    
    # ライセンス情報セクションを解析
    if grep -q "^## ライセンス情報" "$file"; then
        local meta_section=$(sed -n '/^## ライセンス情報/,$ p' "$file")
        license=$(echo "$meta_section" | grep -oP '(?<=ライセンス\]: ).*' | head -1 || echo "Apache-2.0")
        reference=$(echo "$meta_section" | grep -oP '(?<=参照元\]: ).*' | head -1 || echo "")
        author=$(echo "$meta_section" | grep -oP '(?<=原著者\]: ).*' | head -1 || echo "dobachi")
        created_date=$(echo "$meta_section" | grep -oP '(?<=作成日\]: ).*' | head -1 || echo "$(date +"%Y-%m-%d")")
    fi
    
    # 説明文を抽出（最初の段落）
    local description=$(sed -n '3,/^$/p' "$file" | tr '\n' ' ' | sed 's/  */ /g' | sed 's/^ *//;s/ *$//')
    
    # タグを自動生成（カテゴリ、言語、特定のキーワードから）
    local tags=""
    [[ "$title" =~ "Marp" ]] && tags="  - \"marp\""
    [[ "$title" =~ "Python" ]] && tags="${tags}\n  - \"python\""
    [[ "$title" =~ "エージェント" || "$title" =~ "専門家" ]] && tags="${tags}\n  - \"agent\""
    [[ "$title" =~ "API" ]] && tags="${tags}\n  - \"api\""
    [[ "$title" =~ "Web" ]] && tags="${tags}\n  - \"web\""
    
    # ファイル情報
    local file_size=$(stat -c%s "$file" 2>/dev/null || stat -f%z "$file" 2>/dev/null || echo "0")
    local last_modified=$(date -r "$file" +"%Y-%m-%dT%H:%M:%S%z" 2>/dev/null || date +"%Y-%m-%dT%H:%M:%S%z")
    local checksum=$(md5sum "$file" 2>/dev/null | cut -d' ' -f1 || md5 -q "$file" 2>/dev/null || echo "")
    
    # メタデータファイルを生成
    cat > "$meta_file" << EOF
# ${filename} メタデータ
id: "${id}"
name: "${title}"
description: "${description}"
version: "1.0.0"
category: "${category}"
language: "${language}"
tags:
  - "${category}"
  - "${language}"${tags}

# ファイル情報
file:
  name: "${filename}"
  path: "${relative_path}"
  size: ${file_size}
  checksum: "${checksum}"
  last_modified: "${last_modified}"

# メタ情報
metadata:
  author: "${author}"
  created: "${created_date}"
  updated: "$(date +"%Y-%m-%d")"
  license: "${license}"
  reference: "${reference}"

# 将来の拡張用
dependencies: []
compatible_modules: []
variables: {}
EOF

    echo -e "${GREEN}✓${NC} メタデータ生成: ${meta_file}"
}

# メイン処理
main() {
    if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
        show_help
        exit 0
    fi
    
    if [[ ! -d "$INSTRUCTIONS_DIR" ]]; then
        echo -e "${RED}エラー: ディレクトリが見つかりません: $INSTRUCTIONS_DIR${NC}"
        exit 1
    fi
    
    echo -e "${YELLOW}=== AI指示書メタデータ生成開始 ===${NC}"
    echo "対象ディレクトリ: $INSTRUCTIONS_DIR"
    echo ""
    
    local count=0
    local error_count=0
    
    # すべての.mdファイルを処理
    while IFS= read -r -d '' file; do
        if [[ -f "$file" ]] && [[ "$file" == *.md ]]; then
            if extract_metadata "$file"; then
                ((count++))
            else
                ((error_count++))
                echo -e "${RED}✗${NC} エラー: $file"
            fi
        fi
    done < <(find "$INSTRUCTIONS_DIR" -name "*.md" -print0)
    
    echo ""
    echo -e "${GREEN}=== 完了 ===${NC}"
    echo "生成されたメタデータファイル: $count"
    [[ $error_count -gt 0 ]] && echo -e "${RED}エラー: $error_count${NC}"
    
    # インデックスファイルの生成を提案
    echo ""
    echo -e "${YELLOW}ヒント:${NC} カタログ検索を有効にするには、次のコマンドを実行してください:"
    echo "  $0 --index"
}

# スクリプト実行
main "$@"