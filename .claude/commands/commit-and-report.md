---
description: "コミット、プッシュ、Issue報告を一括実行"
---

# コミット・プッシュ・Issue報告

変更をコミット・プッシュし、指定されたIssueに進捗を報告します。作業完了時はIssueをクローズできます。

## 使用方法

```
/commit-and-report "コミットメッセージ" [Issue番号]
```

## 実行内容

1. **変更をステージング・コミット**
   ```bash
   !git add -A
   !git commit -m "$ARGUMENTS"
   ```

2. **リモートにプッシュ**
   ```bash
   !git push
   ```

3. **Issue報告** (Issue番号が指定された場合)
   ```bash
   !if echo "$ARGUMENTS" | grep -q " "; then ISSUE_NUM=$(echo "$ARGUMENTS" | awk '{print $NF}'); COMMIT_MSG=$(echo "$ARGUMENTS" | sed 's/ [0-9]*$//'); gh issue comment "$ISSUE_NUM" --body "✅ $COMMIT_MSG"; fi
   ```

## 使用例

```
/commit-and-report "feat: カスタムコマンド実装"
/commit-and-report "fix: バグ修正" 123
```

Issue番号を指定すると、そのIssueに進捗が自動報告されます。