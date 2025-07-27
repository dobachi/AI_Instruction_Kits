---
layout: default
title: 提案ドキュメント
description: AI指示書キットの新機能・改善提案
lang: ja
---

# 提案ドキュメント

このセクションには、AI指示書キットの新機能や改善に関する提案ドキュメントが含まれています。

## 🔥 アクティブな提案（current/）

### 最優先・最新
- [システム設計総合まとめ](current/comprehensive_system_design_summary.md) - **最新の統合設計** 
  - ペルソナ・タスク分離による汎用化
  - AI自律実行の実現
  - 段階的な実装計画
  - **関連Issue**: [#66](https://github.com/dobachi/AI_Instruction_Kits/issues/66)

- [AI自律実行システム](current/ai_autonomous_instruction_generation.md) - AIによる自動的な指示書生成・実行
  - セミオート型（提案→承認→実行）を推奨
  - 透明性と制御性のバランス

- [3システム分離設計](current/three_systems_separation_design.md) - チェックポイント・モジュラー・並列処理の分離
  - 各システムの独立性確保
  - 段階的な実装アプローチ

### 実装計画
- [学術研究モジュール実装計画](current/academic_modules_implementation_plan.md) - 学術研究支援のためのモジュール
  - **関連Issue**: [#25](https://github.com/dobachi/AI_Instruction_Kits/issues/25)

- [指示書システム再構築提案](current/instructions_system_restructure.md) - システム全体の再構築案

- [モジュラーシステム高度機能](current/modular_advanced_features.md) - 高度な機能の追加計画
  - **関連Issue**: [#13](https://github.com/dobachi/AI_Instruction_Kits/issues/13)

- [v1からv2への移行戦略](current/v1_to_v2_migration_strategy.md) - メジャーバージョンアップ計画

### その他
- [ファイル整理計画](file_organization_plan.md) - このディレクトリの整理計画
  - **関連Issue**: [#67](https://github.com/dobachi/AI_Instruction_Kits/issues/67)

## 📚 アーカイブ

### ✅ 実装完了（completed/）
過去に提案され、すでに実装が完了したもの：
- [Claude Codeカスタムコマンド](../proposals_archive/completed/)
- [モジュールファイル命名規則改訂](../proposals_archive/completed/)
- [モジュールドキュメント統合計画](../proposals_archive/completed/)

### 🔄 統合済み（superseded/）
新しい提案に統合されたもの：
- チェックポイントシステム詳細設計 → 総合まとめに統合
- モジュラーシステム詳細設計 → 総合まとめに統合
- 並列処理アプローチ検討 → 総合まとめに統合
- タスクテンプレート設計 → AI自律実行システムに統合

### 🧪 実験的・参考（experimental/）
研究や参考のために保存：
- 初期アイデア、分析レポート
- 外部ツール連携の検討
- 各種課題の詳細分析

## 🚀 新しい提案の作成

新しい機能や改善の提案がある場合は、以下の手順で提案ドキュメントを作成してください：

1. [GitHubでIssueを作成](https://github.com/dobachi/AI_Instruction_Kits/issues/new)
2. 提案の詳細をMarkdown形式でドキュメント化
3. `docs/proposals/`ディレクトリに配置
4. レビュー後、適切なディレクトリへ移動

## 📋 提案書ステータス管理

各提案書の先頭にYAMLフロントマターでステータスを記載：
```yaml
---
status: draft|review|active|completed|superseded
created: YYYY-MM-DD
updated: YYYY-MM-DD
superseded_by: [ファイル名]  # 置き換えられた場合
---
```

## 📚 関連リンク

- [開発者向けドキュメント](../developers/)
- [モジュラーシステム開発ガイド](../../modular/DEVELOPMENT.md)
- [GitHub Issues](https://github.com/dobachi/AI_Instruction_Kits/issues)