#!/usr/bin/env bash
#
# migrate-skills.sh - 旧版AI指示書キットを使用していたプロジェクトの構成を最新仕様へ移行する
#
# 実施内容:
#   1. 廃止スキルの削除        : .claude/skills/ ・ .agents/skills/ 配下の checkpoint-manager / worktree-manager / auto-build
#   2. 廃止コマンドの削除      : .codex/prompts/{checkpoint,build}.md ・ .gemini/commands/{checkpoint,build}.toml
#   3. レガシー形式の移行      : .claude/skills/*.md（旧フラット形式）→ バックアップして削除（新形式は <name>/SKILL.md）
#   いずれもバックアップを取得してから削除する（非破壊・復元可能）。
#
# 使い方:
#   bash scripts/migrate-skills.sh            # 実行（バックアップの上で移行）
#   bash scripts/migrate-skills.sh --dry-run  # 変更内容の確認のみ
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
        *)
            echo "❌ 不明な引数: $arg" >&2
            exit 1
            ;;
    esac
done

# バックアップ先（タイムスタンプ付き）
BACKUP_DIR=".migration-backup/$(date +%Y%m%d-%H%M%S)"

DEPRECATED_SKILLS=("checkpoint-manager" "worktree-manager" "auto-build")
DEPRECATED_CODEX=("checkpoint.md" "build.md")
DEPRECATED_GEMINI=("checkpoint.toml" "build.toml")

removed_count=0
migrated_count=0

# 対象を退避（バックアップ）してから削除する
backup_and_remove() {
    local target="$1"
    [ -e "$target" ] || return 0
    local dest="$BACKUP_DIR/$target"
    if [ "$DRY_RUN" = true ]; then
        echo "  [dry-run] バックアップ→削除: $target"
        return 0
    fi
    mkdir -p "$(dirname "$dest")"
    cp -rL "$target" "$dest" 2>/dev/null || cp -r "$target" "$dest"
    rm -rf "$target"
    echo "  🗑️  削除（バックアップ済）: $target"
}

echo "🔄 AI指示書キット 構成移行スクリプト"
[ "$DRY_RUN" = true ] && echo "🔍 ドライランモード: 実際の変更は行いません"
echo "📁 バックアップ先: $BACKUP_DIR"
echo ""

# 1. 廃止スキルの削除（.claude/skills/ と .agents/skills/）
echo "1️⃣  廃止スキルの確認 (checkpoint-manager / worktree-manager / auto-build)"
for base in ".claude/skills" ".agents/skills"; do
    for skill in "${DEPRECATED_SKILLS[@]}"; do
        if [ -e "$base/$skill" ]; then
            backup_and_remove "$base/$skill"
            removed_count=$((removed_count + 1))
        fi
    done
done

# 2. 廃止コマンドの削除（Codex / Gemini）
echo "2️⃣  廃止コマンドの確認 (checkpoint / build)"
for f in "${DEPRECATED_CODEX[@]}"; do
    if [ -e ".codex/prompts/$f" ]; then
        backup_and_remove ".codex/prompts/$f"
        removed_count=$((removed_count + 1))
    fi
done
for f in "${DEPRECATED_GEMINI[@]}"; do
    if [ -e ".gemini/commands/$f" ]; then
        backup_and_remove ".gemini/commands/$f"
        removed_count=$((removed_count + 1))
    fi
done

# 3. レガシーなフラット形式スキルの移行（.claude/skills/*.md → 削除）
#    新形式は .claude/skills/<name>/SKILL.md のため、ルート直下の *.md は旧形式とみなす。
echo "3️⃣  レガシー形式スキルの確認 (.claude/skills/*.md)"
if [ -d ".claude/skills" ]; then
    while IFS= read -r -d '' legacy; do
        backup_and_remove "$legacy"
        migrated_count=$((migrated_count + 1))
    done < <(find ".claude/skills" -maxdepth 1 -type f -name "*.md" -print0 2>/dev/null)
fi

echo ""
echo "📊 完了: 廃止削除 $removed_count 件、レガシー移行 $migrated_count 件"
if [ "$DRY_RUN" = false ] && [ $((removed_count + migrated_count)) -gt 0 ]; then
    echo "♻️  復元が必要な場合は $BACKUP_DIR から戻せます。"
fi
echo "👉 次のステップ: 'bash scripts/setup-project.sh' を再実行し、最新のスキル・Antigravity構成を導入してください。"
