#!/bin/bash

# AI指示書をサブモジュールとしてセットアップし、AI.mdを作成するスクリプト
# Claude, Gemini, その他のAIツールに対応

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "🚀 AI指示書をプロジェクトにセットアップします..."

# プロジェクトルートで実行されているか確認
if [ ! -d ".git" ]; then
    echo "❌ エラー: このスクリプトはGitプロジェクトのルートディレクトリで実行してください"
    exit 1
fi

# サブモジュールとして追加
echo "📦 AI指示書をサブモジュールとして追加..."
git submodule add https://github.com/dobachi/AI_Instruction_Sheet.git .ai-instructions

# .gitignoreに追加（既に存在する場合はスキップ）
if ! grep -q "^\.ai-instructions/$" .gitignore 2>/dev/null; then
    echo ".ai-instructions/" >> .gitignore
    echo "✅ .gitignoreに.ai-instructionsを追加しました"
fi

# AI.md（日本語版）の作成
echo "📝 AI.md（日本語版）を作成..."
cat > AI.md << 'EOF'
# AI開発支援設定

このプロジェクトでは`.ai-instructions/`のAI指示書システムを使用します。
タスク開始時は`.ai-instructions/instructions/ja/system/ROOT_INSTRUCTION.md`を読み込んでください。

## プロジェクト設定
- 言語: 日本語 (ja)
- チェックポイント管理: 有効
- ログファイル: checkpoint.log

## プロジェクト固有の追加指示
<!-- ここにプロジェクト固有の指示を追加してください -->

### 例：
- コーディング規約: 
- テストフレームワーク: 
- ビルドコマンド: 
- リントコマンド: 
- その他の制約事項: 
EOF

# AI.en.md（英語版）の作成
echo "📝 AI.en.md（英語版）を作成..."
cat > AI.en.md << 'EOF'
# AI Development Support Configuration

This project uses the AI instruction system in `.ai-instructions/`.
Please load `.ai-instructions/instructions/en/system/ROOT_INSTRUCTION.md` when starting a task.

## Project Settings
- Language: English (en)
- Checkpoint Management: Enabled
- Log File: checkpoint.log

## Project-Specific Instructions
<!-- Add your project-specific instructions here -->

### Examples:
- Coding Standards: 
- Test Framework: 
- Build Commands: 
- Lint Commands: 
- Other Constraints: 
EOF

# シンボリックリンクの作成（後方互換性のため）
ln -sf AI.md CLAUDE.md
ln -sf AI.en.md CLAUDE.en.md

echo ""
echo "✅ セットアップが完了しました！"
echo ""
echo "📖 使い方 / Usage:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🇯🇵 日本語:"
echo "  AIに作業を依頼する際は「AI.mdを参照して、[タスク内容]」と伝えてください"
echo ""
echo "🇺🇸 English:"
echo "  When requesting AI assistance, say \"Please refer to AI.en.md and [task description]\""
echo ""
echo "📌 メモ:"
echo "  • Claude/Gemini/ChatGPT/Cursor等、どのAIツールでも同じ指示で動作します"
echo "  • プロジェクト固有の設定はAI.md/AI.en.mdに追加してください"
echo "  • 後方互換性のため、CLAUDE.md/CLAUDE.en.mdも作成されました"
echo ""
echo "🔗 次のステップ:"
echo "  1. AI.mdを編集してプロジェクト固有の設定を追加"
echo "  2. git add AI.md AI.en.md .gitignore"
echo "  3. git commit -m \"Add AI instruction configuration\""