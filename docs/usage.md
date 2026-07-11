---
layout: default
title: AI Instruction Kits
description: 使用ガイド - 詳細な使い方とベストプラクティス
lang: ja
---

# 使用ガイド

AI Instruction Kits v2.0のスキルベースアーキテクチャによる使い方とベストプラクティスをご紹介します。

## 📖 基本的な使い方

v2.0では、CLAUDE.mdを参照するだけでROOT_INSTRUCTIONがタスクに最適なスキルを自動選択します。セットアップ後は非常にシンプルです。

### セットアップ

```bash
# プロジェクトに統合
bash scripts/setup-project.sh
```

### 日常的な使い方

```bash
# これだけでOK！ROOT_INSTRUCTIONが適切なスキルを自動選択
claude "CLAUDE.mdを参照して、ユーザー認証機能を実装して"

# タスクの種類を問わず同じ入り口
claude "CLAUDE.mdを参照して、パフォーマンスのボトルネックを調査して"
claude "CLAUDE.mdを参照して、RESTful APIを設計して"
```

**仕組み**: `CLAUDE.md` → `ROOT_INSTRUCTION.md`（スキルオーケストレーター）→ `.claude/skills/` から最適なスキルを自動選択 → タスク実行

## 🎯 スキルベースワークフロー

v2.0の中核は、マーケットプレイスから導入する **commit-safe** スキルです（`/plugin install commit-safe@dobachi-skills`）。導入後は ROOT_INSTRUCTION がタスクの内容に応じて自動的に適切なスキルを提案します。

タスク管理（Todo）・進捗追跡・Git worktree・ビルド検出は、近年のAIエージェント（Claude Codeなど）が標準装備しているため、それらのネイティブ機能を活用します。独自スクリプトは不要です。

### commit-safe（安全なコミット）

AI署名なしのクリーンなコミットを作成します。

```bash
# AI署名が自動除去されたクリーンコミット
scripts/commit.sh "feat: ユーザー認証機能を追加"
```

**自動提案タイミング**: 変更後にファイル指定コミットを提案

### タスク管理・worktree・ビルドはAIツールのネイティブ機能を利用

進捗追跡やビルドの自動化は、お使いのAIツールのネイティブ機能（Claude Code の Todo / worktree / ビルド検出など）を利用してください。

### 基本ワークフロー

```
1. タスクをAIに依頼 → 2. AIがネイティブ機能で進捗管理・作業 → 3. commit-safe でコミット
```

## 🛒 マーケットプレイススキル

