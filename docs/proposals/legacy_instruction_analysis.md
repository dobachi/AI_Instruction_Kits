# 既存指示書分析レポート

## 作成日: 2025-07-26

## 概要
既存の単一指示書とプリセット/モジュラーシステムとの比較分析を行い、削除・移動対象を決定する。

## 既存指示書一覧（28ファイル）

### 日本語版指示書（14ファイル）

| カテゴリ | ファイル名 | 機能 | プリセット/モジュール代替 | 推奨アクション |
|---------|-----------|------|------------------------|--------------|
| **agent** | | | | |
| | code_reviewer.md | コードレビュー専門家 | なし（特殊機能） | **legacy保持** |
| | python_expert.md | Python専門家 | cli_tool_basicで部分代替可 | **legacy保持** |
| | technical_writer.md | テクニカルライター | technical_writerプリセット | **削除** |
| **analysis** | | | | |
| | basic_data_analysis.md | データ分析 | data_analystプリセット | **削除** |
| **coding** | | | | |
| | basic_code_generation.md | コード生成 | cli_tool_basic/web_api_production | **削除** |
| **creative** | | | | |
| | basic_creative_work.md | クリエイティブ作業 | なし（汎用的） | **保持検討** |
| **general** | | | | |
| | basic_qa.md | 質問応答 | なし（基本機能） | **保持** |
| **presentation** | | | | |
| | accessibility.md | アクセシビリティ | skill_accessibility | **削除** |
| | marp_specialist.md | Marp専門家 | なし（特殊機能） | **legacy保持** |
| | technical_design.md | 技術設計 | task_presentation_design | **削除** |
| **skills** | | | | |
| | literature_review.md | 文献レビュー | skill_literature_review | **削除** |
| **writing** | | | | |
| | basic_text_creation.md | 文章作成 | technical_writerプリセット | **削除** |
| | presentation_creation.md | プレゼン作成 | task_presentation_design | **削除** |
| | thesis_writing_lite.md | 論文執筆簡易版 | academic_researcherプリセット | **削除** |

### 英語版指示書（14ファイル）
※日本語版と同じ構成のため、同じ判定基準を適用

## 分類結果サマリー

### 削除対象（モジュラー/プリセットで完全代替可能）: 9種類
1. **technical_writer.md** → technical_writerプリセット
2. **basic_data_analysis.md** → data_analystプリセット  
3. **basic_code_generation.md** → cli_tool_basic/web_api_production
4. **accessibility.md** → skill_accessibility
5. **technical_design.md** → task_presentation_design
6. **literature_review.md** → skill_literature_review
7. **basic_text_creation.md** → technical_writerプリセット
8. **presentation_creation.md** → task_presentation_design
9. **thesis_writing_lite.md** → academic_researcherプリセット

### legacy保持対象（特殊機能・高頻度利用）: 3種類
1. **code_reviewer.md** - コードレビュー特化、独自の価値
2. **python_expert.md** - Python特化エージェント
3. **marp_specialist.md** - Marp特化、技術特殊性

### 現状維持対象: 2種類
1. **basic_qa.md** - 基本的な質問応答機能
2. **basic_creative_work.md** - 汎用的なクリエイティブ作業

## 移行計画

### Phase 1: レガシーディレクトリ移動（3ファイル×2言語）
```bash
# 日本語版
mv instructions/ja/agent/code_reviewer.* instructions/ja/legacy/agent/
mv instructions/ja/agent/python_expert.* instructions/ja/legacy/agent/
mv instructions/ja/presentation/marp_specialist.* instructions/ja/legacy/specialist/

# 英語版
mv instructions/en/agent/code_reviewer.* instructions/en/legacy/agent/
mv instructions/en/agent/python_expert.* instructions/en/legacy/agent/
mv instructions/en/presentation/marp_specialist.* instructions/en/legacy/specialist/
```

### Phase 2: 削除（9ファイル×2言語）
リダイレクト情報を残してから削除：
```bash
# 各ファイルにリダイレクト通知を作成
echo "# この指示書は移動しました" > REDIRECT.md
echo "代替: technical_writerプリセットを使用してください" >> REDIRECT.md
echo "パス: instructions/ja/presets/technical_writer.md" >> REDIRECT.md
```

### Phase 3: ROOT_INSTRUCTION更新
1. プリセット優先のロジック追加
2. レガシー指示書への参照更新
3. 削除された指示書の代替案明記

## 効果予測

### 削減効果
- **ファイル数**: 28ファイル → 10ファイル（64%削減）
- **管理負荷**: 重複メンテナンス不要
- **一貫性**: モジュラーシステムへの統一

### リスク対策
- **移行期間**: 2週間の告知期間
- **リダイレクト**: 削除ファイルに代替案を明記
- **ドキュメント**: 移行ガイドの作成

## 次のアクション
1. このレポートのレビューと承認
2. レガシーディレクトリへの移動実行
3. 削除対象ファイルのリダイレクト作成
4. ROOT_INSTRUCTIONの更新

---

## ライセンス情報
- **ライセンス**: Apache-2.0
- **作成日**: 2025-07-26