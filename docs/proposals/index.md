---
layout: default
title: 提案ドキュメント
description: AI指示書キットの新機能・改善提案
lang: ja
---

# 提案ドキュメント

このセクションには、AI指示書キットの新機能や改善に関する提案ドキュメントが含まれています。

## 📋 提案一覧

### [学術モジュール実装計画](academic_modules_implementation_plan.html)
学術論文執筆支援のための5つの新モジュール（academic_writing、citation_management、literature_review、research_methodology、thesis_writing）の実装計画です。これらのモジュールは、研究者や学生がAIを活用して高品質な学術論文を執筆するための包括的な支援を提供します。

**関連Issue**: [#25](https://github.com/dobachi/AI_Instruction_Kits/issues/25)

### [AI駆動型モジュラーシステム](ai_driven_modular_system.html)
AIを活用したモジュール自動生成・最適化システムの提案です。機械学習を用いてユーザーの使用パターンを分析し、最適なモジュール構成を自動的に提案・生成する機能を実現します。

### [分散型メタデータシステム](distributed_metadata_system.html)
各指示書モジュールのメタデータを分散管理し、効率的な検索・フィルタリング・依存関係管理を実現するシステムの提案です。YAMLベースの軽量なメタデータ管理により、大規模なモジュールライブラリの運用を可能にします。

### [モジュラー高度機能](modular_advanced_features.html)
モジュラーシステムの高度な拡張機能の提案です。動的モジュール合成、条件付きモジュール読み込み、モジュール間通信、バージョン管理など、エンタープライズレベルの要求に対応する機能を含みます。

**関連Issue**: [#13](https://github.com/dobachi/AI_Instruction_Kits/issues/13)

### [モジュラーシステムのトークン数削減](modular_token_reduction.html)
モジュラーシステムで生成される指示書のトークン数が過大になる問題に対する解決策の提案と実装計画です。簡潔版モジュールの導入により、AIモデルの制限内で効率的に動作する最適化されたシステムを実現します。

**関連Issue**: [#35](https://github.com/dobachi/AI_Instruction_Kits/issues/35)

### [モジュラーファイル命名規則の改訂](modular_file_naming_revision.html)
簡潔版をデフォルトとする設計思想に基づき、モジュールファイルの命名規則を改訂する提案です。標準ファイル名で簡潔版、`_detailed`サフィックスで詳細版とすることで、より直感的で効率的なシステムを実現します。

**関連Issue**: [#35](https://github.com/dobachi/AI_Instruction_Kits/issues/35)

### [OpenHandsでオープンソースモデルを使用するガイド](openhands_oss_models.html)
OpenHandsで無料のオープンソースLLMモデル（Llama 3.1、Gemma 2、Qwen2.5など）を使用する方法の包括的なガイドです。Ollama、Groq、Google AI Studioなどを活用し、商用APIに依存せずにAI支援開発を実現する実践的な設定方法を提供します。

**関連Issue**: [#38](https://github.com/dobachi/AI_Instruction_Kits/issues/38)

## 🚀 新しい提案の作成

新しい機能や改善の提案がある場合は、以下の手順で提案ドキュメントを作成してください：

1. [GitHubでIssueを作成](https://github.com/dobachi/AI_Instruction_Kits/issues/new)
2. 提案の詳細をMarkdown形式でドキュメント化
3. `docs/proposals/`ディレクトリに配置
4. このindex.mdファイルに追加

## 📚 関連リンク

- [開発者向けドキュメント](../developers/)
- [モジュラーシステム開発ガイド](../../modular/DEVELOPMENT.md)
- [GitHub Issues](https://github.com/dobachi/AI_Instruction_Kits/issues)