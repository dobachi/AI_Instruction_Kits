#!/bin/bash
# モジュールファイルの命名規則を安全に修正するスクリプト

set -e

# カラー定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# 引数処理
DRY_RUN=true
if [ "$1" = "--execute" ]; then
    DRY_RUN=false
fi

MODULES_DIR="modular/ja/modules"
BACKUP_DIR="modular/ja/modules_backup_$(date +%Y%m%d_%H%M%S)"
LOG_FILE="naming_fix_safe_log.txt"

echo "=== モジュールファイル命名規則修正スクリプト（安全版） ==="
echo ""

if [ "$DRY_RUN" = true ]; then
    echo -e "${YELLOW}ドライランモード: 実際の変更は行いません${NC}"
    echo "実行するには: $0 --execute"
else
    echo -e "${RED}実行モード: ファイルが変更されます${NC}"
    # バックアップディレクトリを作成
    echo -e "${BLUE}バックアップを作成中: $BACKUP_DIR${NC}"
    mkdir -p "$BACKUP_DIR"
    cp -r "$MODULES_DIR"/* "$BACKUP_DIR/"
fi

echo ""
echo "開始時刻: $(date)" | tee "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

# Phase 1: 明確に不要なファイルの削除
echo "=== Phase 1: 不要なファイルの削除 ===" | tee -a "$LOG_FILE"

# 1.1 _detailed_concise.md ファイルの削除
echo "--- _detailed_concise.md ファイル ---" | tee -a "$LOG_FILE"
find "$MODULES_DIR" -name "*_detailed_concise.md" | while read file; do
    echo -e "${RED}削除対象${NC}: $file" | tee -a "$LOG_FILE"
    if [ "$DRY_RUN" = false ]; then
        rm "$file"
        echo "  削除完了" | tee -a "$LOG_FILE"
    fi
done

# 1.2 完全に重複しているファイルの削除
echo "" | tee -a "$LOG_FILE"
echo "--- 完全重複ファイル ---" | tee -a "$LOG_FILE"
KNOWN_DUPLICATES=(
    "expertise/parallel_distributed"
    "expertise/machine_learning"
    "expertise/software_engineering"
)

for base in "${KNOWN_DUPLICATES[@]}"; do
    file1="$MODULES_DIR/${base}.md"
    file2="$MODULES_DIR/${base}_concise.md"
    
    if [ -f "$file1" ] && [ -f "$file2" ]; then
        if cmp -s "$file1" "$file2"; then
            echo -e "${YELLOW}重複確認${NC}: $file1 = $file2" | tee -a "$LOG_FILE"
            echo -e "  ${RED}削除${NC}: $file2" | tee -a "$LOG_FILE"
            if [ "$DRY_RUN" = false ]; then
                rm "$file2"
                echo "  削除完了" | tee -a "$LOG_FILE"
            fi
        fi
    fi
done

# Phase 2: 安全な移動（対応するファイルが存在しない場合のみ）
echo "" | tee -a "$LOG_FILE"
echo "=== Phase 2: 安全な_concise.mdファイルの移動 ===" | tee -a "$LOG_FILE"

find "$MODULES_DIR" -name "*_concise.md" | sort | while read concise_file; do
    base_name=$(basename "$concise_file" "_concise.md")
    dir_name=$(dirname "$concise_file")
    standard_file="$dir_name/${base_name}.md"
    
    if [ ! -f "$standard_file" ]; then
        echo -e "${GREEN}安全な移動${NC}: $concise_file -> $standard_file" | tee -a "$LOG_FILE"
        if [ "$DRY_RUN" = false ]; then
            mv "$concise_file" "$standard_file"
            echo "  移動完了" | tee -a "$LOG_FILE"
        fi
    fi
done

# Phase 3: 要確認ファイルのリスト
echo "" | tee -a "$LOG_FILE"
echo "=== Phase 3: 手動確認が必要なファイル ===" | tee -a "$LOG_FILE"

echo "--- サイズが逆転しているファイル ---" | tee -a "$LOG_FILE"
REVERSED_FILES=(
    "skills/error_handling"
    "tasks/code_generation"
)

for base in "${REVERSED_FILES[@]}"; do
    file1="$MODULES_DIR/${base}.md"
    file2="$MODULES_DIR/${base}_concise.md"
    
    if [ -f "$file1" ] && [ -f "$file2" ]; then
        size1=$(stat -f%z "$file1" 2>/dev/null || stat -c%s "$file1" 2>/dev/null)
        size2=$(stat -f%z "$file2" 2>/dev/null || stat -c%s "$file2" 2>/dev/null)
        
        echo -e "${YELLOW}要確認${NC}: $base" | tee -a "$LOG_FILE"
        echo "  $file1: $size1 bytes" | tee -a "$LOG_FILE"
        echo "  $file2: $size2 bytes (_concise.mdの方が大きい！)" | tee -a "$LOG_FILE"
    fi
done

# Phase 4: 残存する_concise.mdファイルのリスト
echo "" | tee -a "$LOG_FILE"
echo "--- まだ残っている_concise.mdファイル ---" | tee -a "$LOG_FILE"
find "$MODULES_DIR" -name "*_concise.md" | sort | while read file; do
    echo -e "${BLUE}残存${NC}: $file" | tee -a "$LOG_FILE"
done

# Phase 5: 統計情報
echo "" | tee -a "$LOG_FILE"
echo "=== 統計情報 ===" | tee -a "$LOG_FILE"

total_modules=$(find "$MODULES_DIR" -name "*.md" | wc -l)
concise_files=$(find "$MODULES_DIR" -name "*_concise.md" | wc -l)
detailed_files=$(find "$MODULES_DIR" -name "*_detailed.md" | wc -l)
standard_files=$(find "$MODULES_DIR" -name "*.md" -not -name "*_concise.md" -not -name "*_detailed.md" | wc -l)

echo "総モジュール数: $total_modules" | tee -a "$LOG_FILE"
echo "  標準ファイル(.md): $standard_files" | tee -a "$LOG_FILE"
echo "  簡潔版(_concise.md): $concise_files" | tee -a "$LOG_FILE"
echo "  詳細版(_detailed.md): $detailed_files" | tee -a "$LOG_FILE"

echo "" | tee -a "$LOG_FILE"
echo "=== 完了 ===" | tee -a "$LOG_FILE"
echo "終了時刻: $(date)" | tee -a "$LOG_FILE"

if [ "$DRY_RUN" = true ]; then
    echo ""
    echo -e "${YELLOW}これはドライランでした。実際に実行するには:${NC}"
    echo "$0 --execute"
    echo ""
    echo -e "${BLUE}推奨事項:${NC}"
    echo "1. 上記の結果を確認してください"
    echo "2. 特に「要確認」のファイルは手動で内容を確認してください"
    echo "3. 問題なければ --execute オプションで実行してください"
fi

if [ "$DRY_RUN" = false ]; then
    echo ""
    echo -e "${GREEN}バックアップ場所: $BACKUP_DIR${NC}"
    echo "問題があった場合は、上記のバックアップから復元できます"
fi