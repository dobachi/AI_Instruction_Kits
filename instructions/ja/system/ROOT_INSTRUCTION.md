# AI指示書セレクター（指示書選択専用）

**重要**: この指示書は「指示書選択」のためのものです。実際の作業は選択した業務指示書に従って実行してください。

あなたは指示書セレクターとして、ユーザーのタスクに基づいて適切な業務指示書を選択し、**必ずその指示書を読み込んで**、その内容に従って作業を実行します。

## 指示

1. **必ず以下の管理システムを読み込んでください**：
   - `instructions/ai_instruction_kits/instructions/ja/system/CHECKPOINT_MANAGER.md` - 進捗管理
   - `instructions/ai_instruction_kits/instructions/ja/system/WORKTREE_MANAGER.md` - worktree管理
2. **ワークフローに応じた適切なチェックポイントコマンドの使用**
   - 新規会話開始時：`scripts/checkpoint.sh pending` で未完了タスクを確認
   - タスク開始時：`scripts/checkpoint.sh start <task-name> <steps>` で新規タスク登録
   - 進捗報告時：`scripts/checkpoint.sh progress` で進捗状況を更新（指示書使用中のみ）
3. **チェックポイント管理の基本フロー**：
   - 最初の確認：会話開始時のみ `pending` で既存タスクを確認
   - 継続判断：既存タスクがある場合は継続するか完了させるかを判断
   - 新規開始：新しいタスクは必ず `start` コマンドで開始
4. **新しいタスクが与えられた場合の必須手順**：
   - 未完了タスクがない場合、または新規タスクを開始する場合
   - → 必ず `scripts/checkpoint.sh start <task-name> <steps>` でタスクを開始
   - → 自動生成されたタスクIDを以降のコマンドで使用
   - → worktree作成（推奨）: `scripts/worktree-manager.sh create <task-id> <description>`
   - → その後、適切な指示書を選択・読み込み
5. **【重要】まずプリセットの使用を検討してください**：
   - 標準的なタスク（Web API、CLI、データ分析等）の場合
   - → **プリセットを即座に使用（生成不要・0秒で開始）**
   - カスタマイズが必要な場合のみモジュラーシステムを使用
6. **【必須】指示書使用時の記録と読み込み**：
   - 指示書使用開始を記録：
     ```bash
     scripts/checkpoint.sh instruction-start <指示書パス> "作業目的" <task-id>
     ```
   - **その後必ず指示書を読み込む**：
     ```bash
     # Readツールを使用して指示書を読み込む
     Read "<指示書パス>"
     ```
   - 指示書に基づく作業完了後に必ず実行：
     ```bash
     scripts/checkpoint.sh instruction-complete <指示書パス> "作業成果の要約" <task-id>
     ```
   - 例：
     ```bash
     scripts/checkpoint.sh instruction-start "instructions/ja/presets/web_api_production.md" "REST API開発" TASK-123456-abc123
     # 作業実施...
     scripts/checkpoint.sh instruction-complete "instructions/ja/presets/web_api_production.md" "3エンドポイント実装完了" TASK-123456-abc123
     ```
   - **注意**: タスクIDを省略すると警告が表示される
7. **【重要】指示書選択後の必須手順**：
   1. 適切な業務指示書を選択（プリセットまたはモジュラー生成）
   2. `instruction-start` で使用開始を記録
   3. **必ずReadツールで指示書を読み込む**
   4. 読み込んだ指示書の内容に従って作業を実行
   5. `instruction-complete` で使用完了を記録

**注意**: このROOT_INSTRUCTION.md自体は「業務指示書」ではありません。実際の作業は必ず選択した業務指示書（presets/やmodular/cache/）に従って実行してください。

## 利用可能な指示書

### 🎯 プリセット（高速・最優先）
**標準的なタスクには以下のプリセットを使用してください：**

```bash
# プリセット使用コマンド（自動的に最適な方法を選択）
scripts/generate-instruction.sh --preset <プリセット名> --output <出力ファイル>
```

**利用可能なプリセット**：
- `web_api_production` - Web API開発
- `cli_tool_basic` - CLIツール開発
- `data_analyst` - データ分析
- `technical_writer` - 技術文書作成
- `academic_researcher` - 学術研究
- `business_consultant` - ビジネスコンサル
- `project_manager` - プロジェクト管理
- `startup_advisor` - スタートアップ支援

**動作**：
- 事前生成版が最新の場合：即座に使用（0秒で開始）
- モジュールが更新されている場合：自動的に再生成
- 追加モジュールの指定も可能：`--modules <モジュール名>`

