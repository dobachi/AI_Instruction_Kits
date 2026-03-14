---
name: worktree-manager
description: Git worktreeの作成・管理を行うスキル。複雑なタスクや複数ファイル変更時にworktree作成を提案、タスク完了時にマージ・クリーンアップを案内。checkpoint-managerと連携。
---

# Worktree管理スキル

Git worktreeを活用して、タスクごとに独立した作業環境を提供するスキルです。

## 自動提案のタイミング

| 状況 | 提案内容 |
|------|----------|
| 複数ファイル変更タスク開始時 | 「worktreeを作成しますか？」 |
| チェックポイント開始後 | 「タスク用のworktreeを作成しますか？」 |
| タスク完了時 | 「worktreeをマージ・クリーンアップしますか？」 |
| 孤立worktree検出時 | 「不要なworktreeをクリーンアップしますか？」 |

## ワークフロー概要

```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│  create     │    │  作業実施   │    │  complete   │    │  clean      │
│  worktree   │ → │  (worktree  │ → │  マージ     │ → │  クリーン   │
│  作成       │    │   内で)     │    │  削除       │    │  アップ     │
└─────────────┘    └─────────────┘    └─────────────┘    └─────────────┘
```

## コマンド一覧

```bash
# 新しいworktreeを作成
scripts/worktree-manager.sh create <task-id> <description>

# アクティブなworktreeを一覧表示
scripts/worktree-manager.sh list

# worktreeのパスを表示（切り替え用）
scripts/worktree-manager.sh switch <task-id>

# worktreeを完了（マージ/削除オプション）
scripts/worktree-manager.sh complete <task-id>

# 孤立したworktreeをクリーンアップ
scripts/worktree-manager.sh clean
```

## 使用シナリオ

### シナリオ1: 新規タスクでworktree作成

チェックポイント開始後、worktreeを作成して独立環境で作業：

```
AI: worktreeを作成しますか？
    タスク: [タスク名]
    タスクID: TASK-123456-abc123

# 実行
scripts/worktree-manager.sh create TASK-123456-abc123 "feature-dev"
cd .gitworktrees/ai-TASK-123456-abc123-feature-dev/
```

### シナリオ2: worktree一覧確認

```
AI: アクティブなworktreeを確認しますか？

# 実行
scripts/worktree-manager.sh list
```

### シナリオ3: タスク完了時のworktree処理

```
AI: worktreeをマージしてクリーンアップしますか？

# 実行
scripts/worktree-manager.sh complete TASK-123456-abc123
# オプション: 1)マージして削除 2)保持 3)マージせず削除
```

### シナリオ4: クリーンアップ

```
AI: 孤立したworktreeをクリーンアップしますか？

# 実行
scripts/worktree-manager.sh clean
```

## checkpoint-managerとの連携

推奨ワークフロー：

```bash
# 1. タスク開始
scripts/checkpoint.sh start "機能開発" 3
# → TASK-123456-abc123

# 2. worktree作成
scripts/worktree-manager.sh create TASK-123456-abc123 "feature-dev"
cd .gitworktrees/ai-TASK-123456-abc123-feature-dev/

# 3. 作業実施...

# 4. タスク完了
scripts/checkpoint.sh complete TASK-123456-abc123 "完了"

# 5. worktreeマージ・削除
scripts/worktree-manager.sh complete TASK-123456-abc123
```

## 判断基準

### worktree作成を提案する条件

- 複数ファイルにまたがる変更が予想される
- リファクタリングや大規模な機能追加
- 既存のコードに影響を与える可能性がある変更
- チェックポイントが開始されている

### worktreeを提案しない条件

- 単一ファイルの小さな修正
- ドキュメントのみの更新
- 設定ファイルの変更のみ

## 注意事項

- worktreeは `.gitworktrees/` ディレクトリに作成される
- ブランチ名は `ai-<task-id>-<description>` 形式
- `scripts/worktree-manager.sh` はプロジェクトルートから実行
- worktree内でも `scripts/checkpoint.sh` は使用可能
