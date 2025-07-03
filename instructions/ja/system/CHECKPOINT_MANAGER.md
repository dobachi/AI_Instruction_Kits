# チェックポイント管理システム（柔軟な構成版）

## 目的
タスクの進捗を簡潔かつ一貫性を持って追跡・報告する

## 基本ルール
**【最重要】すべての応答で必ず以下を実行：**

1. **応答の一番最初に必ず `scripts/checkpoint.sh` を実行してその出力2行を表示**
   - 例外なくすべての応答で実行すること
   - 質問への回答、コード生成、分析など、すべてのタスクで必須
   - スクリプト実行を忘れた場合は、AIの応答品質が低下したとみなされる

2. **タスク開始/エラー/完了時は自動的にログファイルに記録される**

## スクリプトの使用方法

### タスク開始時
```bash
scripts/checkpoint.sh start <task-id> <task-name> <total-steps>
# 例: scripts/checkpoint.sh start TASK-abc123 "Webアプリ開発" 5
```

### 進捗報告時
```bash
scripts/checkpoint.sh progress <current-step> <total-steps> <status> <next-action>
# 例: scripts/checkpoint.sh progress 2 5 "実装完了" "テスト作成"
```

### エラー発生時
```bash
scripts/checkpoint.sh error <task-id> <error-message>
# 例: scripts/checkpoint.sh error TASK-abc123 "依存関係エラー"
```

### タスク完了時
```bash
scripts/checkpoint.sh complete <task-id> <result>
# 例: scripts/checkpoint.sh complete TASK-abc123 "API 3つ、テスト10個作成"
```

## 実装例

```
# タスク開始
$ scripts/checkpoint.sh start TASK-7f9a2b "Python関数実装" 4
`[1/4] 開始 | 次: 分析`
`📌 記録→checkpoint.log: [2025-07-03 19:00:00][TASK-7f9a2b][START] Python関数実装 (推定4ステップ)`

# 進捗報告
$ scripts/checkpoint.sh progress 2 4 "実装完了" "テスト作成"
`[2/4] 実装完了 | 次: テスト作成`
`📌 記録→checkpoint.log: 開始時/エラー時/完了時のみ記録`

# タスク完了
$ scripts/checkpoint.sh complete TASK-7f9a2b "関数1つ、テスト3つ"
`[✓] 全完了 | 成果: 関数1つ、テスト3つ`
`📌 記録→checkpoint.log: [2025-07-03 19:05:00][TASK-7f9a2b][COMPLETE] 成果: 関数1つ、テスト3つ`
```

## 重要な注意事項

1. **タスクIDの生成**: 6文字のランダムな英数字（例: 7f9a2b）
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
- **更新日**: 2025-07-03