# Issue: checkpoint.sh summaryコマンドが個別タスクIDを受け付けない

## 問題の概要
`checkpoint.sh summary <task-id>` コマンドを実行しても、個別のタスクの詳細が表示されない。

## 再現手順
1. `scripts/checkpoint.sh pending` で未完了タスクの一覧を取得
2. 表示されたタスクIDを使って `scripts/checkpoint.sh summary TASK-xxxxx` を実行
3. 何も表示されない（または空の出力）

## 期待される動作
指定したタスクIDの詳細情報（履歴、進捗、使用した指示書など）が表示される

## 環境
- OS: Linux 5.15.167.4-microsoft-standard-WSL2
- プロジェクト: AI_Instruction_Kits
- 日付: 2025-07-27

## 提案
- summaryコマンドに個別タスクID対応を追加
- または、タスクの詳細を確認する別のコマンドを提供

## 関連情報
現在30件の未完了タスクがあり、古いタスクの整理のために各タスクの詳細を確認したいが、summaryコマンドが機能しないため困難。