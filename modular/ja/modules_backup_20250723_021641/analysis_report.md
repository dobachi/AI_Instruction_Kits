=== モジュールファイル分析レポート ===
実行日: 2025年  7月 23日 水曜日 02:05:01 JST

## 1. ファイル名と内容ヘッダーの不一致

- ./expertise/parallel_distributed.md: ヘッダーは「簡潔版」だが、ファイル名は標準版を示している
- ./expertise/machine_learning.md: ヘッダーは「簡潔版」だが、ファイル名は標準版を示している
- ./expertise/academic_writing.md: ヘッダーは「簡潔版」だが、ファイル名は標準版を示している
- ./roles/consultant.md: ヘッダーは「簡潔版」だが、ファイル名は標準版を示している
- ./roles/reviewer.md: ヘッダーは「簡潔版」だが、ファイル名は標準版を示している
- ./roles/advisor.md: ヘッダーは「簡潔版」だが、ファイル名は標準版を示している
- ./skills/business_model_canvas.md: ヘッダーは「簡潔版」だが、ファイル名は標準版を示している
- ./skills/design_thinking.md: ヘッダーは「簡潔版」だが、ファイル名は標準版を示している
- ./skills/facilitation.md: ヘッダーは「簡潔版」だが、ファイル名は標準版を示している
- ./skills/citation_management.md: ヘッダーは「簡潔版」だが、ファイル名は標準版を示している
- ./skills/literature_review.md: ヘッダーは「簡潔版」だが、ファイル名は標準版を示している
- ./skills/api_design.md: ヘッダーは「簡潔版」だが、ファイル名は標準版を示している
- ./skills/swot_analysis.md: ヘッダーは「簡潔版」だが、ファイル名は標準版を示している
- ./tasks/business_planning.md: ヘッダーは「簡潔版」だが、ファイル名は標準版を示している
- ./tasks/research.md: ヘッダーは「簡潔版」だが、ファイル名は標準版を示している
- ./tasks/competitive_analysis.md: ヘッダーは「簡潔版」だが、ファイル名は標準版を示している
- ./tasks/documentation.md: ヘッダーは「簡潔版」だが、ファイル名は標準版を示している
- ./tasks/user_research.md: ヘッダーは「簡潔版」だが、ファイル名は標準版を示している
- ./tasks/market_research.md: ヘッダーは「簡潔版」だが、ファイル名は標準版を示している
- ./tasks/presentation_design.md: ヘッダーは「簡潔版」だが、ファイル名は標準版を示している
- ./tasks/thesis_writing.md: ヘッダーは「簡潔版」だが、ファイル名は標準版を示している
- ./tasks/proposal_writing.md: ヘッダーは「簡潔版」だが、ファイル名は標準版を示している
- ./tasks/data_analysis.md: ヘッダーは「簡潔版」だが、ファイル名は標準版を示している
- ./tasks/report_writing.md: ヘッダーは「簡潔版」だが、ファイル名は標準版を示している
- ./tasks/blog_writing.md: ヘッダーは「簡潔版」だが、ファイル名は標準版を示している

## 2. 重複コンテンツの検出

- ./expertise/parallel_distributed.md と ./expertise/parallel_distributed_concise.md は同一内容
- ./expertise/machine_learning.md と ./expertise/machine_learning_concise.md は同一内容
- ./expertise/software_engineering.md と ./expertise/software_engineering_concise.md は同一内容

## 3. サイズ異常の検出

- 警告: ./quality/production_concise.md (1673B) が ./quality/production.md (1206B) より大きい
- 警告: ./skills/error_handling_concise.md (1494B) が ./skills/error_handling.md (973B) より大きい
- 警告: ./skills/authentication_concise.md (1547B) が ./skills/authentication.md (1484B) より大きい
- 警告: ./tasks/code_generation_concise.md (2086B) が ./tasks/code_generation.md (1176B) より大きい

## 4. 問題のあるファイル名パターン

### _detailed_concise.md パターン（矛盾した命名）:
./expertise/parallel_distributed_detailed_concise.md
./expertise/software_engineering_detailed_concise.md
./expertise/legal_engineering_detailed_concise.md
./expertise/machine_learning_detailed_concise.md

## 5. 推奨アクション

### 即座に対応が必要:
1. 同一内容のファイルの統合または削除
2. _detailed_concise.mdファイルの名前変更
3. ヘッダーとファイル名の不一致の修正

### 中期的な改善:
1. 命名規則の明確化と文書化
2. 自動検証スクリプトの導入
3. テンプレートの更新
