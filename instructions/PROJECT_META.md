# AI指示書キット開発支援設定

このプロジェクトはAI指示書システム自体の開発・改善を行うためのメタプロジェクトです。
タスク開始時は`instructions/ja/system/ROOT_INSTRUCTION.md`を読み込んでください。

**重要**: ROOT_INSTRUCTION.mdはスキルオーケストレーターです。インストール済みスキルを確認し、タスクに応じて利用してください。

## ⚠️ 重要: パスの読み替えについて

このプロジェクト自体で指示書を使用する場合、**パスの読み替えが必要です**：

### 通常のプロジェクトでの使用（サブモジュール経由）
```
instructions/ai_instruction_kits/instructions/ja/system/ROOT_INSTRUCTION.md
scripts/commit.sh
```

### このプロジェクト自体での使用
```
instructions/ja/system/ROOT_INSTRUCTION.md
scripts/commit.sh
```

### パス変換ルール
- `instructions/ai_instruction_kits/instructions/` → `instructions/`
- `instructions/ai_instruction_kits/` → ルートディレクトリ

## プロジェクト概要
- **目的**: AIへの指示書を構造的に管理・提供するシステムの開発
- **言語**: 日本語優先（英語版も同時メンテナンス）
- **ライセンス**: Apache-2.0（個別指示書は各自のライセンス）
- **アーキテクチャ**: スキルベース（v2.0） - スキルは全てマーケットプレイスへ集約（本リポジトリはスキルを同梱しない）

## スキルベースアーキテクチャ（v2.0）

### スキルの配布
commit-safe を含む全スキルは外部マーケットプレイスで配布します。本リポジトリはマーケットではなく、指示書本体の管理に専念します。

- マーケットプレイス: https://github.com/dobachi/claude-skills-marketplace
- 導入: `/plugin marketplace add dobachi/claude-skills-marketplace` → `/plugin install commit-safe@dobachi-skills`

> タスク管理・進捗追跡・Git worktree・ビルドはAIツールのネイティブ機能を利用してください。

## 開発原則

### 1. 構造の明確性
- ディレクトリ構造は直感的に理解できること
- 命名規則は一貫性を保つこと
- カテゴリ分けは実用的であること

### 2. 使いやすさ
- 最小限の手順で利用開始できること
- 既存プロジェクトへの統合が簡単であること
- ドキュメントは実例を含むこと

### 3. 拡張性
- 新しいスキルの追加が容易であること
- カスタマイズが柔軟にできること
- 他のAIツールへの対応が可能であること

## 開発時の重要事項

### ファイル編集時
1. **日英同期**: 日本語版を更新したら必ず英語版も更新
2. **実例優先**: 抽象的な説明より具体例を重視
3. **パス記述**: 指示書内のパスはサブモジュール使用を前提に記述

### 新機能追加時
1. まず日本語版で実装・検証
2. 英語版を作成
3. サンプル・テンプレートを更新
4. READMEとドキュメントを更新

### テスト・検証
1. setup-project.shが正しく動作するか確認
2. 各スキルが独立して機能するか確認
3. パスの整合性確認（サブモジュール環境での動作）

## Claude Codeエージェント機能の活用

プロジェクト分析や大規模な調査タスクには、Agent tool（Taskツール）を積極的に活用してください：

### 推奨される使用場面
- スキルの品質チェック・重複検出
- 未使用コードの特定
- 依存関係の分析
- ドキュメントとコードの整合性確認

## マルチCLIでのスキル利用（Codex / Gemini / Antigravity）

指示書ファイルはツールごとに用意しています（いずれも `PROJECT_META.md` へのsymlink）:

- Claude Code → `CLAUDE.md`
- Codex CLI → `CODEX.md`
- Gemini CLI → `GEMINI.md`
- Antigravity CLI（`agy`）→ `AGENTS.md`

**スキルは全て外部マーケットプレイスに集約**しました。このリポジトリは `.codex/prompts/`・`.gemini/commands/`・`.agents/skills/` をローカル配布しません。各CLIは Agent Skills 標準（`~/.agents/skills/<name>/SKILL.md`）を共有して読み込むため、マーケットプレイスの `install.sh` を一度実行すれば Claude Code・Codex・Gemini・Antigravity すべてで利用できます。

```bash
git clone https://github.com/dobachi/claude-skills-marketplace
bash claude-skills-marketplace/install.sh
```

Claude Code のみプラグイン方式でも導入できます: `/plugin marketplace add dobachi/claude-skills-marketplace` → `/plugin install commit-safe@dobachi-skills`。

## プロジェクト固有の指示

### コーディング規約
- シェルスクリプト: POSIX準拠、エラーハンドリング必須
- Markdown: 見出しレベルは最大3まで、コードブロックには言語指定
- ファイル名: snake_case（英小文字とアンダースコア）

### コミットメッセージ
```
<type>: <description>

- feat: 新機能追加
- fix: バグ修正
- docs: ドキュメント更新
- refactor: リファクタリング
- test: テスト追加・修正
```

### プルリクエスト
- 変更の目的と影響範囲を明記
- 関連するissue番号を含める
- 日英両方の更新を確認

## よく使うコマンド

```bash
# 統合テスト
bash scripts/setup-project.sh

# クリーンなコミット（AIメッセージなし）
bash scripts/commit.sh "コミットメッセージ"
```

## タスク管理・進捗追跡について
タスク管理・進捗追跡・Git worktree・ビルドはAIツールのネイティブ機能を利用してください。

## ダウンストリームプロジェクト（downstream/）

`downstream/` ディレクトリには、このプロジェクトをサブモジュールとして利用しているリポジトリのクローンを配置しています（`.gitignore`対象）。
このプロジェクトの更新時に、これらのサブモジュール参照も合わせて更新する必要があります。

| リポジトリ | 用途 |
|-----------|------|
| ResearchTemplate | 研究プロジェクトテンプレート |
| DevProjectTemplate | 開発プロジェクトテンプレート |
| PresentationTemplate | プレゼンテーションテンプレート |
| DeliberationTemplate | 検討・審議テンプレート |

### 更新手順
```bash
# 全リポジトリを一括更新
bash scripts/update-downstream.sh

# ドライラン（確認のみ）
bash scripts/update-downstream.sh --dry-run

# 特定のリポジトリのみ
bash scripts/update-downstream.sh ResearchTemplate
```

## コミットルール
- **必須**: `bash scripts/commit.sh "メッセージ"` または `git commit -m "メッセージ"`
- **禁止**: AI署名付きコミット（自動検出・拒否されます）

---
## ライセンス情報
- **ライセンス**: MIT
- **作成日**: 2025-01-03
