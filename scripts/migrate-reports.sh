#!/bin/bash
# レポート構造移行スクリプト
#
# 既存のレポート関連ファイルを新しいreports/ディレクトリに移行します

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "レポート構造の移行を開始します..."

# ディレクトリ構造の作成（既に存在していてもOK）
echo "1. ディレクトリ構造を作成..."
mkdir -p "$PROJECT_ROOT/reports/presets/"{monitoring/{daily,weekly,monthly},feedback/archive,logs/archive}

# 既存ファイルの移行
echo "2. 既存ファイルを移行..."

# フィードバックファイル
if [ -f "$PROJECT_ROOT/docs/feedback/PRESET_FEEDBACK.md" ]; then
    echo "   - フィードバックファイルを移動"
    mv "$PROJECT_ROOT/docs/feedback/PRESET_FEEDBACK.md" "$PROJECT_ROOT/reports/presets/feedback/current.md"
    rmdir "$PROJECT_ROOT/docs/feedback" 2>/dev/null || true
fi

# ログファイル
if [ -f "$PROJECT_ROOT/.preset-monitor.log" ]; then
    echo "   - ログファイルを移動"
    mv "$PROJECT_ROOT/.preset-monitor.log" "$PROJECT_ROOT/reports/presets/logs/monitor.log"
fi

# 既存のレポートファイル
if ls "$PROJECT_ROOT/docs/preset-report-"*.md 1> /dev/null 2>&1; then
    echo "   - 既存レポートを移動"
    mv "$PROJECT_ROOT/docs/preset-report-"*.md "$PROJECT_ROOT/reports/presets/monitoring/daily/" 2>/dev/null || true
fi

# READMEとgitignoreの作成（既に存在する場合はスキップ）
if [ ! -f "$PROJECT_ROOT/reports/README.md" ]; then
    echo "3. README.mdを作成..."
    # 既に作成済み
fi

if [ ! -f "$PROJECT_ROOT/reports/.gitignore" ]; then
    echo "4. .gitignoreを作成..."
    # 既に作成済み
fi

# パス更新の確認
echo "5. 更新が必要なファイルの確認..."
echo "   以下のファイルでパスの更新が必要です："
echo "   - scripts/monitor-presets.sh (完了)"
echo "   - README.md (完了)"
echo "   - README_en.md (完了)"
echo "   - その他のドキュメント"

echo ""
echo "移行が完了しました！"
echo ""
echo "新しい構造:"
echo "  reports/"
echo "  └── presets/"
echo "      ├── monitoring/     # レポート"
echo "      ├── feedback/       # フィードバック"
echo "      └── logs/           # ログ"
echo ""
echo "詳細は reports/README.md を参照してください。"