#!/bin/bash

# AIメッセージを含まないクリーンなコミットを作成するツール / Clean commit tool without AI messages

# i18nライブラリをソース
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/i18n.sh"

# 引数チェック
if [ $# -eq 0 ]; then
    MSG_USAGE=$(get_message "usage" "Usage" "使用方法")
    MSG_EXAMPLE=$(get_message "example" "Example" "例")
    MSG_COMMIT_MESSAGE=$(get_message "commit_message" "commit message" "コミットメッセージ")
    MSG_ADD_FEATURE=$(get_message "add_feature" "feat: Add new feature" "feat: 新機能を追加")
    
    echo "$MSG_USAGE: $0 \"$MSG_COMMIT_MESSAGE\""
    echo "$MSG_EXAMPLE: $0 \"$MSG_ADD_FEATURE\""
    exit 1
fi

# コミットメッセージ
COMMIT_MESSAGE="$1"

# git addが必要かチェック
if ! git diff --cached --quiet; then
    MSG_COMMITTING=$(get_message "committing" "Committing staged changes..." "ステージングエリアの変更をコミット中...")
    echo "📝 $MSG_COMMITTING"
    
    # コミット実行（AIメッセージなし）
    git commit -m "$COMMIT_MESSAGE"
    
    if [ $? -eq 0 ]; then
        MSG_COMMIT_COMPLETE=$(get_message "commit_complete" "Commit completed!" "コミット完了!")
        echo "✅ $MSG_COMMIT_COMPLETE"
        git log -1 --oneline
    else
        MSG_COMMIT_FAILED=$(get_message "commit_failed" "Commit failed" "コミットに失敗しました")
        echo "❌ $MSG_COMMIT_FAILED"
        exit 1
    fi
else
    MSG_NO_CHANGES=$(get_message "no_changes" "No changes in staging area" "ステージングエリアに変更がありません")
    MSG_STAGE_FIRST=$(get_message "stage_first" "Please stage changes with 'git add' first" "先に 'git add' で変更をステージしてください")
    
    echo "⚠️  $MSG_NO_CHANGES"
    echo "$MSG_STAGE_FIRST"
    exit 1
fi