# Git Worktree管理システム

## 推奨ルール
**複雑なタスクや複数ファイルの変更を伴う場合は、専用worktreeの作成を推奨**

### worktreeを使うべき場合
- 複数ファイルの追加・変更
- 新機能の実装
- リファクタリング
- 実験的な変更

### worktreeが不要な場合
- 単一ファイルの簡単な修正
- ドキュメントの誤字修正
- 設定ファイルの微調整

```bash
# 1. タスク開始（タスクID取得）
scripts/checkpoint.sh start "タスク名" 5
# → タスクID: TASK-123456-abc

# 2. worktree作成（必須）
scripts/worktree-manager.sh create TASK-123456-abc "簡潔な説明"
# → .gitworktrees/ai-TASK-123456-abc-簡潔な説明/

# 3. 移動して作業
cd .gitworktrees/ai-TASK-123456-abc-簡潔な説明/
```

## 基本コマンド

```bash
# 作成
scripts/worktree-manager.sh create <task-id> <description>

# 一覧
scripts/worktree-manager.sh list

# 完了（マージ/保持/削除を選択）
scripts/worktree-manager.sh complete <task-id>
```

## 重要事項
- worktreeは`.gitworktrees/`に隔離（gitignore対象）
- メインディレクトリでの直接編集は避ける
- 複数タスクの並行作業が可能

---
## ライセンス情報
- **ライセンス**: Apache-2.0
- **参照元**: 
- **原著者**: dobachi
- **作成日**: 2025-01-08
- **更新日**: 2025-01-08