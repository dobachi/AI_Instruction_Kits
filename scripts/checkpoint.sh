#!/bin/bash

# AI指示書チェックポイント管理スクリプト / AI Instruction Checkpoint Management Script

# i18nライブラリをソース
# シンボリックリンク経由でも動作するように実際のスクリプトパスを取得
REAL_PATH="$(readlink -f "${BASH_SOURCE[0]}" 2>/dev/null || realpath "${BASH_SOURCE[0]}" 2>/dev/null || echo "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(cd "$(dirname "$REAL_PATH")" && pwd)"

# i18n.shの存在を確認してから読み込む
if [ -f "$SCRIPT_DIR/lib/i18n.sh" ]; then
    source "$SCRIPT_DIR/lib/i18n.sh"
else
    # i18n.shが見つからない場合はフォールバック関数を定義
    get_message() {
        # 第2引数（英語）をデフォルトとして返す
        echo "$2"
    }
fi

CHECKPOINT_LOG="${CHECKPOINT_LOG:-checkpoint.log}"
ACTION=$1

# 現在時刻取得
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# 使用方法エラー表示
show_usage_error() {
    MSG_ERROR_SPECIFY_SUBCOMMAND=$(get_message "error_specify_subcommand" "Error: Please specify a subcommand" "Error: サブコマンドを指定してください")
    MSG_USAGE_HEADER=$(get_message "usage_header" "Usage" "使用方法")
    MSG_TASK_MANAGEMENT=$(get_message "task_management" "Task Management" "タスク管理")
    MSG_START_NEW_TASK=$(get_message "start_new_task" "Start a new task" "新しいタスクを開始")
    MSG_REPORT_PROGRESS=$(get_message "report_progress" "Report progress" "進捗を報告")
    MSG_COMPLETE_TASK=$(get_message "complete_task" "Complete task" "タスクを完了")
    MSG_REPORT_ERROR=$(get_message "report_error" "Report error" "エラーを報告")
    MSG_INSTRUCTION_MANAGEMENT=$(get_message "instruction_management" "Instruction Management" "指示書管理")
    MSG_INSTRUCTION_START_DESC=$(get_message "instruction_start_desc" "Start using instruction" "指示書使用開始")
    MSG_INSTRUCTION_COMPLETE_DESC=$(get_message "instruction_complete_desc" "Complete instruction" "指示書使用完了")
    MSG_STATUS_CHECK=$(get_message "status_check" "Status Check" "状態確認")
    MSG_PENDING_TASKS=$(get_message "pending_tasks" "List pending tasks" "未完了タスク一覧")
    MSG_TASK_DETAILS=$(get_message "task_details" "Show task details" "タスク詳細表示")
    MSG_SHOW_HELP=$(get_message "show_help" "Show help" "ヘルプ表示")
    MSG_EXAMPLES=$(get_message "examples" "Examples" "例")
    MSG_FOR_DETAILS=$(get_message "for_details" "For details, run" "詳細は")
    MSG_RUN_THIS=$(get_message "run_this" "" "を実行してください")
    
    cat << EOF
$MSG_ERROR_SPECIFY_SUBCOMMAND

$MSG_USAGE_HEADER: scripts/checkpoint.sh <command> [arguments]

$MSG_TASK_MANAGEMENT:
  start <name> <steps>              - $MSG_START_NEW_TASK
  progress <task-id> <cur> <total> <status> <next> - $MSG_REPORT_PROGRESS
  complete <task-id> <result>       - $MSG_COMPLETE_TASK
  error <task-id> <message>         - $MSG_REPORT_ERROR

$MSG_INSTRUCTION_MANAGEMENT:
  instruction-start <path> <purpose> [task-id]     - $MSG_INSTRUCTION_START_DESC
  instruction-complete <path> <result> [task-id]   - $MSG_INSTRUCTION_COMPLETE_DESC

$MSG_STATUS_CHECK:
  pending                           - $MSG_PENDING_TASKS
  summary <task-id>                 - $MSG_TASK_DETAILS
  help                              - $MSG_SHOW_HELP

$MSG_EXAMPLES:
  scripts/checkpoint.sh start "New feature" 5
  scripts/checkpoint.sh pending
  scripts/checkpoint.sh progress TASK-xxx 1 5 "Design complete" "Start implementation"

$MSG_FOR_DETAILS 'scripts/checkpoint.sh help'$MSG_RUN_THIS
EOF
}

