#!/bin/bash
set -e

# 引数チェック
if [ "$#" -lt 2 ]; then
    echo "使用方法: $0 \"コミットメッセージ\" <ファイルパス1> [<ファイルパス2> ...]"
    echo "例: $0 \"feat: 新機能追加\" src/main.py"
    exit 1
fi

COMMIT_MESSAGE="$1"
shift
FILES=($@)

echo "📝 以下のファイルをステージングします:"
for file in "${FILES[@]}"; do
    echo "  - $file"
done

git add "${FILES[@]}"

echo "💬 コミットを実行します..."
git commit -m "$COMMIT_MESSAGE"

echo "✅ コミットが完了しました。"
git log -1 --oneline
