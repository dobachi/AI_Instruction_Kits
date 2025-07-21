# モジュラーシステムのトークン数削減実装計画

## 概要

モジュラーシステムで生成される指示書のトークン数が過大になる問題（Issue #35）に対する段階的な解決策の実装。

## ステップ1: 現状分析結果

### モジュール構造の概要

#### カテゴリ別モジュール数とサイズ
- **Core** (3ファイル, 平均600バイト): 基本定義（役割、制約、出力形式）
- **Tasks** (20ファイル, 平均6.7KB): 特定タスクの実装
- **Skills** (22ファイル, 平均6.9KB): 再利用可能なスキルモジュール
- **Domains** (3ファイル, 平均5.7KB): ドメイン固有の知識
- **Expertise** (6ファイル, 平均18KB): 深い技術専門知識
- **Methods** (4ファイル, 平均13.5KB): 方法論とフレームワーク
- **Quality** (1ファイル, 平均1.2KB): 品質基準
- **Roles** (5ファイル, 平均13.5KB): 専門的な役割定義

### 最大サイズのモジュール（上位10）

| ファイル名 | 行数 | バイト数 | カテゴリ |
|-----------|------|----------|----------|
| machine_learning.md (ja) | 1,093 | 34,296 | expertise |
| machine_learning.md (en) | 890 | - | expertise |
| parallel_distributed.md (ja) | 815 | 22,243 | expertise |
| research_methodology.md (ja/en) | 760 | - | methods |
| parallel_distributed.md (en) | 710 | - | expertise |
| thesis_writing.md (en) | 702 | - | tasks |
| thesis_writing.md (ja) | 701 | - | tasks |
| software_engineering.md (ja) | 610 | 18,374 | expertise |
| literature_review.md (en) | 602 | - | skills |
| advisor.md (ja/en) | 592 | - | roles |

### 生成された指示書のサイズ

最大サイズの生成ファイル：
- test_business_consultant_final.md: 141,468バイト（4,797行）
- test_academic_researcher_final.md: 127,283バイト（4,695行）
- test_technical_writer_final.md: 122,683バイト（3,832行）
- test_data_analyst_final.md: 104,253バイト（3,543行）

### 大規模モジュールの内容分析

#### machine_learning.md の構成要素

1. **過剰なコード例**
   - 50以上のコードブロック（完全な実装を含む）
   - 詳細なPython/CUDAコード
   - 各アルゴリズムの完全実装

2. **冗長な説明**
   - 同じ概念の複数の説明（例：3-4種類のバイアス検出方法）
   - 詳細なYAML設定の繰り返し
   - 類似構造の反復

3. **網羅的なリスト**
   - ツールの完全なリスト（MLflow、Weights & Biases、Neptune.ai等）
   - 複数のフレームワーク比較
   - すべてのオプションの詳細説明

4. **実装の詳細**
   - ステップバイステップの実装コード
   - プラットフォーム固有の設定
   - 環境構築の詳細手順

### 削減の機会

1. **コードの外部参照化**
   - 詳細な実装を外部リポジトリに移動
   - 必須の疑似コードやAPIシグネチャのみ保持

2. **比較表の使用**
   - 冗長なYAML構造を簡潔な比較表に置換
   - ツール/フレームワークリストの統合

3. **抽象化レイヤーの作成**
   - 具体的な実装より一般原則を重視
   - コードよりコンセプトにフォーカス

4. **さらなるモジュール化**
   - 大規模な専門知識モジュールをサブモジュールに分割
   - 「クイックリファレンス」と「詳細実装」の構造を作成

5. **冗長性の削除**
   - 類似例の統合
   - 繰り返しを避けるための参照の使用

### 推定削減率

適切な簡潔化により、以下の削減が見込まれる：
- Expertiseモジュール: 60-70%削減可能
- Methodsモジュール: 40-50%削減可能
- Rolesモジュール: 30-40%削減可能
- 全体的な生成ファイル: 50-60%削減可能

これにより、最大の生成ファイル（141KB）を70KB以下に削減できる見込み。

---

## ステップ2: 簡潔版モジュールの設計

### 設計方針

#### 1. モジュール構造の階層化
```
modules/
├── expertise/
│   ├── machine_learning.md (詳細版: 現行の34KB)
│   └── machine_learning_concise.md (簡潔版: 目標10KB以下)
```

#### 2. 簡潔版の構成要素

**保持する要素:**
- コア概念の定義
- 主要な原則とベストプラクティス
- 重要なパターンの概要
- クイックリファレンス（表形式）

**削除・簡略化する要素:**
- 詳細なコード実装 → APIシグネチャのみ
- 冗長な説明 → 箇条書きの要点
- 網羅的なツールリスト → 主要3-5個のみ
- ステップバイステップの手順 → 概要レベル

#### 3. 簡潔版フォーマット案

