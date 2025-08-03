---
description: "AI指示書システムをリロードし、AIの振る舞いをリセット"
---

# AI指示書リロード＆リセット

AI指示書システムを最新版に更新し、AIが指示に従った適切な振る舞いになるよう是正します。

## 実行内容

1. **現在のタスク状態を保存**
   ```bash
   !echo "📋 現在のタスク状態を保存中..."
   !scripts/checkpoint.sh pending > /tmp/ai_tasks_backup.txt 2>&1 || echo "タスク情報なし"
   ```

2. **サブモジュール更新（このプロジェクト自体の場合はスキップ）**
   ```bash
   !if [ -d "instructions/ai_instruction_kits/.git" ]; then
   !  echo "🔄 AI指示書システムを更新中..."
   !  git submodule update --remote instructions/ai_instruction_kits
   !else
   !  echo "📌 AI指示書キット開発環境で実行中（サブモジュール更新をスキップ）"
   !fi
   ```

3. **更新状態確認**
   ```bash
   !echo -e "\n✅ 現在の指示書システム状態:"
   !if [ -d "instructions/ai_instruction_kits/.git" ]; then
   !  git submodule status instructions/ai_instruction_kits
   !else
   !  echo "開発環境: $(git rev-parse --short HEAD)"
   !fi
   ```

4. **システムリセット宣言**
   以下の手順でAIシステムをリセットします：

   ### 🔄 リセット完了
   
   私は今、以下の状態にリセットされました：
   - ✅ AI指示書システムの最新版を認識
   - ✅ ROOT_INSTRUCTIONに従った動作モード
   - ✅ タスク管理システムの利用準備完了
   - ✅ プリセット優先の指示書選択
   
   ### 📋 適用される基本ルール
   1. **タスク管理**: checkpoint.shを使用した進捗管理
   2. **指示書選択**: プリセット → モジュラー → レガシーの優先順
   3. **作業手順**: タスク開始 → 指示書選択 → 実行 → 完了報告
   4. **パス認識**: 開発環境とサブモジュール環境の自動判別

5. **ROOT_INSTRUCTION再読み込み**
   パスを自動判別して読み込みます：
   @instructions/ja/system/ROOT_INSTRUCTION.md または
   @instructions/ai_instruction_kits/instructions/ja/system/ROOT_INSTRUCTION.md

6. **保存していたタスク状態の確認**
   ```bash
   !if [ -f "/tmp/ai_tasks_backup.txt" ]; then
   !  echo -e "\n📋 保存されていたタスク:"
   !  cat /tmp/ai_tasks_backup.txt
   !  rm /tmp/ai_tasks_backup.txt
   !fi
   ```

## 使用方法

```
/reload-and-reset
```

引数は不要です。AIシステムが完全にリセットされ、最新の指示書に従って動作するようになります。

## 効果

- 🧠 AIの振る舞いが指示書に従った状態にリセット
- 📚 最新の指示書システムを読み込み
- ✅ タスク管理システムの再初期化

## 推奨使用タイミング

- AIが指示書に従わない振る舞いをした時
- 長時間の作業セッション後
- 指示書システムが更新された時
- 新しいタスクセッションを開始する前