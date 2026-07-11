#!/usr/bin/env bash
#
# migration 2.2.0 - 全スキルを外部マーケットプレイスに集約したことに伴う移行
#
# 実施内容（冪等・バックアップ付き）:
#   - キットが配布していたスキルのローカルコピーを掃除する。全スキルは
#     外部マーケット dobachi/claude-skills-marketplace へ集約されたため、
#     プロジェクト直下の以下は不要になった:
#       .claude/skills/<name>      (Claude Code)
#       .agents/skills/<name>      (Antigravity / Codex / Gemini 共有: ~/.agents/skills 標準)
#       .codex/prompts/<name>.md   (Codex カスタムプロンプト)
#       .gemini/commands/<name>.toml (Gemini カスタムコマンド)
#       scripts/gemini/            (Gemini 用ヘルパースクリプト)
#   - 対象はキット管理のスキル名のみ。ユーザー自作のスキルには触れない。
#   - 指示書ファイル（CLAUDE.md / CODEX.md / GEMINI.md / AGENTS.md）は掃除しない。
#
# 使い方:
#   bash migrations/2.2.0.sh            # バックアップの上で掃除
#   bash migrations/2.2.0.sh --dry-run  # 変更内容の確認のみ
#
set -euo pipefail

DRY_RUN=false
for arg in "$@"; do
    case "$arg" in
        --dry-run) DRY_RUN=true ;;
        -h|--help)
            grep '^#' "$0" | sed 's/^# \{0,1\}//'
            exit 0
            ;;
        *) echo "❌ 不明な引数: $arg" >&2; exit 1 ;;
    esac
done

# キットが配布していたスキル名
KIT_SKILLS=(
    "commit-safe"
    "commit-and-report"
    "github-issues"
    "reload-instructions"
    "reload-and-reset"
    "evidence-check"
)

BACKUP_DIR=".migration-backup/$(date +%Y%m%d-%H%M%S)"
removed_count=0

backup_and_remove() {
    local target="$1"
    [ -e "$target" ] || [ -L "$target" ] || return 0
    local dest="$BACKUP_DIR/$target"
    if [ "$DRY_RUN" = true ]; then
        echo "  [dry-run] バックアップ→削除: $target"
        removed_count=$((removed_count + 1))
        return 0
    fi
    mkdir -p "$(dirname "$dest")"
    cp -rL "$target" "$dest" 2>/dev/null || cp -r "$target" "$dest" 2>/dev/null || true
    rm -rf "$target"
    echo "  🗑️  削除（バックアップ済）: $target"
    removed_count=$((removed_count + 1))
}

echo "▶ 2.2.0: キット配布スキルのローカルコピーを掃除（マーケットプレイス集約）"
[ "$DRY_RUN" = true ] && echo "🔍 ドライランモード: 実際の変更は行いません"
echo "📁 バックアップ先: $BACKUP_DIR"
echo ""

for name in "${KIT_SKILLS[@]}"; do
    backup_and_remove ".claude/skills/$name"
    backup_and_remove ".claude/skills/$name.md"
    backup_and_remove ".agents/skills/$name"
    backup_and_remove ".codex/prompts/$name.md"
    backup_and_remove ".gemini/commands/$name.toml"
done

# Gemini 用ヘルパースクリプト（キット管理）
backup_and_remove "scripts/gemini"

echo ""
echo "📊 完了: 掃除 $removed_count 件"
if [ "$DRY_RUN" = false ] && [ "$removed_count" -gt 0 ]; then
    echo "♻️  復元が必要な場合は $BACKUP_DIR から戻せます。"
fi
echo ""
echo "👉 スキルは外部マーケットプレイスから導入してください:"
echo "     git clone https://github.com/dobachi/claude-skills-marketplace"
echo "     bash claude-skills-marketplace/install.sh"
echo "   （Claude Code のみ: /plugin marketplace add dobachi/claude-skills-marketplace → /plugin install commit-safe@dobachi-skills）"
echo "   Codex / Gemini / Antigravity は ~/.agents/skills を共有するため install.sh 一度で全CLIをカバーします。"
