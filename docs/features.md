---
layout: default
title: AI Instruction Kits
description: 機能詳細 - すべての機能を詳しく解説
lang: ja
---

# 機能詳細

AI Instruction Kitsの全機能を詳しくご紹介します。

## 🧩 NEW! モジュラー指示書システム

### 概要
2025年7月にリリースされた革新的な機能で、プロジェクトの要件に応じて動的に指示書を生成します。

### MODULE_COMPOSER
タスクを分析し、最適なモジュールを組み合わせて、カスタマイズされた指示書を自動生成します。

**主な特徴：**
- **自動タスク分析**：自然言語でタスクを入力するだけ
- **インテリジェントな選択**：メタデータを使用して最適なモジュールを選択
- **柔軟な組み合わせ**：複数のモジュールを統合可能
- **デフォルト値対応**：最小限の設定で使用開始

### 🚀 事前生成プリセット（高速・推奨）

**応答時間0秒**で即座に使用できる、事前生成済みの指示書です。

#### 利用可能なプリセット（8種類）

1. **web_api_production**：本番環境向けWeb API開発
   - RESTful API設計、セキュリティ実装、ドキュメント生成
   - パス: `instructions/ja/presets/web_api_production.md`

2. **cli_tool_basic**：CLIツール開発
   - コマンドライン解析、エラーハンドリング、配布準備
   - パス: `instructions/ja/presets/cli_tool_basic.md`

3. **data_analyst**：データ分析タスク
   - データ前処理、統計分析、可視化、レポート作成
   - パス: `instructions/ja/presets/data_analyst.md`

4. **technical_writer**：技術文書作成
   - API文書、ユーザーガイド、技術ブログ、README作成
   - パス: `instructions/ja/presets/technical_writer.md`

5. **academic_researcher**：学術研究支援
   - 文献調査、論文執筆、引用管理、研究計画
   - パス: `instructions/ja/presets/academic_researcher.md`

6. **business_consultant**：ビジネスコンサルティング
   - 市場分析、戦略立案、プレゼン作成、ROI計算
   - パス: `instructions/ja/presets/business_consultant.md`

7. **project_manager**：プロジェクト管理
   - タスク管理、リソース配分、進捗追跡、リスク管理
   - パス: `instructions/ja/presets/project_manager.md`

8. **startup_advisor**：スタートアップ支援
   - ビジネスモデル、ピッチデッキ、資金調達、MVP開発
   - パス: `instructions/ja/presets/startup_advisor.md`

#### プリセットのメリット

- **即座に使用可能**：生成待ち時間なし（0秒）
- **最適化済み**：よく使用されるタスクに特化
- **品質保証**：テスト済みで信頼性が高い
- **自動更新**：モジュール変更時に自動再生成

### 専門知識モジュール（5種類）

1. **software_engineering**：SWEBOK v4.0準拠の最新ソフトウェア工学
2. **legal_engineering**：法令工学と規制技術の専門知識
3. **machine_learning**：ML/AIの設計・実装・運用
4. **parallel_distributed**：並列分散処理システムの専門知識
5. **data_space**：GAIA-X、IDSなどのデータスペース構築

### モジュールの種類

- **Core（コア）**：システムの基本構造を定義
- **Tasks（タスク）**：具体的な作業内容（コード生成、データ分析、文書作成など）
- **Skills（スキル）**：特定の能力（API設計、テスト、エラー処理など）
- **Methods（方法論）**：作業アプローチ（アジャイル、リーン、デザイン思考など）
- **Domains（ドメイン）**：業界固有の知識（金融、ヘルスケア、教育など）
- **Roles（役割）**：AIの振る舞い（メンター、レビュアー、コンサルタントなど）
- **Quality（品質）**：品質レベルや基準
- **Expertise（専門知識）**：深い専門知識と最新ベストプラクティス

### 使用例
```bash
# 学術論文を書く場合
claude "研究論文を執筆してください"
# → MODULE_COMPOSERがacademic_researcherプリセットを選択
# → 引用管理、方法論設計、統計分析モジュールも追加

# データ分析を行う場合
claude "売上データを分析して"
# → data_analystプリセットが自動選択
# → 可視化、統計処理、レポート作成モジュールを組み合わせ

# 専門的なタスクの場合
claude "分散システムの設計をして"
# → parallel_distributed expertiseモジュールが選択
# → 2024-2025年の最新技術トレンドに基づく設計
```

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

組織専用の非公開リポジトリから指示書を安全に取得できます。

#### 実装方法
```bash
# 社内専用リポジトリの例
bash setup-project.sh --url https://github.com/company/private-ai-instructions.git
```

- **利点**: 組織固有の機密性の高い指示書を安全に管理
- **用途**: 社内コーディング規約、独自のビジネスロジック、セキュリティポリシー

### SSH認証サポート

SSH鍵を使用したセキュアな認証方式に対応しています。

#### 実装方法
```bash
# SSH形式のURL使用
bash setup-project.sh --url git@github.com:company/private-instructions.git --submodule
```

- **利点**: パスワード不要で安全な認証、CI/CD環境での自動化が容易
- **前提**: 事前にSSH鍵の設定が必要（`ssh-keygen`と`ssh-add`）

### アクセストークン利用可能

GitHub/GitLab等のパーソナルアクセストークンを使った認証に対応。

#### 実装方法
```bash
# トークンをURLに埋め込む方式
bash setup-project.sh --url https://YOUR_TOKEN@github.com/company/repo.git

# 環境変数を使う方式（より安全）
export GIT_TOKEN=your_personal_access_token
bash setup-project.sh --url https://${GIT_TOKEN}@github.com/company/repo.git
```

