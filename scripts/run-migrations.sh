#!/usr/bin/env bash
#
# run-migrations.sh - バージョン突合でバージョン別マイグレーションを順次適用する
#
# キット側の VERSION（現行）と、利用側プロジェクトの適用済みバージョン
# （instructions/.ai_ik_applied_version）を突合し、未適用のマイグレーション
# （migrations/<version>.sh）のみを semver 昇順で実行する。
# 各マイグレーションは冪等で、--dry-run でプレビューできる。
#
# 使い方:
#   bash scripts/run-migrations.sh            # 未適用の移行を順次適用し、適用済みバージョンを更新
#   bash scripts/run-migrations.sh --dry-run  # 適用される移行を確認のみ（マーカー更新なし）
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

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
KIT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
MIGRATIONS_DIR="$KIT_ROOT/migrations"
VERSION_FILE="$KIT_ROOT/VERSION"
MARKER="instructions/.ai_ik_applied_version"

# semver 比較: a <= b なら真
ver_le() {
    [ "$(printf '%s\n%s\n' "$1" "$2" | sort -V | head -n1)" = "$1" ]
}
# semver 比較: a < b なら真
ver_lt() {
    [ "$1" != "$2" ] && ver_le "$1" "$2"
}

if [ ! -f "$VERSION_FILE" ]; then
    echo "❌ VERSION ファイルが見つかりません: $VERSION_FILE" >&2
    exit 1
fi
current="$(tr -d '[:space:]' < "$VERSION_FILE")"

applied="0.0.0"
if [ -f "$MARKER" ]; then
    applied="$(tr -d '[:space:]' < "$MARKER")"
    [ -z "$applied" ] && applied="0.0.0"
fi

echo "🔢 適用済みバージョン: $applied / 現行バージョン: $current"

if [ "$applied" = "$current" ]; then
    echo "✅ 既に最新です。適用する移行はありません。"
    exit 0
fi

# 未適用の移行を抽出（applied < v <= current）し、semver昇順に並べる
pending=()
if [ -d "$MIGRATIONS_DIR" ]; then
    while IFS= read -r v; do
        [ -z "$v" ] && continue
        if ver_lt "$applied" "$v" && ver_le "$v" "$current"; then
            pending+=("$v")
        fi
    done < <(for f in "$MIGRATIONS_DIR"/*.sh; do [ -e "$f" ] && basename "$f" .sh; done | sort -V)
fi

if [ ${#pending[@]} -eq 0 ]; then
    echo "ℹ️  実行対象のマイグレーションスクリプトはありません。"
    if [ "$DRY_RUN" = false ]; then
        echo "$current" > "$MARKER"
        echo "📌 適用済みバージョンを $current に更新しました ($MARKER)"
    fi
    exit 0
fi

echo "📋 適用対象: ${pending[*]}"
echo ""

for v in "${pending[@]}"; do
    script="$MIGRATIONS_DIR/$v.sh"
    echo "=== migration $v ==="
    if [ "$DRY_RUN" = true ]; then
        bash "$script" --dry-run || true
    else
        bash "$script"
    fi
    echo ""
done

if [ "$DRY_RUN" = false ]; then
    echo "$current" > "$MARKER"
    echo "📌 適用済みバージョンを $current に更新しました ($MARKER)"
    echo "👉 変更内容を確認し、commit-safe または scripts/commit.sh でコミットしてください（*.backup.* は除外）。"
else
    echo "🔍 ドライラン: マーカーは更新していません。"
fi
