# 学術論文執筆支援モジュール拡張 実装計画書

## 概要
本文書は、Issue #25で提案された学術論文執筆支援モジュールの詳細な実装計画を記述します。2025年1月に実施したexpertiseモジュール作成のベストプラクティスを反映しています。

## 調査計画

### 並列調査戦略
```yaml
並列調査の実装:
  ツール: Task（Agentツール）
  同時実行数: 5分野
  
  対象分野:
    1. academic_writing: 学術文章作成の最新動向
    2. citation_management: 引用管理ツールと形式の更新
    3. literature_review: システマティックレビュー手法
    4. thesis_writing: 論文構成の国際標準
    5. research_methodology: 研究方法論の最新トレンド
  
  調査焦点:
    - 2024-2025年の動向
    - 実践的なツールとテクニック
    - 分野横断的なベストプラクティス
    - AI活用の倫理的ガイドライン
```

### 情報源の優先順位
```yaml
情報源ランキング:
  Tier 1 - 最優先:
    - 学術出版社ガイドライン（Elsevier、Springer、IEEE）
    - 大学の学術執筆センター資料
    - APA、MLA等の公式スタイルガイド最新版
    
  Tier 2 - 重要:
    - 査読付き論文（Research Writing、Academic Writingジャーナル）
    - 研究方法論の教科書（2024年版）
    - 文献管理ツール公式ドキュメント
    
  Tier 3 - 参考:
    - 研究者コミュニティのブログ
    - 学術会議のワークショップ資料
    - オンラインコースの教材
```

## モジュール設計詳細（ベストプラクティス適用）

### 1. expertise/academic_writing（学術文章作成専門知識）

#### 階層的な情報整理
```yaml
構造:
  レベル1 - 概要:
    - 学術文章の定義と特徴
    - 他の文章形式との差別化
    
  レベル2 - 基本原則:
    - 客観性・中立性・精密性
    - 論理的構造の構築
    
  レベル3 - 実装技術:
    - パラグラフ構成テクニック
    - 移行表現の効果的使用
    - 専門用語の適切な導入
    
  レベル4 - 応用:
    - 分野別文体ガイド
    - 査読者を意識した執筆
    - リビジョンテクニック
    
  レベル5 - 将来展望:
    - AI執筆支援の倫理的使用
    - 多言語論文執筆
```

#### 実用的な変数設計
```yaml
variables:
  - name: academic_field
    description: "学術分野"
    type: enum
    values: 
      - humanities          # 人文科学
      - social_sciences    # 社会科学
      - natural_sciences   # 自然科学
      - engineering        # 工学
      - computer_science   # コンピュータサイエンス
      - interdisciplinary  # 学際的
    default: computer_science
  
  - name: formality_level
    description: "文体の形式度"
    type: enum
    values:
      - highly_formal      # 最も形式的
      - formal            # 標準的な学術文体
      - semi_formal       # やや柔軟
    default: formal
  
  - name: target_publication
    description: "投稿先タイプ"
    type: enum
    values:
      - top_tier_journal   # トップジャーナル
      - standard_journal   # 一般的なジャーナル
      - conference        # 国際会議
      - workshop          # ワークショップ
      - thesis            # 学位論文
    default: standard_journal
```

### 2. skills/citation_management（引用管理スキル）

#### コード例の効果的な提示
```python
# 実装可能な引用管理クラスの例
class CitationManager:
    def __init__(self, style='APA', version='7th'):
        self.style = style
        self.version = version
        self.citations = []
        self.bibliography = []
        
    def add_citation(self, citation_data):
        """引用を追加し、形式を検証"""
        try:
            validated = self._validate_citation(citation_data)
            formatted = self._format_citation(validated)
            self.citations.append(formatted)
            return formatted
        except ValidationError as e:
            logger.error(f"Citation validation failed: {e}")
            raise
    
    def _validate_citation(self, data):
        """必須フィールドの確認"""
        required_fields = {
            'journal': ['author', 'year', 'title', 'journal', 'volume'],
            'book': ['author', 'year', 'title', 'publisher'],
            'conference': ['author', 'year', 'title', 'conference', 'pages']
        }
        
        pub_type = data.get('type', 'journal')
        for field in required_fields.get(pub_type, []):
            if field not in data:
                raise ValidationError(f"Missing required field: {field}")
        
        return data
    
    def generate_bibliography(self, sort_by='author'):
        """参考文献リストを生成"""
        sorted_citations = sorted(self.citations, key=lambda x: x[sort_by])
        return self._format_bibliography(sorted_citations)
```

### 3. skills/literature_review（文献レビュースキル）

