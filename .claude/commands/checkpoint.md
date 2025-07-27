---
description: "AI指示書システムのチェックポイントを実行"
---

# チェックポイント実行

AI指示書システムのチェックポイントスクリプトを実行し、タスクの進捗を管理します。

## 使用方法

```
/checkpoint <command> [arguments]
```

## 利用可能なコマンド

### タスク管理
- `start <name> <steps>` - 新しいタスクを開始（タスクIDは自動生成）
- `progress <task-id> <current> <total> <status> <next>` - 進捗を報告（要：指示書使用中）
- `complete <task-id> <result>` - タスクを完了（要：指示書すべて完了）
- `error <task-id> <message>` - エラーを報告

### 指示書管理
- `instruction-start <path> <purpose> [task-id]` - 指示書の使用を開始
- `instruction-complete <path> <result> [task-id]` - 指示書の使用を完了

### 状態確認
- `pending` - 未完了タスクの一覧を表示
- `summary <task-id>` - タスクの詳細履歴を表示
- `help` - ヘルプメッセージを表示

## 実行内容

1. **チェックポイントコマンド実行**
   ```bash
   !bash scripts/checkpoint.sh $ARGUMENTS
   ```

2. **結果表示**
   - コマンドに応じた実行結果
   - エラーメッセージ（該当する場合）
   - 次のアクション提案

## 使用例

```
/checkpoint pending
/checkpoint start "新機能実装" 5
/checkpoint progress TASK-123456-abc123 2 5 "設計完了" "実装開始"
/checkpoint instruction-start "instructions/ja/presets/web_api_production.md" "REST API開発" TASK-123456-abc123
/checkpoint complete TASK-123456-abc123 "API 3エンドポイント実装完了"
```

## 注意事項

- 引数なしでの実行は、デフォルトで `pending` コマンドを実行します
- タスクIDは `start` コマンド実行時に自動生成されます
- `progress` コマンドは指示書使用中のみ実行可能です
- ワークフロー制約により、システム指示書は推奨されません