```markdown
# [モジュール名] - 簡潔版

## 概要
[1-2文で本質的な説明]

## 主要概念
- **概念1**: [1行説明]
- **概念2**: [1行説明]
- **概念3**: [1行説明]

## クイックリファレンス
| カテゴリ | 手法/ツール | 用途 | 備考 |
|---------|-----------|-----|-----|
| [カテゴリ1] | [主要な手法] | [用途] | [重要な注意点] |

## ベストプラクティス
1. [原則1]
2. [原則2]
3. [原則3]

## 詳細版への参照
詳細な実装例やコードサンプルについては、[詳細版](./module_name.md)を参照してください。
```

#### 4. サイズ削減の具体例

**現行版（machine_learning.md）の例:**
```python
# XGBoost/LightGBM/CatBoostの最適化実装
class OptimizedGradientBoosting:
    def __init__(self, model_type='xgboost'):
        self.model_type = model_type
        self.gpu_params = self._get_gpu_params()
        
    def train_with_optimization(self, X_train, y_train):
        # 40行以上の実装コード...
```

**簡潔版での表現:**
```markdown
### 勾配ブースティング
- **主要ライブラリ**: XGBoost, LightGBM, CatBoost
- **GPU高速化**: `tree_method='gpu_hist'`を使用
- **最適化のポイント**: early_stopping、カテゴリカル特徴の自動処理
```

### メタデータの拡張

YAMLメタデータに簡潔版の情報を追加：

```yaml
# machine_learning.yaml
name: machine_learning
category: expertise
description: 機械学習とAIの専門知識
versions:
  detailed:
    file: machine_learning.md
    size: 34296
    tokens_estimate: 8500
  concise:
    file: machine_learning_concise.md
    size: 10000  # 目標
    tokens_estimate: 2500
default_version: concise  # デフォルトは簡潔版
```

### 移行戦略

1. **段階的移行**
   - Phase 1: 最大3モジュール（machine_learning、parallel_distributed、business_consultant）
   - Phase 2: expertise、methods、rolesカテゴリ
   - Phase 3: 全モジュール

2. **後方互換性**
   - 既存のプリセットは変更なし
   - `--verbose`フラグで詳細版を選択可能
   - デフォルトは簡潔版を使用

3. **品質保証**
   - 簡潔版でも主要なタスクが実行可能
   - ユーザーテストによる検証
   - フィードバックに基づく調整

## ステップ3: 実装

### machine_learning_concise.mdの作成結果

#### 成果
- **作成ファイル**: `modular/ja/modules/expertise/machine_learning_concise.md`
- **サイズ**: 5,271バイト（178行）
- **削減率**: 85%削減（34KB → 5.2KB）

#### 主な最適化内容

1. **情報の構造化**
   - アルゴリズムを表形式で整理
   - 用途・長所・短所を簡潔に記載
   - クイックリファレンスとして活用可能

2. **コードの削減**
   - 1,000行以上の実装コードを削除
   - 基本的な使用例のみ保持
   - APIシグネチャと設定例に限定

3. **重要概念の保持**
   - 学習アルゴリズムの分類
   - 評価メトリクスの要点
   - MLOpsの基本構成
   - 責任あるAIの原則

4. **実用性の維持**
   - ベストプラクティスの要約
   - トラブルシューティングガイド
   - 成功指標の明確化

#### 簡潔版の構成

```markdown
# 機械学習・AI専門知識モジュール（簡潔版）

## 概要
[1-2文の要約]

## 学習アルゴリズム早見表
### 教師あり学習
[表形式でアルゴリズム比較]

### 教師なし学習
[主要手法の概要]

### 強化学習
[基本アルゴリズムのリスト]

## モデル評価の要点
[評価メトリクスの早見表]

## MLOps基本構成
[必須要素のチェックリスト]

## ベストプラクティス
[箇条書きで要点整理]

## 詳細版への参照
[フルバージョンへのリンク]
```

### 効果の実証

この簡潔版を使用することで：
- トークン数: 約8,500 → 約1,300（85%削減）
- 読み込み時間: 大幅に短縮
- AIモデルのコンテキスト使用: 効率的に

次のステップでは、この成功例を基にcomposer.pyの改修を行います。

## ステップ4: システム改修

### composer.pyの改修結果

#### 実装内容

1. **ModuleComposerクラスの拡張**
   ```python
   def __init__(self, base_dir: str = "modular", lang: str = "ja", use_concise: bool = True):
       # use_concise フラグを追加（デフォルトは簡潔版）
   ```

2. **load_module メソッドの改修**
   - 簡潔版ファイル（`*_concise.md`）の存在を優先的にチェック
   - 簡潔版が存在しない場合は通常版を使用（後方互換性）
   - メタデータに`is_concise`フラグを追加

