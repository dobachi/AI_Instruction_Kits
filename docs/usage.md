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

v2.0の中核は、`.claude/skills/` に配置された4つのコアスキルです。ROOT_INSTRUCTIONがタスクの内容に応じて自動的に適切なスキルを提案します。

### checkpoint-manager（タスク進捗管理）

会話開始時に未完了タスクの確認を自動提案します。

```bash
# タスクの開始
scripts/checkpoint.sh start "新機能開発" 5
# → タスクID: TASK-123456-abc が発行される

# 進捗報告
scripts/checkpoint.sh progress TASK-123456-abc 2 5 "設計完了" "実装開始"

# タスク完了
scripts/checkpoint.sh complete TASK-123456-abc "5機能実装、テスト20個作成"
```

**自動提案タイミング**: 会話開始時にpendingタスクの確認を提案

### worktree-manager（Git worktree管理）

複雑なタスクや複数ファイルの変更時にworktree作成を提案します。

```bash
# worktree作成
scripts/worktree-manager.sh create TASK-123456-abc "feature-auth"
# → .gitworktrees/ai-TASK-123456-abc-feature-auth/ が作成される

# 作業ディレクトリに移動
cd .gitworktrees/ai-TASK-123456-abc-feature-auth/

# 作業完了後
scripts/worktree-manager.sh complete TASK-123456-abc
```

**自動提案タイミング**: 複雑なタスクでworktree作成を提案

### auto-build（自動ビルド・テスト）

プロジェクトの種類を自動判別し、適切なビルドコマンドを実行します。

```bash
# プロジェクトタイプを自動検出してビルド
# package.json → npm run build
# Cargo.toml → cargo build
# go.mod → go build
# など
```

**自動提案タイミング**: コード変更後にビルド・テスト実行を提案

### commit-safe（安全なコミット）

AI署名なしのクリーンなコミットを作成します。

```bash
# AI署名が自動除去されたクリーンコミット
scripts/commit.sh "feat: ユーザー認証機能を追加"
```

**自動提案タイミング**: 変更後にファイル指定コミットを提案

### 基本ワークフロー

```
1. pending確認 → 2. タスク開始 → 3. worktree作成(任意) → 4. 作業 → 5. コミット → 6. 完了
```

## 🛒 マーケットプレイススキル

コミュニティ製の追加スキルを [claude-skills-marketplace](https://github.com/dobachi/claude-skills-marketplace) からインストールできます。

### インストール方法

```bash
# マーケットプレイスからスキルをダウンロード
# .claude/skills/ にファイルを配置するだけ

# 例: コードレビュースキルを追加
cp path/to/code-review .claude/skills/code-review

# インストール後、ROOT_INSTRUCTIONが自動的に新スキルを認識
```

### カスタムスキルの作成

独自のスキルが必要な場合は、skill-creatorスキルを活用できます。スキルファイルを `.claude/skills/` に配置するだけで利用可能になります。

## 📊 チェックポイント管理

`scripts/checkpoint.sh` はタスクの進捗を詳細に記録・管理するスクリプトです。

### 主要コマンド

| コマンド | 用途 | 例 |
|---------|------|-----|
| `start` | 新しいタスクを開始 | `scripts/checkpoint.sh start "API開発" 5` |
| `progress` | 進捗を報告 | `scripts/checkpoint.sh progress TASK-xxx 2 5 "設計完了" "実装開始"` |
| `complete` | タスクを完了 | `scripts/checkpoint.sh complete TASK-xxx "3エンドポイント実装"` |
| `pending` | 未完了タスク一覧 | `scripts/checkpoint.sh pending` |
| `summary` | タスク詳細表示 | `scripts/checkpoint.sh summary TASK-xxx` |
| `error` | エラーを報告 | `scripts/checkpoint.sh error TASK-xxx "依存関係エラー"` |

### スキル使用の追跡

```bash
# 指示書/スキル使用の開始を記録
scripts/checkpoint.sh instruction-start ".claude/skills/auto-build" "API開発" TASK-xxx

# 指示書/スキル使用の完了を記録
scripts/checkpoint.sh instruction-complete ".claude/skills/auto-build" "3エンドポイント実装" TASK-xxx
```

### 進捗の可視化

```bash
# 未完了タスクの確認
scripts/checkpoint.sh pending

# タスクの詳細履歴
scripts/checkpoint.sh summary TASK-xxx

# ヘルプ表示
scripts/checkpoint.sh help
```

## 🌲 Git worktree運用

複雑なタスクや複数ファイルにまたがる変更では、Git worktreeでの作業を推奨します。

### 推奨フロー

```bash
# 1. タスク開始
scripts/checkpoint.sh start "認証機能開発" 5
# → TASK-123456-abc

# 2. worktree作成
scripts/worktree-manager.sh create TASK-123456-abc "feature-auth"

# 3. worktreeに移動して作業
cd .gitworktrees/ai-TASK-123456-abc-feature-auth/

# 4. 作業実施・コミット
scripts/commit.sh "feat: 認証機能を追加"

# 5. タスク完了・worktreeクリーンアップ
scripts/checkpoint.sh complete TASK-123456-abc "認証機能実装完了"
scripts/worktree-manager.sh complete TASK-123456-abc
```

### worktree管理コマンド

```bash
# 一覧表示
scripts/worktree-manager.sh list

# 特定のworktreeに切り替え
scripts/worktree-manager.sh switch TASK-xxx

# 完了・クリーンアップ
scripts/worktree-manager.sh complete TASK-xxx

# 不要なworktreeを一括削除
scripts/worktree-manager.sh clean
```

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

## 🤖 Codex CLI / Gemini CLI

AI Instruction Kitsは、Claude Code以外のAI CLIツールにも対応しています。

### Codex CLI

`.codex/prompts/` にカスタムプロンプトを配置しています。ファイル名がそのまま `/コマンド名` として呼び出せます。

```bash
# 利用可能なコマンド例
/build              # プロジェクトの種類を判断してビルド支援
/checkpoint         # checkpoint.sh の各サブコマンドを案内
/commit-safe        # AI署名なしの安全なコミット
/commit-and-report  # コミット・プッシュ・Issue報告
/reload-instructions # 指示書の再読み込み
```

### Gemini CLI

`.gemini/commands/` にTOML形式のコマンド定義を配置しています。Codex CLIと同様のコマンドセットが利用可能です。

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
- チェックポイント機能で作業履歴を蓄積
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

### Q: チェックポイントログが見つからない場合は？

A: `checkpoint.log` はプロジェクトルートに作成されます。初回のタスク開始時に自動生成されます。

```bash
# 新しいタスクを開始してログを作成
scripts/checkpoint.sh start "テストタスク" 1
```

### Q: worktreeの作成に失敗する場合は？

A: Gitリポジトリのルートディレクトリで実行しているか確認してください。

```bash
# リポジトリルートに移動
cd $(git rev-parse --show-toplevel)

# worktreeを作成
scripts/worktree-manager.sh create TASK-xxx "description"
```

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