追加スキルを [claude-skills-marketplace](https://github.com/dobachi/claude-skills-marketplace) からインストールできます。

### Claude Code の `/plugin` コマンドでインストール

```bash
# Step 1: マーケットプレイスを登録（初回のみ）
/plugin marketplace add dobachi/claude-skills-marketplace

# Step 2: スキルをインストール
/plugin install code-reviewer@dobachi-skills
/plugin install data-analyst@dobachi-skills
```

`/plugin` を単独で実行すると、プラグインマネージャーUIが開き、スキルの一覧・インストール・管理が対話的に行えます。

### インストールスコープ

| スコープ | 説明 | 保存先 |
|---------|------|--------|
| **User** | 自分の全プロジェクトで有効 | `~/.claude/settings.json` |
| **Project** | チームメンバーも利用可能 | `.claude/settings.json` |
| **Local** | このリポジトリの自分だけ | `.claude/settings.local.json` |

### 手動インストール

`/plugin` コマンドを使わない場合は、スキルファイルを直接配置できます：

```bash
# マーケットプレイスからスキルディレクトリをコピー
cp -r path/to/code-reviewer .claude/skills/code-reviewer
```

### カスタムスキルの作成

独自のスキルが必要な場合は、マーケットプレイスの skill-creator スキルを活用できます。スキルファイルを `.claude/skills/` に配置するだけで利用可能になります。

## 📊 タスク管理・進捗追跡

タスク管理（Todo）や進捗追跡は、お使いのAIツールのネイティブ機能を利用してください。Claude Code の Todo 機能などが、会話の中でタスクの分解・進捗の可視化を自動的に行います。独自のチェックポイントスクリプトは不要になりました。

## 🌲 Git worktree運用

複雑なタスクや複数ファイルにまたがる変更では、Git worktreeでの作業を推奨します。worktree の作成・切り替え・クリーンアップは、お使いのAIツールのネイティブ機能（Claude Code の worktree 機能など）を利用してください。

## ⚙️ PROJECT.mdのカスタマイズ

プロジェクト固有の設定はPROJECT.mdに集約します。

### 基本的な設定例

```markdown
## プロジェクト固有の追加指示

### コーディング規約
- ESLint設定: .eslintrc.js に従う
- 命名規則: キャメルケース
- コメント: JSDoc形式

### テスト要件
- カバレッジ: 80%以上
- E2Eテスト: Cypressを使用

### ビルド設定
- ビルドコマンド: npm run build
- リントコマンド: npm run lint
- テストコマンド: npm run test

### 指示の優先順位
1. PROJECT.md（最優先）
2. 個別タスクの指示
3. スキルによる自動判断
```

## 🤖 Codex CLI / Gemini CLI / Antigravity CLI

AI Instruction Kitsは、Claude Code以外のAI CLIツールにも対応しています。各ツール向けの指示書（`CODEX.md` / `GEMINI.md` / `AGENTS.md`、いずれも `PROJECT_META.md` へのsymlink）を用意しています。

**スキルは全て外部マーケットプレイスに集約**しました。Codex・Gemini・Antigravity は Agent Skills 標準（`~/.agents/skills/<name>/SKILL.md`）を共有するため、マーケットプレイスの `install.sh` を一度実行すれば、全CLIで commit-safe などのスキルが利用できます。

```bash
git clone https://github.com/dobachi/claude-skills-marketplace
bash claude-skills-marketplace/install.sh
```

## 🎯 ベストプラクティス

### 1. スキル選択のコツ
- 基本的にはROOT_INSTRUCTIONに任せる（自動選択が最適）
- 特定のスキルを直接指定したい場合は `.claude/skills/` のファイルを参照
- 不足するスキルはマーケットプレイスで探す

### 2. カスタマイズの管理
- PROJECT.mdにプロジェクト固有設定を集約
- バージョン管理で変更履歴を記録
- チームメンバーと共有

### 3. フィードバックループ
- AIツールのネイティブな進捗管理機能で作業履歴を把握
- スキルの効果を評価し、必要に応じてカスタマイズ
- 新しいスキルの作成やマーケットプレイスへの貢献を検討

## 🔍 トラブルシューティング

### Q: スキルが自動選択されない場合は？

A: `.claude/skills/` ディレクトリにスキルファイルが配置されているか確認してください。

```bash
# スキルの存在を確認
ls .claude/skills/

# 再セットアップ
bash scripts/setup-project.sh
```

### Q: タスクの進捗管理はどうすればいい？

A: お使いのAIツールのネイティブ機能（Claude Code の Todo など）を利用してください。会話の中でタスクの分解・進捗の可視化が自動的に行われます。

### Q: worktreeを使いたい場合は？

A: お使いのAIツールのネイティブな worktree 機能を利用してください。リポジトリのルートディレクトリで操作することを推奨します。

### Q: 指示の優先順位が分からない場合は？

A: 以下の優先順位で適用されます。

```
1. PROJECT.md（最優先）
2. タスク固有の指示
3. ROOT_INSTRUCTIONによるスキル選択
4. スキルのデフォルト動作
```

## 📚 さらに詳しく

- [機能詳細](features) - すべての機能の詳細説明
- [クイックスタート](quickstart) - 5分で始める方法
- [GitHub](https://github.com/dobachi/AI_Instruction_Kits) - ソースコード
- [スキルマーケットプレイス](https://github.com/dobachi/claude-skills-marketplace) - コミュニティ製スキル

<div style="margin-top: 3em; padding: 1em; background-color: #f0f8ff; border-radius: 8px;">
  <h3>💡 ヒント</h3>
  <p>v2.0では「CLAUDE.mdを参照して」と伝えるだけで、ROOT_INSTRUCTIONが最適なスキルを自動選択します。まずはシンプルに使い始めて、必要に応じてマーケットプレイスからスキルを追加していきましょう。</p>
</div>
