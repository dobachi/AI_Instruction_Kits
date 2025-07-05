---
layout: default
title: 機能詳細 - AI Instruction Kits
---

# 機能詳細

AI Instruction Kitsの全機能を詳しくご紹介します。

## 📚 指示書カテゴリ

### 1. システム管理 (system)
AIの動作を制御する基本的な指示書

- **ROOT_INSTRUCTION.md** - 指示書マネージャーとして動作
- **INSTRUCTION_SELECTOR.md** - キーワードベースの自動選択
- **CHECKPOINT_MANAGER.md** - 進捗管理システム

### 2. 一般タスク (general)
日常的なタスクに使える汎用指示書

- **basic_qa.md** - 質問応答、情報提供
- プロジェクト管理支援
- ドキュメント作成補助

### 3. コーディング (coding)
プログラミング作業に特化した指示書

- **basic_code_generation.md** - コード生成の基本
- デバッグ支援
- リファクタリング指南
- テストコード作成

### 4. 文章作成 (writing)
ドキュメントやコンテンツ作成用

- **basic_text_creation.md** - 基本的な文章作成
- **presentation_creation.md** - プレゼンテーション構成
- 技術文書作成
- マーケティングコンテンツ

### 5. 分析 (analysis)
データ分析や調査タスク用

- **basic_data_analysis.md** - データ分析の基本
- 市場調査支援
- 競合分析
- パフォーマンス分析

### 6. クリエイティブ (creative)
創造的なタスクのサポート

- **basic_creative_work.md** - アイデア生成
- デザイン提案
- ストーリーテリング
- ブレインストーミング

### 7. エージェント型 (agent)
特定の専門家として振る舞う指示書

- **python_expert.md** - Python開発の専門家
- **code_reviewer.md** - コードレビュアー
- **technical_writer.md** - テクニカルライター

## 🔧 コア機能

### チェックポイント管理

作業の進捗を自動的に記録・追跡

```bash
# タスク開始
[1/5] 開始 | 次: 分析
📌 記録→checkpoint.log: [時刻][タスクID][START] タスク名

# 進捗更新
[3/5] 実装完了 | 次: テスト
📌 記録→checkpoint.log: 開始時/エラー時/完了時のみ記録

# タスク完了
[✓] 全完了 | 成果: 詳細な成果
```

### 統合モード

プロジェクトのニーズに合わせて選択可能

| モード | 利点 | 適用場面 |
|--------|------|----------|
| **コピー** | • Gitなし<br>• 最速セットアップ<br>• オフライン対応 | 小規模プロジェクト<br>Git未使用環境 |
| **クローン** | • 完全な制御<br>• 独自カスタマイズ<br>• 履歴管理 | 大規模カスタマイズ<br>独自の指示書開発 |
| **サブモジュール** | • アップデート簡単<br>• バージョン管理<br>• 複数プロジェクト対応 | チーム開発<br>長期プロジェクト |

### カスタムURL対応

独自のリポジトリから指示書を利用

```bash
# 企業の内部リポジトリ
--url https://gitlab.company.com/ai-team/instructions.git

# 個人のフォーク
--url https://github.com/yourname/custom-instructions.git

# プライベートリポジトリ（認証必要）
--url git@github.com:org/private-instructions.git
```

## 🎯 高度な使い方

### 1. カスタム指示書の作成

```markdown
# カスタム指示書テンプレート
## 目的
この指示書の目的を明確に記述

## 前提条件
- 必要な知識
- 環境要件
- 依存関係

## 具体的な指示
1. ステップ1の詳細
2. ステップ2の詳細
3. ...

## 期待される成果
- 成果物1
- 成果物2

---
## ライセンス情報
- **ライセンス**: [ライセンス名]
- **作成者**: [名前]
- **作成日**: [日付]
```

### 2. PROJECT.mdのカスタマイズ

プロジェクト固有の設定を詳細に記述：

```markdown
## プロジェクト固有の追加指示

### アーキテクチャ
- マイクロサービス構成
- API Gateway: Kong
- メッセージキュー: RabbitMQ

### 開発規約
- コミットメッセージ: Conventional Commits
- ブランチ戦略: Git Flow
- コードレビュー: 必須（2名以上）

### セキュリティ
- 認証: OAuth 2.0
- データ暗号化: AES-256
- シークレット管理: HashiCorp Vault
```

### 3. テンプレートの事前カスタマイズ

```bash
# テンプレートを編集
vi templates/ja/PROJECT_TEMPLATE.md

# 全新規プロジェクトに適用される共通設定を追加
- CI/CD設定
- 標準的なリントルール
- 共通のテストフレームワーク
```

## 🔒 セキュリティ機能

### プライベートリポジトリ対応
- SSH認証サポート
- アクセストークン利用可能
- 社内ネットワーク対応

### バージョン管理
- 特定バージョンの固定
- アップデート制御
- ロールバック機能

## 📊 利用統計とメトリクス

### チェックポイントログ分析
```bash
# タスク完了率を確認
grep "COMPLETE" checkpoint.log | wc -l

# 平均タスク時間を計算
# 各タスクの開始・完了時刻から算出
```

### 指示書使用頻度
- 最も使用される指示書の特定
- カスタマイズ箇所の分析
- チーム内の利用パターン把握

## 🚀 今後の展開

### 計画中の機能
- 🌐 Web UI での指示書管理
- 🤖 AI による指示書自動生成
- 📱 モバイルアプリ対応
- 🔍 指示書の検索・フィルタリング
- 📈 使用分析ダッシュボード

### コミュニティ貢献
- 新しい指示書カテゴリの追加
- 多言語対応（中国語、韓国語等）
- 業界別テンプレート集
- ベストプラクティス共有

<div style="margin-top: 3em; padding: 1em; background-color: #f0f8ff; border-radius: 8px;">
  <h3>📚 さらに詳しく</h3>
  <ul>
    <li><a href="https://github.com/dobachi/AI_Instruction_Kits/tree/main/instructions">全指示書を確認</a></li>
    <li><a href="https://github.com/dobachi/AI_Instruction_Kits/blob/main/docs/HOW_TO_USE.md">詳細な使用ガイド</a></li>
    <li><a href="https://github.com/dobachi/AI_Instruction_Kits/issues/new">機能リクエスト</a></li>
  </ul>
</div>