# 指示書システムリロード（Codex版）

指示書サブモジュールを最新化し、ROOT_INSTRUCTION を再確認するための簡易手順です。

## 手順
1. **サブモジュール更新**  
   ```bash
   git submodule update --remote instructions/ai_instruction_kits
   ```
   - 実行結果をユーザーへ報告し、必要なら差分を確認します。
2. **更新状態の確認**  
   - `git submodule status instructions/ai_instruction_kits` を実行し、取得したリビジョンを共有します。
3. **ROOT_INSTRUCTION の読み込み**  
   - `instructions/ai_instruction_kits/instructions/ja/system/ROOT_INSTRUCTION.md` を開き、最新の重要事項を要約して伝えます。  
   - このプロジェクト自身で作業している場合は、ルート直下の `instructions/ja/system/ROOT_INSTRUCTION.md` を参照します。

## 注意事項
- サブモジュールの更新はリモートに影響しないものの、ローカル変更がある場合は衝突に注意してください。  
- 以降の作業で指示書に沿うため、読み取った要点を明示しておきます。
