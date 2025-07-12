#!/bin/bash

# AI指示書チェックポイント管理スクリプト / AI Instruction Checkpoint Management Script

# i18nライブラリをソース
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/i18n.sh"

CHECKPOINT_LOG="${CHECKPOINT_LOG:-checkpoint.log}"
ACTION=$1

# 現在時刻取得
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

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
        
    "status"|"")
        # 引数なしまたはstatusの場合、現在の状態を表示
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
                elif echo "$LATEST_TASK" | grep -q "\[ERROR\]"; then
                    echo "\`📊 $MSG_LATEST_TASK: $MSG_ERROR_OCCURRED\`"
                else
                    # 進行中のタスク
                    TASK_INFO=$(echo "$LATEST_TASK" | sed 's/.*\[START\] //')
                    echo "\`📊 $MSG_CURRENT_TASK: $TASK_INFO\`"
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
        
        echo "$MSG_USAGE:"
        echo "  $0              # $MSG_SHOW_STATUS ($MSG_DEFAULT)"
        echo "  $0 status       # $MSG_SHOW_STATUS"
        echo "  $0 start <task-id> <task-name> <total-steps>"
        echo "  $0 progress <current-step> <total-steps> <status> <next-action>"
        echo "  $0 error <task-id> <error-message>"
        echo "  $0 complete <task-id> <result>"
        echo ""
        echo "$MSG_EXAMPLE:"
        echo "  $0 start TASK-abc123 '$MSG_WEB_APP_DEV' 5"
        echo "  $0 progress 2 5 '$MSG_IMPL_COMPLETE' '$MSG_CREATE_TESTS'"
        echo "  $0 error TASK-abc123 '$MSG_DEP_ERROR'"
        echo "  $0 complete TASK-abc123 '$MSG_APIS_TESTS'"
        exit 1
        ;;
esac