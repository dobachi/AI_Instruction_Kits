# チェックポイント管理システム（柔軟な構成版）

## 目的
タスクの進捗を簡潔かつ一貫性を持って追跡・報告する

## 基本ルール
**ワークフローの各段階で適切なコマンドを使用：**

1. **チェックポイントコマンドの使い分け**
   - 会話開始時：`pending` で既存タスクを確認（一度だけ）
   - 新規タスク開始：`start` でタスクを登録
   - 進捗報告：`progress` で状況を更新（指示書使用中のみ）
   - エラー報告：`error` で問題を記録
   - タスク完了：`complete` で終了処理

2. **ワークフローの基本パターン**
   - 初回確認→タスク開始→指示書選択→進捗報告→完了
   - 既存タスクがある場合は、継続または完了を判断
   - 進捗報告には指示書使用が必須（ワークフロー制約）

3. **タスク開始/エラー/完了時は自動的にログファイルに記録される**

4. **指示書使用時の記録（必須）**
   - 指示書を読み込む前に `instruction-start` で記録
   - 指示書に基づく作業完了後に `instruction-complete` で記録
   - これにより、どの指示書を使用して作業したかが追跡可能

## スクリプトの使用方法

### タスク開始時
```bash
scripts/checkpoint.sh start <task-name> <total-steps>
# 例: scripts/checkpoint.sh start "Webアプリ開発" 5
# → タスクID: TASK-123456-abc123 が自動生成される
```

### 進捗報告時
```bash
scripts/checkpoint.sh progress <task-id> <current-step> <total-steps> <status> <next-action>
# 例: scripts/checkpoint.sh progress TASK-123456-abc123 2 5 "実装完了" "テスト作成"
```
**注意**: 進捗報告は指示書使用中のみ可能（ワークフロー制約）

### エラー発生時
```bash
scripts/checkpoint.sh error <task-id> <error-message>
# 例: scripts/checkpoint.sh error TASK-123456-abc123 "依存関係エラー"
```

### タスク完了時
```bash
scripts/checkpoint.sh complete <task-id> <result>
# 例: scripts/checkpoint.sh complete TASK-123456-abc123 "API 3つ、テスト10個作成"
```
**注意**: すべての指示書が完了している必要がある（ワークフロー制約）

### 指示書使用開始時（必須）
```bash
scripts/checkpoint.sh instruction-start <instruction-path> <purpose> [task-id]
# 例: scripts/checkpoint.sh instruction-start "instructions/ja/presets/web_api_production.md" "REST API開発" TASK-123456-abc123
```

### 指示書使用完了時
```bash
scripts/checkpoint.sh instruction-complete <instruction-path> <result> [task-id]
# 例: scripts/checkpoint.sh instruction-complete "instructions/ja/presets/web_api_production.md" "3エンドポイント実装" TASK-123456-abc123
```
**注意**: タスクIDを省略すると警告が表示される

## 実装例

```
# 未完了タスクの確認
$ scripts/checkpoint.sh pending
📋 未完了タスク一覧
（タスクがない場合は新規タスク開始を促される）

# タスク開始
$ scripts/checkpoint.sh start "Python関数実装" 4
`🚀 タスク開始: Python関数実装`
`📝 タスクID: TASK-123456-7f9a2b`
`📊 推定ステップ: 4`

# 指示書使用開始（必須）
$ scripts/checkpoint.sh instruction-start "instructions/ja/presets/cli_tool_basic.md" "CLIツール開発" TASK-123456-7f9a2b
`📚 指示書使用開始: cli_tool_basic.md`
`   目的: CLIツール開発`
`📌 タスクID: TASK-123456-7f9a2b`

# 進捗報告（指示書使用中のみ可能）
$ scripts/checkpoint.sh progress TASK-123456-7f9a2b 2 4 "実装完了" "テスト作成"
`[2/4] 実装完了 | 次: テスト作成`
`📌 タスクID: TASK-123456-7f9a2b`

# 指示書使用完了
$ scripts/checkpoint.sh instruction-complete "instructions/ja/presets/cli_tool_basic.md" "基本機能実装完了" TASK-123456-7f9a2b
`✅ 指示書使用完了: cli_tool_basic.md`
`📊 成果: 基本機能実装完了`
`📌 タスクID: TASK-123456-7f9a2b`

# タスク完了（すべての指示書が完了している必要がある）
$ scripts/checkpoint.sh complete TASK-123456-7f9a2b "関数1つ、テスト3つ"
`✅ タスク完了: TASK-123456-7f9a2b`
`📊 成果: 関数1つ、テスト3つ`

# タスクの詳細確認
$ scripts/checkpoint.sh summary TASK-123456-7f9a2b
（タスクの詳細履歴が表示される）
```

## 重要な注意事項

1. **タスクIDの生成**: タイムスタンプ+ランダム値で自動生成（例: TASK-123456-abc123）
2. **簡潔性を保つ**: ステータスとアクションは短く明確に
3. **一貫性を保つ**: 同じタスクでは同じタスクIDとステップ数を使用
4. **パスに注意**: `scripts/checkpoint.sh`はプロジェクトルートからの相対パス

## 他の指示書との連携

このチェックポイント管理は、すべての指示書と組み合わせて使用されます。
各指示書の主要ステップごとに `scripts/checkpoint.sh` を実行してください。

---
## ライセンス情報
- **ライセンス**: Apache-2.0
- **参照元**: 
- **原著者**: dobachi
- **作成日**: 2025-06-30
- **更新日**: 2025-07-27