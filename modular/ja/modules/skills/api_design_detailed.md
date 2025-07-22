## API設計

### RESTful API設計原則

1. **リソースベースのURL設計**
   - 名詞を使用し、動詞はHTTPメソッドで表現
   - 階層構造を明確に: `/resources/{id}/sub-resources`
   - 複数形をコレクションに使用

2. **HTTPメソッドの適切な使用**
   - GET: リソースの取得
   - POST: 新規リソースの作成
   - PUT/PATCH: リソースの更新
   - DELETE: リソースの削除

3. **ステータスコードの正しい使用**
   - 200 OK: 成功
   - 201 Created: リソース作成成功
   - 400 Bad Request: クライアントエラー
   - 401 Unauthorized: 認証必要
   - 404 Not Found: リソースが存在しない
   - 500 Internal Server Error: サーバーエラー

### APIドキュメント

{{#if api_documentation_format}}形式: {{api_documentation_format}}{{/if}}

各エンドポイントについて：
- 目的と概要
- リクエスト/レスポンスのスキーマ
- パラメータの説明
- 使用例
- エラーレスポンス

### バージョニング

{{#if api_versioning_strategy}}
戦略: {{api_versioning_strategy}}
{{else}}
- URLパスにバージョンを含める: `/api/v1/resources`
- バージョン間の互換性を維持
- 非推奨APIの段階的な廃止
{{/if}}

### パフォーマンス最適化

- ページネーションの実装
- フィールドフィルタリングのサポート
- キャッシュヘッダーの適切な設定
- レートリミットの実装