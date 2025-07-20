#!/bin/bash

# モジュールメタデータ検証スクリプト
# 用途: モジュールのYAMLメタデータファイルの妥当性を検証

set -e

# スクリプトのディレクトリを取得
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# 国際対応ライブラリを読み込む
source "$SCRIPT_DIR/lib/i18n.sh"
source "$SCRIPT_DIR/lib/i18n_messages.sh"

# カラー定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# カウンター初期化
TOTAL_FILES=0
VALID_FILES=0
ERROR_FILES=0
WARNING_FILES=0

# モジュールディレクトリ
MODULE_DIR="$PROJECT_ROOT/modular"

# Pythonスクリプトの存在確認
PYTHON_VALIDATOR="$SCRIPT_DIR/validate_module_yaml.py"
if [ ! -f "$PYTHON_VALIDATOR" ]; then
    echo -e "${RED}$(get_message "error_validation_script_not_found" "Error: Validation script $PYTHON_VALIDATOR not found" "エラー: 検証スクリプト $PYTHON_VALIDATOR が見つかりません")${NC}"
    exit 1
fi

echo "🔍 $(get_message "start_validation" "Starting module metadata validation..." "モジュールメタデータ検証を開始します...")"
echo "$(get_message "validation_target" "Target:" "検証対象:") $MODULE_DIR"
echo ""

# 結果を保存する配列
declare -a ERROR_LIST
declare -a WARNING_LIST

# 各言語のモジュールをチェック
for lang in ja en; do
    echo "📂 $(get_message "language" "Language:" "言語:") $lang"
    
    # 各カテゴリをチェック
    for category in core tasks skills methods domains roles quality expertise; do
        category_dir="$MODULE_DIR/$lang/modules/$category"
        
        if [ ! -d "$category_dir" ]; then
            continue
        fi
        
        # カテゴリ内にファイルがあるか確認
        yaml_count=$(find "$category_dir" -name "*.yaml" 2>/dev/null | wc -l)
        if [ "$yaml_count" -eq 0 ]; then
            continue
        fi
        
        echo "  📁 $(get_message "category" "Category:" "カテゴリ:") $category"
        
        # YAMLファイルを検索
        for yaml_file in "$category_dir"/*.yaml; do
            if [ ! -f "$yaml_file" ]; then
                continue
            fi
            
            TOTAL_FILES=$((TOTAL_FILES + 1))
            filename=$(basename "$yaml_file")
            
            # Python検証スクリプトを実行
            validation_result=$(python3 "$PYTHON_VALIDATOR" "$yaml_file" "$category" 2>&1) || true
            
            # 結果をJSONとして解析
            status=$(echo "$validation_result" | python3 -c "import json, sys; data = json.load(sys.stdin); print(data.get('status', 'ERROR'))" 2>/dev/null || echo "ERROR")
            
            if [ "$status" = "ERROR" ]; then
                echo -e "    ${RED}✗${NC} $filename"
                # エラー詳細を表示
                errors=$(echo "$validation_result" | python3 -c "
import json, sys
try:
    data = json.load(sys.stdin)
    for error in data.get('errors', []):
        print(f'      - {error}')
except:
    print('      - JSONパースエラー')
" 2>&1)
                echo "$errors"
                ERROR_FILES=$((ERROR_FILES + 1))
                ERROR_LIST+=("$lang/$category/$filename")
                
            elif [ "$status" = "WARNING" ]; then
                echo -e "    ${YELLOW}⚠${NC}  $filename"
                # 警告詳細を表示
                warnings=$(echo "$validation_result" | python3 -c "
import json, sys
try:
    data = json.load(sys.stdin)
    for warning in data.get('warnings', []):
        print(f'      - {warning}')
except:
    print('      - JSONパースエラー')
" 2>&1)
                echo "$warnings"
                WARNING_FILES=$((WARNING_FILES + 1))
                WARNING_LIST+=("$lang/$category/$filename")
                
            else
                echo -e "    ${GREEN}✓${NC} $filename"
                VALID_FILES=$((VALID_FILES + 1))
            fi
        done
    done
    echo ""
done

# サマリー表示
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 $(get_message "validation_summary" "Validation Summary" "検証結果サマリー")"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "$(get_message "total_files" "Total files:" "総ファイル数:") $TOTAL_FILES"
echo -e "${GREEN}✓ $(get_message "valid" "Valid" "正常")${NC}: $VALID_FILES"
echo -e "${YELLOW}⚠ $(get_message "warning" "Warning" "警告")${NC}: $WARNING_FILES"
echo -e "${RED}✗ $(get_message "error" "Error" "エラー")${NC}: $ERROR_FILES"
echo ""

# エラーファイルリスト表示
if [ ${#ERROR_LIST[@]} -gt 0 ]; then
    echo -e "${RED}$(get_message "files_with_errors" "Files with errors:" "エラーのあるファイル:")${NC}"
    for file in "${ERROR_LIST[@]}"; do
        echo "  - $file"
    done
    echo ""
fi

# 警告ファイルリスト表示
if [ ${#WARNING_LIST[@]} -gt 0 ]; then
    echo -e "${YELLOW}$(get_message "files_with_warnings" "Files with warnings:" "警告のあるファイル:")${NC}"
    for file in "${WARNING_LIST[@]}"; do
        echo "  - $file"
    done
    echo ""
fi

# 終了コード決定
if [ $ERROR_FILES -gt 0 ]; then
    echo -e "${RED}❌ $(get_message "errors_found" "Errors found. Fixes required." "エラーが見つかりました。修正が必要です。")${NC}"
    exit 1
elif [ $WARNING_FILES -gt 0 ]; then
    echo -e "${YELLOW}⚠️  $(get_message "warnings_found" "Warnings found. Review recommended." "警告が見つかりました。確認を推奨します。")${NC}"
    exit 0
else
    echo -e "${GREEN}✅ $(get_message "all_passed" "All modules passed validation!" "すべてのモジュールが検証に合格しました！")${NC}"
    exit 0
fi