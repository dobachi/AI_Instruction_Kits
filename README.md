# AI Instruction Kits v2.0 - Skill-Based Architecture

[English](README_en.md) | 日本語 | [プロジェクトサイト](https://dobachi.github.io/AI_Instruction_Kits/)

AIエージェント向けのスキルベース指示書管理システムです。
v2.0では、従来のモジュラー合成方式から**スキルベースアーキテクチャ**に移行しました。

## v2.0の主な変更点

- **ROOT_INSTRUCTIONがスキルオーケストレーターに**: 約30行のシンプルな構成で、インストール済みスキルを自動的に活用
- **4つのコアスキル**: checkpoint-manager, worktree-manager, auto-build, commit-safe
- **スキルマーケットプレイス**: 追加スキルは [dobachi/claude-skills-marketplace](https://github.com/dobachi/claude-skills-marketplace) から取得
- **Python依存の廃止**: composer.py, select-instruction.py 等は不要に
- **`.claude/skills/`**: 従来の `.claude/commands/` に代わるスキル配置先
- **旧モジュラーシステム**: `archive/v1-modular` ブランチにアーカイブ済み

## クイックスタート

### ワンライナーインストール

```bash
# デフォルト設定で自動インストール
curl -sSL https://raw.githubusercontent.com/dobachi/AI_Instruction_Kits/main/scripts/install.sh | bash
```

### メタプロジェクト化（AI開発支援環境構築）

既存プロジェクトをAI開発支援環境（メタプロジェクト）に変換：

```bash
# 基本的な使用（プロジェクト名指定）
curl -sSL https://raw.githubusercontent.com/dobachi/AI_Instruction_Kits/main/scripts/install-metaproject.sh | bash -s -- --project-name myapp

# GitHubからプロジェクトをクローンして設定
curl -sSL https://raw.githubusercontent.com/dobachi/AI_Instruction_Kits/main/scripts/install-metaproject.sh | bash -s -- --project-name myapp --project-url https://github.com/user/myapp.git
```

メタプロジェクトは、開発対象コードを`sources/`に配置し、外側からAI支援を提供する構造です。

### インタラクティブモード（対話式）

```bash
# ダウンロードしてから実行（推奨）
curl -sSL https://raw.githubusercontent.com/dobachi/AI_Instruction_Kits/main/scripts/install.sh -o install.sh
bash install.sh
rm install.sh
```

詳細は [クイックスタートガイド](docs/QUICKSTART.md) を参照してください。

## アーキテクチャ

### スキルオーケストレーター

`ROOT_INSTRUCTION.md`はスキルオーケストレーターとして機能します。AIエージェントはタスクに応じて`.claude/skills/`のインストール済みスキルを自動的に活用します。

```
1. pending確認 → 2. タスク開始 → 3. worktree作成(任意) → 4. 作業 → 5. コミット → 6. 完了
```

### コアスキル（4つ）

| スキル | 用途 | 自動提案 |
|--------|------|----------|
| **checkpoint-manager** | タスク進捗追跡 | 会話開始時にpending確認を提案 |
| **worktree-manager** | Git worktree管理 | 複雑なタスクでworktree作成を提案 |
| **auto-build** | プロジェクトビルド自動化 | コード変更後にビルドを提案 |
| **commit-safe** | 安全なコミット | 変更後にファイル指定コミットを提案 |

### スキルマーケットプレイス

追加スキルが必要な場合は、マーケットプレイスからインストールできます：

```
https://github.com/dobachi/claude-skills-marketplace
```

カスタムスキルが必要な場合は、マーケットプレイスの skill-creator スキルを利用してください。

## ディレクトリ構造

```
.
├── docs/              # 人間向けドキュメント
│   └── examples/      # 実際の使用例
│       ├── ja/        # 日本語の例
│       └── en/        # 英語の例
├── instructions/      # AI指示書
│   ├── ja/            # 日本語の指示書
│   │   ├── system/    # システム管理用の指示（ROOT_INSTRUCTION等）
│   │   ├── general/   # 一般的な指示
│   │   ├── coding/    # コーディング関連の指示
│   │   ├── writing/   # 文章作成関連の指示
│   │   ├── analysis/  # 分析関連の指示
│   │   ├── creative/  # クリエイティブ関連の指示
│   │   └── agent/     # エージェント型指示書
│   └── en/            # 英語の指示書（同構造）
├── templates/         # 各種テンプレート
│   ├── ja/            # 日本語テンプレート
│   └── en/            # 英語テンプレート
├── .claude/           # Claude Code スキル
│   └── skills/        # スキル定義（4コアスキル）
│       ├── checkpoint-manager.md
│       ├── worktree-manager.md
│       ├── auto-build.md
│       └── commit-safe.md
├── .codex/            # Codex CLI カスタムプロンプト
│   └── prompts/       # カスタムプロンプト定義
├── reports/           # フィードバック・レポート
└── scripts/           # ツール・ユーティリティ
    ├── setup-project.sh        # プロジェクト統合用セットアップ（コアスキルをインストール）
    ├── setup-metaproject.sh    # メタプロジェクト化セットアップ
    ├── install-metaproject.sh  # メタプロジェクト化ワンライナー
    ├── install.sh              # ワンライナーインストール
    ├── uninstall.sh            # アンインストール
    ├── checkpoint.sh           # チェックポイント管理スクリプト
    ├── commit.sh               # クリーンコミットスクリプト
    ├── worktree-manager.sh     # Git worktree管理スクリプト
    └── submodule-update-check.sh # サブモジュール更新チェック
```

## 主要ファイル

### AIへの指示書
- **[instructions/ja/system/ROOT_INSTRUCTION.md](instructions/ja/system/ROOT_INSTRUCTION.md)** - スキルオーケストレーター（約30行）
- **[instructions/ja/system/CHECKPOINT_MANAGER.md](instructions/ja/system/CHECKPOINT_MANAGER.md)** - チェックポイント管理システム

### 人間向けドキュメント
- **[プロジェクトサイト](https://dobachi.github.io/AI_Instruction_Kits/)** - 詳細なドキュメント（GitHub Pages）
  - [クイックスタート](https://dobachi.github.io/AI_Instruction_Kits/quickstart)
  - [使用ガイド](https://dobachi.github.io/AI_Instruction_Kits/usage)
  - [機能詳細](https://dobachi.github.io/AI_Instruction_Kits/features)

## プロジェクトへの統合（推奨）

AI指示書システムをプロジェクトに統合する最も簡単な方法：

```bash
# あなたのプロジェクトのルートディレクトリで実行
bash path/to/ai_instruction_kits/scripts/setup-project.sh
```

### 統合モード（3つから選択）

```bash
# インタラクティブに選択（デフォルト）
bash scripts/setup-project.sh

# モードを直接指定
bash scripts/setup-project.sh --copy      # コピーモード
bash scripts/setup-project.sh --clone     # クローンモード
bash scripts/setup-project.sh --submodule # サブモジュールモード（推奨）
```

### セットアップオプション

```bash
# 自動モード：PROJECT.mdのみ確認、他は自動配置
bash scripts/setup-project.sh --auto --submodule

# 完全自動：確認なし、指示書もスキップ（更新時）
bash scripts/setup-project.sh --auto --skip-instructions --submodule

# 強制実行モード（CI/CD向け）
bash scripts/setup-project.sh --submodule --force

# ドライランモード - 実行内容を確認
bash scripts/setup-project.sh --dry-run

# ヘルプ表示
bash scripts/setup-project.sh --help
```

### 各モードの特徴

| モード | 説明 | 利点 | 更新方法 |
|--------|------|------|----------|
| **copy** | ファイルを直接コピー | シンプル、オフライン可 | 手動で再実行 |
| **clone** | 独立したGitリポジトリ | 自由に変更可、履歴保持 | `git pull` |
| **submodule** | Gitサブモジュール（推奨） | バージョン固定、標準的な管理 | `git submodule update --remote` |

### セットアップ後の構成

```
あなたのプロジェクト/
├── scripts/
│   └── checkpoint.sh → ../instructions/ai_instruction_kits/scripts/checkpoint.sh
├── instructions/
│   ├── ai_instruction_kits/  # サブモジュール（このリポジトリ）
│   ├── PROJECT.md            # プロジェクト固有の設定（日本語）
│   └── PROJECT.en.md         # プロジェクト固有の設定（英語）
├── .claude/
│   └── skills/               # 4コアスキルが自動インストール
├── CLAUDE.md → instructions/PROJECT.md
├── GEMINI.md → instructions/PROJECT.md
└── CURSOR.md → instructions/PROJECT.md
```

### カスタムリポジトリの使用

```bash
# フォークしたリポジトリを使用
bash scripts/setup-project.sh --url https://github.com/yourname/AI_Instruction_Kits.git --clone

# プライベートリポジトリを使用
bash scripts/setup-project.sh --url git@github.com:company/private-instructions.git --submodule
```

## 使い方

### 基本的な使用方法

```bash
# AIへの指示がシンプルに
claude "CLAUDE.mdを参照して、ユーザー認証機能を実装して"

# AIに指示書マネージャーとして動作させる
claude "instructions/ja/system/ROOT_INSTRUCTION.md を参照して、売上データを分析してレポートを作成"
```

AIエージェントはROOT_INSTRUCTIONを読み込むと、自動的にインストール済みスキルを確認し、タスクに最適なスキルを活用します。

## チェックポイント管理

タスクの進捗を追跡し、指示書の使用履歴を記録する管理システム。

```bash
# タスク開始
scripts/checkpoint.sh start "新機能実装" 5

# 進捗報告
scripts/checkpoint.sh ai progress TASK-123 2 5 "実装中" "テスト作成"

# 保留中のタスク確認
scripts/checkpoint.sh ai pending

# 使用統計
scripts/checkpoint.sh stats
```

## Git worktree運用（推奨）

複雑なタスクや複数ファイルの変更時は、専用のworktreeで作業してください：

```bash
# タスク開始時
scripts/checkpoint.sh start "機能開発" 3
# → タスクID: TASK-123456-abc

# worktree作成
scripts/worktree-manager.sh create TASK-123456-abc "feature-dev"
cd .gitworktrees/ai-TASK-123456-abc-feature-dev/

# 作業実施...

# 完了時
scripts/checkpoint.sh complete TASK-123456-abc "完了"
scripts/worktree-manager.sh complete TASK-123456-abc
```

## Codex CLI カスタムプロンプト

Codex CLIユーザー向けの専用カスタムプロンプトを提供。`.codex/prompts/`に配置されます。

`setup-project.sh`実行時に自動的に設定されます。

## Claude Code エージェント機能

Claude CodeのTask tool（エージェント機能）を活用した大規模分析・調査タスクの自動化をサポート。

### 活用例
- プロジェクト全体のコード品質分析
- 依存関係の包括的調査
- テストカバレッジの網羅的確認
- ドキュメントとコードの整合性検証

詳細は[Claude Codeエージェント活用ガイド](instructions/ja/system/CLAUDE_CODE_AGENT.md)を参照してください。

## アンインストール

```bash
# 通常のアンインストール（確認プロンプトあり）
bash scripts/uninstall.sh

# 確認なしで実行
bash scripts/uninstall.sh --force

# 実行内容の確認（実際には削除しない）
bash scripts/uninstall.sh --dry-run
```

### アンインストールされるもの
- `instructions/ai_instruction_kits/` (サブモジュール/クローン/コピー)
- `scripts/`配下のシンボリックリンク
- `CLAUDE.md`, `GEMINI.md`, `CURSOR.md`などの設定ファイル
- `.claude/skills/` (スキルファイル)
- `.openhands/microagents/repo.md`
- `.git/hooks/prepare-commit-msg`

### 保持されるファイル
- `instructions/PROJECT.md` (プロジェクト固有設定)
- `checkpoint.log` (チェックポイントログ)

## v1.xからの移行

v1.x（モジュラー指示書システム）からの移行：

1. `setup-project.sh`を再実行すると、`.claude/skills/`に4コアスキルが自動インストールされます
2. 旧`.claude/commands/`は手動で削除してください
3. 旧モジュラーシステムのコードは `archive/v1-modular` ブランチに保存されています
4. Python依存（composer.py等）は不要になりました

## 指示書の書き方

- 明確で具体的な指示を心がける
- 期待する出力の例を含める
- 制約条件がある場合は明記する
- **ライセンス情報を必ず含める**（詳細は[LICENSE-NOTICE.md](LICENSE-NOTICE.md)を参照）

## プロジェクトサイト

詳しい情報・デモ・使用例は以下のサイトをご覧ください：

**[https://dobachi.github.io/AI_Instruction_Kits/](https://dobachi.github.io/AI_Instruction_Kits/)**

- クイックスタートガイド
- 機能詳細
- 実践的な使用例

## ライセンス

このリポジトリは複数のライセンスが混在しています：

- **デフォルト**: MIT License（[LICENSE](LICENSE)参照）
- **個別の指示書**: 各ファイルの末尾に記載されたライセンスが優先されます

詳細は[LICENSE-NOTICE.md](LICENSE-NOTICE.md)をご確認ください。