# 未完了タスク表示
show_pending_tasks() {
    MSG_PENDING_TASKS_LIST=$(get_message "pending_tasks_list" "📋 Pending Tasks" "📋 未完了タスク一覧")
    MSG_NO_TASKS_RECORDED=$(get_message "no_tasks_recorded" "No tasks recorded yet" "タスクはまだ記録されていません")
    MSG_START_NEW_TASK_TIP=$(get_message "start_new_task_tip" "💡 Start a new task:" "💡 新しいタスクを開始:")
    MSG_TASK_NAME=$(get_message "task_name" "task name" "タスク名")
    MSG_STEPS=$(get_message "steps" "steps" "ステップ数")
    MSG_NO_PENDING_TASKS=$(get_message "no_pending_tasks" "No pending tasks" "未完了タスクはありません")
    MSG_TOTAL=$(get_message "total" "Total" "合計")
    MSG_PENDING_TASKS_COUNT=$(get_message "pending_tasks_count" "pending tasks" "件の未完了タスク")
    
    echo "$MSG_PENDING_TASKS_LIST"
    echo ""
    
    if [ ! -f "$CHECKPOINT_LOG" ]; then
        echo "$MSG_NO_TASKS_RECORDED"
        echo ""
        echo "$MSG_START_NEW_TASK_TIP"
        echo "   scripts/checkpoint.sh start \"$MSG_TASK_NAME\" <$MSG_STEPS>"
        return
    fi
    
    # すべてのSTARTエントリからタスクIDを取得
    local started_tasks=$(grep "\[START\]" "$CHECKPOINT_LOG" 2>/dev/null | \
                         awk -F'[][]' '{print $4}' | sort -u)
    
    if [ -z "$started_tasks" ]; then
        echo "$MSG_NO_TASKS_RECORDED"
        echo ""
        echo "$MSG_START_NEW_TASK_TIP"
        echo "   scripts/checkpoint.sh start \"$MSG_TASK_NAME\" <$MSG_STEPS>"
        return
    fi
    
    local count=0
    while IFS= read -r task_id; do
        # COMPLETEまたはERRORがあるかチェック
        if ! grep -q "\[$task_id\].*\[\(COMPLETE\|ERROR\)\]" "$CHECKPOINT_LOG" 2>/dev/null; then
            count=$((count + 1))
            show_task_summary "$task_id"
        fi
    done <<< "$started_tasks"
    
    if [ "$count" -eq 0 ]; then
        echo "$MSG_NO_PENDING_TASKS"
        echo ""
        echo "$MSG_START_NEW_TASK_TIP"
        echo "   scripts/checkpoint.sh start \"$MSG_TASK_NAME\" <$MSG_STEPS>"
    else
        echo ""
        echo "$MSG_TOTAL: ${count}$MSG_PENDING_TASKS_COUNT"
    fi
}

# タスクサマリー表示
show_task_summary() {
    local task_id="$1"
    local start_line=$(grep "\[$task_id\].*\[START\]" "$CHECKPOINT_LOG" | tail -1)
    
    if [ -z "$start_line" ]; then
        return
    fi
    
    # タスク名と開始時刻を抽出
    local task_info=$(echo "$start_line" | sed 's/.*\[START\] //')
    local task_name=$(echo "$task_info" | cut -d' ' -f1)
    local start_time=$(echo "$start_line" | cut -d']' -f1 | sed 's/\[//')
    
    MSG_STARTED=$(get_message "started" "Started" "開始")
    MSG_LATEST=$(get_message "latest" "Latest" "最新")
    
    echo "- $task_id: $task_name"
    echo "  $MSG_STARTED: $start_time"
    
    # 最新の状態を表示（進捗があれば）
    local latest_entry=$(grep "\[$task_id\]" "$CHECKPOINT_LOG" | tail -1)
    if [ "$latest_entry" != "$start_line" ]; then
        local entry_type=$(echo "$latest_entry" | grep -o '\[INSTRUCTION_START\]\|\[INSTRUCTION_COMPLETE\]\|\[ERROR\]' || echo "")
        if [ -n "$entry_type" ]; then
            echo "  $MSG_LATEST: $entry_type"
        fi
    fi
}

# AI実行検出関数
detect_ai_execution() {
    # 1. 環境変数チェック
    if [ "$CHECKPOINT_AI_MODE" = "true" ]; then
        return 0  # AI実行
    fi
    
    # 2. 実行パターン検出（1分以内の連続実行）
    local last_run_file=".checkpoint_last_run"
    local current_time=$(date +%s)
    
    if [ -f "$last_run_file" ]; then
        local last_time=$(cat "$last_run_file")
        local diff=$((current_time - last_time))
        
        if [ $diff -lt 60 ]; then
            # 1分以内の再実行はAI実行と判定
            echo $current_time > "$last_run_file"
            return 0  # AI実行
        fi
    fi
    
    echo $current_time > "$last_run_file"
    return 1  # 人間実行
}

