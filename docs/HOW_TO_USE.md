# AI指示書リポジトリ 使い方ガイド（人間向け）

このドキュメントは、本リポジトリの利用者（人間）向けのガイドです。

## 基本的な使い方

### 1. シンプルな使用方法

最も簡単な方法は、必要な指示書のパスをAIに伝えることです：

```
「instructions/ja/coding/basic_code_generation.md を参照して、
フィボナッチ数列を生成するPythonコードを書いてください」
```

### 2. ROOT_INSTRUCTIONを使った方法

ROOT_INSTRUCTION.mdは、AIに指示書マネージャーとして振る舞わせます：

```
「ROOT_INSTRUCTION.md を参照して、
売上データを分析してレポートを作成してください」
```

AIは自動的に：
- analysis/basic_data_analysis.md（データ分析用）
- writing/basic_text_creation.md（レポート作成用）
を読み込んで実行します。

### 3. INSTRUCTION_SELECTORを使った方法

特定のユースケース向けに最適化された組み合わせを使用：

```
「INSTRUCTION_SELECTOR.md を参照して、
Webアプリケーション開発タスクとして、
RESTful APIを実装してください」
```

## ユースケース別ガイド

### データ分析プロジェクト
```
必要なファイル：
- ROOT_INSTRUCTION.md または INSTRUCTION_SELECTOR.md
- データファイル

使用例：
「INSTRUCTION_SELECTOR.md のデータサイエンスタスクルールを適用して、
sales_data.csv を分析し、洞察をまとめてください」
```

### コンテンツ作成
```
必要なファイル：
- instructions/ja/writing/basic_text_creation.md
- instructions/ja/creative/basic_creative_work.md

使用例：
「上記の指示書を参照して、
AIの未来についての記事を作成してください」
```

## カスタマイズ方法

### 新しい指示書の追加

1. テンプレートをコピー：
   ```bash
   cp templates/ja/instruction_template.md instructions/ja/[category]/my_instruction.md
   ```

2. 内容を編集

3. ROOT_INSTRUCTION.mdに追加（オプション）

### 組織固有のルール追加

instructions/ja/general/company_rules.md などを作成し、
社内ルールやコーディング規約を記載。

## ベストプラクティス

1. **最小限から始める**
   - 必要最小限の指示書から始めて、必要に応じて追加

2. **明確な指定**
   - ファイルパスは正確に指定
   - タスクの目的を明確に伝える

3. **フィードバックループ**
   - 結果を確認し、必要に応じて指示書を改善

## トラブルシューティング

### AIが期待通りに動作しない場合

1. 指定したファイルパスが正しいか確認
2. より具体的な指示を追加
3. 必要に応じて複数の指示書を明示的に指定

### パフォーマンスの問題

- 大量の指示書を読み込むと処理が遅くなる可能性
- 必要な部分のみを抜粋して使用することを検討

---
## ライセンス情報
- **ライセンス**: Apache-2.0
- **参照元**: 
- **原著者**: dobachi
- **作成日**: 2025-06-30