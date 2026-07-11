---
layout: default
title: AI Instruction Kits
description: 機能詳細 - すべての機能を詳しく解説
lang: ja
---

# 機能詳細

AI Instruction Kitsの全機能を詳しくご紹介します。

## 🧩 v2.0 スキルベースアーキテクチャ

### 概要
v2.0で導入されたスキルベースアーキテクチャにより、タスクに応じたスキルの自動選択・実行が可能になりました。

### スキルオーケストレーター（ROOT_INSTRUCTION）
タスクを分析し、`.claude/skills/` に配置されたスキルから最適なものを自動選択して実行します。

**主な特徴：**
- **自動タスク分析**：自然言語でタスクを入力するだけ
- **インテリジェントな選択**：タスク内容に基づいて最適なスキルを選択
- **マーケットプレイス連携**：スキルはマーケットプレイスから導入
- **最小構成で開始**：commit-safe を入れるだけですぐに利用可能

### スキルはマーケットプレイスから

commit-safe を含む全スキルは [claude-skills-marketplace](https://github.com/dobachi/claude-skills-marketplace) から導入します。本リポジトリはスキルを同梱しません。

```text
/plugin marketplace add dobachi/claude-skills-marketplace
/plugin install commit-safe@dobachi-skills
```

- **commit-safe**：安全なコミット
   - AI署名なしのクリーンコミット（自己完結の commit.sh を同梱）
   - ファイル指定型の安全なコミット手順

タスク管理（Todo）・進捗追跡・Git worktree・ビルド検出は、近年のAIエージェント（Claude Codeなど）が標準装備しているため、それらのネイティブ機能を活用します。

導入したスキルは `.claude/skills/` から自動的に選択・利用されます。

### 使用例
```bash
# スキルオーケストレーターが自動でスキルを選択
claude "新機能を実装してください"
# → ROOT_INSTRUCTION がタスクを分析
# → AIツールのネイティブ機能で進捗管理・作業（Todo / worktree / ビルド検出）
# → commit-safe でクリーンコミット

# 安全なコミット
claude "変更をコミットして"
# → commit-safe スキルがAI署名なしでコミット
```

## 📚 スキルとカスタマイズ

### システム指示書
- **ROOT_INSTRUCTION.md** - スキルオーケストレーター（`.claude/skills/`から最適なスキルを自動選択）

### スキル（マーケットプレイスから導入）
| スキル | 用途 | 自動提案タイミング |
|--------|------|-------------------|
| commit-safe | 安全なコミット | 変更後にファイル指定コミット |

タスク管理（Todo）・進捗追跡・Git worktree・ビルド検出は、AIツールのネイティブ機能を利用します。

### マーケットプレイススキル

追加の専門スキルは [claude-skills-marketplace](https://github.com/dobachi/claude-skills-marketplace) からインストールできます。

| カテゴリ | スキル例 |
|---------|---------|
| 開発ツール | build, commit-and-report, github-issues |
| 役割スキル | web-api-dev, data-analyst, python-expert, code-reviewer |
| プレゼンテーション | marp-slides |
| 品質管理 | fact-checker, evidence-check |

### カスタム指示書

`instructions/ja/` 配下にプロジェクト固有の指示書を追加可能：
- `instructions/ja/coding/` - コーディング関連
- `instructions/ja/writing/` - 文章作成関連
- `instructions/ja/analysis/` - 分析関連

## 🔧 コア機能

### タスク管理・進捗追跡

作業の進捗や指示書の使用履歴は、お使いのAIツールのネイティブ機能（Claude Code の Todo など）で追跡します。会話の中でタスクの分解・進捗の可視化が自動的に行われるため、独自のチェックポイントスクリプトは不要です。

### Claude Codeエージェント機能

Task tool（エージェント機能）を活用した大規模分析タスクの自動化：

- **コード品質分析**: プロジェクト全体の品質チェック
- **依存関係調査**: 包括的な依存関係マッピング
- **テストカバレッジ**: 網羅的なカバレッジ分析
- **ドキュメント検証**: 実装との整合性確認

Claude CodeのTask toolを使用すると、サブエージェントが独立したコンテキストで並行分析を実行できます。CLAUDE.mdの「Claude Codeエージェント機能の活用」セクションを参照してください。

### マーケットプレイスのスキル例

[マーケットプレイス](https://github.com/dobachi/claude-skills-marketplace)から導入できる代表的なスキル（導入後はスキル名で呼び出し・自動起動）：

| スキル | 説明 | 使用例 |
|--------|------|--------|
| `commit-and-report` | コミット＆Issue報告 | `commit-and-report "バグ修正完了"` |
| `commit-safe` | クリーンコミット（AI署名なし） | `commit-safe "ドキュメント更新"` |
| `reload-instructions` | 指示書の再読み込み | `reload-instructions` |
| `github-issues` | GitHub Issueを確認してタスク整理 | `github-issues` |
| `reload-and-reset` | AIシステムをリセットして指示書再読み込み | `reload-and-reset` |

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

### プロジェクト別カスタマイズ分析

PROJECT.mdの内容から、プロジェクトの特性を把握：

```bash
# プロジェクト設定の確認
cat instructions/PROJECT.md | grep -E "(ビルドコマンド|リントコマンド|テストフレームワーク)"

# カスタマイズされた項目数をカウント
grep -v "^#" instructions/PROJECT.md | grep -v "^$" | grep -v "例：" | wc -l
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
    <li><a href="usage">使用ガイド</a></li>
    <li><a href="https://github.com/dobachi/claude-skills-marketplace">スキルマーケットプレイス</a></li>
    <li><a href="https://github.com/dobachi/AI_Instruction_Kits/issues/new">機能リクエスト</a></li>
  </ul>
</div>