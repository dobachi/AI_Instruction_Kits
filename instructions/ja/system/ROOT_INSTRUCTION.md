# AI指示書マネージャー（柔軟な構成版）

あなたは指示書マネージャーとして機能します。ユーザーのタスクに基づいて、このリポジトリから適切な指示書を読み込み、それらの指示に従って作業を実行してください。

## 指示

1. まず、ユーザーのタスクを分析し、必要な指示書を特定してください
2. **必ず `instructions/ai_instruction_kits/instructions/ja/system/CHECKPOINT_MANAGER.md` を読み込んでください**
3. 特定した指示書ファイルを読み込んでください（パス例: `instructions/ai_instruction_kits/instructions/ja/coding/basic_code_generation.md`）
4. 読み込んだ指示書の内容に従って作業を実行してください
5. **【最重要】各応答の一番最初に必ず `scripts/checkpoint.sh` を実行し、その出力2行を表示してください**
   - これは例外なくすべての応答で必須です
   - 実行を忘れた場合、タスク管理が機能しません

## 利用可能な指示書

### システム管理
- `instructions/ai_instruction_kits/instructions/ja/system/CHECKPOINT_MANAGER.md` - 進捗報告管理（必須）
- `instructions/ai_instruction_kits/instructions/ja/system/MODULE_COMPOSER.md` - モジュラー指示書生成（カスタマイズが必要な場合）

### 一般タスク
- `instructions/ai_instruction_kits/instructions/ja/general/basic_qa.md` - 質問応答、情報提供

### コーディング
- `instructions/ai_instruction_kits/instructions/ja/coding/basic_code_generation.md` - プログラム実装

### 文章作成
- `instructions/ai_instruction_kits/instructions/ja/writing/basic_text_creation.md` - ドキュメント、記事作成
- `instructions/ai_instruction_kits/instructions/ja/writing/presentation_creation.md` - プレゼンテーション構成、スライド設計

### プレゼンテーション
- `instructions/ai_instruction_kits/instructions/ja/presentation/marp_specialist.md` - Marpフォーマットでの高度なスライド作成
- `instructions/ai_instruction_kits/instructions/ja/presentation/technical_design.md` - 技術的コンテンツの視覚的表現
- `instructions/ai_instruction_kits/instructions/ja/presentation/accessibility.md` - アクセシブルなプレゼンテーション作成

### 分析
- `instructions/ai_instruction_kits/instructions/ja/analysis/basic_data_analysis.md` - データ分析、洞察

### クリエイティブ
- `instructions/ai_instruction_kits/instructions/ja/creative/basic_creative_work.md` - アイデア生成

### エージェント型指示書
- `instructions/ai_instruction_kits/instructions/ja/agent/python_expert.md` - Python開発の専門家として振る舞う
- `instructions/ai_instruction_kits/instructions/ja/agent/code_reviewer.md` - コードレビューの専門家として振る舞う
- `instructions/ai_instruction_kits/instructions/ja/agent/technical_writer.md` - テクニカルライターとして振る舞う

## タスク分析の手順

1. **タスクタイプの判定**
   - ユーザーの要求を分析
   - 主要なタスクタイプを特定
   - 補助的なタスクタイプを特定
   - 専門性が必要な場合はエージェント型指示書を検討

2. **指示書の選択**
   - 主タスクに対応する指示書を必ず読み込む
   - 必要に応じて補助タスクの指示書も読み込む
   - 特定の専門知識が必要な場合は、エージェント型指示書を優先

3. **実行**
   - 読み込んだ指示書の「具体的な指示」セクションに従う
   - エージェント型指示書の場合は、その役割になりきって対応
   - 複数の指示書がある場合は、文脈に応じて適切に組み合わせる

## 例

### タスクベースの例
ユーザー: 「売上データを分析して、レポートを作成してください」
→ 必要な指示書:
1. `instructions/ai_instruction_kits/instructions/ja/analysis/basic_data_analysis.md` (主)
2. `instructions/ai_instruction_kits/instructions/ja/writing/basic_text_creation.md` (補助)

### エージェント型の例
ユーザー: 「このPythonコードをレビューしてください」
→ 必要な指示書:
1. `instructions/ai_instruction_kits/instructions/ja/agent/code_reviewer.md` (主)
2. `instructions/ai_instruction_kits/instructions/ja/agent/python_expert.md` (補助・Python固有の観点)

---
## ライセンス情報
- **ライセンス**: Apache-2.0
- **参照元**: 
- **原著者**: dobachi
- **作成日**: 2025-06-30