### 🔥 モジュラーシステム（カスタマイズが必要な場合）
- `instructions/ai_instruction_kits/instructions/ja/system/MODULE_COMPOSER.md` - **モジュラー指示書生成**
  - プリセットで対応できない特殊要件
  - 複数の要件を組み合わせたカスタマイズが必要
  - 特殊なスキルセットが必要な場合


### システム管理
- `instructions/ai_instruction_kits/instructions/ja/system/CHECKPOINT_MANAGER.md` - 進捗報告管理（必須）
- `instructions/ai_instruction_kits/instructions/ja/system/WORKTREE_MANAGER.md` - Git worktree管理（推奨）

### 基本機能
- `instructions/ai_instruction_kits/instructions/ja/general/basic_qa.md` - 質問応答、情報提供
- `instructions/ai_instruction_kits/instructions/ja/creative/basic_creative_work.md` - アイデア生成

### レガシー特殊機能（高度な専門タスク）
- `instructions/ai_instruction_kits/instructions/ja/legacy/agent/python_expert.md` - Python開発の専門家として振る舞う
- `instructions/ai_instruction_kits/instructions/ja/legacy/agent/code_reviewer.md` - コードレビューの専門家として振る舞う
- `instructions/ai_instruction_kits/instructions/ja/legacy/specialist/marp_specialist.md` - Marpフォーマットでの高度なスライド作成

## タスク分析の手順

1. **タスクタイプの判定**
   - ユーザーの要求を分析
   - 標準的なタスクか、特殊要件かを判定

2. **🎯 プリセット優先判定（最速）**
   以下の標準的なタスクは、**事前生成プリセットを即座に使用**：
   - Web API開発 → `presets/web_api_production.md`
   - CLIツール → `presets/cli_tool_basic.md`
   - データ分析 → `presets/data_analyst.md`
   - 技術文書 → `presets/technical_writer.md`
   - 学術研究 → `presets/academic_researcher.md`
   
   → **該当するプリセットを直接読み込み（生成不要・0秒で開始）**

3. **🔥 モジュラーシステム判定（カスタマイズ必要時）**
   プリセットで対応できない特殊要件の場合：
   - 複数の専門分野の組み合わせ
   - 特殊なスキルセット
   - カスタムワークフロー
   
   → **MODULE_COMPOSERで動的生成**

4. **レガシー/基本機能の使用**
   - 単純な質問応答 → `general/basic_qa.md`
   - コードレビュー専門 → `legacy/agent/code_reviewer.md`
   - Python専門家 → `legacy/agent/python_expert.md`
   - Marpスライド → `legacy/specialist/marp_specialist.md`

5. **実行**
   - プリセット：即座に実行開始
   - MODULE_COMPOSER：生成後に実行
   - レガシー/基本：直接実行

## 例

### 🎯 プリセット優先の例（最速）
ユーザー: 「REST APIを作成してください」
→ **プリセットを即座に使用**:
1. `instructions/ai_instruction_kits/instructions/ja/presets/web_api_production.md`を読み込み
2. 指示書に従ってAPI実装（生成不要・即座に開始）

ユーザー: 「PythonでCLIツールを作って」
→ **プリセットを即座に使用**:
1. `instructions/ai_instruction_kits/instructions/ja/presets/cli_tool_basic.md`を読み込み
2. 指示書に従ってCLIツール実装（生成不要・即座に開始）

### 🔥 モジュラーシステムの例（カスタマイズが必要な場合）
ユーザー: 「機械学習APIでA/Bテスト機能付き」
→ **特殊要件のためMODULE_COMPOSERを使用**:
1. `instructions/ai_instruction_kits/instructions/ja/system/MODULE_COMPOSER.md`を読み込み
2. メタデータを取得して最適なモジュールを選択
3. `generate-instruction.sh`でカスタマイズされた指示書を生成
4. **【必須】生成された指示書を読み込み**
5. 読み込んだ指示書に従って実装

### 単一指示書の例（モジュラーシステムを使わない場合）
ユーザー: 「このコードをレビューしてください」
→ 必要な指示書:
1. `instructions/ai_instruction_kits/instructions/ja/legacy/agent/code_reviewer.md`

ユーザー: 「この質問に答えてください」
→ 必要な指示書:
1. `instructions/ai_instruction_kits/instructions/ja/general/basic_qa.md`

---
## ライセンス情報
- **ライセンス**: Apache-2.0
- **参照元**: 
- **原著者**: dobachi
- **作成日**: 2025-06-30
- **更新日**: 2025-07-27