# ピッチデッキ作成モジュール

## タスクの概要

投資家向けの説得力あるピッチデッキを作成し、資金調達の成功確率を最大化します。

## ピッチデッキの構成

### 1. タイトルスライド

- **会社名**: {{company_name}}
- **タグライン**: {{tagline}}
- **発表者情報**: {{presenter_info}}
- **日付と場所**

### 2. 問題提起

#### 顧客の痛み
{{#customer_pain_points}}
- {{customer_pain_points}}
{{/customer_pain_points}}

#### 問題の定量化
- 市場規模における影響
- 現状の解決策の限界
- なぜ今解決すべきか

### 3. ソリューション

#### 提供する価値
{{#value_proposition}}
- {{value_proposition}}
{{/value_proposition}}

#### 差別化要因
- 独自の技術・手法
- 実現可能性の根拠
- 顧客への具体的なベネフィット

### 4. 市場機会

#### TAM（Total Addressable Market）
{{#tam_size}}
- **総市場規模**: {{tam_size}}
{{/tam_size}}

#### SAM（Serviceable Available Market）
{{#sam_size}}
- **獲得可能市場**: {{sam_size}}
{{/sam_size}}

#### SOM（Serviceable Obtainable Market）
{{#som_target}}
- **現実的な目標市場**: {{som_target}}
{{/som_target}}

### 5. プロダクト/サービス詳細

#### デモンストレーション
- 主要機能の実演
- ユーザー体験の流れ
- 技術的な優位性

#### 開発ロードマップ
{{#product_roadmap}}
- {{product_roadmap}}
{{/product_roadmap}}

### 6. ビジネスモデル

#### 収益構造
{{#revenue_model}}
- **収益モデル**: {{revenue_model}}
{{/revenue_model}}

#### 価格戦略
- ターゲット顧客別の価格設定
- LTV（顧客生涯価値）の想定
- CAC（顧客獲得コスト）との関係

### 7. 競合分析

#### 競合マトリクス
- 主要競合他社の特定
- 差別化ポイントの明確化
- ポジショニングマップ

#### 競争優位性
{{#competitive_advantages}}
- {{competitive_advantages}}
{{/competitive_advantages}}

### 8. Go-to-Market戦略

#### 市場参入計画
{{#gtm_strategy}}
- {{gtm_strategy}}
{{/gtm_strategy}}

#### 成長戦略
- 初期顧客獲得方法
- スケーリング計画
- パートナーシップ戦略

### 9. チーム紹介

#### 創業チーム
{{#founding_team}}
- {{founding_team}}
{{/founding_team}}

#### アドバイザー・投資家
{{#advisors}}
- {{advisors}}
{{/advisors}}

### 10. トラクション

#### 実績指標
{{#traction_metrics}}
- {{traction_metrics}}
{{/traction_metrics}}

#### 顧客の声
- 導入事例
- 推薦の言葉
- メディア掲載

### 11. 財務計画

#### 収支予測
{{#financial_projections}}
- {{financial_projections}}
{{/financial_projections}}

#### ユニットエコノミクス
- 主要KPIの推移
- 損益分岐点の見通し
- キャッシュフロー計画

### 12. 資金調達の詳細

#### 調達額と使途
{{#funding_ask}}
- **調達希望額**: {{funding_ask}}
{{/funding_ask}}
{{#use_of_funds}}
- **資金使途**: {{use_of_funds}}
{{/use_of_funds}}

#### マイルストーン
- 18ヶ月の達成目標
- 次回調達までのKPI
- Exit戦略の概要

## オーディエンス別カスタマイズ

### VC向け
{{#target_audience == "VC"}}
- スケーラビリティの強調
- 大きな市場機会の提示
- 明確なExit戦略
- 競合優位性の技術的根拠
{{/target_audience}}

### エンジェル投資家向け
{{#target_audience == "Angel"}}
- 創業者の情熱とビジョン
- 初期トラクションの具体例
- チームの実行力
- 社会的インパクト
{{/target_audience}}

### 事業会社向け
{{#target_audience == "Corporate"}}
- シナジー効果の明確化
- 既存事業への貢献
- 技術統合の可能性
- 戦略的パートナーシップ
{{/target_audience}}

## デザインとストーリーテリング

### ビジュアルデザイン原則
- **シンプルさ**: 1スライド1メッセージ
- **一貫性**: ブランドカラーとフォント
- **視覚的階層**: 重要情報の強調
- **データの可視化**: グラフとチャート

### ストーリーアーク
1. **フック**: 聴衆の注意を引く
2. **問題提起**: 共感を生む
3. **解決策**: 希望を与える
4. **証拠**: 信頼を築く
5. **ビジョン**: 未来を描く
6. **行動喚起**: 投資を促す

## よくある投資家の質問への準備

### ビジネスモデル関連
- ユニットエコノミクスの詳細
- 価格設定の根拠
- 顧客獲得コストの削減戦略

### 市場関連
- 市場規模の算出根拠
- 競合他社の動向分析
- 規制リスクと対策

### チーム関連
- 創業者間の株式配分
- キーパーソンの採用計画
- アドバイザーの関与度

### 技術関連
{{#tech_questions}}
- {{tech_questions}}
{{/tech_questions}}

## プレゼンテーションのコツ

### 事前準備
- ピッチの練習（10回以上）
- Q&Aセッションのシミュレーション
- 技術的なバックアップ準備

### 当日の実行
- 時間管理（通常10-15分）
- アイコンタクトとボディランゲージ
- 情熱的かつ論理的な説明
- 質問への誠実な対応

### フォローアップ
- 追加資料の迅速な提供
- 定期的な進捗報告
- 投資家との関係構築

---