# 指示書セレクター / Instruction Selector

## 🎯 クイック選択ガイド / Quick Selection Guide

### ケース別推奨組み合わせ / Recommended Combinations by Use Case

#### 1. **Webアプリケーション開発**
```yaml
必須:
  - instructions/ja/coding/basic_code_generation.md
推奨:
  - instructions/ja/analysis/basic_data_analysis.md  # API設計分析用
  - instructions/ja/writing/basic_text_creation.md   # ドキュメント作成用
```

#### 2. **データサイエンスプロジェクト**
```yaml
必須:
  - instructions/ja/analysis/basic_data_analysis.md
  - instructions/ja/coding/basic_code_generation.md  # 分析コード用
推奨:
  - instructions/ja/writing/basic_text_creation.md   # レポート作成用
```

#### 3. **コンテンツ作成**
```yaml
必須:
  - instructions/ja/writing/basic_text_creation.md
  - instructions/ja/creative/basic_creative_work.md
推奨:
  - instructions/ja/general/basic_qa.md  # ファクトチェック用
```

#### 4. **技術サポート・ヘルプデスク**
```yaml
必須:
  - instructions/ja/general/basic_qa.md
推奨:
  - instructions/ja/writing/basic_text_creation.md  # 回答文書化用
```

## 📋 インタラクティブ選択 / Interactive Selection

AIに以下のメッセージをコピー＆ペーストしてください：

### 日本語版
```
以下から今回のタスクに必要な機能を選んでください（複数選択可）：

1. ✅ 質問への正確な回答
2. ✅ プログラムコードの生成
3. ✅ 文章・ドキュメントの作成
4. ✅ データの分析と洞察
5. ✅ 創造的なアイデア生成

選択した番号: [ここに番号を入力]
```

### English Version
```
Please select the functions needed for your task (multiple selections allowed):

1. ✅ Accurate question answering
2. ✅ Program code generation
3. ✅ Text/document creation
4. ✅ Data analysis and insights
5. ✅ Creative idea generation

Selected numbers: [Enter numbers here]
```

## 🔧 カスタム組み合わせ / Custom Combinations

### テンプレート
```markdown
# カスタムタスク設定

## 主要タスク
- ファイル: `instructions/[lang]/[category]/[filename].md`

## 補助タスク
- ファイル: `instructions/[lang]/[category]/[filename].md`
- ファイル: `instructions/[lang]/[category]/[filename].md`

## タスク固有の追加指示
- [ここに特別な要件を記載]
```

## 💡 使用のヒント / Usage Tips

1. **最小限から始める**: 必要最小限の指示書から始めて、必要に応じて追加
2. **言語の統一**: 日本語/英語の指示書を混在させない
3. **優先順位を明確に**: 複数の指示書を使う場合、どれを優先するか明記
4. **定期的な見直し**: タスクの進化に合わせて指示書の組み合わせを調整

---
## ライセンス情報
- **ライセンス**: Apache-2.0
- **参照元**: 
- **原著者**: dobachi
- **作成日**: 2025-06-30