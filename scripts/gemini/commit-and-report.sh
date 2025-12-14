#!/bin/bash
set -e

# 引数からコミットメッセージとIssue番号を抽出
# 例: "feat: すごい機能" 123
# 例: "fix: バグ修正"
COMMIT_MESSAGE=""
ISSUE_NUM=""

if [[ "$1" =~ ^[0-9]+$ ]]; then
    echo "エラー: 最初の引数はコミットメッセージである必要があります。"
    exit 1
fi

# 引数をループして解析
TEMP_MSG=""
for arg in "$@"; do
  if [[ "$arg" =~ ^[0-9]+$ ]] && [[ -z "$ISSUE_NUM" ]]; then
    ISSUE_NUM=$arg
  else
    TEMP_MSG="$TEMP_MSG $arg"
  fi
done
COMMIT_MESSAGE=$(echo "$TEMP_MSG" | sed 's/^ *//g' | sed 's/ *$//g')

if [ -z "$COMMIT_MESSAGE" ]; then
    echo "使用方法: $0 \"コミットメッセージ\" [Issue番号]"
    echo "例: $0 \"feat: 新機能追加\" 123"
    exit 1
fi

echo "📝 全ての変更をステージングします..."
git add .

echo "💬 コミットを実行します: $COMMIT_MESSAGE"
git commit -m "$COMMIT_MESSAGE"

echo "🚀 リモートリポジトリにプッシュします..."
git push

if [ -n "$ISSUE_NUM" ]; then
    echo "✅ Issue #$ISSUE_NUM に進捗を報告します..."
    if ! command -v gh &> /dev/null; then
        echo "⚠️ 'gh' (GitHub CLI) コマンドが見つかりません。Issueへの報告をスキップします。"
    elif ! gh auth status &> /dev/null; then
        echo "⚠️ GitHub CLIが認証されていません。Issueへの報告をスキップします。"
    else
        gh issue comment "$ISSUE_NUM" --body "✅ **Commit successful**\n- **Message**: \
$COMMIT_MESSAGE\
- A push to the remote repository has been completed."
        echo "✅ Issue #$ISSUE_NUM への報告が完了しました。"
    fi
fi

echo "🎉 全ての処理が完了しました。"
git log -1 --oneline