# ログ書き込み関数（ファイルロック付き）
write_log() {
    local message="$1"
    local lockfile="$CHECKPOINT_LOG.lock"
    
    if command -v flock >/dev/null 2>&1; then
        (
            flock -x 200 || echo "Warning: ログファイルのロック取得に失敗" >&2
            echo "$message" >> "$CHECKPOINT_LOG"
        ) 200>"$lockfile"
    else
        echo "$message" >> "$CHECKPOINT_LOG"
    fi
}

# Claude Codeコマンドの更新チェック関数
check_claude_command_updates() {
    local updates_available=false
    local update_files=()
    
    # .claude/commands ディレクトリが存在する場合のみチェック
    if [ ! -d ".claude/commands" ]; then
        return
    fi
    
    for cmd in checkpoint.md commit-and-report.md reload-instructions.md; do
        src="$SCRIPT_DIR/../templates/claude-commands/$cmd"
        dst=".claude/commands/$cmd"
        
        if [ -f "$src" ] && [ -f "$dst" ]; then
            if ! diff -q "$src" "$dst" > /dev/null 2>&1; then
                updates_available=true
                update_files+=("$cmd")
            fi
        fi
    done
    
    if [ "$updates_available" = true ]; then
        MSG_CLAUDE_UPDATE=$(get_message "claude_update" "Claude Code commands have updates" "Claude Codeコマンドに更新があります")
        MSG_RUN_SYNC=$(get_message "run_sync" "Run" "実行")
        echo "📢 $MSG_CLAUDE_UPDATE: ${update_files[*]}"
        echo "   $MSG_RUN_SYNC: ./scripts/setup-project.sh --sync-claude-commands"
    fi
}

