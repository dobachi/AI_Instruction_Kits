# モジュラーシステム開発ガイド

## 概要

このドキュメントは、AI指示書キットのモジュラーシステムにおける各種モジュール開発のための包括的なガイドです。モジュールの種類、開発プロセス、品質基準、ベストプラクティスを説明します。

## モジュールタイプ

### 1. Core（コア）
システムの基本構造を定義する必須モジュール
- `role_definition`: 役割定義
- `constraints`: 制約事項
- `output_format`: 出力形式

### 2. Tasks（タスク）
具体的な作業内容を定義
- 例: `code_generation`、`data_analysis`、`documentation`

### 3. Skills（スキル）
特定の能力や技術を提供
- 例: `api_design`、`testing`、`error_handling`

### 4. Methods（方法論）
作業アプローチや方法論を定義
- 例: `agile`、`lean`、`design_thinking`

### 5. Domains（ドメイン）
業界固有の知識と慣習
- 例: `fintech`、`healthcare`、`education`

### 6. Roles（役割）
AIの振る舞いやペルソナを定義
- 例: `mentor`、`reviewer`、`consultant`

### 7. Quality（品質）
品質レベルや基準を定義
- 例: `production`（本番品質）

### 8. Expertise（専門知識）
深い専門知識と最新ベストプラクティス
- 例: `software_engineering`、`machine_learning`

## 開発プロセス

### Phase 1: 計画

#### 1.1 モジュールタイプの決定
```yaml
判断基準:
  Core: システムの基本動作に必要
  Tasks: 具体的な成果物を生成
  Skills: 特定の技術的能力
  Methods: プロセスや手順
  Domains: 業界特有の知識
  Roles: AIの振る舞い
  Quality: 品質基準
  Expertise: 深い専門知識（最新トレンド含む）
```

#### 1.2 スコープ定義
- 提供する機能の明確化
- 他モジュールとの境界設定
- 依存関係の特定

### Phase 2: 研究・調査

#### 2.1 情報収集
```bash
# 調査結果の保存先
docs/references/[category]/[module_name]_research.md
```

#### 2.2 ベストプラクティス調査
- 業界標準の確認
- 最新トレンドの把握（特にExpertiseモジュール）
- 実装例の収集

### Phase 3: 設計

#### 3.1 構造設計
```markdown
## 基本構造（全モジュール共通）
1. 概要
2. 主要機能/原則
3. 実装詳細
4. 使用例
5. ベストプラクティス（該当する場合）
```

#### 3.2 変数設計
```yaml
変数設計原則:
  - 明確な命名: [category]_[specific_function]
  - 適切なデフォルト値: 最も一般的な設定
  - 拡張性: 将来の追加を考慮
  - enum型の活用: 選択肢を明確に
```

### Phase 4: 実装

#### 4.1 Markdownファイル作成
```markdown
# [モジュール名]

## 概要
[簡潔で明確な説明]

## [メインセクション]
### 1. [サブセクション]
[詳細内容]

## 変数の活用例
### パターン1: [使用シナリオ]
```yaml
[変数設定例]
```
```

#### 4.2 YAMLメタデータ作成
```yaml
id: [category]_[name]
name: [日本語名]
description: [詳細な説明]
version: 1.0.0
category: [category]
subcategory: [subcategory]

variables:
  - name: "[variable_name]"
    description: "[説明]"
    type: "enum"
    values: [...]
    default: "[default_value]"

dependencies:
  required: []
  optional: []

compatible_tasks: []

tags: []

examples: []
```

### Phase 5: 品質保証

#### 5.1 セルフレビューチェックリスト
```markdown
## 一般チェックリスト
- [ ] 概要が明確で理解しやすい
- [ ] 構造が論理的で一貫している
- [ ] 実装例が動作可能
- [ ] 変数が適切に定義されている
- [ ] 依存関係が正確
- [ ] タグが包括的

## カテゴリ別追加チェック
### Expertise モジュール
- [ ] 2024-2025年の最新情報を反映
- [ ] 権威ある情報源を参照
- [ ] 理論と実践のバランス
- [ ] 実装可能なコード例

### Skills モジュール
- [ ] 具体的な実装手順
- [ ] エラーハンドリング
- [ ] パフォーマンス考慮

### Methods モジュール
- [ ] プロセスが明確
- [ ] 各ステップの成果物定義
- [ ] 実践的なアドバイス
```

