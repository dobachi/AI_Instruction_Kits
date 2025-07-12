#!/bin/bash

# モジュラーシステムを多言語対応ディレクトリ構造に移行するスクリプト

set -e

# スクリプトのディレクトリを取得
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
MODULAR_DIR="$PROJECT_ROOT/modular"

echo "モジュラーシステムの多言語対応移行を開始します..."
echo "プロジェクトルート: $PROJECT_ROOT"
echo "モジュラーディレクトリ: $MODULAR_DIR"

# 1. 日本語用ディレクトリ構造を作成
echo "1. 日本語用ディレクトリ構造を作成中..."
mkdir -p "$MODULAR_DIR/ja/modules"
mkdir -p "$MODULAR_DIR/ja/templates"

# 2. 英語用ディレクトリ構造を作成
echo "2. 英語用ディレクトリ構造を作成中..."
mkdir -p "$MODULAR_DIR/en/modules/core"
mkdir -p "$MODULAR_DIR/en/modules/tasks"
mkdir -p "$MODULAR_DIR/en/modules/skills"
mkdir -p "$MODULAR_DIR/en/modules/quality"
mkdir -p "$MODULAR_DIR/en/modules/fragments"
mkdir -p "$MODULAR_DIR/en/templates/presets"
mkdir -p "$MODULAR_DIR/en/templates/custom"

# 3. 既存のmodulesディレクトリをja/modules/にコピー
echo "3. 既存のモジュールを日本語ディレクトリにコピー中..."
if [ -d "$MODULAR_DIR/modules" ]; then
    cp -r "$MODULAR_DIR/modules/"* "$MODULAR_DIR/ja/modules/" 2>/dev/null || true
    echo "   - modules/* -> ja/modules/ コピー完了"
fi

# 4. 既存のtemplates/presetsをja/templates/にコピー
echo "4. 既存のテンプレートを日本語ディレクトリにコピー中..."
if [ -d "$MODULAR_DIR/templates" ]; then
    cp -r "$MODULAR_DIR/templates/"* "$MODULAR_DIR/ja/templates/" 2>/dev/null || true
    echo "   - templates/* -> ja/templates/ コピー完了"
fi

# 5. 英語版のプレースホルダーファイルを作成
echo "5. 英語版のプレースホルダーファイルを作成中..."

# Core modules placeholders
cat > "$MODULAR_DIR/en/modules/core/README.md" << 'EOF'
# Core Modules (English)

English versions of core modules will be added here.

## Structure
- role_definition.yaml/md
- constraints.yaml/md
- output_format.yaml/md
- headers/
- footers/
- structures/
EOF

# Tasks modules placeholders
cat > "$MODULAR_DIR/en/modules/tasks/README.md" << 'EOF'
# Task Modules (English)

English versions of task modules will be added here.

## Available Tasks
- code_generation
- website
- example_task
EOF

# Skills modules placeholders
cat > "$MODULAR_DIR/en/modules/skills/README.md" << 'EOF'
# Skill Modules (English)

English versions of skill modules will be added here.

## Available Skills
- api_design
- authentication
- error_handling
- testing
- ui_ux
- accessibility
- performance
- code_documentation
EOF

# Quality modules placeholders
cat > "$MODULAR_DIR/en/modules/quality/README.md" << 'EOF'
# Quality Modules (English)

English versions of quality modules will be added here.

## Available Quality Levels
- production
EOF

# Presets placeholders
cat > "$MODULAR_DIR/en/templates/presets/README.md" << 'EOF'
# Preset Templates (English)

English versions of preset templates will be added here.

## Available Presets
- cli_tool_basic.yaml
- web_api_production.yaml
EOF

# 6. 古いディレクトリ構造のバックアップを作成
echo "6. 古いディレクトリ構造のバックアップを作成中..."
timestamp=$(date +%Y%m%d_%H%M%S)
backup_dir="$MODULAR_DIR/backup_$timestamp"
mkdir -p "$backup_dir"

if [ -d "$MODULAR_DIR/modules" ]; then
    mv "$MODULAR_DIR/modules" "$backup_dir/"
    echo "   - modules/ -> backup_$timestamp/modules/"
fi

if [ -d "$MODULAR_DIR/templates" ]; then
    mv "$MODULAR_DIR/templates" "$backup_dir/"
    echo "   - templates/ -> backup_$timestamp/templates/"
fi

# 7. composer.pyの更新が必要なことを通知
echo ""
echo "7. composer.pyの更新が必要です:"
echo "   - BASE_DIRからの相対パスを言語別に対応"
echo "   - --lang または -l オプションの追加（デフォルト: ja）"
echo ""

# 8. 最終的なディレクトリ構造を表示
echo "8. 新しいディレクトリ構造:"
echo ""
echo "modular/"
echo "├── ja/"
echo "│   ├── modules/"
echo "│   │   ├── core/"
echo "│   │   ├── tasks/"
echo "│   │   ├── skills/"
echo "│   │   ├── quality/"
echo "│   │   └── fragments/"
echo "│   └── templates/"
echo "│       ├── presets/"
echo "│       └── custom/"
echo "├── en/"
echo "│   ├── modules/"
echo "│   │   ├── core/"
echo "│   │   ├── tasks/"
echo "│   │   ├── skills/"
echo "│   │   ├── quality/"
echo "│   │   └── fragments/"
echo "│   └── templates/"
echo "│       ├── presets/"
echo "│       └── custom/"
echo "├── cache/            # 共通"
echo "├── composer.py       # 要更新"
echo "├── README.md         # 要更新"
echo "└── backup_$timestamp/  # バックアップ"
echo ""

echo "移行が完了しました！"
echo ""
echo "次のステップ:"
echo "1. composer.pyを更新して言語オプションを追加"
echo "2. README.mdを更新して新しい構造を反映"
echo "3. 英語版モジュールの内容を追加"
echo ""
echo "バックアップは $backup_dir に保存されています。"