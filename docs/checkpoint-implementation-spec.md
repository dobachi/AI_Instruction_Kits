# checkpoint.sh 実装仕様書

## 基本設計方針
- **「現在のタスク」という概念を廃止**
- **すべての操作でタスクIDを明示的に指定**
- **並行実行を前提とした設計**
- **ワークフロー制約により作業品質を保証**

## ワークフロー定義

### 基本フロー
```
1. タスク開始 (start)
   ↓
2. 指示書使用開始 (instruction-start) ※必須
   ↓
3. 進捗報告 (progress) ※指示書使用中のみ可能
   ↓
4. 指示書使用完了 (instruction-complete)
   ↓
5. タスク完了 (complete) または 2に戻る
```

### ワークフロー制約
1. **進捗報告の前提条件**
   - 少なくとも1つの`instruction-start`が実行済み
   - アクティブな指示書がある（`instruction-complete`されていない）

2. **タスク完了の前提条件**
   - すべての指示書が完了済み（開いた指示書がない）
   - 少なくとも1つの進捗報告がある

3. **指示書の入れ子禁止**
   - 1つの指示書を完了する前に別の指示書を開始した場合は警告

## Phase 1: 基本実装

### 1. 引数なし実行時のエラー処理

```bash
if [ -z "$ACTION" ]; then
    show_usage_error
    exit 1
fi

show_usage_error() {
    cat << EOF
Error: サブコマンドを指定してください

使用方法: scripts/checkpoint.sh <command> [arguments]

タスク管理:
  start <name> <steps>              - 新しいタスクを開始
  progress <task-id> <cur> <total> <status> <next> - 進捗を報告
  complete <task-id> <result>       - タスクを完了
  error <task-id> <message>         - エラーを報告

指示書管理:
  instruction-start <path> <purpose> [task-id]     - 指示書使用開始
  instruction-complete <path> <result> [task-id]   - 指示書使用完了

状態確認:
  pending                           - 未完了タスク一覧
  summary <task-id>                 - タスク詳細表示
  help                              - ヘルプ表示

例:
  scripts/checkpoint.sh start "新機能開発" 5
  → タスクID: TASK-4321-abc123

  scripts/checkpoint.sh instruction-start "instructions/ja/presets/web_api.md" "API開発"
  scripts/checkpoint.sh progress TASK-4321-abc123 1 5 "設計完了" "実装開始"
  scripts/checkpoint.sh instruction-complete "instructions/ja/presets/web_api.md" "3エンドポイント実装"
  scripts/checkpoint.sh complete TASK-4321-abc123 "機能実装完了"
EOF
}
```

### 2. ワークフロー状態管理

```bash
# グローバル変数
WORKFLOW_DIR=".checkpoint/workflows"

# ワークフロー状態の初期化
init_workflow() {
    mkdir -p "$WORKFLOW_DIR"
}

# タスクのワークフロー状態を取得
get_task_workflow_state() {
    local task_id="$1"
    local state_file="$WORKFLOW_DIR/$task_id.state"
    
    if [ ! -f "$state_file" ]; then
        # ログから状態を再構築
        reconstruct_workflow_state "$task_id"
    fi
    
    if [ -f "$state_file" ]; then
        cat "$state_file"
    else
        echo "{}"
    fi
}

# ワークフロー状態を保存
save_workflow_state() {
    local task_id="$1"
    local state="$2"
    local state_file="$WORKFLOW_DIR/$task_id.state"
    
    echo "$state" > "$state_file"
}

# ログから状態を再構築（移行用）
reconstruct_workflow_state() {
    local task_id="$1"
    local active_instructions=()
    
    # 指示書の開始と完了を追跡
    while IFS= read -r line; do
        if echo "$line" | grep -q "INSTRUCTION_START"; then
            local inst_path=$(echo "$line" | sed 's/.*INSTRUCTION_START\] //' | cut -d' ' -f1)
            active_instructions+=("$inst_path")
        elif echo "$line" | grep -q "INSTRUCTION_COMPLETE"; then
            local inst_path=$(echo "$line" | sed 's/.*INSTRUCTION_COMPLETE\] //' | cut -d' ' -f1)
            active_instructions=("${active_instructions[@]/$inst_path}")
        fi
    done < <(grep "\[$task_id\]" "$CHECKPOINT_LOG" 2>/dev/null)
    
    # 状態をJSON形式で保存
    local state="{\"active_instructions\": ["
    local first=true
    for inst in "${active_instructions[@]}"; do
        if [ -n "$inst" ]; then
            if [ "$first" = true ]; then
                first=false
            else
                state+=", "
            fi
            state+="\"$inst\""
        fi
    done
    state+="]}"
    
    save_workflow_state "$task_id" "$state"
}
```