- **利点**: 細かい権限制御が可能、有効期限の設定、必要最小限のアクセス権
- **用途**: CI/CD環境、自動化スクリプト、一時的なアクセス

### 社内ネットワーク対応

インターネットに公開されていない組織内部のGitサーバーもサポート。

#### 実装方法
```bash
# 社内GitLabサーバーの例
bash setup-project.sh --url https://gitlab.company.local/team/ai-instructions.git

# 社内Giteaサーバーの例
bash setup-project.sh --url http://git.internal:3000/dev/instructions.git
```

- **対応サーバー**: GitLab CE/EE、Gitea、Bitbucket Server、その他Git互換サーバー
- **利点**: 完全に社内で完結、外部ネットワーク不要、高度なセキュリティ

## 📦 バージョン管理

### 特定バージョンの固定

プロジェクトで使用する指示書のバージョンを固定し、予期しない変更を防ぎます。

#### サブモジュールでの実装
```bash
# 特定のコミットに固定
cd instructions/ai_instruction_kits
git checkout v1.2.3  # または特定のコミットハッシュ
cd ../..
git add instructions/ai_instruction_kits
git commit -m "指示書をv1.2.3に固定"
```

- **利点**: 再現性の確保、安定した動作、チーム間での一貫性
- **用途**: 本番環境、重要なプロジェクト、監査が必要な環境

### アップデート制御

指示書の更新を計画的に管理し、テスト後に適用できます。

#### 更新方法
```bash
# 最新版の確認（実際には更新しない）
cd instructions/ai_instruction_kits
git fetch
git log HEAD..origin/main --oneline

# テスト環境で検証後、更新を適用
git pull origin main
cd ../..
git add instructions/ai_instruction_kits
git commit -m "指示書を最新版に更新"
```

- **ワークフロー**: 
  1. 開発環境で新バージョンをテスト
  2. 変更内容を確認・レビュー
  3. 段階的にステージング→本番へ適用

### ロールバック機能

問題が発生した場合、以前の安定版に即座に戻せます。

#### ロールバック手順
```bash
# 直前のバージョンに戻す
cd instructions/ai_instruction_kits
git checkout HEAD~1
cd ../..
git add instructions/ai_instruction_kits
git commit -m "指示書を前バージョンにロールバック"

# 特定の安定版に戻す
cd instructions/ai_instruction_kits
git checkout v1.1.0  # 安定していた特定バージョン
cd ../..
git add instructions/ai_instruction_kits
git commit -m "指示書をv1.1.0（安定版）にロールバック"
```

- **利点**: リスク管理、迅速な障害対応、安心してアップデートを試せる
- **推奨**: ロールバック前後でテストを実施、変更履歴を記録

## 📊 利用統計とメトリクス

### チェックポイントログ分析

作業の進捗と成果を定量的に把握できます。

#### 基本的な統計情報
```bash
# 完了したタスクの総数
grep "COMPLETE" checkpoint.log | wc -l

# 実行中のタスク（未完了）を確認
grep "START" checkpoint.log | grep -v "COMPLETE"

# 本日のタスク一覧
grep "$(date +%Y-%m-%d)" checkpoint.log

# エラーが発生したタスクを抽出
grep "ERROR" checkpoint.log
```

#### タスク分析の例
```bash
# タスクIDごとの所要時間を計算するスクリプト例
#!/bin/bash
while read -r line; do
    if [[ $line =~ \[TASK-([a-f0-9]+)\] ]]; then
        task_id="${BASH_REMATCH[1]}"
        # START/COMPLETEのペアを見つけて時間差を計算
        # （実装例は省略）
    fi
done < checkpoint.log
```

### プロジェクト別カスタマイズ分析

PROJECT.mdの内容から、プロジェクトの特性を把握：

```bash
# プロジェクト設定の確認
cat instructions/PROJECT.md | grep -E "(ビルドコマンド|リントコマンド|テストフレームワーク)"

# カスタマイズされた項目数をカウント
grep -v "^#" instructions/PROJECT.md | grep -v "^$" | grep -v "例：" | wc -l
```

### 成果物の定量化

チェックポイントログから成果を抽出：

```bash
# 成果物のサマリーを生成
grep "成果:" checkpoint.log | sed 's/.*成果: //' | sort | uniq -c | sort -nr

# 作成されたファイル数、テスト数などを集計
grep "成果:" checkpoint.log | grep -E "[0-9]+個|[0-9]+件|[0-9]+ファイル"
```

## 🚀 今後の展開

### 計画中の機能

#### 🤖 AI による指示書自動生成
既存の指示書を学習して、新しいカテゴリの指示書を自動生成
- プロジェクトの特性を分析して最適な指示書を提案
- 既存指示書のベストプラクティスを組み合わせ
- ユーザーのフィードバックを反映した改善

#### 🔍 指示書の検索・フィルタリング
指示書が増えても素早く必要なものを見つけられる仕組み
- タグベースの分類システム
- キーワード検索機能
- 依存関係の可視化
- 使用頻度に基づく推奨

#### 📝 指示書のバージョン間差分表示
更新時に何が変わったかを把握しやすく
- 変更箇所のハイライト表示
- 影響範囲の分析
- ロールバック時の判断材料

#### 🧪 指示書のテストフレームワーク
指示書の品質を保証する仕組み
- 期待する出力のテストケース
- 指示の曖昧さチェック
- 複数AI間での互換性テスト

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