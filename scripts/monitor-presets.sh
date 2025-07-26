#!/bin/bash

# プリセット使用状況監視スクリプト
# 
# 使用方法:
#   ./scripts/monitor-presets.sh [report|check|stats]
#
# コマンド:
#   report - 詳細レポートを生成
#   check  - プリセットの整合性チェック
#   stats  - 使用統計の表示

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PRESET_DIR="$PROJECT_ROOT/instructions"
REPORT_DIR="$PROJECT_ROOT/reports/presets"
LOG_FILE="$REPORT_DIR/logs/monitor.log"

# レポートディレクトリの確認と作成
mkdir -p "$REPORT_DIR/logs" "$REPORT_DIR/monitoring/daily" "$REPORT_DIR/monitoring/weekly" "$REPORT_DIR/monitoring/monthly"

# カラー定義
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ログ記録
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

# プリセットの整合性チェック
check_presets() {
    echo -e "${BLUE}プリセット整合性チェックを開始...${NC}"
    local errors=0
    local warnings=0
    
    # 各言語のプリセットをチェック
    for lang in ja en; do
        echo -e "\n${YELLOW}言語: $lang${NC}"
        preset_path="$PRESET_DIR/$lang/presets"
        
        if [ ! -d "$preset_path" ]; then
            echo -e "${RED}エラー: プリセットディレクトリが存在しません: $preset_path${NC}"
            ((errors++))
            continue
        fi
        
        # プリセットファイルのチェック
        while IFS= read -r preset_file; do
            basename=$(basename "$preset_file")
            echo -n "  $basename: "
            
            # ファイルサイズチェック
            size=$(stat -c%s "$preset_file" 2>/dev/null || stat -f%z "$preset_file" 2>/dev/null)
            if [ $size -lt 1024 ]; then
                echo -e "${YELLOW}警告 - ファイルサイズが小さい (${size}B)${NC}"
                ((warnings++))
            else
                # 自動生成マーカーのチェック
                if grep -q "自動生成されたプリセット" "$preset_file" || grep -q "automatically generated" "$preset_file"; then
                    echo -e "${GREEN}OK${NC}"
                else
                    echo -e "${YELLOW}警告 - 自動生成マーカーが見つかりません${NC}"
                    ((warnings++))
                fi
            fi
        done < <(find "$preset_path" -name "*.md" -type f 2>/dev/null)
    done
    
    echo -e "\n${BLUE}チェック結果:${NC}"
    echo "  エラー: $errors"
    echo "  警告: $warnings"
    
    log "CHECK: errors=$errors, warnings=$warnings"
    
    if [ $errors -gt 0 ]; then
        return 1
    fi
    return 0
}

# 使用統計の表示
show_stats() {
    echo -e "${BLUE}プリセット統計情報${NC}"
    echo "================================"
    
    # プリセット数のカウント
    for lang in ja en; do
        preset_count=$(find "$PRESET_DIR/$lang/presets" -name "*.md" -type f 2>/dev/null | wc -l)
        echo "$lang プリセット数: $preset_count"
    done
    
    echo ""
    echo "プリセット一覧:"
    echo "----------------"
    
    # プリセット名とサイズを表示
    for lang in ja en; do
        echo -e "\n${YELLOW}[$lang]${NC}"
        find "$PRESET_DIR/$lang/presets" -name "*.md" -type f 2>/dev/null | while read preset; do
            name=$(basename "$preset" .md)
            size=$(stat -c%s "$preset" 2>/dev/null || stat -f%z "$preset" 2>/dev/null)
            size_kb=$((size / 1024))
            echo "  - $name (${size_kb}KB)"
        done
    done
    
    # 最終更新日時
    echo -e "\n${BLUE}最終更新情報:${NC}"
    latest_preset=$(find "$PRESET_DIR" -name "*.md" -type f -path "*/presets/*" -exec stat -c '%Y %n' {} \; 2>/dev/null | sort -n | tail -1 | cut -d' ' -f2-)
    if [ -n "$latest_preset" ]; then
        update_time=$(stat -c '%y' "$latest_preset" 2>/dev/null || stat -f '%Sm' "$latest_preset" 2>/dev/null)
        echo "最後に更新されたプリセット: $(basename "$latest_preset")"
        echo "更新日時: $update_time"
    fi
    
    log "STATS: displayed statistics"
}

