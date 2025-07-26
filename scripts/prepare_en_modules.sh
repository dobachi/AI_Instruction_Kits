#!/bin/bash
# 英語版モジュールの準備スクリプト（バックアップとリネーム）

set -euo pipefail

# カラー設定
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 基本設定
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
EN_MODULES_DIR="$PROJECT_ROOT/modular/en/modules"
BACKUP_DIR="$PROJECT_ROOT/modular/en_backup_$(date +%Y%m%d_%H%M%S)"
LOG_FILE="$PROJECT_ROOT/docs/development/en_module_preparation_log.txt"

# ログ関数
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Phase 1: バックアップ作成
create_backup() {
    log "Phase 1: バックアップ作成開始"
    
    if [ -d "$EN_MODULES_DIR" ]; then
        mkdir -p "$BACKUP_DIR"
        cp -r "$EN_MODULES_DIR" "$BACKUP_DIR/"
        log "バックアップ作成完了: $BACKUP_DIR"
    else
        echo -e "${RED}エラー: 英語版モジュールディレクトリが見つかりません: $EN_MODULES_DIR${NC}"
        exit 1
    fi
}

# Phase 2: 現在のファイルを_detailed.mdにリネーム
rename_to_detailed() {
    log "Phase 2: 既存ファイルの_detailed.mdへのリネーム開始"
    
    local count=0
    local files=()
    
    # リネーム対象ファイルをリストアップ
    while IFS= read -r -d '' file; do
        dir=$(dirname "$file")
        base=$(basename "$file" .md)
        
        # すでに_detailed.mdや_concise.mdの場合はスキップ
        if [[ "$base" == *"_detailed" ]] || [[ "$base" == *"_concise" ]]; then
            continue
        fi
        
        files+=("$file")
    done < <(find "$EN_MODULES_DIR" -name "*.md" -type f -print0)
    
    # 確認表示
    echo -e "\n${YELLOW}リネーム対象ファイル数: ${#files[@]}${NC}"
    
    # リネーム実行
    for file in "${files[@]}"; do
        dir=$(dirname "$file")
        base=$(basename "$file" .md)
        new_name="${dir}/${base}_detailed.md"
        
        mv "$file" "$new_name"
        ((count++))
        log "リネーム: $(basename "$file") → $(basename "$new_name")"
    done
    
    log "Phase 2完了: ${count}ファイルをリネーム"
}

# Phase 3: 検証
verify_results() {
    log "Phase 3: 検証開始"
    
    echo -e "\n${BLUE}=== リネーム結果 ===${NC}"
    echo "詳細版(_detailed.md): $(find "$EN_MODULES_DIR" -name "*_detailed.md" | wc -l)"
    echo "標準版(.md): $(find "$EN_MODULES_DIR" -name "*.md" -not -name "*_detailed.md" -not -name "*_concise.md" | wc -l)"
    echo "YAMLファイル: $(find "$EN_MODULES_DIR" -name "*.yaml" | wc -l)"
    
    log "検証完了"
}

# メイン処理
main() {
    echo -e "${GREEN}=== 英語版モジュール準備開始 ===${NC}"
    
    # ログファイルの初期化
    mkdir -p "$(dirname "$LOG_FILE")"
    echo "=== 英語版モジュール準備ログ ===" > "$LOG_FILE"
    log "スクリプト開始"
    
    # 現在の状態を表示
    echo -e "\n${BLUE}現在の状態:${NC}"
    echo "総MDファイル数: $(find "$EN_MODULES_DIR" -name "*.md" | wc -l)"
    echo "YAMLファイル数: $(find "$EN_MODULES_DIR" -name "*.yaml" | wc -l)"
    
    # Phase 1: バックアップ
    create_backup
    
    # Phase 2: リネーム
    rename_to_detailed
    
    # Phase 3: 検証
    verify_results
    
    echo -e "\n${GREEN}準備完了！${NC}"
    echo -e "${YELLOW}次のステップ:${NC}"
    echo "1. 各_detailed.mdファイルから簡潔版(.md)を作成"
    echo "2. modular/DEVELOPMENT.mdのPhase 4.5ガイドラインに従う"
    echo ""
    echo "バックアップ場所: $BACKUP_DIR"
    
    log "スクリプト完了"
}

# 実行確認
echo -e "${YELLOW}このスクリプトは英語版モジュールを準備します:${NC}"
echo "1. バックアップを作成"
echo "2. 現在の.mdファイルを_detailed.mdにリネーム"
echo ""
read -p "続行しますか？ (y/N): " confirm

if [[ "$confirm" =~ ^[Yy]$ ]]; then
    main
else
    echo "キャンセルしました"
    exit 0
fi