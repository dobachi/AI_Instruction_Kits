# git worktree運用環境の構築

## 概要
AIタスクごとに独立したgit worktreeで作業し、メインディレクトリへの影響を防ぐ。

## 主な変更
1. `.gitworktrees/`ディレクトリをデフォルト作成（.gitignore対象）
2. `scripts/worktree-manager.sh`で管理
3. `WORKTREE_MANAGER.md`指示書を追加
4. タスクIDと連携した命名規則: `ai-TASK-xxx-description`

## 実装項目
- [ ] worktree-manager.shスクリプト作成
- [ ] WORKTREE_MANAGER.md指示書作成（日英）
- [ ] setup-project.shに統合
- [ ] ROOT_INSTRUCTIONに必須読み込み追加

## 利点
- 複数AIの並行作業が安全
- コードレビューが容易
- git履歴がクリーン