case "$ACTION" in
    "start")
        TASK_NAME=$2
        TOTAL_STEPS=$3
        
        # 引数チェック
        if [ -z "$TASK_NAME" ] || [ -z "$TOTAL_STEPS" ]; then
            MSG_ERROR_SPECIFY_TASK=$(get_message "error_specify_task" "Error: Please specify task name and number of steps" "Error: タスク名とステップ数を指定してください")
            MSG_USAGE=$(get_message "usage" "Usage" "使用方法")
            MSG_TASK_NAME=$(get_message "task_name" "task name" "タスク名")
            MSG_NUM_STEPS=$(get_message "num_steps" "steps" "ステップ数")
            echo "$MSG_ERROR_SPECIFY_TASK"
            echo "$MSG_USAGE: scripts/checkpoint.sh start <$MSG_TASK_NAME> <$MSG_NUM_STEPS>"
            exit 1
        fi
        
        # タスクID生成（タイムスタンプ + ランダム値）
        TASK_ID="TASK-$(date +%s%N | cut -c12-17)-$(openssl rand -hex 3)"
        
        # ログファイルに記録
        MSG_ESTIMATED=$(get_message "estimated" "estimated" "推定")
        MSG_STEPS=$(get_message "steps" "steps" "ステップ")
        write_log "[$TIMESTAMP] [$TASK_ID] [START] $TASK_NAME ($MSG_ESTIMATED${TOTAL_STEPS}$MSG_STEPS)"
        
        # 標準出力（タスクIDを強調）
        MSG_TASK_STARTED=$(get_message "task_started" "🚀 Task started" "🚀 タスク開始")
        MSG_TASK_ID=$(get_message "task_id" "📝 Task ID" "📝 タスクID")
        MSG_ESTIMATED_STEPS=$(get_message "estimated_steps" "📊 Estimated steps" "📊 推定ステップ")
        MSG_IMPORTANT_USE_ID=$(get_message "important_use_id" "Important: Use the above task ID for subsequent commands" "重要: 以降のコマンドでは上記のタスクIDを使用してください")
        MSG_NEXT_COMMANDS=$(get_message "next_commands" "Example commands" "次のコマンド例")
        MSG_INSTRUCTION_PATH=$(get_message "instruction_path" "instruction path" "指示書パス")
        MSG_PURPOSE=$(get_message "purpose" "purpose" "目的")
        MSG_START=$(get_message "start" "start" "開始")
        MSG_NEXT_STEP=$(get_message "next_step" "next step" "次のステップ")
        
        echo "\`$MSG_TASK_STARTED: $TASK_NAME\`"
        echo "\`$MSG_TASK_ID: $TASK_ID\`"
        echo "\`$MSG_ESTIMATED_STEPS: $TOTAL_STEPS\`"
        echo ""
        echo "\`$MSG_IMPORTANT_USE_ID\`"
        echo ""
        echo "$MSG_NEXT_COMMANDS:"
        echo "\`  scripts/checkpoint.sh instruction-start \"$MSG_INSTRUCTION_PATH\" \"$MSG_PURPOSE\" $TASK_ID\`"
        echo "\`  scripts/checkpoint.sh progress $TASK_ID 1 $TOTAL_STEPS \"$MSG_START\" \"$MSG_NEXT_STEP\"\`"
        ;;
        
    "progress")
        TASK_ID=$2
        CURRENT_STEP=$3
        TOTAL_STEPS=$4
        STATUS=$5
        NEXT_ACTION=$6
        
        # 引数チェック
        if [ -z "$TASK_ID" ] || [ -z "$CURRENT_STEP" ] || [ -z "$TOTAL_STEPS" ] || [ -z "$STATUS" ] || [ -z "$NEXT_ACTION" ]; then
            echo "Error: すべての引数を指定してください"
            echo "使用方法: scripts/checkpoint.sh progress <task-id> <current> <total> <status> <next>"
            exit 1
        fi
        
        # タスクの存在確認
        if ! grep -q "\[$TASK_ID\].*\[START\]" "$CHECKPOINT_LOG" 2>/dev/null; then
            echo "Error: タスクID '$TASK_ID' が見つかりません"
            echo "未完了タスクを確認: scripts/checkpoint.sh pending"
            exit 1
        fi
        
        # 既にCOMPLETEしていないか確認
        if grep -q "\[$TASK_ID\].*\[COMPLETE\]" "$CHECKPOINT_LOG" 2>/dev/null; then
            echo "Error: タスク '$TASK_ID' は既に完了しています"
            exit 1
        fi
        
        # 標準出力
        echo "\`[$CURRENT_STEP/$TOTAL_STEPS] $STATUS | 次: $NEXT_ACTION\`"
        echo "\`📌 タスクID: $TASK_ID\`"
        
        # ワークフロー検証（エラーレベル）
        instruction_count=$(grep "\[$TASK_ID\].*INSTRUCTION_START" "$CHECKPOINT_LOG" 2>/dev/null | wc -l)
        if [ "$instruction_count" -eq 0 ]; then
            MSG_WORKFLOW_ERROR_NO_INST=$(get_message "workflow_error_no_inst" "❌ Error: Workflow violation - No instructions are being used" "❌ Error: ワークフロー違反 - 指示書が使用されていません")
            MSG_MUST_USE_INST=$(get_message "must_use_inst" "You must use an instruction before reporting progress:" "進捗報告の前に指示書を使用する必要があります:")
            MSG_RECOMMENDED_INST=$(get_message "recommended_inst" "Recommended instructions:" "推奨される指示書:")
            
            echo ""
            echo "\`$MSG_WORKFLOW_ERROR_NO_INST\`"
            echo ""
            echo "$MSG_MUST_USE_INST"
            echo "  scripts/checkpoint.sh instruction-start <$(get_message "instruction_path" "instruction path" "指示書パス")> <$(get_message "purpose" "purpose" "目的")> $TASK_ID"
            echo ""
            echo "$MSG_RECOMMENDED_INST"
            echo "  - instructions/ja/system/ROOT_INSTRUCTION.md"
            echo "  - instructions/ja/presets/web_api_production.md"
            echo "  - instructions/ja/presets/cli_tool_basic.md"
            exit 1
        fi
        
        # アクティブな指示書があるか確認
        open_instructions=$(grep "\[$TASK_ID\].*INSTRUCTION_START" "$CHECKPOINT_LOG" 2>/dev/null | wc -l)
        completed_instructions=$(grep "\[$TASK_ID\].*INSTRUCTION_COMPLETE" "$CHECKPOINT_LOG" 2>/dev/null | wc -l)
        
        if [ "$open_instructions" -le "$completed_instructions" ]; then
            MSG_ALL_INST_COMPLETE=$(get_message "all_inst_complete" "⚠️  Warning: All instructions are completed" "⚠️  Warning: すべての指示書が完了しています")
            MSG_START_NEW_OR_COMPLETE=$(get_message "start_new_or_complete" "Start a new instruction or complete the task" "新しい指示書を開始するか、タスクを完了してください")
            echo ""
            echo "\`$MSG_ALL_INST_COMPLETE\`"
            echo "\`   $MSG_START_NEW_OR_COMPLETE\`"
        fi
        ;;
        
    "error")
        TASK_ID=$2
        ERROR_MSG=$3
        
        # 標準出力
        MSG_ERROR_OCCURRED=$(get_message "error_occurred" "Error occurred" "エラー発生")
        MSG_ACTION=$(get_message "action" "Action" "対処")
        MSG_CHECKING=$(get_message "checking" "Checking" "確認中")
        MSG_RECORDED=$(get_message "recorded" "Recorded to" "記録→")
        
        echo "\`[×] ⚠️ $MSG_ERROR_OCCURRED | $MSG_ACTION: $MSG_CHECKING\`"
        echo "\`📌 $MSG_RECORDED$CHECKPOINT_LOG: [$TIMESTAMP][$TASK_ID][ERROR] $ERROR_MSG\`"
        
        # ログファイルに記録
        echo "[$TIMESTAMP] [$TASK_ID] [ERROR] $ERROR_MSG" >> "$CHECKPOINT_LOG"
        ;;
        
    "complete")
        TASK_ID=$2
        RESULT=$3
        
        # 引数チェック
        if [ -z "$TASK_ID" ] || [ -z "$RESULT" ]; then
            echo "Error: タスクIDと成果を指定してください"
            echo "使用方法: scripts/checkpoint.sh complete <task-id> <result>"
            exit 1
        fi
        
        # タスクの存在確認
        if ! grep -q "\[$TASK_ID\].*\[START\]" "$CHECKPOINT_LOG" 2>/dev/null; then
            echo "Error: タスクID '$TASK_ID' が見つかりません"
            exit 1
        fi
        
        # 既にCOMPLETEしていないか確認
        if grep -q "\[$TASK_ID\].*\[COMPLETE\]" "$CHECKPOINT_LOG" 2>/dev/null; then
            echo "Error: タスク '$TASK_ID' は既に完了しています"
            exit 1
        fi
        
        # ワークフロー検証（エラーレベル）
        open_instructions=$(grep "\[$TASK_ID\].*INSTRUCTION_START" "$CHECKPOINT_LOG" 2>/dev/null | wc -l)
        completed_instructions=$(grep "\[$TASK_ID\].*INSTRUCTION_COMPLETE" "$CHECKPOINT_LOG" 2>/dev/null | wc -l)
        
        if [ "$open_instructions" -gt "$completed_instructions" ]; then
            echo "\`❌ Error: ワークフロー違反 - 未完了の指示書があります\`"
            echo "\`   開始: $open_instructions, 完了: $completed_instructions\`"
            echo ""
            echo "すべての指示書を完了してください:"
            
            # 未完了の指示書をリストアップ
            while IFS= read -r line; do
                if echo "$line" | grep -q "INSTRUCTION_START"; then
                    inst_path=$(echo "$line" | sed 's/.*INSTRUCTION_START\] //' | cut -d' ' -f1)
                    # この指示書が完了しているかチェック
                    if ! grep "\[$TASK_ID\].*INSTRUCTION_COMPLETE.*$inst_path" "$CHECKPOINT_LOG" >/dev/null 2>&1; then
                        echo "  - $inst_path"
                        echo "    scripts/checkpoint.sh instruction-complete \"$inst_path\" <成果> $TASK_ID"
                    fi
                fi
            done < <(grep "\[$TASK_ID\].*INSTRUCTION_START" "$CHECKPOINT_LOG" 2>/dev/null)
            
            exit 1
        fi
        
        # 指示書が一度も使用されていない場合の警告
        if [ "$open_instructions" -eq 0 ]; then
            echo "\`⚠️  Warning: 指示書が一度も使用されていません\`"
            echo "\`   タスクの品質を確保するため、指示書の使用を推奨します\`"
        fi
        
        # ログファイルに記録
        write_log "[$TIMESTAMP] [$TASK_ID] [COMPLETE] 成果: $RESULT"
        
        # 標準出力
        echo "\`✅ タスク完了: $TASK_ID\`"
        echo "\`📊 成果: $RESULT\`"
        ;;
        
    "instruction-start")
        INSTRUCTION_PATH=$2
        PURPOSE=$3
        TASK_ID=$4
        
        # 引数チェック
        if [ -z "$INSTRUCTION_PATH" ] || [ -z "$PURPOSE" ]; then
            echo "Error: 指示書パスと目的を指定してください"
            echo "使用方法: scripts/checkpoint.sh instruction-start <path> <purpose> [task-id]"
            exit 1
        fi
        
        # タスクIDの取得または検証
        if [ -z "$TASK_ID" ]; then
            # 最新の未完了タスクを取得（危険だが後方互換性のため）
            LATEST_TASK=$(grep "\[START\]" "$CHECKPOINT_LOG" 2>/dev/null | \
                         while IFS= read -r line; do
                             task_id=$(echo "$line" | awk -F'[][]' '{print $4}')
                             if ! grep -q "\[$task_id\].*\[COMPLETE\]" "$CHECKPOINT_LOG" 2>/dev/null; then
                                 echo "$task_id"
                             fi
                         done | tail -1)
            
            if [ -z "$LATEST_TASK" ]; then
                echo "Error: アクティブなタスクがありません"
                echo "タスクIDを明示的に指定してください"
                exit 1
            fi
            TASK_ID="$LATEST_TASK"
            echo "\`⚠️  Warning: タスクID未指定のため '$TASK_ID' を使用します\`"
        fi
        
        # ログファイルに記録
        write_log "[$TIMESTAMP] [$TASK_ID] [INSTRUCTION_START] $INSTRUCTION_PATH - $PURPOSE"
        
        # 標準出力
        echo "\`📚 指示書使用開始: $(basename "$INSTRUCTION_PATH")\`"
        echo "\`   目的: $PURPOSE\`"
        echo "\`📌 タスクID: $TASK_ID\`"
        ;;
        
    "instruction-complete")
        INSTRUCTION_PATH=$2
        RESULT=$3
        TASK_ID=$4
        
        # 引数チェック
        if [ -z "$INSTRUCTION_PATH" ] || [ -z "$RESULT" ]; then
            echo "Error: 指示書パスと成果を指定してください"
            echo "使用方法: scripts/checkpoint.sh instruction-complete <path> <result> [task-id]"
            exit 1
        fi
        
        # タスクIDの取得（instruction-startと同じロジック）
        if [ -z "$TASK_ID" ]; then
            LATEST_TASK=$(grep "\[START\]" "$CHECKPOINT_LOG" 2>/dev/null | \
                         while IFS= read -r line; do
                             task_id=$(echo "$line" | awk -F'[][]' '{print $4}')
                             if ! grep -q "\[$task_id\].*\[COMPLETE\]" "$CHECKPOINT_LOG" 2>/dev/null; then
                                 echo "$task_id"
                             fi
                         done | tail -1)
            
            if [ -z "$LATEST_TASK" ]; then
                echo "Error: アクティブなタスクがありません"
                exit 1
            fi
            TASK_ID="$LATEST_TASK"
        fi
        
        # ログファイルに記録
        write_log "[$TIMESTAMP] [$TASK_ID] [INSTRUCTION_COMPLETE] $INSTRUCTION_PATH - $RESULT"
        
        # 標準出力
        echo "\`✅ 指示書使用完了: $(basename "$INSTRUCTION_PATH")\`"
        echo "\`📊 成果: $RESULT\`"
        echo "\`📌 タスクID: $TASK_ID\`"
        ;;
        
    "status")
        # statusコマンドは後方互換性のため残す（将来削除予定）
        echo "⚠️ Warning: 'status'コマンドは非推奨です。'pending'を使用してください。"
        echo ""
        # pendingにフォールスルー
        ;&
        
    "pending")
        # 未完了タスクの一覧を表示
        show_pending_tasks
        ;;
        
    "summary")
        TASK_ID=$2
        
        # 引数チェック
        if [ -z "$TASK_ID" ]; then
            echo "Error: タスクIDを指定してください"
            echo "使用方法: scripts/checkpoint.sh summary <task-id>"
            echo ""
            echo "未完了タスクを確認: scripts/checkpoint.sh pending"
            exit 1
        fi
        
        # タスクの存在確認
        if ! grep -q "\[$TASK_ID\]" "$CHECKPOINT_LOG" 2>/dev/null; then
            echo "Error: タスクID '$TASK_ID' が見つかりません"
            exit 1
        fi
        
        echo "📋 タスク詳細: $TASK_ID"
        echo "=" | awk '{for(i=1;i<=50;i++)printf $0}'
        echo ""
        
        # タスクのすべてのエントリを時系列で表示
        grep "\[$TASK_ID\]" "$CHECKPOINT_LOG" | while IFS= read -r line; do
            # タイムスタンプを抽出
            timestamp=$(echo "$line" | sed 's/^\[\([^]]*\)\].*/\1/')
            # エントリタイプを抽出
            entry_type=$(echo "$line" | grep -o '\[START\]\|\[INSTRUCTION_START\]\|\[INSTRUCTION_COMPLETE\]\|\[ERROR\]\|\[COMPLETE\]' || echo "[UNKNOWN]")
            # 内容を抽出
            content=$(echo "$line" | sed 's/.*\] //')
            
            # タイプに応じたアイコンと表示
            case "$entry_type" in
                "[START]")
                    echo "🚀 $timestamp [開始]"
                    echo "   $content"
                    ;;
                "[INSTRUCTION_START]")
                    echo "📚 $timestamp [指示書開始]"
                    echo "   $content"
                    ;;
                "[INSTRUCTION_COMPLETE]")
                    echo "✅ $timestamp [指示書完了]"
                    echo "   $content"
                    ;;
                "[ERROR]")
                    echo "❌ $timestamp [エラー]"
                    echo "   $content"
                    ;;
                "[COMPLETE]")
                    echo "🎉 $timestamp [完了]"
                    echo "   $content"
                    ;;
                *)
                    echo "❓ $timestamp [不明]"
                    echo "   $content"
                    ;;
            esac
            echo ""
        done
        
        # サマリー統計
        echo "=" | awk '{for(i=1;i<=50;i++)printf $0}'
        echo ""
        
        # 統計情報を計算
        instruction_starts=$(grep "\[$TASK_ID\].*INSTRUCTION_START" "$CHECKPOINT_LOG" 2>/dev/null | wc -l)
        instruction_completes=$(grep "\[$TASK_ID\].*INSTRUCTION_COMPLETE" "$CHECKPOINT_LOG" 2>/dev/null | wc -l)
        errors=$(grep "\[$TASK_ID\].*ERROR" "$CHECKPOINT_LOG" 2>/dev/null | wc -l)
        is_complete=$(grep "\[$TASK_ID\].*COMPLETE" "$CHECKPOINT_LOG" 2>/dev/null | wc -l)
        
        echo "📊 統計:"
        echo "   指示書: 開始 $instruction_starts / 完了 $instruction_completes"
        echo "   エラー: $errors"
        if [ "$is_complete" -gt 0 ]; then
            echo "   状態: ✅ 完了"
        else
            echo "   状態: 🔄 進行中"
            if [ "$instruction_starts" -gt "$instruction_completes" ]; then
                echo ""
                echo "⚠️  未完了の指示書があります ($((instruction_starts - instruction_completes))件)"
            fi
        fi
        ;;
        
    "")
        # 引数なしの場合はエラー
        show_usage_error
        exit 1
        ;;
        
    "help")
        MSG_TITLE=$(get_message "title" "AI Instruction Checkpoint Management Script" "AI指示書チェックポイント管理スクリプト")
        MSG_USAGE=$(get_message "usage" "Usage" "使用方法")
        MSG_TASK_MGMT_CMDS=$(get_message "task_mgmt_cmds" "📋 Task Management Commands:" "📋 タスク管理コマンド:")
        MSG_START_DESC=$(get_message "start_desc" "Start a new task" "新しいタスクを開始します")
        MSG_PROGRESS_DESC=$(get_message "progress_desc" "Report task progress (requires: instruction in use)" "タスクの進捗を報告します（要: 指示書使用中）")
        MSG_COMPLETE_DESC=$(get_message "complete_desc" "Complete task (requires: all instructions completed)" "タスクを完了します（要: 指示書すべて完了）")
        MSG_ERROR_DESC=$(get_message "error_desc" "Report error" "エラーを報告します")
        MSG_INST_MGMT_CMDS=$(get_message "inst_mgmt_cmds" "📚 Instruction Management Commands:" "📚 指示書管理コマンド:")
        MSG_INST_START_DESC2=$(get_message "inst_start_desc2" "Start using an instruction" "指示書の使用を開始します")
        MSG_INST_COMPLETE_DESC2=$(get_message "inst_complete_desc2" "Complete instruction usage" "指示書の使用を完了します")
        MSG_STATUS_CMDS=$(get_message "status_cmds" "🔍 Status Check Commands:" "🔍 状態確認コマンド:")
        MSG_PENDING_DESC=$(get_message "pending_desc" "Show list of pending tasks" "未完了タスクの一覧を表示します")
        MSG_SUMMARY_DESC=$(get_message "summary_desc" "Show detailed task history" "タスクの詳細履歴を表示します")
        MSG_HELP_DESC=$(get_message "help_desc" "Show this help message" "このヘルプメッセージを表示します")
        MSG_WORKFLOW=$(get_message "workflow" "📝 Workflow:" "📝 ワークフロー:")
        MSG_START_TASK=$(get_message "start_task" "Start task" "タスク開始")
        MSG_START_INST=$(get_message "start_inst" "Start instruction" "指示書使用開始")
        MSG_REQUIRED=$(get_message "required" "Required" "必須")
        MSG_REPORT_PROG=$(get_message "report_prog" "Report progress" "進捗報告")
        MSG_COMPLETE_INST=$(get_message "complete_inst" "Complete instruction" "指示書使用完了")
        MSG_COMPLETE_TASK2=$(get_message "complete_task2" "Complete task" "タスク完了")
        MSG_IMPORTANT_CHANGES=$(get_message "important_changes" "⚠️  Important Changes:" "⚠️  重要な変更:")
        MSG_NO_ARGS_ERROR=$(get_message "no_args_error" "Running without arguments will cause an error" "引数なしでの実行はエラーになります")
        MSG_EXPLICIT_ID=$(get_message "explicit_id" "Task ID must be explicitly specified" "タスクIDは明示的に指定が必要です")
        MSG_PARALLEL_SUPPORT=$(get_message "parallel_support" "Supports parallel execution by multiple AI agents" "複数AIエージェントの並行実行に対応")
        MSG_EXAMPLE=$(get_message "example" "Example" "例")
        MSG_ENDPOINTS=$(get_message "endpoints" "endpoints" "エンドポイント")
        MSG_DESIGN_COMPLETE=$(get_message "design_complete" "Design complete" "設計完了")
        MSG_START_IMPL=$(get_message "start_impl" "Start implementation" "実装開始")
        MSG_IMPL_COMPLETE2=$(get_message "impl_complete2" "implementation complete" "実装完了")
        MSG_DEP_ERROR2=$(get_message "dep_error2" "Dependency error" "依存関係エラー")
        MSG_API_DEV=$(get_message "api_dev" "API development" "API開発")
        MSG_REST_API_DEV=$(get_message "rest_api_dev" "REST API development" "REST API開発")
        
        echo "$MSG_TITLE"
        echo "======================================="
        echo ""
        echo "$MSG_USAGE: scripts/checkpoint.sh <command> [arguments]"
        echo ""
        echo "$MSG_TASK_MGMT_CMDS"
        echo "  start <name> <steps>"
        echo "    $MSG_START_DESC"
        echo "    $MSG_EXAMPLE: scripts/checkpoint.sh start \"$MSG_API_DEV\" 5"
        echo ""
        echo "  progress <task-id> <current> <total> <status> <next>"
        echo "    $MSG_PROGRESS_DESC"
        echo "    $MSG_EXAMPLE: scripts/checkpoint.sh progress TASK-xxx 2 5 \"$MSG_DESIGN_COMPLETE\" \"$MSG_START_IMPL\""
        echo ""
        echo "  complete <task-id> <result>"
        echo "    $MSG_COMPLETE_DESC"
        echo "    $MSG_EXAMPLE: scripts/checkpoint.sh complete TASK-xxx \"3$MSG_ENDPOINTS$MSG_IMPL_COMPLETE2\""
        echo ""
        echo "  error <task-id> <message>"
        echo "    $MSG_ERROR_DESC"
        echo "    $MSG_EXAMPLE: scripts/checkpoint.sh error TASK-xxx \"$MSG_DEP_ERROR2\""
        echo ""
        echo "$MSG_INST_MGMT_CMDS"
        echo "  instruction-start <path> <purpose> [task-id]"
        echo "    $MSG_INST_START_DESC2"
        echo "    $MSG_EXAMPLE: scripts/checkpoint.sh instruction-start \"instructions/ja/presets/web_api.md\" \"$MSG_REST_API_DEV\" TASK-xxx"
        echo ""
        echo "  instruction-complete <path> <result> [task-id]"
        echo "    $MSG_INST_COMPLETE_DESC2"
        echo "    $MSG_EXAMPLE: scripts/checkpoint.sh instruction-complete \"instructions/ja/presets/web_api.md\" \"3$MSG_ENDPOINTS\" TASK-xxx"
        echo ""
        echo "$MSG_STATUS_CMDS"
        echo "  pending"
        echo "    $MSG_PENDING_DESC"
        echo "    $MSG_EXAMPLE: scripts/checkpoint.sh pending"
        echo ""
        echo "  summary <task-id>"
        echo "    $MSG_SUMMARY_DESC"
        echo "    $MSG_EXAMPLE: scripts/checkpoint.sh summary TASK-xxx"
        echo ""
        echo "  help"
        echo "    $MSG_HELP_DESC"
        echo ""
        echo "$MSG_WORKFLOW"
        echo "  1. $MSG_START_TASK (start)"
        echo "  2. $MSG_START_INST (instruction-start) ※$MSG_REQUIRED"
        echo "  3. $MSG_REPORT_PROG (progress)"
        echo "  4. $MSG_COMPLETE_INST (instruction-complete)"
        echo "  5. $MSG_COMPLETE_TASK2 (complete)"
        echo ""
        echo "$MSG_IMPORTANT_CHANGES"
        echo "  - $MSG_NO_ARGS_ERROR"
        echo "  - $MSG_EXPLICIT_ID"
        echo "  - $MSG_PARALLEL_SUPPORT"
        echo ""
        ;;
        
    *)
        # 不明なコマンド
        MSG_UNKNOWN_COMMAND=$(get_message "unknown_command" "Error: Unknown command" "Error: 不明なコマンド")
        echo "$MSG_UNKNOWN_COMMAND '$ACTION'"
        echo ""
        show_usage_error
        exit 1
        ;;
esac