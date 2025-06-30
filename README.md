# AI Instruction Sheet Repository

[English](README_en.md) | 日本語

このリポジトリは、AIに渡す指示書を管理するためのものです。

## ディレクトリ構造

```
instructions/
├── ja/            # 日本語の指示書
│   ├── general/   # 一般的な指示
│   ├── coding/    # コーディング関連の指示
│   ├── writing/   # 文章作成関連の指示
│   ├── analysis/  # 分析関連の指示
│   └── creative/  # クリエイティブ関連の指示
└── en/            # 英語の指示書
    ├── general/   # 一般的な指示
    ├── coding/    # コーディング関連の指示
    ├── writing/   # 文章作成関連の指示
    ├── analysis/  # 分析関連の指示
    └── creative/  # クリエイティブ関連の指示

examples/          # 実際の使用例
├── ja/            # 日本語の例
└── en/            # 英語の例

templates/         # 指示書のテンプレート
├── ja/            # 日本語テンプレート
└── en/            # 英語テンプレート
```

## 使い方

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