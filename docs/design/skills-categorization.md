# スキル仕分けと新アーキテクチャ設計

> **移行完了**: 2026-03-14 にv2.0移行を実施。modular/は`archive/v1-modular`ブランチに退避済み。
> コアスキル4個（checkpoint-manager, worktree-manager, auto-build, commit-safe）をローカル維持、
> その他はdobachi/claude-skills-marketplaceへ移動予定。

## 1. 背景・目的

### 現状の問題

AI_Instruction_Kitsは「モジュラー指示書合成システム」として発展してきたが、以下の課題が顕在化している：

- **複雑すぎる合成フロー**: CLAUDE.md → ROOT_INSTRUCTION → MODULE_COMPOSER → composer.py → プリセット生成という5-6段階のホップ
- **膨大なモジュール数**: modular/ディレクトリに271ファイル、管理・更新が困難
- **Python依存**: composer.pyによるプリセット生成がPython環境を前提とする
- **学習コストの高さ**: 新規利用者がシステム全体を理解するまでに時間がかかる

### 目標

**dobachi/claude-skills-marketplace をスキル提供の中心に据え**、AI_Instruction_Kitsは以下の役割に特化する：

- プロジェクト固有指示書（CLAUDE.md）のテンプレート提供
- スキルオーケストレーター（ROOT_INSTRUCTION）による発見・利用の仲介
- セットアップ基盤（setup-project.sh等）の提供

### 設計原則

- **プロジェクト固有指示書 → システム指示書の分離構造は維持する**
- スキルの実体はマーケットプレイスで管理し、このリポジトリはフレームワークに徹する
- 既存ユーザーへの移行パスを段階的に提供する

## 2. 新旧アーキテクチャ比較

### 現在のアーキテクチャ

```
CLAUDE.md → ROOT_INSTRUCTION → CHECKPOINT_MANAGER / WORKTREE_MANAGER
                              → MODULE_COMPOSER → composer.py → プリセット生成
                                                              → modular/ (271ファイル)
                                                              → presets/ → 生成済み指示書
```

**問題点**: ROOT_INSTRUCTIONが巨大で、MODULE_COMPOSERとcomposer.pyによる合成フローが複雑。

### 新アーキテクチャ

```
CLAUDE.md → ROOT_INSTRUCTION（スキルオーケストレーター、~40行）
                → .claude/skills/ のインストール済みスキルを使用
                → 不足時はマーケットプレイスまたは /skill-creator を案内
```

**改善点**:
- ROOT_INSTRUCTIONが~40行のシンプルなオーケストレーターに
- スキルの追加・削除がファイルコピーだけで完結
- Python依存の排除
- マーケットプレイスによるスキルの発見・共有

## 3. 全コンポーネント仕分け一覧

### STAY（このリポジトリに残す）

| カテゴリ | 対象 | 理由 |
|----------|------|------|
| プロジェクト固有指示書テンプレート | `templates/ja/PROJECT_TEMPLATE.md` 等 | プロジェクトごとのCLAUDE.md生成に必要 |
| システム指示書（再設計） | `ROOT_INSTRUCTION.md`（スキルオーケストレーター版） | スキル発見・利用のコア。~40行に簡素化 |
| システム指示書（簡素化） | `CLAUDE_CODE_AGENT.md` | Taskツール等のエージェント機能ガイド。要点のみに簡素化 |
| インストール基盤 | `setup-project.sh`, `install.sh`, `uninstall.sh` 等 | リポジトリ自体のセットアップ機構 |
| セッションフック | `gh-setup.sh`, `submodule-update-check.sh` | `.claude/settings.json` のSessionStartフック |
| Claude設定 | `.claude/settings.json` | フック・attribution設定 |
| Gitフック | `templates/git-hooks/prepare-commit-msg` | AI署名禁止フック |
| i18nライブラリ | `scripts/lib/i18n.sh`, `i18n_messages.sh` | setup-project.sh等の共有ライブラリ |
| ドキュメント | `docs/` 全体 | プロジェクトドキュメント |

### MOVE（マーケットプレイスに移動）

#### 既存スキル

| スキル名 | 現在パス | 同梱スクリプト |
|----------|----------|----------------|
| auto-build | `templates/claude-skills/ja/auto-build/` | なし |
| checkpoint-manager | `templates/claude-skills/ja/checkpoint-manager/` | `scripts/checkpoint.sh` |
| verify-content | `templates/claude-skills/ja/verify-content/` | なし |

#### 既存コマンド（スキル化して移動）

| コマンド名 | 現在パス | 同梱スクリプト |
|------------|----------|----------------|
| build | `templates/claude-commands/ja/build.md` | なし |
| checkpoint | `templates/claude-commands/ja/checkpoint.md` | `checkpoint.sh`（共有） |
| commit-and-report | `templates/claude-commands/ja/commit-and-report.md` | なし |
| commit-safe | `templates/claude-commands/ja/commit-safe.md` | `scripts/commit.sh` |
| github-issues | `templates/claude-commands/ja/github-issues.md` | なし |
| reload-instructions | `templates/claude-commands/ja/reload-instructions.md` | なし |
| reload-and-reset | `templates/claude-commands/ja/reload-and-reset.md` | なし |
| evidence-check | `templates/claude-commands/ja/evidence-check.md` | fact-checkerに統合 |

#### プリセット → 役割スキル化

