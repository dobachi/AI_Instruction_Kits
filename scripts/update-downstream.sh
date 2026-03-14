#!/bin/bash
# downstream/ 配下のプロジェクトのサブモジュールを一括更新するスクリプト
#
# Usage:
#   bash scripts/update-downstream.sh              # 全リポジトリを更新
#   bash scripts/update-downstream.sh --dry-run     # 変更内容を確認のみ
#   bash scripts/update-downstream.sh ResearchTemplate  # 指定リポジトリのみ

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
DOWNSTREAM_DIR="$PROJECT_ROOT/downstream"
SUBMODULE_PATH="instructions/ai_instruction_kits"

DRY_RUN=false
TARGETS=()

# 引数解析
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=true ;;
    --help|-h)
      echo "Usage: $(basename "$0") [--dry-run] [repo_name ...]"
      echo ""
      echo "Options:"
      echo "  --dry-run    変更内容を確認するのみ（コミット・プッシュしない）"
      echo "  repo_name    更新対象のリポジトリ名（省略時は全リポジトリ）"
      echo ""
      echo "Examples:"
      echo "  $(basename "$0")                    # 全リポジトリを更新"
      echo "  $(basename "$0") --dry-run          # ドライラン"
      echo "  $(basename "$0") ResearchTemplate   # 指定リポジトリのみ"
      exit 0
      ;;
    *) TARGETS+=("$arg") ;;
  esac
done

if [ ! -d "$DOWNSTREAM_DIR" ]; then
  echo "ERROR: downstream/ ディレクトリが見つかりません: $DOWNSTREAM_DIR"
  exit 1
fi

# 対象リポジトリの決定
if [ ${#TARGETS[@]} -eq 0 ]; then
  repos=()
  for d in "$DOWNSTREAM_DIR"/*/; do
    [ -d "$d/.git" ] && repos+=("$d")
  done
else
  repos=()
  for name in "${TARGETS[@]}"; do
    dir="$DOWNSTREAM_DIR/$name"
    if [ -d "$dir/.git" ]; then
      repos+=("$dir/")
    else
      echo "WARNING: $name はGitリポジトリではありません。スキップします。"
    fi
  done
fi

if [ ${#repos[@]} -eq 0 ]; then
  echo "更新対象のリポジトリがありません。"
  exit 0
fi

SUCCESS=0
SKIPPED=0
FAILED=0

for repo in "${repos[@]}"; do
  name=$(basename "$repo")
  echo "=== $name ==="

  cd "$repo"

  # サブモジュール初期化（未初期化の場合）
  if [ ! -d "$SUBMODULE_PATH/.git" ] && [ ! -f "$SUBMODULE_PATH/.git" ]; then
    echo "  サブモジュールを初期化中..."
    if ! git submodule update --init "$SUBMODULE_PATH" 2>/dev/null; then
      echo "  ERROR: サブモジュールの初期化に失敗しました"
      FAILED=$((FAILED + 1))
      echo ""
      continue
    fi
  fi

  # リモートから最新を取得
  if ! git -C "$SUBMODULE_PATH" fetch origin main 2>/dev/null; then
    echo "  ERROR: リモートからのフェッチに失敗しました"
    FAILED=$((FAILED + 1))
    echo ""
    continue
  fi

  # 現在と最新のコミットを比較
  current=$(git -C "$SUBMODULE_PATH" rev-parse HEAD 2>/dev/null)
  latest=$(git -C "$SUBMODULE_PATH" rev-parse origin/main 2>/dev/null)

  if [ "$current" = "$latest" ]; then
    echo "  既に最新です ($current)"
    SKIPPED=$((SKIPPED + 1))
    echo ""
    continue
  fi

  echo "  $current -> $latest"
  short_latest=$(echo "$latest" | cut -c1-7)

  if $DRY_RUN; then
    echo "  [dry-run] コミット・プッシュはスキップします"
    SUCCESS=$((SUCCESS + 1))
    echo ""
    continue
  fi

  # サブモジュールを更新
  git -C "$SUBMODULE_PATH" checkout "$latest"
  git add "$SUBMODULE_PATH"

  # 変更がある場合のみコミット
  if git diff --cached --quiet; then
    echo "  ステージされた変更がありません。スキップします。"
    SKIPPED=$((SKIPPED + 1))
  else
    git commit -m "chore: update ai_instruction_kits submodule to $short_latest"
    git push
    echo "  更新完了"
    SUCCESS=$((SUCCESS + 1))
  fi

  echo ""
done

echo "--- 結果 ---"
echo "更新: $SUCCESS  スキップ: $SKIPPED  失敗: $FAILED"
