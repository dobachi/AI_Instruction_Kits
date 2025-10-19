# 指示書リロード＆リセット（Codex版）

AI 指示書システムを最新化し、作業ルールを再確認するための手順です。実行する際は、リポジトリ構成に応じてサブモジュールパスを判断してください。

## 手順
1. **タスク状態のバックアップ**  
   - 進行中タスクがあれば `bash scripts/checkpoint.sh pending > /tmp/ai_tasks_backup.txt 2>&1` のように退避し、成功可否を報告します。
2. **サブモジュール更新**  
   - `instructions/ai_instruction_kits/.git` が存在する場合は `git submodule update --remote instructions/ai_instruction_kits` を実行し、結果を共有します。  
   - このプロジェクト自体で実行している場合は、サブモジュール更新をスキップしたことを明記します。
3. **更新状態の確認**  
   - `git submodule status instructions/ai_instruction_kits` または `git rev-parse --short HEAD` を使って現在のバージョンを示します。
4. **システムリセット宣言**  
   - 以下の状態に戻ったことを明言し、必要ならユーザーに確認します。  
     - 指示書システムが最新  
     - ROOT_INSTRUCTION に従うモード  
     - タスク管理スクリプトの利用準備完了  
     - パス変換ルールの再確認済み
5. **ROOT_INSTRUCTION の読み込み**  
   - 環境に応じた正しいパスを開き、要点を確認して共有します。  
     - サブモジュール経由: `instructions/ai_instruction_kits/instructions/ja/system/ROOT_INSTRUCTION.md`  
     - このプロジェクト内: `instructions/ja/system/ROOT_INSTRUCTION.md`
6. **バックアップ結果の復元**  
   - `/tmp/ai_tasks_backup.txt` が存在すれば中身を表示し、不要になったら削除します。

## 推奨タイミング
- 指示書に従わない挙動が見られたとき
- 長時間作業を続けたあと
- 指示書システムを更新した直後
- 新しいタスクセットに取り掛かる前

## 注意事項
- 破壊的な操作は含まれていませんが、念のためコミット状況を確認してから実行します。  
- チームで共有している環境の場合は、サブモジュール更新が他メンバーへ影響しないか確認します。
