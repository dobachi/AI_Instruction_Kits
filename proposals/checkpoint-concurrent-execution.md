# チェックポイントシステムの並行実行対応提案

## 背景と課題

現在の`checkpoint.sh`は単一プロセスでの使用を前提としており、複数のAIエージェントや並行タスクでの同時実行時に以下の問題が発生する可能性がある：

### 1. ファイルロックの欠如
- 複数のプロセスが同時に`checkpoint.log`に書き込むと、ログの破損や不整合が発生
- 書き込み中の読み取りによる不完全なデータの取得

### 2. タスクIDの重複
- 複数のエージェントが同時にタスクを開始すると、同じランダムIDが生成される可能性
- タスクの識別が困難になる

### 3. 最新タスクの判定問題
- 複数のタスクが並走している場合、「最新」のタスクを正しく特定できない
- `instruction-start/complete`でタスクIDが自動取得される際に誤ったタスクと関連付けられる

### 4. ログの競合状態
- 複数のプロセスが同時に同じファイルに書き込むことで、ログエントリが混在
- タイムスタンプの順序とファイル内の順序が一致しない可能性

## 提案するアプローチ

### アプローチ1: ファイルロックの実装

#### 概要
`flock`コマンドを使用してログファイルへの排他的アクセスを保証する。

#### 実装例
```bash
# ログ書き込み関数
write_log() {
    local message="$1"
    (
        flock -x 200
        echo "$message" >> "$CHECKPOINT_LOG"
    ) 200>"$CHECKPOINT_LOG.lock"
}

# 使用例
write_log "[$TIMESTAMP] [$TASK_ID] [START] $TASK_NAME"
```

#### メリット
- 実装が簡単
- 既存のログ構造を維持
- POSIX準拠で移植性が高い

#### デメリット
- ロック待機によるパフォーマンス低下
- デッドロックの可能性
- ロックファイルの管理が必要

### アプローチ2: エージェント別ログファイル

#### 概要
各エージェントやセッションごとに個別のログファイルを作成する。

#### 実装例
```bash
# エージェントIDまたはセッションIDを使用
AGENT_ID="${AGENT_ID:-default}"
CHECKPOINT_LOG="checkpoint_${AGENT_ID}.log"

# マスターログへの統合（オプション）
consolidate_logs() {
    cat checkpoint_*.log | sort -k1,2 > checkpoint_master.log
}
```

#### メリット
- ロック不要で高速
- エージェントごとの履歴が明確
- 並行実行に最適

#### デメリット
- ログファイルが分散
- 統合処理が必要
- 全体像の把握が困難

### アプローチ3: タスクID生成の改善

#### 概要
UUID v4やタイムスタンプベースのIDを使用して重複を防ぐ。

#### 実装例
```bash
# UUID v4を使用（macOS/Linux互換）
generate_task_id() {
    if command -v uuidgen >/dev/null 2>&1; then
        # macOS
        echo "TASK-$(uuidgen | tr '[:upper:]' '[:lower:]' | cut -c1-8)"
    elif [ -f /proc/sys/kernel/random/uuid ]; then
        # Linux
        echo "TASK-$(cat /proc/sys/kernel/random/uuid | cut -c1-8)"
    else
        # フォールバック：タイムスタンプ+ランダム
        echo "TASK-$(date +%s)-$(openssl rand -hex 3)"
    fi
}
```

#### メリット
- 重複の可能性が極めて低い
- 標準的な方法
- 追跡が容易

#### デメリット
- IDが長くなる
- 既存のID形式との互換性

### アプローチ4: 構造化ログフォーマット（JSON）

#### 概要
ログをJSON形式で保存し、並行アクセスに強い構造にする。

#### 実装例
```bash
# JSON形式でログ出力
write_json_log() {
    local action="$1"
    local data="$2"
    
    local entry=$(jq -n \
        --arg ts "$TIMESTAMP" \
        --arg tid "$TASK_ID" \
        --arg act "$action" \
        --arg data "$data" \
        --arg agent "${AGENT_ID:-default}" \
        '{timestamp: $ts, task_id: $tid, action: $act, data: $data, agent: $agent}')
    
    echo "$entry" >> "$CHECKPOINT_LOG.jsonl"
}
```

#### メリット
- 構造化データで解析が容易
- メタデータの追加が簡単
- 並行処理に適している

#### デメリット
- 人間が読みにくい
- jqなどのツールが必要
- 既存フォーマットとの非互換

### アプローチ5: セマフォとアトミック操作

#### 概要
セマフォを使用した高度な並行制御とアトミックな操作を実装。

#### 実装例
```bash
# アトミックなログ追加
atomic_log_append() {
    local temp_file=$(mktemp)
    local message="$1"
    
    # 既存ログを読み込み
    cp "$CHECKPOINT_LOG" "$temp_file" 2>/dev/null || touch "$temp_file"
    
    # 新しいエントリを追加
    echo "$message" >> "$temp_file"
    
    # アトミックに置換
    mv -f "$temp_file" "$CHECKPOINT_LOG"
}
```

#### メリット
- 完全なアトミック性
- データ整合性の保証
- 高い信頼性

#### デメリット
- 実装が複雑
- パフォーマンスのオーバーヘッド
- プラットフォーム依存

## 比較検討

| 観点 | ファイルロック | エージェント別ログ | UUID改善 | JSON形式 | セマフォ |
|------|--------------|-----------------|----------|----------|----------|
| 実装難易度 | 低 | 低 | 低 | 中 | 高 |
| パフォーマンス | 中 | 高 | 高 | 中 | 低 |
| 互換性 | 高 | 低 | 高 | 低 | 中 |
| 拡張性 | 中 | 高 | 中 | 高 | 高 |
| 信頼性 | 高 | 中 | 中 | 高 | 最高 |

