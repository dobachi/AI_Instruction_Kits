# AI Instruction Sheet Repository

[English](README_en.md) | 日本語

このリポジトリは、AIに渡す指示書を管理するためのものです。

## ディレクトリ構造

```
.
├── docs/          # 人間向けドキュメント
├── instructions/  # AI指示書
│   ├── ja/        # 日本語の指示書
│   │   ├── general/   # 一般的な指示
│   │   ├── coding/    # コーディング関連の指示
│   │   ├── writing/   # 文章作成関連の指示
│   │   ├── analysis/  # 分析関連の指示
│   │   └── creative/  # クリエイティブ関連の指示
│   └── en/        # 英語の指示書
│       ├── general/   # 一般的な指示
│       ├── coding/    # コーディング関連の指示
│       ├── writing/   # 文章作成関連の指示
│       ├── analysis/  # 分析関連の指示
│       └── creative/  # クリエイティブ関連の指示
├── examples/      # 実際の使用例
│   ├── ja/        # 日本語の例
│   └── en/        # 英語の例
└── templates/     # 指示書のテンプレート
    ├── ja/        # 日本語テンプレート
    └── en/        # 英語テンプレート
```

## 主要ファイル

### AIへの指示書
- **[ROOT_INSTRUCTION.md](ROOT_INSTRUCTION.md)** - AIが指示書マネージャーとして動作
- **[INSTRUCTION_SELECTOR.md](INSTRUCTION_SELECTOR.md)** - キーワードベースの自動選択

### 人間向けドキュメント
- **[docs/HOW_TO_USE.md](docs/HOW_TO_USE.md)** - 詳細な使用ガイド（人間向け）
- **[USAGE_GUIDE.md](USAGE_GUIDE.md)** - 使用方法の概要

## 使い方

### 基本的な使用方法

1. **単一の指示書を使う場合**
   ```bash
   # ファイルパスを直接指定
   claude "instructions/ja/coding/basic_code_generation.md を参照して..."
   ```

2. **自動選択を使う場合**
   ```bash
   # AIに指示書マネージャーとして動作させる
   claude "ROOT_INSTRUCTION.md を参照して、売上データを分析してレポートを作成"
   
   # キーワードベースの自動選択
   claude "INSTRUCTION_SELECTOR.md を参照して、Web APIを実装"
   ```

### 新しい指示書の追加

1. 適切なカテゴリと言語のディレクトリに指示書を保存
2. ファイル名は内容が分かりやすい名前を使用
3. Markdownフォーマット（.md）で記述することを推奨

## 指示書の書き方

- 明確で具体的な指示を心がける
- 期待する出力の例を含める
- 制約条件がある場合は明記する
- **ライセンス情報を必ず含める**（詳細は[LICENSE-NOTICE.md](LICENSE-NOTICE.md)を参照）

## ライセンス

このリポジトリは複数のライセンスが混在しています：

- **デフォルト**: Apache License 2.0（[LICENSE](LICENSE)参照）
- **個別の指示書**: 各ファイルの末尾に記載されたライセンスが優先されます

詳細は[LICENSE-NOTICE.md](LICENSE-NOTICE.md)をご確認ください。