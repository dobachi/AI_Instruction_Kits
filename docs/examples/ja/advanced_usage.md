# 高度な使用例

このドキュメントでは、AI指示書マネージャーの高度な使用方法を示します。

## 1. カスタム指示書の作成

プロジェクト固有の指示書を作成する方法です。

### テンプレートを使用した作成

```bash
# テンプレートをコピーして編集
cp templates/instruction_template.md instructions/ja/custom/my_project_rules.md

# カスタム指示書を使用
claude "instructions/ja/custom/my_project_rules.md を参照して、
プロジェクトのコーディング規約に従ってリファクタリングしてください"
```

### カスタム指示書の例

```markdown
# プロジェクト固有のコーディング規約

## 目的
このプロジェクト特有のコーディング規約とベストプラクティスに従う

## 具体的な指示
1. すべての関数に型注釈を追加する
2. エラーハンドリングは必ずtry-exceptで包む
3. ログ出力には専用のloggerを使用する
4. テストカバレッジは80%以上を維持する

## ライセンス情報
- **ライセンス**: Proprietary
- **原著者**: プロジェクトチーム
- **作成日**: 2025-06-30
```

## 2. 条件分岐を含む複雑なタスク

```bash
claude "instructions/ja/system/ROOT_INSTRUCTION.md を参照して、
以下の条件に基づいてAPIを実装してください：
- 認証が必要な場合はJWT認証を実装
- キャッシュが必要な場合はRedisを使用
- レート制限が必要な場合は1分間に60リクエストまで"
```

期待される動作：
```
`[1/5] 要件分析完了 | 次: API設計`
`📌 記録→checkpoint.log: [2025-06-30 12:00:00][TASK003][START] 条件付きAPI実装 (5ステップ)`

要件を分析し、以下の実装が必要と判断しました：
- JWT認証: 必要
- Redisキャッシュ: 必要
- レート制限: 必要

`[2/5] API設計完了 | 次: 認証実装`
`📌 記録→checkpoint.log: 開始時/エラー時/完了時のみ記録`
```

## 3. 既存コードベースとの統合

```bash
# 既存のプロジェクト構造を理解してから実装
claude "instructions/ja/system/ROOT_INSTRUCTION.md を参照して、
1. まず既存のコード構造を分析してください
2. 既存のパターンとコンベンションを特定してください
3. それらに従って新機能を実装してください"
```

## 4. 段階的な機能追加

```bash
# 複数回のセッションにわたる開発
# セッション1
claude "instructions/ja/system/ROOT_INSTRUCTION.md を参照して、
基本的なCRUD APIを実装してください。
完了したらcheckpoint.logに記録してください"

# セッション2（後日）
claude "instructions/ja/system/ROOT_INSTRUCTION.md を参照して、
checkpoint.logを確認し、前回の続きから
認証機能を追加してください"
```

## 5. デバッグとトラブルシューティング

```bash
# エラーの詳細な調査
claude "instructions/ja/system/ROOT_INSTRUCTION.md を参照して、
1. エラーログを分析してください
2. 根本原因を特定してください
3. 修正案を提示してください
4. 修正を実装してください
5. テストで検証してください"
```

期待される動作：
```
`[1/5] ログ分析中 | 次: 原因特定`
`📌 記録→checkpoint.log: [2025-06-30 13:00:00][TASK004][START] エラー調査 (5ステップ)`

エラーログを確認しています...

`[2/5] 原因特定完了 | 次: 修正案作成`
`📌 記録→checkpoint.log: 開始時/エラー時/完了時のみ記録`

NullPointerExceptionの原因：初期化前のオブジェクト参照

`[3/5] 修正案作成完了 | 次: 実装`
`📌 記録→checkpoint.log: 開始時/エラー時/完了時のみ記録`
```

## 6. パフォーマンス最適化

```bash
claude "instructions/ja/system/ROOT_INSTRUCTION.md を参照して、
1. 現在のパフォーマンスボトルネックを特定
2. 最適化の優先順位を決定
3. 段階的に最適化を実装
4. 各段階でベンチマークを実行"
```

## 7. マルチ言語対応

```bash
# 日本語と英語の両方の指示書を作成
claude "instructions/ja/system/ROOT_INSTRUCTION.md を参照して、
新しい指示書を作成し、日本語版と英語版の両方を用意してください"
```

## ベストプラクティス

1. **明確なタスク定義**: タスクを明確に定義することで、適切な指示書が選択されます
2. **段階的な実行**: 大きなタスクは小さなステップに分割します
3. **エラー処理**: エラーが発生した場合の対処法を事前に考慮します
4. **ログの活用**: checkpoint.logを活用して進捗を追跡します
5. **カスタマイズ**: プロジェクト固有の要求に応じて指示書をカスタマイズします

---
## ライセンス情報
- **ライセンス**: Apache-2.0
- **原著者**: dobachi
- **作成日**: 2025-06-30