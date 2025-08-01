# AI指示書キット モジュールサイズ基準に関する調査報告書

## 調査日時
2025-01-26

## 調査概要
AI指示書キットのモジュラーシステムにおける詳細版と簡潔版のモジュールファイルのサイズ基準について調査を実施しました。

## 主要な発見事項

### 1. 現状のモジュールサイズ分布

#### 簡潔版（通常版）モジュール
- **平均行数**: 約70-250行
- **最小**: 52行（accessibility.md）
- **最大**: 248行（parallel_distributed.md）
- **中央値**: 約120-150行

#### 詳細版モジュール（_detailed.md）
- **平均行数**: 約200-800行
- **最小**: 65行（accessibility_detailed.md）
- **最大**: 1,093行（machine_learning_detailed.md）
- **中央値**: 約350-450行

### 2. サイズ比率の分析

詳細版と簡潔版のサイズ比率を分析した結果：
- **最小比率**: 1.25倍（accessibility）
- **最大比率**: 6.14倍（machine_learning）
- **平均比率**: 約3.5倍
- **推奨比率**: 2.5〜4.0倍

### 3. 明文化されたガイドライン

#### docs/developers/best-practices/module-creation.md より
```yaml
簡潔版の作成原則:
  - 詳細版を先に作成: 広く深い調査とベストプラクティスに基づく完全版
  - エッセンスの抽出: 詳細版から最重要概念のみを抽出
  - サイズ目標: 詳細版の20-30%（トークン効率重視）
```

#### docs/proposals/modular_token_reduction.md より
- 簡潔版の目標: 詳細版の30-40%のサイズ
- 具体例: machine_learning.md（34KB）→ machine_learning_concise.md（目標10KB以下）

### 4. バリデーションスクリプトの確認

`validate-modules.sh`および`validate_module_yaml.py`を確認した結果：
- **サイズチェック機能は実装されていない**
- 現在はメタデータ（YAML）の構造検証のみ
- ファイルサイズやトークン数の検証は含まれていない

## 問題点と課題

### 1. サイズ基準の不統一
- ドキュメント間で推奨サイズが異なる（20-30% vs 30-40%）
- 実際のモジュールでは比率が1.25倍〜6.14倍と大きくばらつく
- 明確な上限・下限が定められていない

### 2. バリデーションの欠如
- 自動的なサイズチェックが実装されていない
- 過大なモジュール（1,000行超）の検出ができない
- トークン数での管理がされていない

### 3. ドキュメントの分散
モジュールに関するドキュメントが複数の場所に分散：
- `/docs/developers/best-practices/module-creation.md`
- `/docs/proposals/modular_token_reduction.md`
- `/modular/README.md`
- `/modular/DEVELOPMENT.md`
- 各モジュールディレクトリ内の散在するドキュメント

## 推奨される改善案

### 1. 明確なサイズ基準の策定
```yaml
モジュールサイズ基準:
  簡潔版:
    推奨: 50-200行
    最大: 300行
    トークン数: 1,000-4,000
  
  詳細版:
    推奨: 200-600行
    最大: 800行
    トークン数: 4,000-16,000
    
  比率:
    推奨: 詳細版は簡潔版の2.5-4.0倍
    最大: 5倍まで
```

### 2. バリデーション機能の追加
- `validate-modules.sh`にサイズチェック機能を追加
- 行数とトークン数の両方をチェック
- 基準を超えた場合は警告またはエラーを出力

### 3. ドキュメントの統合
- モジュール開発ガイドラインを一箇所に集約
- サイズ基準、命名規則、品質基準を統一的に記載
- 実装例とアンチパターンを明示

### 4. 既存モジュールの見直し
特に大きなモジュールの分割や簡潔化：
- machine_learning_detailed.md（1,093行）
- parallel_distributed_detailed.md（815行）
- research_methodology_detailed.md（760行）

## 次のステップ

1. この調査報告書をGitHub Issueとして登録
2. モジュールドキュメントの統合計画を作成
3. バリデーション機能の実装仕様を検討
4. 既存の大規模モジュールのリファクタリング計画を立案

## 参考資料

- 調査対象ディレクトリ: `/instructions/ai_instruction_kits/modular/ja/modules/`
- 分析対象モジュール数: 簡潔版64個、詳細版41個
- 使用ツール: wc、grep、sort、Pythonスクリプト