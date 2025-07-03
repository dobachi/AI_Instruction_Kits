# 利用ガイド / Usage Guide

## 🚀 クイックスタート / Quick Start

### 0. プロジェクトへの統合（推奨）
```bash
# あなたのプロジェクトで一度だけ実行
cd ~/your-project
bash path/to/AI_Instruction_Kits/tools/setup-project.sh

# その後は簡単に使用可能
claude "CLAUDE.mdを参照して、ユーザー認証機能を実装して"
```

### 1. 単一の指示書を使う場合
```bash
# AIツールに直接ファイルパスを指定
claude "instructions/ja/coding/basic_code_generation.md を参照して、フィボナッチ数列を生成するコードを書いて"
```

### 2. 複数の指示書を組み合わせる場合
```bash
# ROOT_INSTRUCTION.md を使用
claude "ROOT_INSTRUCTION.md を参照して、コーディングとデータ分析の指示書を適用してください"
```

### 3. セレクターを使う場合
```bash
# INSTRUCTION_SELECTOR.md から選択
claude "INSTRUCTION_SELECTOR.md のWebアプリケーション開発セットを使用"
```

## 📖 詳細な使用方法 / Detailed Usage

### Claude Codeでの使用例

#### 方法1: ファイル参照
```markdown
以下のファイルの指示に従ってください：
- /path/to/AI_Instruction_Kits/instructions/ja/coding/basic_code_generation.md
- /path/to/AI_Instruction_Kits/instructions/ja/writing/basic_text_creation.md

タスク: RESTful APIのエンドポイントを実装し、APIドキュメントを作成
```

#### 方法2: 内容をコピー＆ペースト
1. 必要な指示書を開く
2. 内容をコピー
3. プロンプトの冒頭に貼り付け
4. その後に具体的なタスクを記述

### 効果的な組み合わせパターン

#### パターン1: 段階的適用
```markdown
ステップ1: instructions/ja/analysis/basic_data_analysis.md でデータを分析
ステップ2: instructions/ja/writing/basic_text_creation.md で報告書作成
ステップ3: instructions/ja/creative/basic_creative_work.md で改善提案
```

#### パターン2: 役割分担
```markdown
メイン: instructions/ja/coding/basic_code_generation.md
サポート: instructions/ja/general/basic_qa.md （技術的質問への回答用）
```

## ⚙️ カスタマイズ / Customization

### 独自の指示書を追加する

1. テンプレートをコピー
```bash
cp templates/ja/instruction_template.md instructions/ja/[category]/my_instruction.md
```

2. 内容を編集
3. ROOT_INSTRUCTION.md に追加

### 組織用カスタマイズ

```markdown
# 社内プロジェクト用設定
## ベース指示書
- instructions/ja/coding/basic_code_generation.md

## 追加ルール
- 社内コーディング規約に従う
- セキュリティガイドラインを遵守
- コメントは英語で記述
```

## 🔍 トラブルシューティング / Troubleshooting

### Q: 指示が競合する場合は？
A: より具体的な指示を優先。ROOT_INSTRUCTION.md で優先順位を明記。

### Q: 指示書が長すぎる場合は？
A: 必要な部分のみ抜粋するか、要約版を作成。

### Q: 言語を混在させたい場合は？
A: 推奨しませんが、必要な場合は明示的に言語を指定。

## 📊 効果測定 / Effectiveness Measurement

### チェックリスト
- [ ] タスクの要件は満たされたか
- [ ] 出力の品質は期待通りか
- [ ] 指示書の組み合わせは適切だったか
- [ ] 改善点はあるか

### フィードバックループ
1. 使用した指示書の組み合わせを記録
2. 結果を評価
3. 必要に応じて指示書を調整
4. ベストプラクティスを文書化

---
## ライセンス情報
- **ライセンス**: Apache-2.0
- **参照元**: 
- **原著者**: dobachi
- **作成日**: 2025-06-30