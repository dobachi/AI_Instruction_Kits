# アクセシビリティスキルモジュール（簡潔版）

## コア概念
すべてのユーザーが平等にアクセスできるWebコンテンツの実現。WCAG 2.1ガイドラインに基づき、知覚・操作・理解・堅牢性の4原則を実装。

## WCAG 2.1準拠

### 4つの原則
| 原則 | 実装内容 |
|------|----------|
| **知覚可能** | 代替テキスト、コントラスト比、構造化 |
| **操作可能** | キーボード対応、時間制限配慮、ナビゲーション |
| **理解可能** | 明確な言語、エラー処理、一貫性 |
| **堅牢性** | 標準準拠、ARIA正しい使用 |

## 実装チェックリスト

### 基本要件
- [ ] 全画像にalt属性
- [ ] コントラスト比4.5:1以上
- [ ] キーボードのみで操作可能
- [ ] フォーカス表示明確
- [ ] エラーメッセージ明確

### HTML構造
```yaml
HTML要素: セマンティックな使用
見出し: 適切な階層構造
ランドマーク: header, nav, main, footer
lang属性: ページ言語明示
```

## 支援技術対応

### スクリーンリーダー
- 適切なARIAラベル
- 状態変化の通知
- ライブリージョン

### キーボードナビゲーション
- Tabキーで全要素アクセス
- スキップリンク提供
- 論理的なタブ順序

## プログレッシブエンハンスメント
- 基本機能はJSなしで動作
- 段階的な機能拡張
- フォールバック実装

---
**モジュール作成日**: 2025-01-21
**カテゴリ**: skills/accessibility
**バージョン**: 1.0.0-concise