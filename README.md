# AI Instruction Kits Repository

[English](README_en.md) | 日本語 | [📖 プロジェクトサイト](https://dobachi.github.io/AI_Instruction_Kits/)

このリポジトリは、AIに渡す指示書を管理するためのものです。

## ディレクトリ構造

```
.
├── docs/          # 人間向けドキュメント
│   └── examples/  # 実際の使用例
│       ├── ja/    # 日本語の例
│       └── en/    # 英語の例
├── instructions/  # AI指示書
│   ├── ja/        # 日本語の指示書
│   │   ├── system/    # システム管理用の指示
│   │   ├── general/   # 一般的な指示
│   │   ├── coding/    # コーディング関連の指示
│   │   ├── writing/   # 文章作成関連の指示
│   │   ├── analysis/  # 分析関連の指示
│   │   ├── creative/  # クリエイティブ関連の指示
│   │   └── agent/     # エージェント型指示書
│   └── en/        # 英語の指示書
│       ├── system/    # システム管理用の指示
│       ├── general/   # 一般的な指示
│       ├── coding/    # コーディング関連の指示
│       ├── writing/   # 文章作成関連の指示
│       ├── analysis/  # 分析関連の指示
│       ├── creative/  # クリエイティブ関連の指示
│       └── agent/     # エージェント型指示書
├── templates/     # 各種テンプレート
│   ├── ja/        # 日本語テンプレート
│   │   ├── instruction_template.md  # 指示書作成用テンプレート
│   │   └── PROJECT_TEMPLATE.md      # PROJECT.md用テンプレート
│   └── en/        # 英語テンプレート
│       ├── instruction_template.md  # 指示書作成用テンプレート
│       └── PROJECT_TEMPLATE.md      # PROJECT.en.md用テンプレート
├── modular/       # モジュラー指示書システム（新機能）
│   ├── ja/        # 日本語モジュール
│   │   ├── modules/   # 再利用可能なモジュール
│   │   ├── presets/   # 事前定義された組み合わせ
│   │   └── templates/ # 生成用テンプレート
│   └── en/        # 英語モジュール
├── .claude/       # Claude Code カスタムコマンド（新機能）
│   └── commands/  # カスタムコマンド定義
│       ├── checkpoint.md       # チェックポイント管理コマンド
│       ├── commit-and-report.md # コミット＆Issue報告
│       ├── commit-safe.md      # クリーンコミット
│       └── reload-instructions.md # 指示書再読み込み
├── reports/       # フィードバック・レポート
│   └── presets/   # プリセット関連レポート
└── scripts/       # ツール・ユーティリティ
    ├── setup-project.sh        # プロジェクト統合用セットアップスクリプト
    ├── checkpoint.sh           # チェックポイント管理スクリプト（拡張版）
    ├── generate-instruction.sh # モジュラー指示書生成スクリプト
    ├── generate-all-presets.sh # 全プリセット一括生成
    ├── monitor-presets.sh      # プリセット管理・統計
    ├── generate-metadata.sh    # メタデータ生成スクリプト
    ├── search-instructions.sh  # 指示書検索スクリプト
    ├── select-instruction.py   # Pythonベースの指示書選択ツール
    └── lib/
        └── i18n.sh            # 国際化対応ライブラリ
```

## 主要ファイル

### AIへの指示書
- **[instructions/ja/system/ROOT_INSTRUCTION.md](instructions/ja/system/ROOT_INSTRUCTION.md)** - AIが指示書マネージャーとして動作
- **[instructions/ja/system/INSTRUCTION_SELECTOR.md](instructions/ja/system/INSTRUCTION_SELECTOR.md)** - キーワードベースの自動選択
- **[instructions/ja/system/CHECKPOINT_MANAGER.md](instructions/ja/system/CHECKPOINT_MANAGER.md)** - チェックポイント管理システム
- **[instructions/ja/system/MODULE_COMPOSER.md](instructions/ja/system/MODULE_COMPOSER.md)** - モジュラー指示書生成

### メタデータシステム（新機能）
各指示書ファイルには対応する`.yaml`メタデータファイルが付随し、高速検索やカテゴリ絞り込みが可能です。

### 人間向けドキュメント
- **[プロジェクトサイト](https://dobachi.github.io/AI_Instruction_Kits/)** - 詳細なドキュメント（GitHub Pages）
  - [クイックスタート](https://dobachi.github.io/AI_Instruction_Kits/quickstart)
  - [使用ガイド](https://dobachi.github.io/AI_Instruction_Kits/usage)
  - [機能詳細](https://dobachi.github.io/AI_Instruction_Kits/features)

## 開発環境のセットアップ（OpenHandsを使いたい方向け）

### Python環境の構築（uvを使用）

OpenHandsを使ってこのプロジェクトのAI支援開発を行いたい方は、以下の手順でPython環境を構築してください：

```bash
# uvのインストール（まだの場合）
curl -LsSf https://astral.sh/uv/install.sh | sh

# プロジェクトのクローン
git clone https://github.com/dobachi/AI_Instruction_Kits.git
cd AI_Instruction_Kits

# Python仮想環境の作成と有効化
uv venv
source .venv/bin/activate  # Linux/Mac
# または
.venv\Scripts\activate  # Windows

# 依存パッケージのインストール（OpenHandsを含む）
uv pip install -e .

# 開発用パッケージも含めてインストール
uv pip install -e ".[dev]"

# または、完全な環境を再現する場合（全てのパッケージ）
uv pip install -r requirements.txt
```

### OpenHandsの利用

環境構築後、OpenHandsを使用してAI支援開発が可能になります：

```bash
# OpenHandsの起動
openhands
```

#### OpenHands専用統合（自動検出）

AI指示書キットは、OpenHands環境を自動的に検出し、専用の指示書（`OPENHANDS_ROOT.md`）を読み込みます。これにより：

- **並列処理の最適化**: 独立したタスクを自動的に並列実行
- **エラーリカバリー**: 一時的なエラーを自動リトライ
- **進捗可視化**: タスクの進行状況を詳細に報告
- **リソース最適化**: ファイル操作のバッチ処理、キャッシュ活用

OpenHandsを使用する場合、`setup-project.sh`が自動的に`.openhands/microagents/repo.md`を適切な指示書にリンクします。

## Claude Code カスタムコマンド（新機能）

### 概要

Claude Codeユーザー向けの専用カスタムコマンドを提供。プロジェクトのワークフローを効率化します。

### 利用可能なコマンド

| コマンド | 説明 | 使用例 |
|---------|------|--------|
| `/checkpoint` | チェックポイント管理 | `/checkpoint start "新機能実装" 5` |
| `/commit-and-report` | コミット＆Issue報告 | `/commit-and-report "バグ修正完了"` |
| `/commit-safe` | クリーンコミット（AI署名なし） | `/commit-safe "ドキュメント更新"` |
| `/reload-instructions` | 指示書の再読み込み | `/reload-instructions` |

### 自動設定

`setup-project.sh`実行時に自動的に`.claude/commands/`ディレクトリが設定されます。

```bash
# カスタムコマンドも含めて自動設定
bash scripts/setup-project.sh
```

## 使い方

### プロジェクトへの統合（推奨）

AI指示書システムをプロジェクトに統合する最も簡単な方法：

```bash
# あなたのプロジェクトのルートディレクトリで実行
bash path/to/ai_instruction_kits/scripts/setup-project.sh
```

#### 統合モード（3つから選択）

```bash
# インタラクティブに選択（デフォルト）
bash scripts/setup-project.sh

# モードを直接指定
bash scripts/setup-project.sh --copy      # コピーモード
bash scripts/setup-project.sh --clone     # クローンモード
bash scripts/setup-project.sh --submodule # サブモジュールモード（推奨）
```

**各モードの特徴：**

| モード | 説明 | 利点 | 更新方法 |
|--------|------|------|----------|
| **copy** | ファイルを直接コピー | • Gitなし<br>• 最もシンプル<br>• オフライン可 | 手動で再実行 |
| **clone** | 独立したGitリポジトリ | • 自由に変更可<br>• 履歴保持<br>• 独自カスタマイズ | `git pull` |
| **submodule** | Gitサブモジュール（推奨） | • バージョン固定<br>• 親リポジトリと連携<br>• 標準的な管理 | `git submodule update --remote` |

#### カスタムリポジトリの使用

```bash
# フォークしたリポジトリを使用
bash scripts/setup-project.sh --url https://github.com/yourname/AI_Instruction_Kits.git --clone

# プライベートリポジトリを使用（事前認証が必要）
bash scripts/setup-project.sh --url git@github.com:company/private-instructions.git --submodule

# 社内GitLabを使用
bash scripts/setup-project.sh --url https://gitlab.company.com/team/ai-instructions.git --submodule
```

#### その他のオプション

```bash
# 強制実行モード - 確認なしで自動実行（CI/CD向け）
bash scripts/setup-project.sh --submodule --force

# ドライランモード - 実行内容を確認（実際には変更しない）
bash scripts/setup-project.sh --dry-run

# バックアップなしモード - 既存ファイルを直接上書き
bash scripts/setup-project.sh --force --no-backup

# ヘルプ表示
bash scripts/setup-project.sh --help
```

これにより以下が自動的に設定されます：

```
あなたのプロジェクト/
├── scripts/
│   └── checkpoint.sh → ../instructions/ai_instruction_kits/scripts/checkpoint.sh
├── instructions/
│   ├── ai_instruction_kits/  # サブモジュール（このリポジトリ）
│   ├── PROJECT.md            # プロジェクト固有の設定（日本語）
│   └── PROJECT.en.md         # プロジェクト固有の設定（英語）
├── CLAUDE.md → instructions/PROJECT.md
├── GEMINI.md → instructions/PROJECT.md
└── CURSOR.md → instructions/PROJECT.md
```

使用例：
```bash
# AIへの指示がシンプルに
claude "CLAUDE.mdを参照して、ユーザー認証機能を実装して"
```

### 基本的な使用方法（手動）

1. **単一の指示書を使う場合**
   ```bash
   # ファイルパスを直接指定
   claude "instructions/ja/coding/basic_code_generation.md を参照して..."
   ```

2. **自動選択を使う場合**
   ```bash
   # AIに指示書マネージャーとして動作させる
   claude "instructions/ja/system/ROOT_INSTRUCTION.md を参照して、売上データを分析してレポートを作成"
   
   # キーワードベースの自動選択
   claude "instructions/ja/system/INSTRUCTION_SELECTOR.md を参照して、Web APIを実装"
   ```

3. **検索機能を使う場合（新機能）**
   ```bash
   # キーワードで検索
   ./scripts/search-instructions.sh python
   
   # カテゴリで絞り込み
   ./scripts/search-instructions.sh -c coding -l ja
   
   # 詳細情報を表示
   ./scripts/search-instructions.sh -f detail marp
   
   # Pythonツールで検索
   python3 scripts/select-instruction.py --search "API開発"
   ```

### 新しい指示書の追加

1. 適切なカテゴリと言語のディレクトリに指示書を保存
2. ファイル名は内容が分かりやすい名前を使用
3. Markdownフォーマット（.md）で記述することを推奨
4. メタデータを生成して検索可能にする
   ```bash
   # 単一ファイルのメタデータ生成
   ./scripts/generate-metadata.sh instructions/ja/coding/my_new_instruction.md
   
   # 全ファイルのメタデータを再生成
   ./scripts/generate-metadata.sh
   ```

### PROJECT.mdのカスタマイズ

セットアップ後、`instructions/PROJECT.md`は`templates/ja/PROJECT_TEMPLATE.md`からコピーされます。
テンプレートを事前に編集することで、すべての新規プロジェクトに共通設定を適用できます。

```bash
# テンプレートのカスタマイズ例
vi templates/ja/PROJECT_TEMPLATE.md
vi templates/en/PROJECT_TEMPLATE.md
```

## プリセットシステム（高速応答）

### 概要

プリセットは、よく使用されるタスクに最適化された事前生成済みの指示書です。動的生成と比較して、即座に使用できるため応答時間が大幅に短縮されます。

### 利用可能なプリセット

| プリセット名 | 用途 | パス |
|------------|------|------|
| **web_api_production** | 本番環境向けWeb API開発 | `instructions/ja/presets/web_api_production.md` |
| **cli_tool_basic** | CLIツール開発 | `instructions/ja/presets/cli_tool_basic.md` |
| **data_analyst** | データ分析タスク | `instructions/ja/presets/data_analyst.md` |
| **technical_writer** | 技術文書作成 | `instructions/ja/presets/technical_writer.md` |
| **academic_researcher** | 学術研究支援 | `instructions/ja/presets/academic_researcher.md` |
| **business_consultant** | ビジネスコンサルティング | `instructions/ja/presets/business_consultant.md` |
| **project_manager** | プロジェクト管理 | `instructions/ja/presets/project_manager.md` |
| **startup_advisor** | スタートアップ支援 | `instructions/ja/presets/startup_advisor.md` |

### プリセットの使用方法

```bash
# 例: Web API開発タスク
claude "REST APIを作成してください"
# → AIが自動的にweb_api_productionプリセットを使用

# 例: データ分析タスク
claude "売上データを分析してください"
# → AIが自動的にdata_analystプリセットを使用
```

### プリセットの管理

```bash
# すべてのプリセットを再生成
./scripts/generate-all-presets.sh

# 特定のプリセットのみ再生成
./scripts/generate-all-presets.sh --preset web_api_production

# プリセットの整合性チェック
./scripts/monitor-presets.sh check

# プリセット使用統計の表示
./scripts/monitor-presets.sh stats
```

### 自動更新

プリセットは以下のタイミングで自動更新されます：
- モジュールの更新時（GitHub Actions）
- 手動トリガー（GitHub Actions workflow_dispatch）

詳細な使用ガイドは[docs/guides/PRESET_USAGE_GUIDE.md](docs/guides/PRESET_USAGE_GUIDE.md)を参照してください。

## モジュラー指示書システム（新機能）

### 概要

モジュラー指示書システムは、再利用可能なモジュールを組み合わせてカスタム指示書を生成する機能です。
プリセットをベースにカスタマイズすることも可能になりました。

### 基本的な使い方

```bash
# プリセットを使用
./scripts/generate-instruction.sh --preset web_api_production --output api.md

# プリセットをカスタマイズ（新機能）
./scripts/generate-instruction.sh --preset web_api_production \
  --modules skill_testing skill_deployment \
  --variable framework=FastAPI

# モジュールを直接指定
./scripts/generate-instruction.sh \
  --modules core_role_definition task_code_generation skill_error_handling \
  --output custom.md

# AI分析によるモジュール推奨（--metadataオプション）
./scripts/generate-instruction.sh --metadata \
  --prompt "RESTful APIとデータベース統合を含むWebサービス開発"
```

### 利用可能なプリセット

```bash
# プリセット一覧を表示
./scripts/generate-instruction.sh --list presets
```

### 利用可能なモジュール

```bash
# モジュール一覧を表示
./scripts/generate-instruction.sh --list modules
```

### プリセットカスタマイズの例

1. **Web API + 追加機能**
   ```bash
   ./scripts/generate-instruction.sh \
     --preset web_api_production \
     --modules skill_caching skill_monitoring
   ```

2. **テクニカルライター + コード文書化**
   ```bash
   ./scripts/generate-instruction.sh \
     --preset technical_writer \
     --modules skill_code_documentation \
     --variable code_language=Python
   ```

3. **データ分析 + 可視化**
   ```bash
   ./scripts/generate-instruction.sh \
     --preset data_analyst \
     --modules skill_data_visualization \
     --variable visualization_tool=matplotlib
   ```

詳細は[instructions/ja/system/MODULE_COMPOSER.md](instructions/ja/system/MODULE_COMPOSER.md)を参照してください。

## チェックポイント管理システム（拡張版）

### 概要

タスクの進捗を追跡し、指示書の使用履歴を記録する高度な管理システム。

### 拡張機能

```bash
# 指示書使用の追跡
scripts/checkpoint.sh instruction-start "instructions/ja/presets/web_api_production.md" "API開発" TASK-123
scripts/checkpoint.sh instruction-complete "instructions/ja/presets/web_api_production.md" "3エンドポイント実装" TASK-123

# AI向け簡潔出力モード
scripts/checkpoint.sh ai pending
scripts/checkpoint.sh ai progress TASK-123 2 5 "実装中" "テスト作成"

# 使用統計の表示
scripts/checkpoint.sh stats

# 指示書使用履歴
scripts/checkpoint.sh history
```

### ワークフロー制約

- 進捗報告（progress）は指示書使用中のみ可能
- タスク完了時はすべての指示書が完了している必要がある
- タスクIDは自動生成され、一貫性を保証

### フィードバックとレポート

プリセットの改善にご協力ください：
- フィードバック記録: `reports/presets/feedback/current.md`
- モニタリングレポート: `reports/presets/monitoring/`
- 詳細は[reports/README.md](reports/README.md)を参照

## 指示書の書き方

- 明確で具体的な指示を心がける
- 期待する出力の例を含める
- 制約条件がある場合は明記する
- **ライセンス情報を必ず含める**（詳細は[LICENSE-NOTICE.md](LICENSE-NOTICE.md)を参照）

## 📖 プロジェクトサイト

詳しい情報・デモ・使用例は以下のサイトをご覧ください：

🌐 **[https://dobachi.github.io/AI_Instruction_Kits/](https://dobachi.github.io/AI_Instruction_Kits/)**

- クイックスタートガイド
- 機能詳細
- 実践的な使用例

## ライセンス

このリポジトリは複数のライセンスが混在しています：

- **デフォルト**: MIT License（[LICENSE](LICENSE)参照）
- **個別の指示書**: 各ファイルの末尾に記載されたライセンスが優先されます

詳細は[LICENSE-NOTICE.md](LICENSE-NOTICE.md)をご確認ください。