## パフォーマンス最適化

### 目標設定
- **読み込み時間**: {{target_load_time}}
- **Core Web Vitals**の改善

### リソース最適化

{{#if image_optimization}}
#### 画像の最適化
- 適切な画像形式の選択（WebP、AVIF）
- レスポンシブ画像（srcset）の使用
- 画像圧縮の実施
- アスペクト比の指定でレイアウトシフト防止
{{/if}}

{{#if minification}}
#### CSS/JSの最適化
- ファイルの最小化（minify）
- 不要なコードの削除
- Tree Shakingの活用
- Critical CSSのインライン化
{{/if}}

#### フォントの最適化
- Web フォントのサブセット化
- font-displayの適切な設定
- ローカルフォントの優先使用

### 読み込み戦略

{{#if lazy_loading}}
#### 遅延読み込み
- 画像の遅延読み込み（loading="lazy"）
- スクロールに応じたコンテンツ読み込み
- Intersection Observerの活用
{{/if}}

#### リソースの優先順位
- preloadによる重要リソースの事前読み込み
- prefetchによる次ページの準備
- deferとasyncの適切な使い分け

### キャッシュ戦略
- {{cache_strategy}}
- 適切なCache-Controlヘッダー
- Service Workerの活用検討
- CDNの利用

### 計測と監視

#### パフォーマンス指標
- First Contentful Paint (FCP)
- Largest Contentful Paint (LCP)
- First Input Delay (FID)
- Cumulative Layout Shift (CLS)

#### 最適化の継続
- Lighthouseによる定期的な計測
- Real User Monitoring (RUM)
- パフォーマンスバジェットの設定