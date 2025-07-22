# パフォーマンス最適化スキルモジュール（簡潔版）

## コア概念
Webアプリケーションの速度と快適性を最大化。リソース最適化、読み込み戦略、キャッシュ戦略を統合的に実施し、Core Web Vitalsを改善。

## リソース最適化

### 最適化チェックリスト
| 対象 | 手法 |
|------|------|
| **画像** | WebP/AVIF、srcset、圧縮、アスペクト比指定 |
| **CSS/JS** | Minify、Tree Shaking、Critical CSSインライン |
| **フォント** | サブセット化、font-display設定 |

## 読み込み戦略

### 優先順位付け
```yaml
preload: 重要リソースの事前読み込み
prefetch: 次ページの準備
defer/async: スクリプトの非同期化
lazy loading: 画像の遅延読み込み
```

## キャッシュ戦略
- Cache-Controlヘッダー設定
- Service Worker活用
- CDN利用
- ブラウザキャッシュ最適化

## Core Web Vitals

| 指標 | 目標 | 改善方法 |
|------|------|----------|
| **FCP** | <1.8s | リソース最適化 |
| **LCP** | <2.5s | 画像最適化、CDN |
| **FID** | <100ms | JS最適化 |
| **CLS** | <0.1 | レイアウト固定 |

## 計測と監視
- Lighthouse定期計測
- Real User Monitoring (RUM)
- パフォーマンスバジェット設定

---
**モジュール作成日**: 2025-01-21
**カテゴリ**: skills/performance
**バージョン**: 1.0.0-concise