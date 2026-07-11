# 移行ガイド（AI指示書キットを利用するプロジェクト向け）

このキットを **サブモジュールとして利用しているプロジェクト**（テンプレート派生・直接利用を含む）が、最新仕様へ移行するための手順とバージョン別の移行記録。

## バージョン突合の仕組み

- キット側の現行バージョンは `VERSION` ファイル（単一の真実）。
- 利用側プロジェクトの適用済みバージョンは `instructions/.ai_ik_applied_version`。
- `scripts/run-migrations.sh` が両者を突合し、未適用の `migrations/<version>.sh` のみを semver 昇順で適用する（各移行は冪等・バックアップ付き）。
- SessionStartフック（`submodule-update-check.sh`）が pull/セッション開始時に突合し、未適用があればAIへ手順を提示する。

```bash
# 未適用の移行を確認
bash instructions/ai_instruction_kits/scripts/run-migrations.sh --dry-run

# 未適用の移行を適用し、適用済みバージョンを記録
bash instructions/ai_instruction_kits/scripts/run-migrations.sh
```

## AIエージェントへの標準手順

未適用のマイグレーション、または旧構成を検知した場合は次を順に実施する。

```bash
# 1. バージョン別の移行を適用（廃止物の掃除等。バックアップ付き）
bash instructions/ai_instruction_kits/scripts/run-migrations.sh

# 2. 最新構成を導入（PROJECT.md は上書きしない）
bash instructions/ai_instruction_kits/scripts/setup-project.sh --auto --skip-instructions --submodule
```

実施後の注意:

- `*.backup.*` はコミットしない（migrate / setup が生成するバックアップ）。
- `instructions/PROJECT.md` はプロジェクト固有設定。**絶対に上書きしない**（必ず `--skip-instructions`）。
- 変更を確認の上、commit-safe または `scripts/commit.sh` でコミットする。

## バージョン別 移行記録

新しいバージョンを追加する際は、ここに区間と手順を追記し、対応する `migrations/<version>.sh`（冪等）を用意する。

### → 2.1.0（Antigravity CLI対応・コアスキル整理）

| 区分 | 内容 |
|------|------|
| 廃止 | スキル checkpoint-manager / worktree-manager / auto-build、コマンド checkpoint / build |
| 移行 | レガシーなフラット形式 `.claude/skills/*.md` → `<name>/SKILL.md` 形式 |
| 追加 | Antigravity CLI対応（`AGENTS.md`・`.agents/skills/`） |
| 追加 | プラグインマーケットプレイス（`.claude-plugin/`、任意）※後に外部マーケットへ集約（下記参照） |

移行スクリプト: `migrations/2.1.0.sh`（廃止物の掃除を `migrate-skills.sh` に委譲）。

> **その後の変更（マーケット集約）**: 本リポジトリのプラグインマーケット（`.claude-plugin/`）と、各CLI向けのローカルスキル配布（`.claude/skills/`・`.agents/skills/`・`.codex/prompts/`・`.gemini/commands/`）を廃止し、commit-safe を含む全スキルを外部マーケット [dobachi/claude-skills-marketplace](https://github.com/dobachi/claude-skills-marketplace) に集約しました。`setup-project.sh` はスキルを配布せず、末尾で導入方法を案内します。Codex・Gemini・Antigravity は Agent Skills 標準（`~/.agents/skills`）を共有するため、マーケットの `install.sh` を一度実行すれば全CLIで利用できます。指示書ファイル（`CLAUDE.md`・`CODEX.md`・`GEMINI.md`・`AGENTS.md`）は従来どおり `setup-project.sh` が設定します。

## プラグイン利用

commit-safe を含むスキルは外部マーケットプレイスから導入します:

```text
/plugin marketplace add dobachi/claude-skills-marketplace
/plugin install commit-safe@dobachi-skills
```