| プリセット名 | マーケットプレイスのスキル名（案） |
|-------------|--------------------------------|
| web_api_production | web-api-dev |
| cli_tool_basic | cli-tool-dev |
| data_analyst | data-analyst |
| technical_writer | technical-writer |
| academic_researcher | academic-researcher |
| business_consultant | business-consultant |
| project_manager | project-manager |
| startup_advisor | startup-advisor |
| blueprint_sample | 削除（サンプルのため） |

#### レガシー指示書 → スキル化

| レガシー名 | マーケットプレイスのスキル名（案） |
|-----------|--------------------------------|
| python_expert | python-expert |
| code_reviewer | code-reviewer |
| marp_specialist | marp-slides |
| basic_qa | 削除（AI標準能力で十分） |
| basic_creative_work | 削除（AI標準能力で十分） |

#### 新規スキル（独立スクリプトをスキル化）

| スキル名（案） | 元 |
|----------------|-----|
| worktree-manager | `scripts/worktree-manager.sh` + `instructions/ja/system/WORKTREE_MANAGER.md` |

> **注**: 全て英語版（`en/`）も同様に扱う。

### DEPRECATE（廃止 → アーカイブ）

| 対象 | 理由 |
|------|------|
| `MODULE_COMPOSER.md` | マーケットプレイスで代替 |
| `CHECKPOINT_MANAGER.md`（指示書版） | checkpoint-managerスキルで代替 |
| `WORKTREE_MANAGER.md` | worktree-managerスキルで代替 |
| `OPENHANDS_ROOT.md` | ニッチ。必要時にスキル化 |
| `modular/` 全体（271ファイル + `composer.py`） | スキルマーケットプレイスで代替 |
| `instructions/ja/presets/` 全体 | マーケットプレイスのスキルで代替 |
| `instructions/ja/legacy/` 全体 | マーケットプレイスのスキルで代替 |
| `generate-instruction.sh` | モジュラーシステム廃止に伴い不要 |
| `generate-metadata.sh` | 同上 |
| `generate-all-presets.sh` | 同上 |
| `validate-modules.sh` | 同上 |
| `search-instructions.sh` | 同上 |
| Pythonツール群（`composer.py` 等） | 同上 |

## 4. 新ROOT_INSTRUCTION設計方針

ROOT_INSTRUCTIONを~40行のスキルオーケストレーターとして再設計する。

### 責務

1. **インストール済みスキルの発見**: `.claude/skills/` 配下のスキルを自動検出し、タスクに応じて利用
2. **マーケットプレイスの案内**: 不足するスキルがあれば `dobachi/claude-skills-marketplace` を案内
3. **スキル作成の案内**: `/skill-creator` による不足スキルの自作を案内
4. **オプション機能の委譲**: タスク追跡はcheckpoint-managerスキルがあれば使い、なければスキップ

### 設計ポイント

- 条件分岐やモジュール合成のロジックを持たない
- スキルの有無をファイルシステムで判定（`.claude/skills/` の存在チェック）
- 指示書自体は宣言的な記述に留める

## 5. 重複解消方針

### evidence-check → fact-checker統合

- `evidence-check`コマンドの有用な部分をfact-checkerスキルに統合
- evidence-checkは廃止

### verify-content vs fact-checker

| | verify-content | fact-checker |
|---|---|---|
| 位置づけ | 軽量版（依存なし） | 重量版（Puppeteer利用） |
| ユースケース | 簡易チェック、オフライン環境 | 徹底検証、引用元の実在確認 |
| 方針 | マーケットプレイスに移動、維持 | マーケットプレイスに移動、維持 |

両者は用途が異なるため、別スキルとして共存させる。

## 6. インストール・初期化スクリプトへの影響

### setup-project.sh の影響箇所

| 関数/箇所 | 概要行 | 変更内容 |
|-----------|--------|----------|
| コマンドセットアップ | L345-L400付近 | 廃止 → マーケットプレイス案内に変更 |
| `setup_claude_skills()` | L475-L558付近 | 廃止 → マーケットプレイス案内に変更 |
| `sync_claude_commands()` | L916-L960付近 | 廃止 → マーケットプレイス案内に変更 |
| プリセット選択フロー | 全般 | 廃止。初期セットアップを簡素化 |
| 完了メッセージ | L1667-L1707付近 | マーケットプレイスURLと `/skill-creator` を案内 |
| Gemini/Codex同期 | L1032-L1282付近 | 現状維持の可能性（Gemini/Codexは残す方針のため検討） |

### 新しいsetup-project.shのフロー

1. **統合モード選択**（copy/clone/submodule）→ 現状維持
2. **基本ファイル配置**（ROOT_INSTRUCTION, scripts, git-hooks）→ 簡素化
3. **`.claude/skills/` ディレクトリ初期化** → 新規追加
4. **マーケットプレイス連携の案内表示** → 新規追加

## 7. 移行パス

実際の移行は別タスクとして段階的に実施する。

| フェーズ | 内容 | 主な作業 |
|----------|------|----------|
| Phase 1 | スキル変換・公開 | プリセット・レガシー指示書をマーケットプレイスのスキルに変換して公開 |
| Phase 2 | コア再設計 | ROOT_INSTRUCTION再設計、`/skill-creator` 作成 |
| Phase 3 | コマンド・スクリプト移動 | 残りのコマンド・スクリプトをスキル化してマーケットプレイスに移動 |
| Phase 4 | レガシー削除 | `modular/` をアーカイブ、廃止スクリプト削除 |
| Phase 5 | 仕上げ | setup-project.sh簡素化、README更新、英語版同期 |

各フェーズは独立したPR/issueとして管理し、段階的に移行する。
