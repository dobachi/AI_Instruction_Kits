# AI指示書キット開発支援設定

このプロジェクトはAI指示書システム自体の開発・改善を行うためのメタプロジェクトです。
タスク開始時は`instructions/ja/system/ROOT_INSTRUCTION.md`を読み込んでください。

**重要**: ROOT_INSTRUCTION.mdは指示書選択専用です。選択した業務指示書を必ず読み込んでから作業を実行してください。

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
- 新しい指示書タイプの追加が容易であること
- カスタマイズが柔軟にできること
- 他のAIツールへの対応が可能であること

## 開発時の重要事項

### ファイル編集時
1. **日英同期**: 日本語版を更新したら必ず英語版も更新
2. **実例優先**: 抽象的な説明より具体例を重視
3. **後方互換性**: 既存の使用方法を壊さない
4. **パス記述**: 指示書内のパスはサブモジュール使用を前提に記述

### 新機能追加時
1. まず日本語版で実装・検証
2. 英語版を作成
3. サンプル・テンプレートを更新
4. READMEとドキュメントを更新

### テスト・検証
1. setup-project.shが正しく動作するか確認
2. 各指示書が独立して機能するか確認
3. ROOT_INSTRUCTIONとMODULE_COMPOSERの連携確認
4. パスの整合性確認（サブモジュール環境での動作）

## Claude Codeエージェント機能の活用

プロジェクト分析や大規模な調査タスクには、Task toolを積極的に活用してください：

### 推奨される使用場面
- 指示書の品質チェック・重複検出
- 未使用コードの特定
- 依存関係の分析
- ドキュメントとコードの整合性確認

### 使用方法
詳細は `instructions/ja/system/CLAUDE_CODE_AGENT.md` を参照してください。
エージェント機能により、複雑な分析タスクを自律的に実行できます。

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
# 新しい指示書の追加（日本語）
cp templates/ja/instruction_template.md instructions/ja/<category>/<name>.md

# 新しい指示書の追加（英語）
cp templates/en/instruction_template.md instructions/en/<category>/<name>.md

# 統合テスト
bash scripts/setup-project.sh

# このプロジェクト自体でのcheckpoint実行
bash scripts/checkpoint.sh

# クリーンなコミット（AIメッセージなし）
bash scripts/commit.sh "コミットメッセージ"

# ファイル整合性チェック（将来実装予定）
# bash scripts/validate-instructions.sh
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

## コミットルール
- **必須**: `bash scripts/commit.sh "メッセージ"` または `git commit -m "メッセージ"`
- **禁止**: AI署名付きコミット（自動検出・拒否されます）

## 現在の課題と今後の改善点

1. 指示書間の重複を減らす仕組み
2. バージョン管理とアップデート通知
3. コミュニティからの貢献を受け入れる仕組み
4. 自動テストの充実
5. パフォーマンス最適化（大量の指示書読み込み時）
6. パスの自動変換機能（メタ使用時）

---
## ライセンス情報
- **ライセンス**: MIT
- **作成日**: 2025-01-03