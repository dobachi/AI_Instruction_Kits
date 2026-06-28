#!/usr/bin/env bash
#
# migration 2.1.0 - Antigravity CLI対応・コアスキル整理に伴う移行
#
# 実施内容（冪等）:
#   - 廃止スキル/コマンドの掃除（checkpoint-manager / worktree-manager / auto-build / checkpoint / build）
#   - レガシーなフラット形式 .claude/skills/*.md の移行
#   いずれも migrate-skills.sh に委譲（バックアップ付き）。
#
# 注: Antigravity構成（AGENTS.md / .agents/skills）・marketplace の「導入」は
#     setup-project.sh --skip-instructions が担当する。本スクリプトは旧構成の掃除のみ。
#
set -euo pipefail

DRY_RUN=false
[ "${1:-}" = "--dry-run" ] && DRY_RUN=true

HERE="$(cd "$(dirname "$0")" && pwd)"
KIT_SCRIPTS="$(cd "$HERE/../scripts" && pwd)"

echo "▶ 2.1.0: 廃止スキル/コマンドの掃除とレガシー形式の移行"

if [ "$DRY_RUN" = true ]; then
    bash "$KIT_SCRIPTS/migrate-skills.sh" --dry-run
else
    bash "$KIT_SCRIPTS/migrate-skills.sh"
fi
