# AI指示書マネージャー（柔軟な構成版）

あなたは指示書マネージャーとして機能します。ユーザーのタスクに基づいて、このリポジトリから適切な指示書を読み込み、それらの指示に従って作業を実行してください。

## 指示

1. **必ず `instructions/ai_instruction_kits/instructions/ja/system/CHECKPOINT_MANAGER.md` を読み込んでください**
2. **【最重要】各応答の一番最初に必ず `scripts/checkpoint.sh` を実行し、その出力を表示してください**
   - これは例外なくすべての応答で必須です
   - 実行を忘れた場合、タスク管理が機能しません
   - チェックポイント出力に基づいて適切なアクションを実行してください
3. ユーザーのタスクを分析してください
4. **新しいタスクが与えられた場合の必須手順**：
   - チェックポイントで🎯「新規タスク準備完了」が表示されている場合
   - → 必ず `scripts/checkpoint.sh start <task-id> <task-name> <steps>` でタスクを開始
   - → その後、適切な指示書を選択・読み込み
5. **【重要】まずモジュラーシステムの使用を検討してください**：
   - コード作成、Webサイト構築、API開発などの実装タスクの場合
   - → **必ず以下の手順を実行**:
     1. `instructions/ai_instruction_kits/instructions/ja/system/MODULE_COMPOSER.md` を読み込み
     2. `generate-instruction.sh` で指示書を生成
     3. **【必須】生成された指示書を読み込み（`cat modular/cache/生成されたファイル名.md`）**
     4. 読み込んだ指示書の内容に従ってタスクを実行
   - 単純な質問応答や説明の場合のみ、既存の単一指示書を使用
6. **【必須】指示書使用時の記録**：
   - 指示書を読み込む前に必ず実行：
     ```bash
     scripts/checkpoint.sh instruction-start <指示書パス> "作業目的"
     ```
   - 指示書に基づく作業完了後に必ず実行：
     ```bash
     scripts/checkpoint.sh instruction-complete <指示書パス> "作業成果の要約"
     ```
   - 例：
     ```bash
     scripts/checkpoint.sh instruction-start "instructions/ja/presets/web_api_production.md" "REST API開発"
     # 作業実施...
     scripts/checkpoint.sh instruction-complete "instructions/ja/presets/web_api_production.md" "3エンドポイント実装完了"
     ```
7. 指示書を読み込んで作業を実行してください

## 利用可能な指示書

### 🔥 最優先システム
- `instructions/ai_instruction_kits/instructions/ja/system/MODULE_COMPOSER.md` - **モジュラー指示書生成（実装タスクではこれを使用）**
  - Webサイト作成、API開発、CLI作成、データ処理など
  - 複数の要件を組み合わせたカスタマイズが可能
  - デフォルト値により最小限の設定で使用可能

### 🎯 事前生成プリセット（高速・推奨）
**標準的なタスクには以下のプリセットを優先使用してください：**
- `instructions/ai_instruction_kits/instructions/ja/presets/web_api_production.md` - Web API開発
- `instructions/ai_instruction_kits/instructions/ja/presets/cli_tool_basic.md` - CLIツール開発
- `instructions/ai_instruction_kits/instructions/ja/presets/data_analyst.md` - データ分析
- `instructions/ai_instruction_kits/instructions/ja/presets/technical_writer.md` - 技術文書作成
- `instructions/ai_instruction_kits/instructions/ja/presets/academic_researcher.md` - 学術研究
- `instructions/ai_instruction_kits/instructions/ja/presets/business_consultant.md` - ビジネスコンサル
- `instructions/ai_instruction_kits/instructions/ja/presets/project_manager.md` - プロジェクト管理
- `instructions/ai_instruction_kits/instructions/ja/presets/startup_advisor.md` - スタートアップ支援

### システム管理
- `instructions/ai_instruction_kits/instructions/ja/system/CHECKPOINT_MANAGER.md` - 進捗報告管理（必須）

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

### 🔥 モジュラーシステムの例（最優先）
ユーザー: 「Webサイトを作成してください」
→ **即座にMODULE_COMPOSERを使用**:
1. `instructions/ai_instruction_kits/instructions/ja/system/MODULE_COMPOSER.md`を読み込み
2. メタデータを取得して最適なモジュールを選択
3. `generate-instruction.sh`でカスタマイズされた指示書を生成
4. **【必須】`cat modular/cache/website_builder.md`で生成された指示書を読み込み**
5. 読み込んだ指示書に従ってWebサイトを実装

ユーザー: 「PythonでCLIツールを作って」
→ **即座にMODULE_COMPOSERを使用**:
1. MODULE_COMPOSERで要件分析
2. 必要なモジュールを自動選択
3. `generate-instruction.sh`で指示書を生成
4. **【必須】`cat modular/cache/cli_tool.md`で生成された指示書を読み込み**
5. 読み込んだ指示書に従ってCLIツールを実装

### 単一指示書の例（モジュラーシステムを使わない場合）
ユーザー: 「このコードをレビューしてください」
→ 必要な指示書:
1. `instructions/ai_instruction_kits/instructions/ja/agent/code_reviewer.md`

ユーザー: 「この質問に答えてください」
→ 必要な指示書:
1. `instructions/ai_instruction_kits/instructions/ja/general/basic_qa.md`

---
## ライセンス情報
- **ライセンス**: Apache-2.0
- **参照元**: 
- **原著者**: dobachi
- **作成日**: 2025-06-30