## 推奨案：段階的実装アプローチ

### Phase 1: 即時対応（最小限の変更）
1. **ファイルロックの実装**（アプローチ1）
2. **タスクID生成の改善**（アプローチ3）

### Phase 2: 中期改善
1. **エージェントIDサポート**（アプローチ2の部分実装）
2. **ロック付きJSON出力オプション**（アプローチ4の準備）

### Phase 3: 長期最適化
1. **完全な並行実行サポート**
2. **分散ログの統合ツール**
3. **リアルタイム監視機能**

## 実装計画

### Phase 1の詳細実装

```bash
#!/bin/bash

# ロック付きログ書き込み
log_with_lock() {
    local message="$1"
    local lock_file="$CHECKPOINT_LOG.lock"
    local max_wait=5
    
    # flockが利用可能か確認
    if command -v flock >/dev/null 2>&1; then
        (
            flock -w $max_wait -x 200 || {
                echo "Warning: Could not acquire lock, writing anyway" >&2
            }
            echo "$message" >> "$CHECKPOINT_LOG"
        ) 200>"$lock_file"
    else
        # flockが使えない場合は直接書き込み（警告付き）
        echo "$message" >> "$CHECKPOINT_LOG"
    fi
}

# 改善されたタスクID生成
generate_unique_task_id() {
    local prefix="TASK"
    
    # 方法1: UUIDを試す
    if command -v uuidgen >/dev/null 2>&1; then
        echo "${prefix}-$(uuidgen | tr '[:upper:]' '[:lower:]' | cut -c1-8)"
        return
    fi
    
    # 方法2: /proc/sys/kernel/random/uuidを試す
    if [ -f /proc/sys/kernel/random/uuid ]; then
        echo "${prefix}-$(cat /proc/sys/kernel/random/uuid | cut -c1-8)"
        return
    fi
    
    # 方法3: タイムスタンプ + PID + ランダム
    echo "${prefix}-$(date +%s%N | cut -c1-10)-$$-$(openssl rand -hex 2)"
}

# 現在のタスクID取得（エージェントID対応）
get_current_task_id() {
    local agent_id="${AGENT_ID:-default}"
    
    # エージェント固有の最新タスクを取得
    grep "] \[START\]" "$CHECKPOINT_LOG" 2>/dev/null | \
        grep -F "[agent:$agent_id]" | \
        tail -1 | \
        sed 's/.*\] \[\([^]]*\)\] \[START\].*/\1/'
}
```

## 追加考慮事項：エージェント再起動時の状態復元

### 現状の課題
AIエージェントが再起動した際に、以下の情報を効率的に取得する機能が不足：
- 前回の作業状態
- 未完了タスクの詳細
- 使用していた指示書
- エラーで中断したタスク

※注：Issue #57により、`scripts/checkpoint.sh`（引数なし）はAIモードではエラーを返すよう変更予定。そのため、状態確認用の新しいコマンドが必要。

### 提案する機能

#### 1. タスクサマリー機能
```bash
# 特定タスクの完全な履歴を表示
scripts/checkpoint.sh summary <task-id>

# 出力例：
# タスクID: TASK-abc123
# タスク名: Web API開発
# 状態: 進行中 (3/5ステップ完了)
# 開始: 2025-07-27 10:00:00
# 最終更新: 2025-07-27 11:30:00
# 使用指示書:
#   - instructions/ja/presets/web_api_production.md (REST API開発)
# 進捗:
#   [1/5] 開始 | 次: 分析
#   [2/5] 分析完了 | 次: 設計
#   [3/5] 設計完了 | 次: 実装
```

#### 2. 未完了タスク一覧
```bash
# 未完了タスクのみ表示
scripts/checkpoint.sh pending

# エージェント別の未完了タスク
scripts/checkpoint.sh pending --agent <agent-id>
```

#### 3. コンテキスト復元機能
```bash
# 最後の作業状態を詳細表示
scripts/checkpoint.sh restore

# 出力例：
# 最終作業タスク: TASK-abc123 (Web API開発)
# 状態: 3/5ステップ完了
# 次のアクション: 実装
# 使用中の指示書: web_api_production.md
# 
# 推奨アクション:
# 1. scripts/checkpoint.sh progress 4 5 "実装中" "テスト作成"
# 2. 指示書 web_api_production.md の続きから作業再開
```

#### 4. エージェント固有の状態ファイル
```bash
# エージェントの状態を保存
.checkpoint/
├── agents/
│   ├── agent-001.state    # 最新状態のスナップショット
│   └── agent-002.state
└── checkpoint.log          # 共有ログ

# state ファイルの内容（JSON）
{
  "agent_id": "agent-001",
  "current_task": "TASK-abc123",
  "last_instruction": "instructions/ja/presets/web_api_production.md",
  "last_checkpoint": "2025-07-27T11:30:00Z",
  "context": {
    "step": 3,
    "total_steps": 5,
    "next_action": "実装"
  }
}
```

### 実装の優先順位
1. **高優先度**: タスクサマリー機能（既存ログから情報抽出）
2. **中優先度**: 未完了タスク一覧（フィルタリング機能）
3. **低優先度**: 状態ファイルシステム（新規実装）

**注：これらの機能は`checkpoint-subcommand-design.md`で定義されたサブコマンド体系の一部として実装されます。**

## まとめ

推奨する段階的実装により：
1. **即座に並行実行の基本的な問題を解決**
2. **既存システムとの互換性を維持**
3. **将来の拡張に向けた基盤を構築**
4. **エージェント再起動時の効率的な状態復元**

この実装により、複数のAIエージェントが同時に動作し、再起動しても作業を継続できる堅牢なチェックポイントシステムが実現される。