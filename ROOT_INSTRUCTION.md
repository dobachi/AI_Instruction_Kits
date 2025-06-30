# AI指示書ルートファイル

このファイルは、本リポジトリの指示書を選択的に読み込むためのエントリーポイントです。

## 使い方

以下の指示書から必要なものを選択し、AIに読み込ませてください：

### 1. 一般的なタスク (General)
- [ ] **基本的な質問応答**: `instructions/ja/general/basic_qa.md`
  - 事実に基づいた正確な回答が必要な場合

### 2. コーディング (Coding)
- [ ] **基本的なコード生成**: `instructions/ja/coding/basic_code_generation.md`
  - プログラムの実装が必要な場合

### 3. 文章作成 (Writing)
- [ ] **基本的な文章作成**: `instructions/ja/writing/basic_text_creation.md`
  - ビジネス文書や記事の作成が必要な場合

### 4. 分析 (Analysis)
- [ ] **基本的なデータ分析**: `instructions/ja/analysis/basic_data_analysis.md`
  - データから洞察を得る必要がある場合

### 5. クリエイティブ (Creative)
- [ ] **基本的なクリエイティブ作業**: `instructions/ja/creative/basic_creative_work.md`
  - 創造的なアイデアや解決策が必要な場合

## 選択方法

### 方法1: 直接参照
```
以下の指示書に従ってください：
- instructions/ja/coding/basic_code_generation.md
- instructions/ja/analysis/basic_data_analysis.md
```

### 方法2: タスクタイプを指定
```
タスクタイプ: コーディング、分析
言語: 日本語
```

### 方法3: 複合タスクの場合
```
主タスク: データ分析
補助タスク: 結果の文章化、視覚化コードの生成
```

## 注意事項
- 矛盾する指示がある場合は、より具体的な指示を優先
- 必要に応じて指示書を組み合わせて使用可能
- タスクの性質に応じて適切な指示書を選択

---
## ライセンス情報
- **ライセンス**: Apache-2.0
- **参照元**: 
- **原著者**: dobachi
- **作成日**: 2025-06-30