# 詳細レポートの生成
generate_report() {
    # レポートタイプの判定（デフォルトは月次）
    local report_type="${1:-monthly}"
    local timestamp=$(date +%Y%m%d-%H%M%S)
    local report_file
    
    case "$report_type" in
        daily)
            report_file="$REPORT_DIR/monitoring/daily/report-$(date +%Y%m%d).md"
            ;;
        weekly)
            report_file="$REPORT_DIR/monitoring/weekly/report-$(date +%Y-W%V).md"
            ;;
        monthly|*)
            report_file="$REPORT_DIR/monitoring/monthly/report-$(date +%Y%m).md"
            ;;
    esac
    
    echo -e "${BLUE}詳細レポート（$report_type）を生成中...${NC}"
    
    cat > "$report_file" << EOF
# プリセット監視レポート

生成日時: $(date '+%Y-%m-%d %H:%M:%S')

## 概要

### プリセット数
EOF
    
    # プリセット数を追加
    for lang in ja en; do
        preset_count=$(find "$PRESET_DIR/$lang/presets" -name "*.md" -type f 2>/dev/null | wc -l)
        echo "- $lang: $preset_count プリセット" >> "$report_file"
    done
    
    echo "" >> "$report_file"
    echo "## プリセット詳細" >> "$report_file"
    
    # 各プリセットの詳細情報
    for lang in ja en; do
        echo "" >> "$report_file"
        echo "### $lang プリセット" >> "$report_file"
        echo "" >> "$report_file"
        
        find "$PRESET_DIR/$lang/presets" -name "*.md" -type f 2>/dev/null | while read preset; do
            name=$(basename "$preset" .md)
            size=$(stat -c%s "$preset" 2>/dev/null || stat -f%z "$preset" 2>/dev/null)
            size_kb=$((size / 1024))
            modified=$(stat -c '%y' "$preset" 2>/dev/null || stat -f '%Sm' "$preset" 2>/dev/null)
            
            echo "#### $name" >> "$report_file"
            echo "- ファイルサイズ: ${size_kb}KB" >> "$report_file"
            echo "- 最終更新: $modified" >> "$report_file"
            
            # 生成情報を抽出
            if grep -q "生成日時:" "$preset" 2>/dev/null; then
                gen_time=$(grep "生成日時:" "$preset" | head -1 | sed 's/.*生成日時: //')
                echo "- 生成日時: $gen_time" >> "$report_file"
            fi
            
            echo "" >> "$report_file"
        done
    done
    
    # 問題点のサマリー
    echo "## 問題点と推奨事項" >> "$report_file"
    echo "" >> "$report_file"
    
    # サイズが小さいプリセットをチェック
    small_presets=$(find "$PRESET_DIR" -name "*.md" -type f -path "*/presets/*" -size -1k 2>/dev/null | wc -l)
    if [ $small_presets -gt 0 ]; then
        echo "- **警告**: $small_presets 個のプリセットファイルが1KB未満です" >> "$report_file"
    fi
    
    # 古いプリセットをチェック（30日以上）
    old_presets=$(find "$PRESET_DIR" -name "*.md" -type f -path "*/presets/*" -mtime +30 2>/dev/null | wc -l)
    if [ $old_presets -gt 0 ]; then
        echo "- **情報**: $old_presets 個のプリセットが30日以上更新されていません" >> "$report_file"
    fi
    
    echo "" >> "$report_file"
    echo "## 推奨アクション" >> "$report_file"
    echo "" >> "$report_file"
    echo "1. 定期的なプリセット再生成の実行" >> "$report_file"
    echo "2. 小さなプリセットファイルの内容確認" >> "$report_file"
    echo "3. 使用されていないプリセットの削除検討" >> "$report_file"
    
    echo -e "${GREEN}レポートを生成しました: $report_file${NC}"
    log "REPORT: generated at $report_file"
}

# メイン処理
main() {
    local command="${1:-check}"
    
    case "$command" in
        check)
            check_presets
            ;;
        stats)
            show_stats
            ;;
        report)
            generate_report
            ;;
        *)
            echo "使用方法: $0 [report|check|stats]"
            echo ""
            echo "コマンド:"
            echo "  check  - プリセットの整合性チェック"
            echo "  stats  - 使用統計の表示"
            echo "  report - 詳細レポートを生成"
            exit 1
            ;;
    esac
}

# スクリプト実行
main "$@"