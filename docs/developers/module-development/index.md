---
layout: default
title: モジュール開発ドキュメント
description: AI指示書キットのモジュール開発に関する包括的ガイド
lang: ja
---

# モジュール開発ドキュメント

このディレクトリには、AI指示書キットのモジュール開発に関するすべてのドキュメントが集約されています。

## 📚 ドキュメント構成

### 🚀 はじめに
- **[01-getting-started](./01-getting-started)** - モジュール開発のクイックスタート
  - 初めてモジュールを作成する方向け
  - 基本概念と最小限の例
  - 10分で最初のモジュールを作成

### 📖 開発ガイド
- **[02-development-guide](./02-development-guide)** - モジュール開発の包括的ガイド
  - モジュールの種類と構造
  - サイズ基準と品質基準
  - ベストプラクティスとアンチパターン

### 🔧 テンプレート活用
- **[03-template-guide](./03-template-guide)** - テンプレートを使った効率的な開発
  - カテゴリ別テンプレートの使い方
  - テンプレートのカスタマイズ方法
  - Phase 0 アプローチの詳細

### 🔍 調査方法
- **[04-research-methods](./04-research-methods)** - 効果的な情報収集と調査
  - 並列調査戦略
  - 情報源の評価（Tier 1-3）
  - 2025年1月プロジェクトの成功事例

### ✅ 品質保証
- **[05-quality-assurance](./05-quality-assurance)** - モジュールの検証と品質管理
  - validate-modules.sh の使い方
  - サイズチェック機能（--check-size）
  - 品質メトリクスとレビューチェックリスト

### 🎓 上級トピック
- **[06-advanced-topics](./06-advanced-topics)** - 高度な開発テクニック
  - 大規模モジュールの分割方法
  - 複雑な依存関係の管理
  - パフォーマンス最適化

## 📂 サブディレクトリ

### examples/
実際のモジュール例が含まれています：
- `simple-module/` - シンプルなタスクモジュールの例
- `complex-module/` - 依存関係を持つ複雑なモジュールの例
- `refactored-module/` - 巨大モジュールを分割した例

### references/
技術仕様とリファレンス：
- `size-standards.md` - 詳細なサイズ基準
- `naming-conventions.md` - 命名規則の完全ガイド
- `yaml-metadata-spec.md` - YAMLメタデータ仕様

## 🎯 推奨される学習パス

### 初心者向け
1. [01-getting-started](./01-getting-started) でクイックスタート
2. [02-development-guide](./02-development-guide) で基本を学ぶ
3. [03-template-guide](./03-template-guide) でテンプレートを活用
4. `examples/simple-module/` で実例を確認

### 経験者向け
1. [02-development-guide](./02-development-guide) の品質基準を確認
2. [04-research-methods](./04-research-methods) で効率的な調査方法を学ぶ
3. [06-advanced-topics](./06-advanced-topics) で高度なテクニックを習得
4. `references/` で技術仕様を参照

## 🔧 よく使うコマンド

```bash
# モジュールの検証（メタデータのみ）
./scripts/validate-modules.sh

# サイズチェックを含む検証
./scripts/validate-modules.sh --check-size

# 新規モジュールの作成（テンプレート使用）
cp templates/ja/module_template.md modular/ja/modules/[category]/[module_name].md
```

## 📌 重要な基準

### サイズ基準（統一版）
- **簡潔版**: 50-200行（推奨）、最大300行
- **詳細版**: 200-600行（推奨）、最大800行
- **比率**: 簡潔版は詳細版の25-40%

### 品質基準
- ✅ YAMLメタデータの完全性
- ✅ 適切なサイズ範囲
- ✅ 明確で実行可能な指示
- ✅ 実用的な例の提供

## 🤝 貢献方法

1. このガイドラインに従ってモジュールを作成
2. `validate-modules.sh --check-size` で検証
3. プルリクエストを作成
4. レビューとフィードバックを受ける

## 📊 関連Issue

- [#45: モジュールサイズ基準の明確化と検証機能の実装提案](https://github.com/dobachi/AI_Instruction_Kits/issues/45)
- [#46: モジュール開発ドキュメントの統合・集約提案](https://github.com/dobachi/AI_Instruction_Kits/issues/46)

---

最終更新日: 2025-01-26