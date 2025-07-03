#!/bin/bash

# AIメッセージを含まないクリーンなコミットを作成するツール

# 引数チェック
if [ $# -eq 0 ]; then
    echo "使用方法: $0 \"コミットメッセージ\""
    echo "例: $0 \"feat: 新機能を追加\""
    exit 1
fi

# コミットメッセージ
COMMIT_MESSAGE="$1"

# git addが必要かチェック
if ! git diff --cached --quiet; then
    echo "📝 ステージングエリアの変更をコミット中..."
    
    # コミット実行（AIメッセージなし）
    git commit -m "$COMMIT_MESSAGE"
    
    if [ $? -eq 0 ]; then
        echo "✅ コミット完了!"
        git log -1 --oneline
    else
        echo "❌ コミットに失敗しました"
        exit 1
    fi
else
    echo "⚠️  ステージングエリアに変更がありません"
    echo "先に 'git add' で変更をステージしてください"
    exit 1
fi