### 3. progressコマンドのワークフロー検証

```bash
"progress")
    TASK_ID=$2
    CURRENT_STEP=$3
    TOTAL_STEPS=$4
    STATUS=$5
    NEXT_ACTION=$6
    
    # タスクの存在確認
    if ! grep -q "\[$TASK_ID\].*\[START\]" "$CHECKPOINT_LOG" 2>/dev/null; then
        echo "Error: タスクID '$TASK_ID' が見つかりません"
        exit 1
    fi
    
    # ワークフロー検証
    if ! validate_progress_workflow "$TASK_ID"; then
        exit 1
    fi
    
    # 出力
    echo "\`[$CURRENT_STEP/$TOTAL_STEPS] $STATUS | 次: $NEXT_ACTION\`"
    echo "\`📌 タスクID: $TASK_ID\`"
    ;;

validate_progress_workflow() {
    local task_id="$1"
    
    # 指示書使用履歴を確認
    local instruction_count=$(grep "\[$task_id\].*INSTRUCTION_START" "$CHECKPOINT_LOG" 2>/dev/null | wc -l)
    
    if [ "$instruction_count" -eq 0 ]; then
        echo "❌ Error: ワークフロー違反 - 指示書が使用されていません"
        echo ""
        echo "進捗報告の前に指示書を使用する必要があります:"
        echo "  scripts/checkpoint.sh instruction-start <指示書パス> <目的>"
        echo ""
        echo "推奨される指示書:"
        echo "  - instructions/ja/presets/web_api_production.md"
        echo "  - instructions/ja/presets/cli_tool_basic.md"
        echo "  - instructions/ja/system/ROOT_INSTRUCTION.md"
        return 1
    fi
    
    # アクティブな指示書があるか確認
    local state=$(get_task_workflow_state "$task_id")
    local active_count=$(echo "$state" | grep -o "active_instructions" | wc -l)
    
    if [ "$active_count" -eq 0 ]; then
        echo "⚠️ Warning: すべての指示書が完了しています"
        echo "新しい指示書を開始するか、タスクを完了してください"
    fi
    
    return 0
}
```

### 4. completeコマンドのワークフロー検証

```bash
"complete")
    TASK_ID=$2
    RESULT=$3
    
    # タスクの存在確認
    if ! grep -q "\[$TASK_ID\].*\[START\]" "$CHECKPOINT_LOG" 2>/dev/null; then
        echo "Error: タスクID '$TASK_ID' が見つかりません"
        exit 1
    fi
    
    # ワークフロー検証
    if ! validate_complete_workflow "$TASK_ID"; then
        exit 1
    fi
    
    # ログ記録
    write_log "[$TIMESTAMP] [$TASK_ID] [COMPLETE] 成果: $RESULT"
    
    # ワークフロー状態をクリア
    rm -f "$WORKFLOW_DIR/$TASK_ID.state"
    
    # 出力
    echo "\`✅ タスク完了: $TASK_ID\`"
    echo "\`📊 成果: $RESULT\`"
    ;;

validate_complete_workflow() {
    local task_id="$1"
    
    # 未完了の指示書がないか確認
    local state=$(get_task_workflow_state "$task_id")
    local active_instructions=$(echo "$state" | grep -o '"[^"]*"' | grep -v "active_instructions" | tr -d '"')
    
    if [ -n "$active_instructions" ]; then
        echo "❌ Error: ワークフロー違反 - 未完了の指示書があります"
        echo ""
        echo "以下の指示書を完了してください:"
        echo "$active_instructions" | while IFS= read -r inst; do
            echo "  - $inst"
            echo "    scripts/checkpoint.sh instruction-complete \"$inst\" <成果>"
        done
        return 1
    fi
    
    # 進捗報告があるか確認
    local progress_count=$(grep "\[$task_id\]" "$CHECKPOINT_LOG" | grep -c "progress\|PROGRESS" || true)
    
    if [ "$progress_count" -eq 0 ]; then
        echo "⚠️ Warning: 進捗報告がありません"
        echo "タスクの作業内容が不明確です"
    fi
    
    return 0
}
```

