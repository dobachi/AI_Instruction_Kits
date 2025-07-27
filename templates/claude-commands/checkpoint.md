---
description: "AI指示書システムのチェックポイントを実行"
---

# チェックポイント実行

AI指示書システムのチェックポイントスクリプトを実行し、タスクの進捗を管理します。

## 使用方法

```
/checkpoint [start <task-id> <task-name> <steps>]
```

## 実行内容

1. **基本チェックポイント実行**
   ```bash
   !bash scripts/checkpoint.sh $ARGUMENTS
   ```

2. **結果表示**
   - 現在のタスク状況
   - 進捗状況
   - 次のアクション提案

## 使用例

```
/checkpoint
/checkpoint start task-123 "新機能実装" 5
```

