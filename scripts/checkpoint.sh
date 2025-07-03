#!/bin/bash

# AI指示書チェックポイント管理スクリプト
# 使用方法:
#   ./checkpoint.sh start <task-id> <task-name> <total-steps>
#   ./checkpoint.sh progress <current-step> <total-steps> <status> <next-action>
#   ./checkpoint.sh error <task-id> <error-message>
#   ./checkpoint.sh complete <task-id> <result>

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
        echo "\`[1/$TOTAL_STEPS] 開始 | 次: 分析\`"
        echo "\`📌 記録→$CHECKPOINT_LOG: [$TIMESTAMP][$TASK_ID][START] $TASK_NAME (推定${TOTAL_STEPS}ステップ)\`"
        
        # ログファイルに記録
        echo "[$TIMESTAMP] [$TASK_ID] [START] $TASK_NAME (推定${TOTAL_STEPS}ステップ)" >> "$CHECKPOINT_LOG"
        ;;
        
    "progress")
        CURRENT_STEP=$2
        TOTAL_STEPS=$3
        STATUS=$4
        NEXT_ACTION=$5
        
        # 標準出力のみ（ログファイルには記録しない）
        echo "\`[$CURRENT_STEP/$TOTAL_STEPS] $STATUS | 次: $NEXT_ACTION\`"
        echo "\`📌 記録→$CHECKPOINT_LOG: 開始時/エラー時/完了時のみ記録\`"
        ;;
        
    "error")
        TASK_ID=$2
        ERROR_MSG=$3
        
        # 標準出力
        echo "\`[×] ⚠️ エラー発生 | 対処: 確認中\`"
        echo "\`📌 記録→$CHECKPOINT_LOG: [$TIMESTAMP][$TASK_ID][ERROR] $ERROR_MSG\`"
        
        # ログファイルに記録
        echo "[$TIMESTAMP] [$TASK_ID] [ERROR] $ERROR_MSG" >> "$CHECKPOINT_LOG"
        ;;
        
    "complete")
        TASK_ID=$2
        RESULT=$3
        
        # 標準出力
        echo "\`[✓] 全完了 | 成果: $RESULT\`"
        echo "\`📌 記録→$CHECKPOINT_LOG: [$TIMESTAMP][$TASK_ID][COMPLETE] 成果: $RESULT\`"
        
        # ログファイルに記録
        echo "[$TIMESTAMP] [$TASK_ID] [COMPLETE] 成果: $RESULT" >> "$CHECKPOINT_LOG"
        ;;
        
    "help"|*)
        echo "使用方法:"
        echo "  $0 start <task-id> <task-name> <total-steps>"
        echo "  $0 progress <current-step> <total-steps> <status> <next-action>"
        echo "  $0 error <task-id> <error-message>"
        echo "  $0 complete <task-id> <result>"
        echo ""
        echo "例:"
        echo "  $0 start TASK-abc123 'Webアプリ開発' 5"
        echo "  $0 progress 2 5 '実装完了' 'テスト作成'"
        echo "  $0 error TASK-abc123 '依存関係エラー'"
        echo "  $0 complete TASK-abc123 'API 3つ、テスト10個作成'"
        exit 1
        ;;
esac