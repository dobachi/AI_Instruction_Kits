#!/bin/bash
# モジュールファイルの命名規則を修正するスクリプト

set -e

# カラー定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# 引数処理
DRY_RUN=true
if [ "$1" = "--execute" ]; then
    DRY_RUN=false
fi

MODULES_DIR="modular/ja/modules"
LOG_FILE="naming_fix_log.txt"

echo "=== モジュールファイル命名規則修正スクリプト ==="
echo ""

if [ "$DRY_RUN" = true ]; then
    echo -e "${YELLOW}ドライランモード: 実際の変更は行いません${NC}"
    echo "実行するには: $0 --execute"
else
    echo -e "${RED}実行モード: ファイルが変更されます${NC}"
fi

echo ""
echo "開始時刻: $(date)" | tee "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

# 1. _detailed_concise.md ファイルの削除
echo "=== Step 1: _detailed_concise.md ファイルの削除 ===" | tee -a "$LOG_FILE"
find "$MODULES_DIR" -name "*_detailed_concise.md" | while read file; do
    echo -e "${RED}削除対象${NC}: $file" | tee -a "$LOG_FILE"
    if [ "$DRY_RUN" = false ]; then
        rm "$file"
    fi
done

# 2. 重複ファイルの処理
echo "" | tee -a "$LOG_FILE"
echo "=== Step 2: 重複ファイルの確認と処理 ===" | tee -a "$LOG_FILE"

# 既知の重複ファイル
DUPLICATES=(
    "expertise/parallel_distributed"
    "expertise/machine_learning"
    "expertise/software_engineering"
)

for base in "${DUPLICATES[@]}"; do
    file1="$MODULES_DIR/${base}.md"
    file2="$MODULES_DIR/${base}_concise.md"
    
    if [ -f "$file1" ] && [ -f "$file2" ]; then
        if cmp -s "$file1" "$file2"; then
            echo -e "${YELLOW}重複発見${NC}: $file1 と $file2" | tee -a "$LOG_FILE"
            # ヘッダーを確認して簡潔版を特定
            if head -n 5 "$file1" | grep -q "簡潔版"; then
                echo "  -> $file1 は簡潔版の内容" | tee -a "$LOG_FILE"
                echo "  -> $file2 を削除" | tee -a "$LOG_FILE"
                if [ "$DRY_RUN" = false ]; then
                    rm "$file2"
                fi
            fi
        fi
    fi
done

# 3. _concise.md ファイルの処理
echo "" | tee -a "$LOG_FILE"
echo "=== Step 3: _concise.md ファイルの移行 ===" | tee -a "$LOG_FILE"

find "$MODULES_DIR" -name "*_concise.md" | while read concise_file; do
    base_name=$(basename "$concise_file" "_concise.md")
    dir_name=$(dirname "$concise_file")
    standard_file="$dir_name/${base_name}.md"
    
    echo "処理中: $concise_file" | tee -a "$LOG_FILE"
    
    if [ ! -f "$standard_file" ]; then
        # 標準ファイルが存在しない場合
        echo -e "  ${GREEN}移動${NC}: $concise_file -> $standard_file" | tee -a "$LOG_FILE"
        if [ "$DRY_RUN" = false ]; then
            mv "$concise_file" "$standard_file"
        fi
    else
        # 標準ファイルが存在する場合
        echo -e "  ${YELLOW}確認必要${NC}: $standard_file が既に存在" | tee -a "$LOG_FILE"
        # ファイルサイズで判断
        size_standard=$(stat -f%z "$standard_file" 2>/dev/null || stat -c%s "$standard_file" 2>/dev/null)
        size_concise=$(stat -f%z "$concise_file" 2>/dev/null || stat -c%s "$concise_file" 2>/dev/null)
        
        if [ "$size_concise" -lt "$size_standard" ]; then
            echo "    -> _concise.md の方が小さい（正常）" | tee -a "$LOG_FILE"
        else
            echo -e "    ${RED}警告${NC}: _concise.md の方が大きい！" | tee -a "$LOG_FILE"
        fi
    fi
done

# 4. ヘッダーとファイル名の不一致を検出
echo "" | tee -a "$LOG_FILE"
echo "=== Step 4: ヘッダーとファイル名の不一致検出 ===" | tee -a "$LOG_FILE"

find "$MODULES_DIR" -name "*.md" -not -name "*_detailed.md" -not -name "*_concise.md" | while read file; do
    if head -n 5 "$file" | grep -q "簡潔版"; then
        echo -e "${YELLOW}不一致${NC}: $file のヘッダーは「簡潔版」" | tee -a "$LOG_FILE"
        # これは正常（.mdファイルは簡潔版であるべき）
    fi
done

echo "" | tee -a "$LOG_FILE"
echo "=== 完了 ===" | tee -a "$LOG_FILE"
echo "終了時刻: $(date)" | tee -a "$LOG_FILE"

if [ "$DRY_RUN" = true ]; then
    echo ""
    echo -e "${YELLOW}これはドライランでした。実際に実行するには:${NC}"
    echo "$0 --execute"
fi