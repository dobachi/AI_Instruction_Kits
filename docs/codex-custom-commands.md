# Codex CLI カスタムコマンド一覧

このドキュメントでは、AI指示書キットで利用可能なCodex CLIカスタムプロンプトについて説明します。

## 利用可能なコマンド

### 1. `/checkpoint` - 進捗管理
タスクの進捗状況を管理・報告するためのコマンドです。

**使用例:**
```
/checkpoint
/checkpoint start TASK-001 "新機能実装" 5
/checkpoint progress TASK-001 "認証機能を実装中"
/checkpoint complete TASK-001 "完了"
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
/commit-and-report "バグ修正: ログイン処理" #123
```

**機能:**
- 変更内容の自動コミット
- 進捗状況の更新
- Issue番号への自動報告

### 3. `/commit-safe` - 安全なコミット
ファイル指定型の安全なコミットを行います。

**使用例:**
```
/commit-safe "リファクタリング: コード整理"
/commit-safe "バグ修正" src/main.ts src/utils.ts
```

**機能:**
- ファイル単位でのステージング確認
- 変更内容の事前確認
- 意図しないファイルのコミット防止

### 4. `/github-issues` - GitHub Issue確認
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

### 6. `/reload-and-reset` - システムリセット
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

### 7. `/build` - スマートビルドシステム
プロジェクトの構成を自動検出し、最適なビルドコマンドを実行します。

**使用例:**
```
/build                    # 基本ビルド
/build --clean           # クリーンビルド
/build --prod            # プロダクションビルド
/build --test            # テスト含むビルド
/build --deps            # 依存関係のみインストール
/build --check           # ビルド可能性チェック
/build --verbose         # 詳細ログ出力
/build --clean --prod    # 複数オプション組み合わせ
```

**対応プロジェクトタイプ:**
- **フロントエンド**: Node.js、Vite、Next.js、React、Vue、Angular、Webpack
- **バックエンド**: Rust、Go、Python、Java (Maven/Gradle)、C/C++、CMake
- **モバイル**: Flutter、React Native
- **その他**: Docker、Deno、WebAssembly

### 8. `/evidence-check` - エビデンスチェック
レポートや論文の参考文献・引用の妥当性を検証します。

**使用例:**
```
/evidence-check                    # カレントディレクトリ全体をチェック
/evidence-check docs/report.md     # 特定ファイルをチェック
/evidence-check "第3章 実験結果"    # 特定箇所をチェック
```

**機能:**
- 参考文献の存在確認
- 引用内容の整合性確認
- 文脈の適切性確認
- 自動修正案の提示

## セットアップ方法

### 新規プロジェクトでの導入

```bash
# AI指示書キットをサブモジュールとして追加
git submodule add https://github.com/dobachi/AI_Instruction_Kits.git instructions/ai_instruction_kits

# セットアップスクリプトの実行
./instructions/ai_instruction_kits/scripts/setup-project.sh
```

### カスタムプロンプトの更新

```bash
# ファイル同期（最新版への更新）
./scripts/setup-project.sh --sync-codex-commands
# または短縮形
./scripts/setup-project.sh --sync-codex
```

### 手動でのセットアップ

Codex CLIは `~/.codex/prompts/` または `.codex/prompts/` ディレクトリからカスタムプロンプトを読み込みます。

```bash
# プロジェクト固有（推奨）
mkdir -p .codex/prompts
cp instructions/ai_instruction_kits/.codex/prompts/*.md .codex/prompts/

# またはグローバル
mkdir -p ~/.codex/prompts
cp instructions/ai_instruction_kits/.codex/prompts/*.md ~/.codex/prompts/
```

プロンプトをコピー後、Codex CLIを再起動してください。

## トラブルシューティング

### GitHub CLIの認証エラー
```bash
# 認証状態の確認
gh auth status

# 認証が必要な場合
gh auth login
```

### コマンドが認識されない
1. `.codex/prompts/`ディレクトリの確認
2. プロンプトファイルの存在確認
3. Codex CLIの再起動

### 指示書が正しく読み込まれない
`/reload-and-reset`コマンドを使用してシステムをリセットしてください。

## 注意事項

- カスタムプロンプトはCodex CLI専用の機能です
- プロンプトファイルは`.codex/prompts/`ディレクトリに配置されます
- 定期的に`--sync-codex`で最新版に更新することを推奨します
- Claude Code版と同等の機能を提供しますが、フォーマットが異なります（YAMLフロントマターなし）
