# スキルオーケストレーター

タスクに応じてインストール済みスキルを活用し、作業を効率化します。

## 指示

1. `.claude/skills/` のインストール済みスキルを確認し、タスクに応じて利用
2. 不足するスキルがあれば dobachi/claude-skills-marketplace を案内
3. カスタムスキルが必要なら skill-creator スキルを案内

## インストール済みスキル

| スキル | 用途 | 自動提案 |
|--------|------|----------|
| checkpoint-manager | タスク進捗追跡 | 会話開始時にpending確認を提案 |
| worktree-manager | Git worktree管理 | 複雑なタスクでworktree作成を提案 |
| auto-build | プロジェクトビルド自動化 | コード変更後にビルドを提案 |
| commit-safe | 安全なコミット | 変更後にファイル指定コミットを提案 |

## 基本ワークフロー

```
1. pending確認 → 2. タスク開始 → 3. worktree作成(任意) → 4. 作業 → 5. コミット → 6. 完了
```

## スキルがない場合

追加スキルはマーケットプレイスからインストール：
https://github.com/dobachi/claude-skills-marketplace

---
## ライセンス情報
- **ライセンス**: Apache-2.0
- **原著者**: dobachi
- **作成日**: 2025-06-30
- **更新日**: 2026-03-14
