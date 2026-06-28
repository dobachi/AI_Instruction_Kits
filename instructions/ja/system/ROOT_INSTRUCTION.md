# スキルオーケストレーター

タスクに応じてインストール済みスキルを活用し、作業を効率化します。

## 指示

1. `.claude/skills/` のインストール済みスキルを確認し、タスクに応じて利用
2. 不足するスキルがあれば dobachi/claude-skills-marketplace を案内
3. カスタムスキルが必要なら skill-creator スキルを案内

## インストール済みスキル

| スキル | 用途 | 自動提案 |
|--------|------|----------|
| commit-safe | 安全なコミット | 変更後にファイル指定コミットを提案 |

> タスク管理・進捗追跡・Git worktree・ビルドは、AIツールのネイティブ機能を利用してください。

## 基本ワークフロー

```
1. 作業 → 2. ネイティブなタスク管理で進捗追跡 → 3. commit-safe で安全にコミット
```

## スキルがない場合

追加スキルはマーケットプレイスからインストール：
https://github.com/dobachi/claude-skills-marketplace

## 更新・移行の確認

1. `bash instructions/ai_instruction_kits/scripts/run-migrations.sh --dry-run` で未適用の移行を確認
2. 未適用があれば `run-migrations.sh` を実行し、`setup-project.sh --skip-instructions` で最新構成を導入
3. 詳細は `docs/UPGRADING.md` を参照。`*.backup.*` はコミットしない

---
## ライセンス情報
- **ライセンス**: Apache-2.0
- **原著者**: dobachi
- **作成日**: 2025-06-30
- **更新日**: 2026-03-14
