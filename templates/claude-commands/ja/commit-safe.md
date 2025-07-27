---
description: "安全に変更を確認してからコミット"
---

# 安全なコミット

変更内容を確認してから、選択的にコミットを行います。

## 使用方法

```
/commit-safe "コミットメッセージ" [ファイルパス...]
```

## 実行内容

1. **変更内容の確認**
   ```bash
   !git status --short
   !git diff --stat
   ```

2. **指定ファイルのみステージング・コミット**
   ```bash
   # ファイルが指定された場合
   !git add [指定されたファイル]
   !git commit -m "コミットメッセージ"
   
   # ファイルが指定されない場合
   !echo "⚠️ ファイルを指定してください。全体をコミットする場合は /commit-and-report を使用してください。"
   ```

## 使用例

```
/commit-safe "feat: 新機能追加" src/main.py src/utils.py
/commit-safe "docs: README更新" README.md
```

## 推奨ワークフロー

1. まず `git status` で変更を確認
2. 必要なファイルのみを指定してコミット
3. 大きな変更は複数の小さなコミットに分割

## 関連コマンド

- `/commit-and-report` - すべての変更を一括コミット（注意が必要）
- `git status` - 変更内容の確認
- `git diff` - 詳細な変更内容の確認