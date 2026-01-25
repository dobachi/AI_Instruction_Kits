#!/bin/bash
# AI指示書サブモジュール自動更新チェックスクリプト
# SessionStartフックから呼び出され、サブモジュールの更新を自動チェック・実行する

set -e

# 設定
SUBMODULE_PATH="instructions/ai_instruction_kits"
FETCH_TIMEOUT=30
MAX_LOG_ENTRIES=5

# 色定義
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# プレフィックス
PREFIX="[ai-instructions]"

info() {
    echo -e "${GREEN}${PREFIX}${NC} $1"
}

warn() {
    echo -e "${YELLOW}${PREFIX}${NC} $1"
}

highlight() {
    echo -e "${CYAN}${PREFIX}${NC} $1"
}

separator() {
    echo -e "${GREEN}${PREFIX}${NC} ================================"
}

# サブモジュールの存在チェック
check_submodule_exists() {
    if [ ! -d "$SUBMODULE_PATH/.git" ] && [ ! -f "$SUBMODULE_PATH/.git" ]; then
        return 1
    fi
    return 0
}

# リモートからフェッチ（タイムアウト付き）
fetch_remote() {
    cd "$SUBMODULE_PATH"

    # タイムアウト付きでfetch実行
    if command -v timeout >/dev/null 2>&1; then
        timeout "$FETCH_TIMEOUT" git fetch origin 2>/dev/null || {
            warn "リモートからの取得がタイムアウトしました（${FETCH_TIMEOUT}秒）"
            cd - >/dev/null
            return 1
        }
    else
        # timeoutコマンドがない場合は直接実行
        git fetch origin 2>/dev/null || {
            warn "リモートからの取得に失敗しました"
            cd - >/dev/null
            return 1
        }
    fi

    cd - >/dev/null
    return 0
}

# 更新の有無をチェック
check_updates_available() {
    cd "$SUBMODULE_PATH"

    # 現在のブランチを取得
    local current_branch
    current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "HEAD")

    # HEADが detached の場合、デフォルトブランチを使用
    if [ "$current_branch" = "HEAD" ]; then
        # リモートのデフォルトブランチを取得
        current_branch=$(git remote show origin 2>/dev/null | grep 'HEAD branch' | awk '{print $NF}' || echo "main")
    fi

    local local_commit remote_commit
    local_commit=$(git rev-parse HEAD 2>/dev/null)
    remote_commit=$(git rev-parse "origin/$current_branch" 2>/dev/null || git rev-parse "origin/main" 2>/dev/null || echo "")

    cd - >/dev/null

    if [ -z "$remote_commit" ]; then
        return 1  # リモート参照が取得できない
    fi

    if [ "$local_commit" != "$remote_commit" ]; then
        return 0  # 更新あり
    fi

    return 1  # 更新なし
}

# 更新件数を取得
get_update_count() {
    cd "$SUBMODULE_PATH"

    local current_branch
    current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "HEAD")

    if [ "$current_branch" = "HEAD" ]; then
        current_branch=$(git remote show origin 2>/dev/null | grep 'HEAD branch' | awk '{print $NF}' || echo "main")
    fi

    local count
    count=$(git rev-list --count HEAD.."origin/$current_branch" 2>/dev/null || git rev-list --count HEAD..origin/main 2>/dev/null || echo "0")

    cd - >/dev/null
    echo "$count"
}

# 変更内容を表示
show_changes() {
    cd "$SUBMODULE_PATH"

    local current_branch
    current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "HEAD")

    if [ "$current_branch" = "HEAD" ]; then
        current_branch=$(git remote show origin 2>/dev/null | grep 'HEAD branch' | awk '{print $NF}' || echo "main")
    fi

    info "主な変更内容:"
    git log --oneline HEAD.."origin/$current_branch" -n "$MAX_LOG_ENTRIES" 2>/dev/null | while read -r line; do
        echo "  - $line"
    done || git log --oneline HEAD..origin/main -n "$MAX_LOG_ENTRIES" 2>/dev/null | while read -r line; do
        echo "  - $line"
    done

    cd - >/dev/null
}

# サブモジュールを更新
update_submodule() {
    cd "$SUBMODULE_PATH"

    local current_branch
    current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "HEAD")

    if [ "$current_branch" = "HEAD" ]; then
        current_branch=$(git remote show origin 2>/dev/null | grep 'HEAD branch' | awk '{print $NF}' || echo "main")
    fi

    info "サブモジュールを更新中..."

    # デタッチされた状態でも更新できるようにmergeを使用
    git merge --ff-only "origin/$current_branch" 2>/dev/null || git merge --ff-only origin/main 2>/dev/null || {
        warn "自動マージに失敗しました。手動での更新が必要です"
        cd - >/dev/null
        return 1
    }

    local new_commit
    new_commit=$(git rev-parse --short HEAD)
    info "更新完了: $new_commit"

    cd - >/dev/null
    return 0
}

# 推奨アクションを表示
show_recommended_actions() {
    echo ""
    separator
    info "推奨アクション"
    separator
    echo ""
    echo "1. setup-project.shを再実行して設定を同期してください："
    echo ""
    echo "   ./instructions/ai_instruction_kits/scripts/setup-project.sh --auto --skip-instructions --submodule"
    echo ""
    echo "   （指示書以外のClaude Code設定、スクリプト等を自動更新）"
    echo ""
    echo "2. 必要に応じてAIにコミットを指示してください："
    echo "   「サブモジュール更新をコミットして」等"
    echo ""
}

# メイン処理
main() {
    # サブモジュールが存在しない場合は静かに終了
    if ! check_submodule_exists; then
        exit 0
    fi

    # リモートからフェッチ
    if ! fetch_remote; then
        exit 0  # フェッチ失敗時は静かに終了
    fi

    # 更新チェック
    if ! check_updates_available; then
        info "AI指示書システムは最新です"
        exit 0
    fi

    # 更新がある場合
    local update_count
    update_count=$(get_update_count)

    echo ""
    separator
    highlight "AI指示書システムに更新があります"
    separator
    echo ""
    info "未適用の更新: ${update_count}件"
    echo ""

    # 変更内容を表示
    show_changes
    echo ""

    # サブモジュールを更新
    if update_submodule; then
        # 推奨アクションを表示
        show_recommended_actions
    fi
}

# スクリプト実行
main "$@"
