# git worktree運用環境の構築

## 概要
AIが安全に作業できるようにgit worktree運用環境をデフォルトで提供する。各AIタスクは独立したworktreeで作業し、メインのワーキングディレクトリに影響を与えない。

## 背景
- 複数のAIが同時に作業する際の競合を防ぐ
- 各タスクの作業を明確に分離
- メインブランチを常にクリーンに保つ
- レビューとマージの流れを明確化

## 要件

### 1. ディレクトリ構造
```
AI_Instruction_Kits/
├── .gitworktrees/          # git worktree用ディレクトリ（.gitignore対象）
│   ├── ai-TASK-xxx-feature/
│   ├── ai-TASK-yyy-bugfix/
│   └── ai-TASK-zzz-api/
├── scripts/
│   ├── worktree-manager.sh # worktree管理スクリプト（新規）
│   └── setup-project.sh    # 既存（worktree機能追加）
└── .gitignore              # .gitworktrees/を追加
```

### 2. 機能要件

#### worktree-manager.sh
- `create <task-id> <description>`: 新規worktree作成
- `list`: 現在のworktree一覧表示
- `clean`: 不要なworktree削除
- `switch <task-id>`: worktreeへの切り替え
- `complete <task-id>`: 完了処理（マージ or 削除）

#### 命名規則
- AIタスク: `ai-{タスクID}-{簡潔な説明}`
- 手動作業: `feature-{機能名}`, `bugfix-{issue番号}`

### 3. 指示書の作成
- `WORKTREE_MANAGER.md`を新規作成
- ROOT_INSTRUCTION.mdの必須読み込みに追加
- checkpointとの連携フローを定義

### 4. setup-project.shの拡張
- デフォルトで`.gitworktrees/`ディレクトリを作成
- `--disable-worktree`オプションで無効化可能
- 既存プロジェクトへの適用も考慮

## 実装タスク

- [ ] `.gitignore`に`.gitworktrees/`を追加
- [ ] `scripts/worktree-manager.sh`の作成
- [ ] `instructions/ja/system/WORKTREE_MANAGER.md`の作成
- [ ] `instructions/en/system/WORKTREE_MANAGER.md`の作成（英語版）
- [ ] ROOT_INSTRUCTION.mdの更新（日英両方）
- [ ] setup-project.shへのworktree機能統合
- [ ] CLAUDE.mdへの使用例追加
- [ ] テストとドキュメント作成

## 期待される効果
- AIの作業がより安全に
- 複数タスクの並行作業が可能
- コードレビューが容易に
- git履歴がクリーンに保たれる

## 関連
- #checkpoint-manager
- #setup-project