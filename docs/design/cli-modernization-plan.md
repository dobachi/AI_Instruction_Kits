# CLI最新仕様対応 設計方針（Claude Code / Antigravity CLI）

最新のClaude CodeおよびAntigravity CLIの仕様にリポジトリを追従させ、旧版利用の下流プロジェクトを安全に移行するための設計方針。

調査日: 2026-06-28 / 対象: AI指示書キット本体および下流テンプレート群

## 1. 調査サマリ

### Claude Code（最新仕様）

- スキルは `.claude/skills/<name>/SKILL.md`（Agent Skills標準）。セッション中ホットリロード対応。
- SKILL.md frontmatter: `name`/`description`（必須）＋ `allowed-tools` `disable-model-invocation` `user-invocable` `model` `effort` `context: fork` `hooks` 等（任意）。
- `.claude/settings.json` の `attribution: {commit:"", pr:""}` がAI署名抑止の現行仕様（**本リポジトリは既に正しい**）。`includeCoAuthoredBy` は廃止。
- 配布は plugin marketplace。`.claude-plugin/marketplace.json` で公開し `/plugin marketplace add` → `/plugin install` で導入。

### Antigravity CLI（新規対応）

- CLIコマンドは `agy`。Gemini CLI（`.gemini/`）の後継的位置づけ。
- 指示書はルートの `AGENTS.md`（全プロンプトに前置。Codex等とも共有されるクロスツール標準）。
- スキル/スラッシュコマンドは `.agents/skills/`。**Claude Codeと同じ Agent Skills（SKILL.md）標準**を採用 → スキル本体を共通化可能。
- MCPは `mcp_config.json`。確認は `agy inspect`、Gemini資産移行は `agy plugin import gemini`。

### 本リポジトリの現状

| ツール | 指示書 | コマンド/スキル | 設定 |
|--------|--------|----------------|------|
| Claude Code | `CLAUDE.md`→`PROJECT_META.md` | `.claude/skills/`→`templates/claude-skills/ja` | `.claude/settings.json`（attribution済） |
| Codex CLI | `CODEX.md`→`PROJECT_META.md` | `.codex/prompts/*.md` | — |
| Gemini CLI | `GEMINI.md`→`PROJECT_META.md` | `.gemini/commands/*.toml` | — |
| Cursor | `CURSOR.md`→`PROJECT_META.md` | — | — |
| Antigravity | （無し） | （無し） | （無し） |

## 2. 設計上の主要判断

### スキル本体の単一ソース化

Claude CodeとAntigravityが同一のSKILL.md標準を使うため、スキル本体を `templates/claude-skills/<lang>/<skill>/SKILL.md` に一本化し、各ツールはそれを参照（symlink/コピー）する。日英同期の原則を維持する。

### 「スキル」と「コマンド」の整理

- スキル（自動起動の能力）: `commit-safe` → `templates/claude-skills/`。
- コマンド（ユーザ起動の手順）: `commit-and-report` / `github-issues` / `reload-instructions` / `reload-and-reset` / `evidence-check` → 現状 `.codex/prompts`・`.gemini/commands`。
- Antigravityは両者を `.agents/skills/*` のスラッシュコマンドとして扱うため、コマンド類もSKILL.md形式へ橋渡しする。

### plugin marketplace化の位置づけ

外部マーケットプレイス（`dobachi/claude-skills-marketplace`）とは別に、本リポジトリのコアスキルを `/plugin` で直接導入できるよう `.claude-plugin/marketplace.json` を追加する。下流プロジェクトはサブモジュール経由のコピー（従来）と、plugin導入（新）の双方を選択可能になる。

## 3. 対応タスク

### フェーズA: Antigravity CLI 対応（追加・低リスク）

1. `AGENTS.md` → `instructions/PROJECT_META.md` のsymlink追加（既存4ファイルと同パターン）。
2. `.agents/skills/<name>/SKILL.md` を新設。`commit-safe` はスキル本体から、コマンド類は `.codex/prompts` から移植（frontmatterに `name`/`description` を付与）。
3. `mcp_config.json` はMCP前提コマンドが無いため当面見送り（必要時に追加）。
4. `PROJECT_META.md` にAntigravity CLIの記述を追加。

### フェーズB: Claude Code plugin marketplace化

1. `.claude-plugin/marketplace.json` を追加し、コアプラグインを登録。
2. `plugins/<plugin>/.claude-plugin/plugin.json` ＋ スキルを配置（本体はtemplates参照）。
3. `attribution` は現行仕様で正しいため変更不要（明記のみ）。
4. `/plugin marketplace add .` での導入手順をREADME/docsに追加。

### フェーズC: 整合性・スクリプト・ドキュメント

1. `setup-project.sh` を拡張: `.agents/`・`AGENTS.md` のセットアップ、SKILL.md形式への一本化、レガシー成果物の掃除。
2. 英語スキル露出問題の解消（言語別の配置/symlink方針を確定）。
3. 日英 README / docs を同期更新。

## 4. 旧版下流プロジェクトの移行方針

下流テンプレート（ResearchTemplate / DevProjectTemplate / PresentationTemplate / DeliberationTemplate）は本リポジトリをサブモジュール化し `setup-project.sh` で各種設定をコピーしている。旧版には次の遺物が残りうる。

- レガシーなフラット形式 `.claude/skills/commit-safe.md`（現行はディレクトリ＋SKILL.md）。
- 廃止済みの独自タスク管理スキル（commit 4b80263 で削除）。
- Antigravity設定の不在。

### 移行戦略（後方互換重視）

1. **べき等な再セットアップ**: `setup-project.sh` を再実行すれば新構造へ更新されるようにする。レガシーなフラット`.md`を検出して新形式へ移行（または明示的に削除提案）。`git add -A` を避けユーザ確認を挟む既存方針を踏襲。
2. **マイグレーションスクリプト**: `scripts/migrate-skills.sh`（仮）を追加し、旧形式検出→バックアップ→新形式配置→廃止スキル削除を対話式で実施。ドライラン対応。
3. **一括反映**: `update-downstream.sh` にマイグレーション実行ステップを追加し、サブモジュール参照更新と同時に各下流へ新構造を適用。
4. **非破壊の既定**: 既存ユーザ設定（`.claude/settings.json` 等）は上書きせず、不足分のみ追記。Antigravity（`.agents/`・`AGENTS.md`）は新規追加のため衝突しない。

### 確定事項（2026-06-28）

- レガシー成果物（旧フラットスキル・廃止スキル）は**バックアップの上で自動移行・削除**する。
- 下流への適用は **`update-downstream.sh` による一括適用**とする。
- 実装は**フェーズAから着手**する。

## 5. 推奨実装順序

1. フェーズA（Antigravity、純粋追加）
2. フェーズB（marketplace、追加）
3. `migrate-skills.sh` 追加 ＋ `setup-project.sh` 拡張（後方互換）
4. ドキュメント日英同期
5. `update-downstream.sh` 連携 → 下流へ一括反映
