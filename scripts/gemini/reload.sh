#!/bin/bash
set -e

# このリポジトリがサブモジュールとして使われているかチェック
if [ -d "instructions/ai_instruction_kits/.git" ]; then
  echo "🔄 AI指示書システム（サブモジュール）を更新中..."
  git submodule update --remote instructions/ai_instruction_kits
  echo "✅ AI指示書システムを更新しました。"
  echo ""
  echo "現在のバージョン:"
  git submodule status instructions/ai_instruction_kits
elif [ -f ".git/config" ]; then
  echo "📌 AI指示書キット開発環境で実行中（サブモジュール更新をスキップ）"
  echo ""
  echo "現在のバージョン:"
  git rev-parse --short HEAD
else
  echo "🤷 Gitリポジトリではありません。更新をスキップします。"
fi
