#!/bin/bash

# AI指示書を柔軟な構成でセットアップするスクリプト
# scripts/とinstructions/ディレクトリ構成に対応

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "🚀 AI指示書を柔軟な構成でセットアップします..."

# プロジェクトルートで実行されているか確認
if [ ! -d ".git" ]; then
    echo "❌ エラー: このスクリプトはGitプロジェクトのルートディレクトリで実行してください"
    exit 1
fi

# ディレクトリ作成
echo "📁 必要なディレクトリを作成..."
mkdir -p scripts
mkdir -p instructions

# サブモジュールとして追加
echo "📦 AI指示書をサブモジュールとして追加..."
cd instructions
git submodule add https://github.com/dobachi/AI_Instruction_Kits.git ai_instruction_kits
cd ..

# checkpoint.shへのシンボリックリンク
echo "🔗 checkpoint.shへのシンボリックリンクを作成..."
ln -sf ../instructions/ai_instruction_kits/tools/checkpoint.sh scripts/checkpoint.sh

# PROJECT.md（日本語版）の作成
echo "📝 instructions/PROJECT.md（日本語版）を作成..."
cat > instructions/PROJECT.md << 'EOF'
# AI開発支援設定

このプロジェクトでは`instructions/ai_instruction_kits/`のAI指示書システムを使用します。
タスク開始時は`instructions/ai_instruction_kits/instructions/ja/system/ROOT_INSTRUCTION.md`を読み込んでください。

## プロジェクト設定
- 言語: 日本語 (ja)
- チェックポイント管理: 有効
- チェックポイントスクリプト: scripts/checkpoint.sh
- ログファイル: checkpoint.log

## 重要なパス
- AI指示書システム: `instructions/ai_instruction_kits/`
- チェックポイントスクリプト: `scripts/checkpoint.sh`
- プロジェクト固有の設定: このファイル（`instructions/PROJECT.md`）

## プロジェクト固有の追加指示
<!-- ここにプロジェクト固有の指示を追加してください -->

### 例：
- コーディング規約: 
- テストフレームワーク: 
- ビルドコマンド: 
- リントコマンド: 
- その他の制約事項: 
EOF

# PROJECT.en.md（英語版）の作成
echo "📝 instructions/PROJECT.en.md（英語版）を作成..."
cat > instructions/PROJECT.en.md << 'EOF'
# AI Development Support Configuration

This project uses the AI instruction system in `instructions/ai_instruction_kits/`.
Please load `instructions/ai_instruction_kits/instructions/en/system/ROOT_INSTRUCTION.md` when starting a task.

## Project Settings
- Language: English (en)
- Checkpoint Management: Enabled
- Checkpoint Script: scripts/checkpoint.sh
- Log File: checkpoint.log

## Important Paths
- AI Instruction System: `instructions/ai_instruction_kits/`
- Checkpoint Script: `scripts/checkpoint.sh`
- Project-Specific Configuration: This file (`instructions/PROJECT.en.md`)

## Project-Specific Instructions
<!-- Add your project-specific instructions here -->

### Examples:
- Coding Standards: 
- Test Framework: 
- Build Commands: 
- Lint Commands: 
- Other Constraints: 
EOF

# AI製品別のシンボリックリンク作成
echo "🔗 AI製品別のシンボリックリンクを作成..."
ln -sf instructions/PROJECT.md CLAUDE.md
ln -sf instructions/PROJECT.md GEMINI.md
ln -sf instructions/PROJECT.md CURSOR.md
ln -sf instructions/PROJECT.en.md CLAUDE.en.md
ln -sf instructions/PROJECT.en.md GEMINI.en.md
ln -sf instructions/PROJECT.en.md CURSOR.en.md

# .gitignoreに追加
echo "📄 .gitignoreを更新..."
if ! grep -q "^instructions/ai_instruction_kits/$" .gitignore 2>/dev/null; then
    echo "instructions/ai_instruction_kits/" >> .gitignore
fi

echo ""
echo "✅ セットアップが完了しました！"
echo ""
echo "📖 使い方 / Usage:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🇯🇵 日本語:"
echo "  AIに作業を依頼する際は「CLAUDE.mdを参照して、[タスク内容]」と伝えてください"
echo "  （GEMINI.md、CURSOR.mdも同様に使用可能）"
echo ""
echo "🇺🇸 English:"
echo "  When requesting AI assistance, say \"Please refer to CLAUDE.en.md and [task description]\""
echo "  (GEMINI.en.md, CURSOR.en.md also available)"
echo ""
echo "📁 作成された構成:"
echo "  scripts/"
echo "    └── checkpoint.sh → ../instructions/ai_instruction_kits/tools/checkpoint.sh"
echo "  instructions/"
echo "    ├── ai_instruction_kits/ (サブモジュール)"
echo "    ├── PROJECT.md (プロジェクト設定)"
echo "    └── PROJECT.en.md (Project configuration)"
echo "  CLAUDE.md → instructions/PROJECT.md"
echo "  GEMINI.md → instructions/PROJECT.md"
echo "  CURSOR.md → instructions/PROJECT.md"
echo ""
echo "🔗 次のステップ:"
echo "  1. instructions/PROJECT.mdを編集してプロジェクト固有の設定を追加"
echo "  2. git add -A"
echo "  3. git commit -m \"Add AI instruction configuration with flexible structure\""
echo ""
echo "⚠️  重要:"
echo "  • チェックポイントは scripts/checkpoint.sh から実行されます"
echo "  • AIは自動的に正しいパスを使用します"