#### 5.2 テスト
```bash
# モジュール生成テスト
python modular/composer.py \
  --modules [module_id] \
  --output test_output.md

# 内容確認
- 正しく生成されるか
- 変数が適切に展開されるか
- 他モジュールとの統合
```

### Phase 6: 国際化

#### 6.1 英語版作成
```bash
# ファイル構造
modular/
├── ja/modules/[category]/[name].md
├── ja/modules/[category]/[name].yaml
├── en/modules/[category]/[name].md
└── en/modules/[category]/[name].yaml
```

#### 6.2 翻訳のポイント
- 専門用語の正確性
- 文化的コンテキストの調整
- コード例はそのまま維持

## ベストプラクティス

### 1. 一貫性の維持
- 統一された構造
- 命名規則の遵守
- スタイルガイドの順守

### 2. 実用性の重視
- 理論より実践
- 具体的な例の提供
- すぐに使える内容

### 3. 保守性の確保
- 明確なバージョニング
- 更新履歴の記録
- 依存関係の最小化

### 4. 協調性
- 他モジュールとの連携
- 再利用可能な設計
- 明確なインターフェース

## カテゴリ別ガイドライン

### Expertiseモジュール
詳細は [EXPERTISE_MODULE_GUIDE.md](../docs/development/EXPERTISE_MODULE_GUIDE.md) を参照

特徴:
- 深い専門知識
- 最新トレンドの反映
- 包括的な実装例
- 業界標準準拠

### Skillsモジュール
特徴:
- 具体的な技術実装
- ステップバイステップ
- エラー処理含む
- 実践的なTips

### Methodsモジュール
特徴:
- プロセス定義
- 役割と責任
- 成果物の明確化
- 実施手順

## トラブルシューティング

### 問題: モジュールが正しく読み込まれない
```yaml
確認事項:
  - YAMLの構文エラー
  - IDの重複
  - 必須フィールドの欠落
  
解決方法:
  - YAMLリンターで検証
  - catalog_cache.jsonの確認
  - エラーログの確認
```

### 問題: 変数が展開されない
```yaml
確認事項:
  - 変数名の一致
  - デフォルト値の設定
  - 型の整合性
  
解決方法:
  - 変数定義の見直し
  - テンプレート構文の確認
```

## 開発ツール

### 1. モジュール生成テスト
```bash
# 単一モジュールテスト
python modular/composer.py --modules [id]

# 複数モジュール統合テスト
python modular/composer.py --modules [id1] [id2] [id3]
```

### 2. 品質チェックツール（今後実装予定）
```bash
# 構造チェック
scripts/validate-module.sh [module_path]

# スタイルチェック
scripts/check-style.sh [module_path]
```

## 貢献ガイドライン

### 1. 新規モジュール提案
1. Issueで提案
2. 既存モジュールとの差別化を説明
3. 使用例を提示

### 2. 既存モジュール改善
1. 小さな改善から開始
2. 後方互換性の維持
3. テストの追加

### 3. レビュープロセス
1. セルフチェックリスト完了
2. プルリクエスト作成
3. レビューフィードバック対応

## 今後の展望

### 1. 自動化の推進
- モジュール生成支援ツール
- 品質チェック自動化
- 依存関係の自動解決

### 2. エコシステムの拡大
- コミュニティモジュール
- モジュールマーケットプレイス
- 評価・レビューシステム

### 3. 高度な機能
- 条件付きモジュール読み込み
- 動的モジュール生成
- AIによるモジュール推薦

---

このガイドに従うことで、高品質で再利用可能なモジュールを効率的に開発できます。質問や提案がある場合は、Issueを作成してください。