### 5. instruction-startの改善

```bash
"instruction-start")
    INSTRUCTION_PATH=$2
    PURPOSE=$3
    TASK_ID=$4
    
    # タスクIDの自動取得または検証
    if [ -z "$TASK_ID" ]; then
        # 最新の未完了タスクから推測（危険だが互換性のため）
        TASK_ID=$(get_latest_active_task)
        if [ -z "$TASK_ID" ]; then
            echo "Error: アクティブなタスクがありません"
            echo "タスクIDを明示的に指定してください"
            exit 1
        fi
        echo "⚠️ Warning: タスクID未指定のため '$TASK_ID' を使用します"
    fi
    
    # 既に同じ指示書が使用中でないか確認
    local state=$(get_task_workflow_state "$TASK_ID")
    if echo "$state" | grep -q "$INSTRUCTION_PATH"; then
        echo "⚠️ Warning: この指示書は既に使用中です"
    fi
    
    # 別の指示書が未完了でないか確認
    local active_count=$(echo "$state" | grep -o '"[^"]*"' | grep -v "active_instructions" | wc -c)
    if [ "$active_count" -gt 0 ]; then
        echo "⚠️ Warning: 別の指示書が未完了です"
        echo "入れ子の指示書使用は推奨されません"
    fi
    
    # ログ記録
    write_log "[$TIMESTAMP] [$TASK_ID] [INSTRUCTION_START] $INSTRUCTION_PATH${PURPOSE:+ - $PURPOSE}"
    
    # ワークフロー状態を更新
    update_workflow_state_add_instruction "$TASK_ID" "$INSTRUCTION_PATH"
    
    # 出力
    echo "\`📚 指示書使用開始: $(basename "$INSTRUCTION_PATH")\`"
    [ -n "$PURPOSE" ] && echo "\`   目的: $PURPOSE\`"
    echo "\`📌 タスクID: $TASK_ID\`"
    ;;
```

## 実装順序

1. **基盤機能**（最初）
   - [ ] init_workflow関数
   - [ ] ファイルロック機能  
   - [ ] 引数なしエラー処理

2. **コア機能**（次）
   - [ ] pendingサブコマンド
   - [ ] startコマンド（タスクID強調）
   - [ ] ワークフロー状態管理

3. **検証機能**（最後）
   - [ ] progressのワークフロー検証
   - [ ] completeのワークフロー検証
   - [ ] instruction系の改善

## テストシナリオ

### 正常系
```bash
$ scripts/checkpoint.sh start "API開発" 3
タスクID: TASK-4321-abc

$ scripts/checkpoint.sh instruction-start "instructions/ja/presets/web_api.md" "REST API" TASK-4321-abc
✓ 指示書使用開始

$ scripts/checkpoint.sh progress TASK-4321-abc 1 3 "設計完了" "実装"
✓ 進捗報告成功

$ scripts/checkpoint.sh instruction-complete "instructions/ja/presets/web_api.md" "3エンドポイント" TASK-4321-abc
✓ 指示書使用完了

$ scripts/checkpoint.sh complete TASK-4321-abc "API実装完了"
✓ タスク完了
```

### 異常系
```bash
$ scripts/checkpoint.sh start "テスト" 2
タスクID: TASK-5555-def

$ scripts/checkpoint.sh progress TASK-5555-def 1 2 "開始" "次"
❌ Error: ワークフロー違反 - 指示書が使用されていません

$ scripts/checkpoint.sh instruction-start "test.md" "テスト" TASK-5555-def
✓ 指示書使用開始

$ scripts/checkpoint.sh complete TASK-5555-def "完了"
❌ Error: ワークフロー違反 - 未完了の指示書があります
```