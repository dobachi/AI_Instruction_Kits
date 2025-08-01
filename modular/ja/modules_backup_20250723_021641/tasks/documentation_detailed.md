# 技術文書作成タスクモジュール

## タスクの概要

明確で包括的、かつ使いやすい技術文書を作成し、ユーザーが技術的な情報を理解・活用できるようにします。

## 文書作成対象

- **文書の種類**: {{document_type}}
- **対象読者**: {{target_audience}}
{{#document_purpose}}
- **文書の目的**: {{document_purpose}}
{{/document_purpose}}

## 文書作成のベストプラクティス

### 1. 読者の理解

#### 読者層の分析
{{#audience_analysis}}
{{audience_analysis}}
{{/audience_analysis}}
{{^audience_analysis}}
1. **技術レベル**
   - 初心者、中級者、上級者の区分
   - 前提知識の明確化
   - 専門用語の使用レベル決定

2. **利用コンテキスト**
   - 文書を使用する状況
   - 求められる情報の深さ
   - 時間的制約の考慮

3. **期待される成果**
   - 読者が達成したいゴール
   - 必要な行動ステップ
   - 成功基準の定義
{{/audience_analysis}}

### 2. 構造とナビゲーション

#### 文書構造の設計
1. **階層的な構成**
   - 明確な見出し階層（H1〜H4）
   - 論理的な情報の流れ
   - モジュール化されたセクション

2. **ナビゲーション要素**
   - 目次の自動生成
   - クロスリファレンス
   - 検索機能の考慮
   - バージョン管理情報

3. **視覚的な構造化**
   - 適切な空白の使用
   - リストと表の活用
   - 図表の効果的な配置

### 3. コンテンツの作成

#### 執筆の原則
{{#writing_style}}
- {{writing_style}}
{{/writing_style}}
{{^writing_style}}
1. **明確性**
   - 簡潔で直接的な表現
   - 能動態の使用
   - 一文一意の原則

2. **一貫性**
   - 用語の統一
   - スタイルガイドの遵守
   - フォーマットの標準化

3. **具体性**
   - 抽象的な説明を避ける
   - 実例とサンプルコード
   - ステップバイステップの手順
{{/writing_style}}

#### コンテンツ要素
{{#content_elements}}
{{content_elements}}
{{/content_elements}}
{{^content_elements}}
- **概要セクション**: 文書の目的と範囲
- **前提条件**: 必要な環境や知識
- **手順説明**: 詳細なステップ
- **例とサンプル**: 実践的な使用例
- **トラブルシューティング**: よくある問題と解決策
- **リファレンス**: 詳細な仕様情報
{{/content_elements}}

### 4. 技術的な考慮事項

#### フォーマットと標準
{{#documentation_format}}
- **使用フォーマット**: {{documentation_format}}
{{/documentation_format}}
{{^documentation_format}}
選択可能なフォーマット：
- **Markdown**: 軽量で習得しやすい、バージョン管理との親和性
- **DITA XML**: 大規模で構造化された文書、再利用性重視
- **HTML/CSS**: ウェブベースのインタラクティブ文書
- **PDF**: 印刷や配布用の固定レイアウト
{{/documentation_format}}

#### バージョン管理と更新
1. **変更履歴の管理**
   - 詳細な変更ログ
   - バージョン番号の体系
   - 破壊的変更の明示

2. **継続的な更新**
   - ドキュメントとコードの同期
   - フィードバックループの確立
   - 定期的なレビュー

### 5. API文書固有の要素（該当する場合）

{{#api_documentation}}
#### APIドキュメントの必須要素
1. **認証と認可**
   - 認証方法の詳細説明
   - APIキーの取得方法
   - セキュリティベストプラクティス

2. **エンドポイント仕様**
   - HTTPメソッドとURL
   - リクエスト/レスポンス形式
   - パラメータの詳細説明

3. **コード例**
   - 複数言語でのサンプル
   - 実行可能なコードスニペット
   - エラーハンドリング例

4. **インタラクティブ要素**
   - APIエクスプローラー
   - サンドボックス環境
   - リアルタイムテスト機能
{{/api_documentation}}

### 6. ユーザビリティとアクセシビリティ

#### 検索とナビゲーション
- 強力な検索機能
- 文脈に応じたヘルプ
- 関連情報へのリンク

#### アクセシビリティ対応
{{#accessibility_requirements}}
- {{accessibility_requirements}}
{{/accessibility_requirements}}
{{^accessibility_requirements}}
- スクリーンリーダー対応
- キーボードナビゲーション
- 適切な色コントラスト
- 代替テキストの提供
{{/accessibility_requirements}}

### 7. 品質保証

#### レビューとテスト
1. **技術的正確性**
   - 専門家によるレビュー
   - コード例の動作確認
   - 仕様との整合性チェック

2. **読みやすさ**
   - 読者テスト
   - 理解度の確認
   - フィードバックの収集

#### 測定と改善
- 文書の利用状況分析
- ユーザー満足度調査
- 継続的な改善プロセス

---