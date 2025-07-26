# モジュール開発ドキュメント統合計画

## 作成日: 2025-01-26

## 概要
モジュール開発に関するドキュメントが複数の場所に分散し、重複や矛盾が生じている問題を解決するための統合計画です。すべてのモジュール開発関連ドキュメントを一箇所に集約します。

## 現状の問題点

### 1. ドキュメントの分散
現在、モジュール開発に関する情報が7つ以上のファイルに分散：
- `/docs/module-development-guide.md` - 統一的ガイド（新規作成）
- `/modular/DEVELOPMENT.md` - テンプレート重視の開発ガイド
- `/docs/developers/best-practices/module-creation.md` - 実践的ガイド
- `/docs/developers/research/MODULE_CREATION_BEST_PRACTICES.md` - 調査方法
- `/docs/proposals/module_size_*` - サイズ基準関連（複数）
- その他、各所に散在する情報

### 2. 情報の重複と矛盾
- **サイズ基準の不統一**: 20-30% vs 25-40% vs 30-40%
- **開発手順の重複**: Phase番号の不整合（3.5 vs 4.5）
- **ベストプラクティスの分散**: 統一的な参照先が不明確

### 3. ナビゲーションの困難さ
- 新規開発者がどのドキュメントから読むべきか不明
- 最新の正しい情報がどこにあるか判断困難
- 相互参照が不十分

## 統合方針

### 基本方針
1. **集約**: すべてのモジュール開発ドキュメントを `/docs/module-development/` に集約
2. **Single Source of Truth**: 各トピックに対して権威ある単一の情報源を確立
3. **明確な構造**: 論理的で直感的なディレクトリ構造

### 提案する新構造

```
📁 /docs/module-development/
│
├── 📄 README.md
│   - モジュール開発の概要とナビゲーション
│   - 各ドキュメントへのリンクと説明
│
├── 📄 01-getting-started.md
│   - クイックスタートガイド
│   - 基本概念の説明
│   - 最初のモジュール作成
│
├── 📄 02-development-guide.md（← 現在の module-development-guide.md）
│   - 統一的な開発ガイド
│   - 正しいサイズ基準（簡潔版：50-200行、詳細版：200-600行）
│   - 標準的な開発手順
│   - 品質基準とベストプラクティス
│
├── 📄 03-template-guide.md（← 現在の /modular/DEVELOPMENT.md）
│   - テンプレートの使用方法
│   - カテゴリ別のテンプレート例
│   - テンプレートのカスタマイズ
│
├── 📄 04-research-methods.md（← MODULE_CREATION_BEST_PRACTICES.md を統合）
│   - 効果的な調査方法
│   - 情報源の評価（Tier 1-3）
│   - 並列調査戦略
│   - 2025年1月プロジェクトの事例
│
├── 📄 05-quality-assurance.md
│   - 検証方法の詳細
│   - validate-modules.sh の使い方
│   - サイズチェック機能
│   - 品質メトリクス
│
├── 📄 06-advanced-topics.md
│   - 大規模モジュールの分割
│   - 依存関係の管理
│   - パフォーマンス最適化
│
├── 📁 examples/
│   ├── simple-module/
│   ├── complex-module/
│   └── refactored-module/
│
└── 📁 references/
    ├── size-standards.md
    ├── naming-conventions.md
    └── yaml-metadata-spec.md
```

## 実装計画

### Phase 1: ディレクトリ作成と基本移行（1日）
1. **新ディレクトリ作成**
   ```bash
   mkdir -p /docs/module-development/examples
   mkdir -p /docs/module-development/references
   ```

2. **既存ファイルの移動とリネーム**
   - `/docs/module-development-guide.md` → `/docs/module-development/02-development-guide.md`
   - `/modular/DEVELOPMENT.md` → `/docs/module-development/03-template-guide.md`

3. **README.md作成**
   - ナビゲーションハブとして機能
   - 各ドキュメントの役割を明確に説明

### Phase 2: コンテンツ統合と整理（3-4日）
1. **重複内容の統合**
   - サイズ基準を統一（簡潔版は詳細版の25-40%）
   - 開発手順の統一（Phase番号の整合性確保）

2. **新規ドキュメント作成**
   - `01-getting-started.md` - 初心者向けガイド
   - `05-quality-assurance.md` - 品質保証の詳細
   - `06-advanced-topics.md` - 上級トピック

3. **事例とリファレンスの整理**
   - 実際のモジュール例を `examples/` に配置
   - 技術仕様を `references/` に配置

### Phase 3: 既存ドキュメントの更新（2-3日）
1. **リダイレクトとリンク更新**
   - 旧ファイルにリダイレクト通知を配置
   - すべての内部リンクを更新

2. **他のドキュメントからの参照更新**
   - READMEやその他のガイドからのリンク修正
   - 相互参照の確認

3. **アーカイブ処理**
   - 古いファイルを `/docs/archive/` に移動
   - 履歴として保持

## 移行マッピング

| 現在のファイル | 新しい場所 | アクション |
|--------------|-----------|-----------|
| `/docs/module-development-guide.md` | `/docs/module-development/02-development-guide.md` | 移動・更新 |
| `/modular/DEVELOPMENT.md` | `/docs/module-development/03-template-guide.md` | 移動・整理 |
| `/docs/developers/best-practices/module-creation.md` | `/docs/module-development/02-development-guide.md` | 統合 |
| `/docs/developers/research/MODULE_CREATION_BEST_PRACTICES.md` | `/docs/module-development/04-research-methods.md` | 移動・更新 |
| `/docs/proposals/module_size_*.md` | `/docs/module-development/references/size-standards.md` | 統合 |

## 期待される効果

1. **アクセシビリティ向上**
   - ワンストップでモジュール開発情報にアクセス
   - 論理的な順序での学習パス

2. **保守性向上**
   - 情報の重複削除
   - 更新箇所の一元化

3. **開発効率向上**
   - 必要な情報への迅速なアクセス
   - 明確なガイドラインによる品質向上

## リスクと対策

### リスク
1. **既存リンクの破損**: 多数の内部・外部リンクが無効化
2. **一時的な混乱**: 開発者が新しい場所を把握するまでの期間
3. **ドキュメント間の不整合**: 統合作業中の情報の矛盾

### 対策
1. **段階的移行とリダイレクト**: 旧ファイルに新しい場所への案内を残す
2. **明確な告知**: READMEとSlack/Discord等での周知
3. **徹底的なレビュー**: 統合前後での内容確認

## 次のステップ

1. この計画のレビューと承認
2. `/docs/module-development/` ディレクトリの作成
3. Phase 1の実行開始

## 統合後の利用イメージ

```bash
# 新規開発者の場合
1. /docs/module-development/README.md を読む
2. 01-getting-started.md でクイックスタート
3. 02-development-guide.md で詳細を学ぶ

# 経験者の場合
- 必要に応じて特定のガイドを参照
- examples/ から類似モジュールを探す
- references/ で技術仕様を確認
```