#### 実践的な検索戦略テンプレート
```yaml
systematic_search_template:
  databases:
    - Google Scholar
    - IEEE Xplore
    - ACM Digital Library
    - PubMed (if applicable)
    - Scopus
    
  search_string_construction:
    primary_terms: ["data space", "data ecosystem"]
    secondary_terms: ["interoperability", "sovereignty", "governance"]
    operators: 
      - AND: 概念の組み合わせ
      - OR: 同義語の包含
      - NOT: 除外条件
    
  example_query: |
    ("data space" OR "data ecosystem") 
    AND (interoperability OR sovereignty) 
    AND (GAIA-X OR IDS OR "Ouranos Ecosystem")
    NOT review
    
  filters:
    - publication_year: 2020-2025
    - document_type: [article, conference_paper]
    - language: [english, japanese]
```

### 4. tasks/thesis_writing（論文執筆タスク）

#### IMRADフォーマットの詳細実装
```markdown
## Introduction セクションテンプレート
1. **背景（Background）** - 1-2段落
   - 研究分野の重要性
   - 現在の課題や問題点
   
2. **関連研究（Related Work）** - 2-3段落
   - 既存研究の概要
   - 未解決の問題
   
3. **研究ギャップ（Research Gap）** - 1段落
   - 既存研究の限界
   - 本研究の必要性
   
4. **研究目的と貢献（Objectives and Contributions）** - 1-2段落
   - 明確な研究質問
   - 期待される貢献（箇条書き）
   
5. **論文構成（Paper Organization）** - 1段落
   - 各セクションの概要
```

### 5. methods/research_methodology（研究方法論）

#### 研究デザインマトリックス
```yaml
research_design_matrix:
  quantitative:
    experimental:
      data_collection: [controlled_experiment, A/B_testing]
      analysis: [t-test, ANOVA, regression]
      sample_size: "統計的検定力分析で決定"
      
    survey:
      data_collection: [questionnaire, structured_interview]
      analysis: [descriptive_stats, factor_analysis]
      sample_size: "母集団の5-10%"
      
  qualitative:
    case_study:
      data_collection: [interview, observation, documents]
      analysis: [thematic_analysis, grounded_theory]
      sample_size: "理論的飽和まで"
      
    ethnography:
      data_collection: [participant_observation, field_notes]
      analysis: [narrative_analysis, discourse_analysis]
      sample_size: "深い洞察が得られるまで"
      
  mixed_methods:
    sequential:
      approach: "QUAL → QUAN または QUAN → QUAL"
      integration: "結果の統合段階で実施"
```

## 実装スケジュール（ベストプラクティス適用）

### Phase 0: 調査と準備（3日間）
```yaml
Day 1: 並列調査の実施
  - 5分野同時調査（Taskツール使用）
  - 情報源の評価と整理
  
Day 2: 調査結果の体系化
  - 参考資料ファイルの作成
  - 共通パターンの抽出
  
Day 3: テンプレートと変数設計
  - 統一テンプレートの作成
  - 変数体系の設計
```

### Phase 1: 並列モジュール作成（1週間）
```yaml
Week 1: 全モジュール同時作成
  Day 1-2: 基本構造の実装
    - 5モジュール並列作成
    - 相互参照の即座反映
    
  Day 3-4: コンテンツの充実
    - 具体例の追加
    - コード例の実装
    
  Day 5: 横断的な調整
    - 用語の統一
    - 依存関係の確認
    
  Day 6-7: 品質チェック
    - セルフレビュー実施
    - 相互運用性テスト
```

### Phase 2: 統合とテスト（4日間）
```yaml
Day 1-2: プリセット更新
  - academic_researcherプリセットへの統合
  - 新規変数の追加
  
Day 3: 統合テスト
  - データスペース論文執筆シナリオ
  - エンドツーエンドテスト
  
Day 4: ドキュメント作成
  - 使用ガイドの作成
  - サンプルの準備
```

## 品質保証チェックリスト

### 構造の一貫性
- [ ] 全モジュール同じセクション構成
- [ ] 見出しレベルの統一（最大3レベル）
- [ ] 説明の粒度の均一化

### 内容の充実度
- [ ] 理論と実践のバランス（3:7）
- [ ] 具体例3つ以上/モジュール
- [ ] 2024-2025年情報80%以上

### 実装の具体性
- [ ] コピー&ペーストで動作するコード
- [ ] エラーハンドリング含む
- [ ] 本番環境での使用想定

### 相互運用性
- [ ] 他モジュールとの連携明示
- [ ] 依存関係の正確な記述
- [ ] 共通用語集の使用

## リスク管理（ベストプラクティス反映）

### 並列作成のリスク
- **リスク**: 一貫性の欠如
- **対策**: リアルタイム調整、共通テンプレート使用

### 最新性の維持
- **リスク**: 情報の陳腐化
- **対策**: 6ヶ月ごとの定期レビュー

### 分野特異性
- **リスク**: 過度の一般化
- **対策**: 分野別サブモジュールの準備

## 成果物と成功指標

### 成果物
- 5つの新規モジュール（日英各10ファイル）
- 更新されたacademic_researcherプリセット
- 実装ガイドとサンプル集

### 成功指標
- 並列作成による時間削減: 75%以上
- 品質チェックリスト達成率: 95%以上
- クロスレファレンス数: 20以上
- ユーザビリティスコア: 4.5/5.0