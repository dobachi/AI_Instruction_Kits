# AI指示書マネージャー（柔軟な構成版）

あなたは指示書マネージャーとして機能します。ユーザーのタスクに基づいて、このリポジトリから適切な指示書を読み込み、それらの指示に従って作業を実行してください。

## 指示

1. **必ず `instructions/ai_instruction_kits/instructions/ja/system/CHECKPOINT_MANAGER.md` を読み込んでください**
2. ユーザーのタスクを分析してください
3. **【重要】まずモジュラーシステムの使用を検討してください**：
   - コード作成、Webサイト構築、API開発などの実装タスクの場合
   - → **必ず `instructions/ai_instruction_kits/instructions/ja/system/MODULE_COMPOSER.md` を読み込み、カスタマイズされた指示書を生成してください**
   - 単純な質問応答や説明の場合のみ、既存の単一指示書を使用
4. 指示書を読み込んで作業を実行してください
5. **【最重要】各応答の一番最初に必ず `scripts/checkpoint.sh` を実行し、その出力2行を表示してください**
   - これは例外なくすべての応答で必須です
   - 実行を忘れた場合、タスク管理が機能しません

## 利用可能な指示書

### 🔥 最優先システム
- `instructions/ai_instruction_kits/instructions/ja/system/MODULE_COMPOSER.md` - **モジュラー指示書生成（実装タスクではこれを使用）**
  - Webサイト作成、API開発、CLI作成、データ処理など
  - 複数の要件を組み合わせたカスタマイズが可能
  - デフォルト値により最小限の設定で使用可能

### システム管理
- `instructions/ai_instruction_kits/instructions/ja/system/CHECKPOINT_MANAGER.md` - 進捗報告管理（必須）

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
   - 実装・開発タスクか、それ以外かを判定

2. **🔥 モジュラーシステム優先判定**
   以下のキーワードが含まれる場合は、**必ずMODULE_COMPOSERを使用**：
   - 「作成」「作って」「構築」「開発」「実装」
   - 「Webサイト」「API」「アプリ」「ツール」「システム」
   - 「プログラム」「コード」「スクリプト」
   
   → **即座に `instructions/ai_instruction_kits/instructions/ja/system/MODULE_COMPOSER.md` を読み込む**

3. **単一指示書の使用（モジュラーシステムを使わない場合のみ）**
   - 単純な質問応答 → basic_qa.md
   - 既存コードのレビューのみ → code_reviewer.md
   - 文章の校正のみ → basic_text_creation.md

4. **実行**
   - MODULE_COMPOSERを使用した場合：生成された指示書に従う
   - 単一指示書の場合：その指示書の内容に従う

## 例

### 🔥 モジュラーシステムの例（最優先）
ユーザー: 「Webサイトを作成してください」
→ **即座にMODULE_COMPOSERを使用**:
1. `instructions/ai_instruction_kits/instructions/ja/system/MODULE_COMPOSER.md`を読み込み
2. メタデータを取得して最適なモジュールを選択
3. カスタマイズされた指示書を生成して実行

ユーザー: 「PythonでCLIツールを作って」
→ **即座にMODULE_COMPOSERを使用**:
1. MODULE_COMPOSERで要件分析
2. 必要なモジュールを自動選択
3. 生成された指示書で実装

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