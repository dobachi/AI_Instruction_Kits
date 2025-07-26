---
description: "AI指示書システムを最新版に更新・リロード"
---

# 指示書システムリロード

AI指示書システムを最新版に更新し、ROOT_INSTRUCTIONを再読み込みします。

## 実行内容

1. **サブモジュール更新**
   ```bash
   !git submodule update --remote instructions/ai_instruction_kits
   ```

2. **更新確認**
   ```bash
   !echo "✅ AI指示書システムを更新しました"
   !git submodule status instructions/ai_instruction_kits
   ```

3. **ROOT_INSTRUCTION読み込み**
   @instructions/ai_instruction_kits/instructions/ja/system/ROOT_INSTRUCTION.md

## 使用方法

```
/reload-instructions
```

引数は不要です。最新のAI指示書システムを取得し、ROOT_INSTRUCTIONの内容を表示します。