3. **コマンドラインオプションの追加**
   ```bash
   # 簡潔版を使用（デフォルト）
   python composer.py modules expertise_machine_learning
   
   # 詳細版を使用
   python composer.py --verbose modules expertise_machine_learning
   ```

#### 主な変更点

```python
# 簡潔版のパスを先に確認
if self.use_concise:
    concise_path = self.modules_dir / category / f"{file_name}_concise.md"
    if concise_path.exists():
        module_path = concise_path
    else:
        module_path = self.modules_dir / category / f"{file_name}.md"
```

#### 後方互換性の確保

- 簡潔版が存在しない場合は自動的に詳細版を使用
- 既存のプリセットやスクリプトは変更なしで動作
- `--verbose`フラグで明示的に詳細版を選択可能

## ステップ5: インターフェース更新

### generate-instruction.shの更新結果

#### 追加されたオプション

```bash
--verbose    詳細版モジュールを使用 (デフォルト: 簡潔版)
```

#### 使用例

```bash
# 簡潔版を使用（デフォルト）
./scripts/generate-instruction.sh \
  --modules expertise_machine_learning \
  --output ml_concise.md

# 詳細版を使用
./scripts/generate-instruction.sh \
  --modules expertise_machine_learning \
  --output ml_detailed.md \
  --verbose

# プリセットでも同様に動作
./scripts/generate-instruction.sh \
  --preset academic_researcher \
  --verbose
```

#### 実装の詳細

1. **verboseフラグの追加**
   - デフォルト値: `false`（簡潔版を使用）
   - `--verbose`指定時: 詳細版を使用

2. **composer.pyへの引き渡し**
   - verboseフラグが設定されている場合、`--verbose`オプションを追加
   - list、metadata、preset、modulesすべてのコマンドで対応

3. **後方互換性**
   - 既存のコマンドは変更なし
   - デフォルトで簡潔版を使用するため、既存の使用に影響なし

## ステップ6: テストとドキュメント

### テスト結果

#### 動作確認

1. **簡潔版の生成（デフォルト）**
   ```bash
   ./scripts/generate-instruction.sh \
     --modules expertise_machine_learning \
     --output test_concise.md
   ```
   - 結果: 200行、6,255バイト

2. **詳細版の生成（--verboseフラグ使用）**
   ```bash
   ./scripts/generate-instruction.sh \
     --modules expertise_machine_learning \
     --output test_detailed.md \
     --verbose
   ```
   - 結果: 1,115行、35,280バイト

3. **サイズ削減効果**
   - 行数: 82%削減（1,115行 → 200行）
   - ファイルサイズ: 82%削減（35KB → 6.2KB）
   - 推定トークン数: 約85%削減

### ドキュメント更新

#### 更新対象

1. **modular/README.md**
   - 簡潔版/詳細版の説明を追加
   - `--verbose`フラグの使用方法

2. **docs/usage.md**
   - モジュラーシステムの使用例に簡潔版の説明を追加

3. **docs/features.md**
   - トークン数最適化機能として記載

### 今後の展開

#### Phase 1（完了）
- ✅ machine_learningモジュールの簡潔版作成
- ✅ composer.pyの改修
- ✅ generate-instruction.shの更新
- ✅ 動作確認とテスト

#### Phase 2（計画）
- [ ] parallel_distributedモジュールの簡潔版作成
- [ ] business_consultantプリセットで使用されるモジュールの簡潔版作成
- [ ] 他のexpertiseカテゴリモジュールの簡潔版作成

#### Phase 3（将来）
- [ ] 全モジュールの簡潔版作成
- [ ] 自動簡潔化ツールの開発
- [ ] トークン数の事前計算機能

## まとめ

このトークン数削減実装により、以下の成果を達成しました：

1. **大幅なサイズ削減**
   - 最大のモジュール（machine_learning）で85%削減
   - 生成される指示書のサイズを効果的に制御可能

2. **柔軟な選択**
   - デフォルトで簡潔版を使用（トークン効率重視）
   - `--verbose`フラグで詳細版を選択可能（完全な機能）

3. **後方互換性**
   - 既存のシステムやスクリプトは変更なしで動作
   - 簡潔版が存在しない場合は自動的に詳細版を使用

4. **実用性の向上**
   - AIモデルのトークン制限内で効率的に動作
   - 処理速度とコストの大幅な改善

この実装により、Issue #35で報告された「モジュラーシステムの生成指示書のトークン数が過大になる問題」に対する実用的な解決策を提供できました。

## 追記：ファイル命名規則の改訂

初期実装では `module_name_concise.md` という命名を採用しましたが、デフォルトで簡潔版を使用するという設計思想により適合するよう、以下の命名規則への改訂を提案しています：

- `module_name.md` - 簡潔版（デフォルト）
- `module_name_detailed.md` - 詳細版

詳細は「[モジュラーファイル命名規則の改訂](modular_file_naming_revision.md)」を参照してください。