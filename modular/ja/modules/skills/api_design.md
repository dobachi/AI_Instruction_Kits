# API設計スキルモジュール（簡潔版）

## コア概念
RESTful原則に基づいた一貫性あるAPI設計。リソースベースのURL、適切なHTTPメソッド、ステータスコードで直感的なAPIを実現。

## RESTful設計原則

### URL設計
- 名詞使用（動詞はHTTPメソッド）
- 階層構造: `/resources/{id}/sub-resources`
- コレクションは複数形

### HTTPメソッド
| メソッド | 用途 | 冗長性 |
|---------|------|-------|
| GET | リソース取得 | 冗長 |
| POST | 新規作成 | 非冗長 |
| PUT/PATCH | 更新 | 冗長 |
| DELETE | 削除 | 冗長 |

### ステータスコード
```yaml
2xx: 成功
  200: OK
  201: Created
  204: No Content
4xx: クライアントエラー
  400: Bad Request
  401: Unauthorized
  404: Not Found
5xx: サーバーエラー
  500: Internal Server Error
```

## ドキュメント構成
- 目的と概要
- リクエスト/レスポンススキーマ
- パラメータ説明
- 使用例（curl, SDK）
- エラーレスポンス

## バージョニング
- URLパス: `/api/v1/resources`
- 互換性維持
- 非推奨APIの段階的廃止

## パフォーマンス
- ページネーション
- フィールドフィルタリング
- キャッシュヘッダー
- レートリミット

---
**モジュール作成日**: 2025-01-21
**カテゴリ**: skills/api_design
**バージョン**: 1.0.0-concise