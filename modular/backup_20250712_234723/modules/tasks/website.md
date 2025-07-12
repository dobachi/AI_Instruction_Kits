## 静的ウェブサイト開発

以下の要件に従って、高品質な静的ウェブサイトを作成してください。

### サイト要件
- **サイトタイプ**: {{site_type}}
- **デザインスタイル**: {{design_style}}
- **ページ数**: {{page_count}}

### 技術要件

#### HTML
- セマンティックHTMLの使用
- 適切な見出し階層（h1-h6）
- アクセシビリティ属性（alt、aria-label等）
{{#if seo_optimization}}
- メタタグの最適化（title、description、OGP）
- 構造化データの実装（必要に応じて）
{{/if}}

#### CSS
{{#if css_framework}}
- フレームワーク: {{css_framework}}を使用
{{else}}
- カスタムCSSで実装
- CSS変数を活用した保守性の高い設計
{{/if}}
{{#if responsive_design}}
- モバイルファースト設計
- ブレークポイント: 768px（タブレット）、1024px（デスクトップ）
{{/if}}
- {{design_style}}なデザインの実現

#### JavaScript
{{#if javascript_framework}}
- フレームワーク: {{javascript_framework}}を使用
{{else}}
- バニラJavaScriptで実装
{{/if}}
- プログレッシブエンハンスメント
- イベントリスナーの適切な管理

### パフォーマンス要件
{{#if loading_optimization}}
- 画像の最適化（適切な形式とサイズ）
- CSSとJSの最小化
- 遅延読み込みの実装
- 重要なCSSのインライン化
{{/if}}

### ファイル構成
```
project/
├── index.html
├── css/
│   └── style.css
├── js/
│   └── script.js
├── images/
│   └── (最適化された画像ファイル)
└── README.md
```

### 成果物
1. 完全に機能するウェブサイト
2. クリーンで保守性の高いコード
3. README.mdによるプロジェクト説明