---
layout: default
title: AI Instruction Kits
description: クイックスタートガイド - 5分で始めるAI指示書キット
lang: ja
---

# クイックスタートガイド

5分でAI指示書キットをプロジェクトに導入しましょう！

## 📋 前提条件

- Git（サブモジュール/クローンモードの場合）
- Bash シェル
- AI開発ツール（Claude、ChatGPT、Gemini等）

## 🚀 ステップ1: リポジトリを取得

```bash
# AI指示書キットをクローン
git clone https://github.com/dobachi/AI_Instruction_Kits.git
cd AI_Instruction_Kits
```

## 🔧 ステップ2: プロジェクトにセットアップ

あなたのプロジェクトのルートディレクトリで実行：

```bash
# 対話形式でセットアップ（推奨）
bash path/to/AI_Instruction_Kits/scripts/setup-project.sh
```

### セットアップモードを選択

画面に表示される3つのモードから選択：

```
🎯 AI指示書の統合モードを選択してください:

1) copy      - シンプルなファイルコピー（Gitなし）
2) clone     - 独立したGitリポジトリ（自由に変更可能）
3) submodule - Gitサブモジュール（推奨）

選択してください [1-3] (デフォルト: 3): 
```

## 📝 ステップ3: プロジェクト設定をカスタマイズ

生成された `instructions/PROJECT.md` を編集：

```markdown
## プロジェクト固有の追加指示

### 例：
- コーディング規約: ESLint設定に従う
- テストフレームワーク: Jest
- ビルドコマンド: npm run build
- リントコマンド: npm run lint
- その他の制約事項: TypeScript strict mode
```

## 💬 ステップ4: AIに指示を出す

### Claude の場合
```bash
# プロジェクト設定を読み込んで作業開始
claude "CLAUDE.mdを参照して、ユーザー認証APIを実装して"
```

### ChatGPT の場合
```bash
# ファイルをアップロードまたはコピー＆ペースト
"CLAUDE.mdの内容に従って、データベーススキーマを設計して"
```

### Gemini の場合
```bash
# ファイルをアップロードまたはコピー＆ペースト
"GEMINI.mdの内容に従って、データベーススキーマを設計して"
```

## 🎯 実践例

### 例1: Reactコンポーネント作成
```bash
claude "CLAUDE.mdを参照して、商品一覧を表示するReactコンポーネントを作成。
- Material-UIを使用
- ページネーション機能付き
- 検索機能付き"
```

### 例2: API設計
```bash
claude "CLAUDE.mdを参照して、RESTful APIを設計。
エンドポイント:
- ユーザー管理 (CRUD)
- 認証（JWT使用）
- ファイルアップロード"
```

## ⚡ 高度な使い方

### カスタムリポジトリを使用

```bash
# フォークしたリポジトリを使用
bash setup-project.sh --url https://github.com/yourname/AI_Instruction_Kits.git --clone

# プライベートリポジトリを使用
bash setup-project.sh --url git@github.com:company/private-instructions.git --submodule
```

### CI/CDでの自動セットアップ

```bash
# 確認プロンプトなしで実行
bash setup-project.sh --submodule --force
```

## 📊 進捗管理

チェックポイント機能が自動的に作業を記録：

```bash
# 進捗ログを確認
cat checkpoint.log

# 出力例：
[2024-01-05 10:00:00][TASK-abc123][START] ユーザー認証API実装 (推定5ステップ)
[2024-01-05 10:30:00][TASK-abc123][COMPLETE] 成果: API 3エンドポイント、テスト15個作成
```

## ❓ よくある質問

### Q: 既存のプロジェクトに影響はありますか？
A: 最小限の影響で導入できます。追加されるのは：
- `instructions/` ディレクトリ
- シンボリックリンク（CLAUDE.md等）
- `scripts/checkpoint.sh` へのリンク

### Q: 指示書は日本語のみですか？
A: 日本語と英語の両方に対応しています。`PROJECT.en.md`を編集すれば英語版も利用できます。

### Q: カスタマイズは可能ですか？
A: はい！各指示書は自由に編集でき、新しい指示書の追加も簡単です。

## 🎉 セットアップ完了！

これでAI指示書キットの導入は完了です。
効率的なAI活用をお楽しみください！

<div style="margin-top: 3em; padding: 1em; background-color: #f0f8ff; border-radius: 8px;">
  <h3>🚀 次のステップ</h3>
  <ul>
    <li><a href="features">機能の詳細を見る</a></li>
    <li><a href="https://github.com/dobachi/AI_Instruction_Kits">GitHubでソースコードを確認</a></li>
    <li><a href="https://github.com/dobachi/AI_Instruction_Kits/issues">質問・要望を投稿</a></li>
  </ul>
</div>