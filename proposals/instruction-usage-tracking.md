# 指示書使用履歴追跡システムの提案

## 背景と課題

現在のAI指示書システムでは、AIが指示書を生成・読み込んで処理を行うが、どの指示書を使用して作業を行ったかの履歴が残らない。これにより以下の問題が発生している：

- AIがどの指示書に基づいて行動したか追跡できない
- デバッグや品質改善の際に、使用された指示書を特定できない
- 同じタスクで異なる指示書が使われた場合の比較が困難
- ユーザーが過去のセッションで使用された指示書を確認できない

## 提案するアプローチ

### アプローチ1: チェックポイントシステムへの統合

#### 概要
既存の`checkpoint.sh`スクリプトを拡張し、指示書使用履歴を記録する機能を追加する。

#### 実装方法
```bash
# 新しいコマンドの追加
scripts/checkpoint.sh instruction <instruction-path> [task-id]

# 使用例
scripts/checkpoint.sh instruction "instructions/ja/presets/web_api_production.md" TASK-abc123
```

#### データ構造
```
[2025-07-27 15:30:00][TASK-abc123][INSTRUCTION] instructions/ja/presets/web_api_production.md
```

#### メリット
- 既存システムとの親和性が高い
- タスクIDとの関連付けが容易
- 実装コストが低い
- ログファイルの一元管理

#### デメリット
- チェックポイントログが肥大化する可能性
- 指示書専用の検索機能が必要

### アプローチ2: 専用履歴ファイルシステム

#### 概要
指示書使用履歴専用の記録システムを新規作成する。

#### 実装方法
```bash
# 新しいスクリプトの作成
scripts/instruction-tracker.sh <action> <instruction-path> [options]

# 使用例
scripts/instruction-tracker.sh use "instructions/ja/presets/web_api_production.md" --task-id TASK-abc123
scripts/instruction-tracker.sh list --task-id TASK-abc123
scripts/instruction-tracker.sh stats --date 2025-07-27
```

#### データ構造
```json
{
  "timestamp": "2025-07-27T15:30:00Z",
  "task_id": "TASK-abc123",
  "instruction": {
    "path": "instructions/ja/presets/web_api_production.md",
    "type": "preset",
    "generated": false
  },
  "session_id": "session-xyz789",
  "metadata": {
    "user": "dobachi",
    "project": "AI_Instruction_Kits"
  }
}
```

#### メリット
- 高度な検索・分析機能の実装が容易
- 構造化データによる詳細な記録
- 将来的な拡張性が高い
- 統計情報の取得が容易

#### デメリット
- 新規実装のコストが高い
- 別システムとの連携が必要

### アプローチ3: 指示書メタデータ拡張

#### 概要
生成された指示書自体にメタデータを埋め込み、自己記録型にする。

#### 実装方法
```markdown
<!-- INSTRUCTION_METADATA
{
  "generated_at": "2025-07-27T15:30:00Z",
  "generator_version": "1.0.0",
  "base_modules": ["core_role_definition", "web_skills"],
  "task_id": "TASK-abc123",
  "usage_count": 0
}
-->
```

#### 自動更新機能
```bash
# generate-instruction.sh内で自動的にメタデータを追加
# AIがread時に自動的にusage_countを更新
```

#### メリット
- 指示書と履歴が一体化
- バージョン管理システムとの親和性
- 指示書の使用頻度が把握可能

#### デメリット
- 指示書ファイルの頻繁な更新が必要
- Git履歴が複雑化
- 読み込み時の処理が増加

### アプローチ4: AIへの記録指示の組み込み

#### 概要
ROOT_INSTRUCTIONやCHECKPOINT_MANAGERに、指示書使用時の記録を必須化する指示を追加。

#### 実装方法
ROOT_INSTRUCTION.mdへの追加：
```markdown
## 指示書使用時の必須アクション
1. 指示書を読み込む前に必ず以下を実行：
   ```bash
   scripts/checkpoint.sh instruction-start <instruction-path>
   ```
2. 指示書に基づく作業完了後に必ず以下を実行：
   ```bash
   scripts/checkpoint.sh instruction-complete <instruction-path> <result>
   ```
```

#### メリット
- AIの行動として自然に組み込まれる
- 既存インフラを最大限活用
- ユーザーの追加作業が不要

#### デメリット
- AIの指示遵守に依存
- 記録漏れの可能性

## 比較検討

| 観点 | アプローチ1 | アプローチ2 | アプローチ3 | アプローチ4 |
|------|------------|------------|------------|------------|
| 実装コスト | 低 | 高 | 中 | 最低 |
| 保守性 | 高 | 中 | 低 | 高 |
| 検索性 | 中 | 高 | 低 | 中 |
| 拡張性 | 中 | 高 | 中 | 低 |
| 信頼性 | 高 | 高 | 中 | 中 |
| 既存システムとの親和性 | 高 | 低 | 中 | 最高 |

## 推奨案：ハイブリッドアプローチ

最適な解決策として、**アプローチ1とアプローチ4の組み合わせ**を推奨する。

### 実装計画

#### Phase 1: 基本実装
1. `checkpoint.sh`に`instruction`コマンドを追加
2. ROOT_INSTRUCTIONとCHECKPOINT_MANAGERに記録指示を追加
3. 基本的なログ記録機能の実装

#### Phase 2: 機能拡張
1. 指示書使用統計の表示機能
2. タスクごとの指示書履歴表示
3. 簡易検索機能の実装

#### Phase 3: 高度な分析（将来）
1. 使用頻度分析
2. パフォーマンス相関分析
3. 推奨指示書の提案機能

### 実装例

#### checkpoint.shの拡張
```bash
# 指示書使用開始の記録
instruction_start() {
    local instruction_path="$1"
    local task_id="${2:-$CURRENT_TASK_ID}"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    echo "[$timestamp][$task_id][INSTRUCTION_START] $instruction_path" >> "$LOG_FILE"
    echo "📚 指示書使用開始: $(basename "$instruction_path")"
}

# 指示書使用完了の記録
instruction_complete() {
    local instruction_path="$1"
    local result="$2"
    local task_id="${3:-$CURRENT_TASK_ID}"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    echo "[$timestamp][$task_id][INSTRUCTION_COMPLETE] $instruction_path - $result" >> "$LOG_FILE"
    echo "✅ 指示書使用完了: $(basename "$instruction_path")"
}
```

#### ROOT_INSTRUCTION.mdへの追加
```markdown
## 指示書使用時の記録（必須）

### 指示書読み込み前
```bash
scripts/checkpoint.sh instruction-start <指示書パス>
```

### 指示書に基づく作業完了後
```bash
scripts/checkpoint.sh instruction-complete <指示書パス> "作業内容の要約"
```

### 記録例
```bash
# Web API開発の指示書を使用開始
scripts/checkpoint.sh instruction-start "instructions/ja/presets/web_api_production.md"

# 作業実施...

# 完了後
scripts/checkpoint.sh instruction-complete "instructions/ja/presets/web_api_production.md" "REST API 3エンドポイント実装"
```
```

## まとめ

提案するハイブリッドアプローチにより：
- 最小限の実装コストで指示書使用履歴の記録を開始
- 既存システムとの高い親和性を維持
- 段階的な機能拡張が可能
- AIの自然な作業フローに統合

この実装により、AI指示書システムの透明性と追跡可能性が大幅に向上し、品質改善やデバッグが容易になることが期待される。