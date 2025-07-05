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
└── scripts/       # ツール・ユーティリティ
    ├── setup-project.sh  # プロジェクト統合用セットアップスクリプト
    └── checkpoint.sh     # チェックポイント管理スクリプト
```

## 主要ファイル

### AIへの指示書
- **[instructions/ja/system/ROOT_INSTRUCTION.md](instructions/ja/system/ROOT_INSTRUCTION.md)** - AIが指示書マネージャーとして動作
- **[instructions/ja/system/INSTRUCTION_SELECTOR.md](instructions/ja/system/INSTRUCTION_SELECTOR.md)** - キーワードベースの自動選択

### 人間向けドキュメント
- **[プロジェクトサイト](https://dobachi.github.io/AI_Instruction_Kits/)** - 詳細なドキュメント（GitHub Pages）
  - [クイックスタート](https://dobachi.github.io/AI_Instruction_Kits/quickstart)
  - [使用ガイド](https://dobachi.github.io/AI_Instruction_Kits/usage)
  - [機能詳細](https://dobachi.github.io/AI_Instruction_Kits/features)

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

### 新しい指示書の追加

1. 適切なカテゴリと言語のディレクトリに指示書を保存
2. ファイル名は内容が分かりやすい名前を使用
3. Markdownフォーマット（.md）で記述することを推奨

### PROJECT.mdのカスタマイズ

セットアップ後、`instructions/PROJECT.md`は`templates/ja/PROJECT_TEMPLATE.md`からコピーされます。
テンプレートを事前に編集することで、すべての新規プロジェクトに共通設定を適用できます。

```bash
# テンプレートのカスタマイズ例
vi templates/ja/PROJECT_TEMPLATE.md
vi templates/en/PROJECT_TEMPLATE.md
```

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