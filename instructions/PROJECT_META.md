# AI指示書キット開発支援設定

このプロジェクトはAI指示書システム自体の開発・改善を行うためのメタプロジェクトです。
タスク開始時は`instructions/ja/system/ROOT_INSTRUCTION.md`を読み込んでください。

**重要**: ROOT_INSTRUCTION.mdはスキルオーケストレーターです。インストール済みスキルを確認し、タスクに応じて利用してください。

## ⚠️ 重要: パスの読み替えについて

このプロジェクト自体で指示書を使用する場合、**パスの読み替えが必要です**：

### 通常のプロジェクトでの使用（サブモジュール経由）
```
instructions/ai_instruction_kits/instructions/ja/system/ROOT_INSTRUCTION.md
scripts/checkpoint.sh
```

### このプロジェクト自体での使用
```
instructions/ja/system/ROOT_INSTRUCTION.md
scripts/checkpoint.sh
```

### パス変換ルール
- `instructions/ai_instruction_kits/instructions/` → `instructions/`
- `instructions/ai_instruction_kits/` → ルートディレクトリ

## プロジェクト概要
- **目的**: AIへの指示書を構造的に管理・提供するシステムの開発
- **言語**: 日本語優先（英語版も同時メンテナンス）
- **ライセンス**: Apache-2.0（個別指示書は各自のライセンス）
- **アーキテクチャ**: スキルベース（v2.0） - コアスキル4個をローカル維持、その他はマーケットプレイスへ

## スキルベースアーキテクチャ（v2.0）

### コアスキル（ローカル維持）
| スキル | 用途 |
|--------|------|
| checkpoint-manager | タスク進捗追跡・管理 |
| worktree-manager | Git worktree管理 |
| auto-build | プロジェクトビルド自動化 |
| commit-safe | 安全なコミット |

### 追加スキル
マーケットプレイスからインストール: https://github.com/dobachi/claude-skills-marketplace

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

## Codex CLIカスタムコマンド

Codex CLI向けのカスタムプロンプトを`.codex/prompts/`に追加しました。ファイル名がそのまま`/コマンド名`として呼び出せます（例: `build.md` → `/build`）。必要に応じて自分の環境の`~/.codex/prompts/`へコピーし、CLIを再起動してください。

- `build` — プロジェクトの種類を判断してビルドを支援
- `checkpoint` — `scripts/checkpoint.sh` の各サブコマンドを案内
- `commit-and-report` — コミット・プッシュ・Issue報告の手順
- `commit-safe` — ファイル指定型の安全なコミット手順
- `github-issues` — GitHub Issueの取得と整理
- `reload-instructions` — 指示書サブモジュールの更新と再読込
- `reload-and-reset` — 指示書更新とルール再確認

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

# このプロジェクト自体でのcheckpoint実行
bash scripts/checkpoint.sh

# クリーンなコミット（AIメッセージなし）
bash scripts/commit.sh "コミットメッセージ"
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
# 各ダウンストリームプロジェクトのサブモジュールを更新
for repo in downstream/*/; do
  (cd "$repo" && git submodule update --remote instructions/ai_instruction_kits && git add -A && git commit -m "chore: update ai_instruction_kits submodule" && git push)
done
```

## コミットルール
- **必須**: `bash scripts/commit.sh "メッセージ"` または `git commit -m "メッセージ"`
- **禁止**: AI署名付きコミット（自動検出・拒否されます）

---
## ライセンス情報
- **ライセンス**: MIT
- **作成日**: 2025-01-03
