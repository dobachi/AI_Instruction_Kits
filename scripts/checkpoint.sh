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
        TASK_ID=$2
        TASK_NAME=$3
        TOTAL_STEPS=$4
        
        # 標準出力
        MSG_START=$(get_message "start" "Starting" "開始")
        MSG_NEXT=$(get_message "next" "Next" "次")
        MSG_ANALYSIS=$(get_message "analysis" "Analysis" "分析")
        MSG_RECORDED=$(get_message "recorded" "Recorded to" "記録→")
        MSG_ESTIMATED=$(get_message "estimated" "estimated" "推定")
        MSG_STEPS=$(get_message "steps" "steps" "ステップ")
        
        echo "\`[1/$TOTAL_STEPS] $MSG_START | $MSG_NEXT: $MSG_ANALYSIS\`"
        echo "\`📌 $MSG_RECORDED$CHECKPOINT_LOG: [$TIMESTAMP][$TASK_ID][START] $TASK_NAME (${MSG_ESTIMATED}${TOTAL_STEPS}${MSG_STEPS})\`"
        
        # ログファイルに記録
        echo "[$TIMESTAMP] [$TASK_ID] [START] $TASK_NAME (推定${TOTAL_STEPS}ステップ)" >> "$CHECKPOINT_LOG"
        ;;
        
    "progress")
        CURRENT_STEP=$2
        TOTAL_STEPS=$3
        STATUS=$4
        NEXT_ACTION=$5
        
        # 標準出力のみ（ログファイルには記録しない）
        MSG_NEXT=$(get_message "next" "Next" "次")
        MSG_RECORDED=$(get_message "recorded" "Recorded to" "記録→")
        MSG_LOG_TIMING=$(get_message "log_timing" "Only logged at start/error/completion" "開始時/エラー時/完了時のみ記録")
        
        echo "\`[$CURRENT_STEP/$TOTAL_STEPS] $STATUS | $MSG_NEXT: $NEXT_ACTION\`"
        echo "\`📌 $MSG_RECORDED$CHECKPOINT_LOG: $MSG_LOG_TIMING\`"
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
        
        # 標準出力
        MSG_ALL_COMPLETE=$(get_message "all_complete" "All completed" "全完了")
        MSG_RESULT=$(get_message "result" "Result" "成果")
        MSG_RECORDED=$(get_message "recorded" "Recorded to" "記録→")
        
        echo "\`[✓] $MSG_ALL_COMPLETE | $MSG_RESULT: $RESULT\`"
        echo "\`📌 $MSG_RECORDED$CHECKPOINT_LOG: [$TIMESTAMP][$TASK_ID][COMPLETE] $MSG_RESULT: $RESULT\`"
        
        # ログファイルに記録
        echo "[$TIMESTAMP] [$TASK_ID] [COMPLETE] 成果: $RESULT" >> "$CHECKPOINT_LOG"
        ;;
        
    "instruction-start")
        INSTRUCTION_PATH=$2
        PURPOSE=$3
        TASK_ID=$4
        
        # 現在のタスクIDを取得（未指定の場合は最新のタスクから）
        if [ -z "$TASK_ID" ] && [ -f "$CHECKPOINT_LOG" ]; then
            # 最新のSTARTエントリからタスクIDを抽出
            LATEST_START=$(grep "] \[START\]" "$CHECKPOINT_LOG" | tail -1)
            TASK_ID=$(echo "$LATEST_START" | sed 's/.*\] \[\([^]]*\)\] \[START\].*/\1/')
        fi
        
        # 標準出力
        MSG_INSTRUCTION_START=$(get_message "instruction_start" "Starting instruction" "指示書使用開始")
        MSG_RECORDED=$(get_message "recorded" "Recorded to" "記録→")
        MSG_PURPOSE=$(get_message "purpose" "Purpose" "目的")
        
        echo "\`📚 $MSG_INSTRUCTION_START: $(basename "$INSTRUCTION_PATH")\`"
        if [ -n "$PURPOSE" ]; then
            echo "\`   $MSG_PURPOSE: $PURPOSE\`"
        fi
        echo "\`📌 $MSG_RECORDED$CHECKPOINT_LOG: [$TIMESTAMP][$TASK_ID][INSTRUCTION_START] $INSTRUCTION_PATH${PURPOSE:+ - $PURPOSE}\`"
        
        # ログファイルに記録
        echo "[$TIMESTAMP] [$TASK_ID] [INSTRUCTION_START] $INSTRUCTION_PATH${PURPOSE:+ - $PURPOSE}" >> "$CHECKPOINT_LOG"
        ;;
        
    "instruction-complete")
        INSTRUCTION_PATH=$2
        RESULT=$3
        TASK_ID=$4
        
        # 現在のタスクIDを取得（未指定の場合は最新のタスクから）
        if [ -z "$TASK_ID" ] && [ -f "$CHECKPOINT_LOG" ]; then
            # 最新のSTARTエントリからタスクIDを抽出
            LATEST_START=$(grep "] \[START\]" "$CHECKPOINT_LOG" | tail -1)
            TASK_ID=$(echo "$LATEST_START" | sed 's/.*\] \[\([^]]*\)\] \[START\].*/\1/')
        fi
        
        # 標準出力
        MSG_INSTRUCTION_COMPLETE=$(get_message "instruction_complete" "Instruction completed" "指示書使用完了")
        MSG_RECORDED=$(get_message "recorded" "Recorded to" "記録→")
        
        echo "\`✅ $MSG_INSTRUCTION_COMPLETE: $(basename "$INSTRUCTION_PATH")\`"
        echo "\`📌 $MSG_RECORDED$CHECKPOINT_LOG: [$TIMESTAMP][$TASK_ID][INSTRUCTION_COMPLETE] $INSTRUCTION_PATH - $RESULT\`"
        
        # ログファイルに記録
        echo "[$TIMESTAMP] [$TASK_ID] [INSTRUCTION_COMPLETE] $INSTRUCTION_PATH - $RESULT" >> "$CHECKPOINT_LOG"
        ;;
        
    "status"|"")
        # 引数なしまたはstatusの場合、現在の状態を表示
        # Claude Codeコマンドの更新チェック（status時のみ）
        check_claude_command_updates
        
        if [ -f "$CHECKPOINT_LOG" ]; then
            # 最新のタスク情報を取得
            LATEST_TASK=$(grep -E "\[START\]|\[COMPLETE\]|\[ERROR\]" "$CHECKPOINT_LOG" | tail -1)
            if [ -n "$LATEST_TASK" ]; then
                MSG_LATEST_TASK=$(get_message "latest_task" "Latest task" "最新タスク")
                MSG_CURRENT_TASK=$(get_message "current_task" "Current task" "現在のタスク")
                MSG_COMPLETED=$(get_message "completed" "Completed" "完了済み")
                MSG_ERROR_OCCURRED=$(get_message "error_occurred" "Error occurred" "エラー発生")
                
                if echo "$LATEST_TASK" | grep -q "\[COMPLETE\]"; then
                    echo "\`📊 $MSG_LATEST_TASK: $MSG_COMPLETED\`"
                    # 新しいタスク開始を促す
                    MSG_READY_FOR_NEW=$(get_message "ready_for_new" "🎯 Ready for new task - use 'scripts/checkpoint.sh start <task-id> <name> <steps>' when starting work" "🎯 新規タスク準備完了 - 作業開始時は 'scripts/checkpoint.sh start <task-id> <name> <steps>' を使用")
                    echo "\`$MSG_READY_FOR_NEW\`"
                elif echo "$LATEST_TASK" | grep -q "\[ERROR\]"; then
                    echo "\`📊 $MSG_LATEST_TASK: $MSG_ERROR_OCCURRED\`"
                    # エラー時の対応促し
                    MSG_ERROR_RECOVERY=$(get_message "error_recovery" "⚠️ Previous task had errors - address issues or start new task" "⚠️ 前回タスクでエラー - 問題解決または新規タスク開始")
                    echo "\`$MSG_ERROR_RECOVERY\`"
                else
                    # 進行中のタスク
                    TASK_INFO=$(echo "$LATEST_TASK" | sed 's/.*\[START\] //')
                    echo "\`📊 $MSG_CURRENT_TASK: $TASK_INFO\`"
                    # 進行中タスクの継続促し
                    MSG_CONTINUE_WORK=$(get_message "continue_work" "🔄 Task in progress - continue with next steps or use 'progress/complete/error' commands" "🔄 タスク進行中 - 次のステップを続行するか 'progress/complete/error' コマンドを使用")
                    echo "\`$MSG_CONTINUE_WORK\`"
                fi
                MSG_DETAILS=$(get_message "details" "Details" "詳細")
                MSG_TASK_RECORDS=$(get_message "task_records" "task records" "件のタスク記録")
                TASK_COUNT=$(grep -c "START" "$CHECKPOINT_LOG" 2>/dev/null || echo 0)
                echo "\`📌 $MSG_DETAILS→$CHECKPOINT_LOG (${TASK_COUNT}${MSG_TASK_RECORDS})\`"
            else
                MSG_TASK=$(get_message "task" "Task" "タスク")
                MSG_NOT_STARTED=$(get_message "not_started" "Not started" "未開始")
                MSG_NEW_TASK=$(get_message "new_task" "Start new task with" "新規タスクは")
                MSG_START_WITH=$(get_message "start_with" "to start" "で開始")
                
                echo "\`📊 $MSG_TASK: $MSG_NOT_STARTED\`"
                echo "\`📌 $MSG_NEW_TASK 'scripts/checkpoint.sh start' $MSG_START_WITH\`"
            fi
        else
            MSG_CHECKPOINT=$(get_message "checkpoint" "Checkpoint" "チェックポイント")
            MSG_FIRST_RUN=$(get_message "first_run" "First run" "初回起動")
            MSG_LOG_FILE=$(get_message "log_file" "Log file" "ログファイル")
            MSG_TO_BE_CREATED=$(get_message "to_be_created" "to be created" "作成予定")
            
            echo "\`📊 $MSG_CHECKPOINT: $MSG_FIRST_RUN\`"
            echo "\`📌 $MSG_LOG_FILE→$CHECKPOINT_LOG ($MSG_TO_BE_CREATED)\`"
        fi
        ;;
        
    "help"|*)
        MSG_USAGE=$(get_message "usage" "Usage" "使用方法")
        MSG_SHOW_STATUS=$(get_message "show_status" "Show current status" "現在の状態を表示")
        MSG_DEFAULT=$(get_message "default" "default" "デフォルト")
        MSG_EXAMPLE=$(get_message "example" "Example" "例")
        MSG_WEB_APP_DEV=$(get_message "web_app_dev" "Web app development" "Webアプリ開発")
        MSG_IMPL_COMPLETE=$(get_message "impl_complete" "Implementation complete" "実装完了")
        MSG_CREATE_TESTS=$(get_message "create_tests" "Create tests" "テスト作成")
        MSG_DEP_ERROR=$(get_message "dep_error" "Dependency error" "依存関係エラー")
        MSG_APIS_TESTS=$(get_message "apis_tests" "3 APIs, 10 tests created" "API 3つ、テスト10個作成")
        MSG_INSTRUCTION_USAGE=$(get_message "instruction_usage" "Instruction usage tracking" "指示書使用記録")
        
        echo "$MSG_USAGE:"
        echo "  $0              # $MSG_SHOW_STATUS ($MSG_DEFAULT)"
        echo "  $0 status       # $MSG_SHOW_STATUS"
        echo "  $0 start <task-id> <task-name> <total-steps>"
        echo "  $0 progress <current-step> <total-steps> <status> <next-action>"
        echo "  $0 error <task-id> <error-message>"
        echo "  $0 complete <task-id> <result>"
        echo "  $0 instruction-start <instruction-path> [purpose] [task-id]  # $MSG_INSTRUCTION_USAGE"
        echo "  $0 instruction-complete <instruction-path> <result> [task-id]"
        echo ""
        echo "$MSG_EXAMPLE:"
        echo "  $0 start TASK-abc123 '$MSG_WEB_APP_DEV' 5"
        echo "  $0 progress 2 5 '$MSG_IMPL_COMPLETE' '$MSG_CREATE_TESTS'"
        echo "  $0 error TASK-abc123 '$MSG_DEP_ERROR'"
        echo "  $0 complete TASK-abc123 '$MSG_APIS_TESTS'"
        echo "  $0 instruction-start 'instructions/ja/presets/web_api_production.md' 'REST API開発'"
        echo "  $0 instruction-complete 'instructions/ja/presets/web_api_production.md' 'API実装完了'"
        exit 1
        ;;
esac