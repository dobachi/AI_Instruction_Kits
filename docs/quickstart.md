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

### v2.0 スキルベースのワークフロー（推奨）
```bash
# 自然言語でタスクを指示するだけ！
claude "ECサイトを作成してください"
# → CLAUDE.md → ROOT_INSTRUCTION（スキルオーケストレーター）が起動
# → .claude/skills/ から最適なスキルを自動選択
# → タスク管理・進捗追跡はAIツールのネイティブ機能（Claude Code の Todo など）を利用

claude "テストを書いてください"
# → ビルド・テスト実行はAIツールのネイティブ機能（ビルド検出など）を利用

claude "安全にコミットしてください"
# → commit-safe スキルがクリーンコミットを実行
```

マーケットプレイスから追加スキルを導入することも可能です:
[claude-skills-marketplace](https://github.com/dobachi/claude-skills-marketplace)

### 従来の方法
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

タスク管理・進捗追跡は、AIツールのネイティブ機能（Claude Code の Todo など）を利用してください。近年のAIエージェントはタスクの分解・進捗追跡を標準装備しているため、独自のスクリプトは不要です。

```bash
# 自然言語でタスクを指示するだけで、AIが進捗を管理
claude "ユーザー認証APIを実装してください"
# → Claude Code が Todo リストを自動生成し、進捗を追跡
```

## 🛒 マーケットプレイスのスキル

commit-safe を含むスキルは[マーケットプレイス](https://github.com/dobachi/claude-skills-marketplace)から導入します。導入後はスキル名で呼び出せます（自動起動）：

```bash
# コミット＆Issue報告
commit-and-report "バグ修正完了"

# クリーンコミット（AI署名なし）
commit-safe "ドキュメント更新"

# 指示書の再読み込み
reload-instructions
```

導入方法（Claude Code）：

```text
/plugin marketplace add dobachi/claude-skills-marketplace
/plugin install commit-safe@dobachi-skills
```

Codex / Gemini / Antigravity では、マーケットの `install.sh`（`~/.agents/skills` へ配置）で同じスキルが使えます。

## ❓ よくある質問

### Q: 既存のプロジェクトに影響はありますか？
A: 最小限の影響で導入できます。追加されるのは：
- `instructions/` ディレクトリ
- シンボリックリンク（CLAUDE.md等）
- `.claude/settings.json`（スキルはマーケットプレイスから別途導入）

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