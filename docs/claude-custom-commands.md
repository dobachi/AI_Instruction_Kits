# Claude Code カスタムコマンド一覧

このドキュメントでは、AI指示書キットで利用可能なClaude Codeカスタムコマンドについて説明します。

## 利用可能なコマンド

### 1. `/checkpoint` - 進捗管理
タスクの進捗状況を管理・報告するためのコマンドです。

**使用例:**
```
/checkpoint
```

**機能:**
- 現在のタスク一覧表示
- 進捗状況の確認
- タスクの開始・完了管理

### 2. `/commit-and-report` - コミット＆進捗報告
Gitコミットと同時に進捗報告を行うコマンドです。

**使用例:**
```
/commit-and-report "機能追加: カスタムコマンド実装"
```

**機能:**
- 変更内容の自動コミット
- 進捗状況の更新
- コミットメッセージの自動生成

### 3. `/commit-safe` - AIマーカーなしコミット
AIによる署名を含まない通常のGitコミットを行います。

**使用例:**
```
/commit-safe "リファクタリング: コード整理"
```

**機能:**
- 通常のGitコミット実行
- AIマーカーを含まない
- `scripts/commit.sh`を使用

### 4. `/github-issues` - GitHub Issue確認 🆕
GitHub Issueを確認し、やるべきタスクを整理します。

**使用例:**
```
/github-issues
```

**機能:**
- オープンなIssue一覧表示
- ラベル別の集計
- 最近作成されたIssueの確認
- 高優先度Issueの抽出
- タスク整理の提案

**必要条件:**
- GitHub CLI (`gh`) のインストール
- `gh auth login` による認証

### 5. `/reload-instructions` - 指示書更新
AI指示書システムを最新版に更新します。

**使用例:**
```
/reload-instructions
```

**機能:**
- サブモジュールの更新
- ROOT_INSTRUCTIONの再読み込み
- 最新の指示書システムへの更新

### 6. `/reload-and-reset` - システムリセット 🆕
AI指示書システムをリロードし、AIの振る舞いをリセットします。

**使用例:**
```
/reload-and-reset
```

**機能:**
- 現在のタスク状態の保存
- サブモジュールの更新（開発環境では自動判別）
- AIシステムの完全リセット
- ROOT_INSTRUCTIONの再読み込み
- 保存したタスク状態の復元

**推奨使用タイミング:**
- AIが指示書に従わない振る舞いをした時
- 長時間の作業セッション後
- 新しいタスクセッションを開始する前

### 7. `/build` - プロジェクトビルド 🆕
プロジェクトに適したビルドコマンドを自動的に検出・実行します。

**使用例:**
```
/build
/build --clean
/build --prod
/build --test
```

**機能:**
- プロジェクトタイプの自動検出（Node.js、Rust、Python、Go等）
- パッケージマネージャーの自動判別（npm、yarn、pnpm）
- 依存関係の自動インストール
- ビルドエラーの分析と解決策の提案
- プロジェクト固有の設定対応（CLAUDE.md記載のカスタムコマンド）

**対応プロジェクト:**
- Node.js/JavaScript/TypeScript (package.json)
- Rust (Cargo.toml)
- Python (pyproject.toml)
- Go (go.mod)
- Java (pom.xml, build.gradle)
- その他 (Makefile)

## セットアップ方法

### 新規プロジェクトでの導入

```bash
# AI指示書キットをサブモジュールとして追加
git submodule add https://github.com/dobachi/AI_Instruction_Kits.git instructions/ai_instruction_kits

# セットアップスクリプトの実行
./instructions/ai_instruction_kits/scripts/setup-project.sh
```

### カスタムコマンドの更新

```bash
# ファイル同期（最新版への更新）
./scripts/setup-project.sh --sync-claude-commands
# または短縮形
./scripts/setup-project.sh --sync-claude
```

## トラブルシューティング

### GitHub CLIの認証エラー
```bash
# 認証状態の確認
gh auth status

# 認証が必要な場合
gh auth login
```

### コマンドが認識されない
1. `.claude/commands/`ディレクトリの確認
2. コマンドファイルの存在確認
3. Claude Codeの再起動

### 指示書が正しく読み込まれない
`/reload-and-reset`コマンドを使用してシステムをリセットしてください。

## 注意事項

- カスタムコマンドはClaude Code専用の機能です
- 他のAIツール（Cursor、Gemini等）では利用できません
- コマンドファイルは`.claude/commands/`ディレクトリに配置されます
- 定期的に`--sync-claude-commands`で最新版に更新することを推奨します