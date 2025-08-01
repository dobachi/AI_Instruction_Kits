# ブレインストーミングスキルモジュール

## ブレインストーミングの実施

### 基本原則

1. **判断の保留**
   - 批判や評価は後回し
   - 全てのアイデアを歓迎
   - 実現可能性は考えない

2. **量を重視**
   - できるだけ多くのアイデア
   - 質より量を優先
   - 連想を広げる

3. **相乗効果**
   - 他者のアイデアに便乗
   - 組み合わせと発展
   - 協調的な雰囲気

### 選択された手法

{{#if (eq technique "classic")}}
#### クラシック・ブレインストーミング
- **自由発想**: 制約なしでアイデアを出す
- **ルール**: 批判厳禁、量重視、便乗歓迎、自由奔放
- **進行**: ファシリテーターが記録しながら進行
{{/if}}

{{#if (eq technique "mindmap")}}
#### マインドマップ法
- **中心テーマ**: 中央に主題を配置
- **放射状展開**: 関連アイデアを枝分かれ
- **視覚的整理**: 色やイメージを活用
- **階層構造**: 主要概念から詳細へ
{{/if}}

{{#if (eq technique "scamper")}}
#### SCAMPER法
- **S** (Substitute): 置き換える
- **C** (Combine): 組み合わせる
- **A** (Adapt): 適応させる
- **M** (Modify/Magnify): 修正・拡大する
- **P** (Put to other uses): 他の用途に使う
- **E** (Eliminate): 取り除く
- **R** (Reverse/Rearrange): 逆転・再配置する
{{/if}}

{{#if (eq technique "635")}}
#### 6-3-5法
- **参加者**: 6名
- **アイデア数**: 各自3つずつ
- **ラウンド数**: 5回転
- **手順**: 紙を回して他者のアイデアを発展
{{/if}}

{{#if (eq technique "reverse")}}
#### 逆ブレインストーミング
- **問題の逆転**: 「どうすれば失敗するか」を考える
- **否定的発想**: 最悪のシナリオを列挙
- **解決策への転換**: 逆の発想から正解を導く
{{/if}}

{{#if (eq technique "brainwriting")}}
#### ブレインライティング
- **無言の発想**: 話さずに書く
- **同時進行**: 全員が同時にアイデア記入
- **内向的配慮**: 発言が苦手な人も参加しやすい
{{/if}}

{{#if (eq technique "async_brainstorming")}}
#### 非同期ブレインストーミング
- **時間の自由度**: 参加者が自分のペースで貢献
- **深い思考**: 熟考時間を確保
- **グローバル対応**: タイムゾーンの違いを克服
- **デジタルプラットフォーム**: Miro、Mural、Conceptboard等を活用
{{/if}}

{{#if (eq technique "hybrid_session")}}
#### ハイブリッドセッション
- **対面＋オンライン**: 物理的参加者とリモート参加者の融合
- **技術統合**: デジタルホワイトボードと物理ボードの連携
- **参加の平等性**: 両環境での発言機会の確保
- **記録の一元化**: リアルタイム共有システム
{{/if}}

{{#if (eq technique "ai_assisted")}}
#### AI支援ブレインストーミング
- **アイデア増幅**: AIによる関連概念の提案
- **バイアス軽減**: 多様な視点の自動提示
- **パターン分析**: 既存アイデアの関連性発見
- **創発支援**: 意外な組み合わせの提案
{{/if}}

{{#if (eq technique "question_storming")}}
#### クエスチョンストーミング
- **問いかけ重視**: 答えではなく質問を生成
- **前提の検証**: 当たり前を疑う
- **視点の拡張**: 多角的な問題設定
- **深堀り促進**: 「なぜ？」を5回繰り返す
{{/if}}

### 参加規模への対応

{{#if (eq group_size "individual")}}
#### 個人でのブレインストーミング
- セルフファシリテーション
- タイマーを使った時間管理
- 記録ツールの活用（ノート、アプリ等）
{{/if}}

{{#if (eq group_size "small")}}
#### 小グループ（2-6名）
- 全員参加の促進
- アイディアの深掘り可能
- 親密な雰囲気づくり
{{/if}}

{{#if (eq group_size "large")}}
#### 大グループ（7名以上）
- サブグループへの分割検討
- 発言機会の公平な配分
- 効率的な記録システム
{{/if}}

### タイムマネジメント

**セッション時間**: {{time_limit}}

#### 時間配分の目安
1. **導入とルール説明**: 10%
2. **アイデア生成**: 60%
3. **整理と分類**: 20%
4. **次のステップ確認**: 10%

### アイデアの評価

**評価方法**: {{evaluation_method}}

#### 研究に基づく評価手法

1. **実現可能性スコアリング**
   - 技術的実現性（1-5点）
   - 経済的実現性（1-5点）
   - 時間的実現性（1-5点）
   - 組織的実現性（1-5点）

2. **イノベーション指数**
   - 新規性レベル（増分的/急進的/破壊的）
   - 市場インパクト予測
   - 競合優位性
   - スケーラビリティ

3. **多次元評価マトリクス**
   - X軸: 実現可能性
   - Y軸: インパクト
   - Z軸: 新規性
   - バブルサイズ: リソース要件

4. **効果測定指標**
   - **量的指標**: アイデア数、参加率、実装率
   - **質的指標**: 独創性スコア、実用性評価
   - **プロセス指標**: 参加満足度、心理的安全性レベル
   - **成果指標**: 実装成功率、ROI

#### 評価の観点
- 実現可能性（技術・経済・時間・組織）
- 影響力・インパクト（市場・社会・組織）
- 新規性・独創性（増分・急進・破壊的）
- リソース要件（人・金・時間・技術）
- 実装の容易さ（複雑度・依存関係）
- 戦略適合性（ビジョン・目標・価値観）

## ファシリテーションのコツ

### 雰囲気づくり
1. **心理的安全性の確保**
   - 失敗を恐れない環境
   - 全員の貢献を認める
   - ポジティブな反応
   - 実験的思考の奨励
   - 判断の明確な分離（創造フェーズと評価フェーズ）

2. **神経多様性への配慮**
   - **注意特性**: ADHD特性者向けの構造化とタイマー活用
   - **情報処理**: 自閉症スペクトラム特性者向けの事前情報提供
   - **表現方法**: 視覚的、言語的、身体的な多様な表現手段
   - **参加スタイル**: 発言型と観察・記録型の両方を尊重

3. **文化的多様性への配慮**
   - **コミュニケーションスタイル**: 直接的・間接的表現の両方を歓迎
   - **階層意識**: フラットな参加を促す仕組み
   - **時間感覚**: 異なる時間認識への配慮
   - **集団行動**: 個人主義と集団主義の調和

4. **エネルギー管理**
   - 適度な休憩（90分ごとの休憩推奨）
   - 行き詰まったら手法を変更
   - 音楽や環境の工夫
   - 身体的な動きの導入

### 記録と整理
1. **可視化**
   - ホワイトボード活用
   - 付箋の色分け
   - デジタルツールの併用

2. **デジタルツール統合**
   - **Miro**: 無限キャンバスでの視覚的整理
   - **Mural**: テンプレート豊富な協働プラットフォーム
   - **Conceptboard**: リアルタイム共有ボード
   - **FigJam**: デザイン思考支援ツール
   - **Stormboard**: 構造化されたアイデア管理

3. **バイアス軽減手法**
   - **匿名化**: アイデアの出所を隠して評価
   - **多様性チェック**: 参加者の背景・視点の確認
   - **悪魔の代弁者**: 意図的な反対意見の導入
   - **ローテーション**: ファシリテーター役の交代

4. **構造化**
   - カテゴリー分類
   - 関連性の明示
   - 優先順位の可視化
   - 実装時系列の整理

### トラブルシューティング

#### 一般的な問題
- **沈黙が続く場合**: 具体例を提示、視点を変える質問、1分間の個人思考時間
- **特定の人が独占**: タイムキーパー設定、順番制導入、ラウンドロビン形式
- **批判的な発言**: ルールの再確認、建設的な表現への言い換え

#### 神経多様性関連の配慮
- **感覚過敏**: 照明・音量調整、静寂空間の提供
- **注意の散漫**: 明確な構造、視覚的手がかり、タイマー活用
- **情報処理の違い**: 事前資料提供、処理時間の確保
- **表現の困難**: 代替的表現手段（描画、モデル作成等）

#### 文化的バリアの解決
- **言語の壁**: 視覚的表現の活用、通訳・翻訳支援
- **階層意識**: 匿名投稿、役職を意識しないルール設定
- **発言スタイル**: 書面と口頭の選択肢提供
- **時間認識**: 柔軟なスケジューリング、文化的背景の説明

#### 研究に基づくベストプラクティス
- **多様性効果**: 異なる背景・専門性の参加者を意図的に混合
- **認知的多様性**: 思考スタイル・問題解決アプローチの多様化
- **準備フェーズ**: 事前の個人ブレインストーミング（15-20分）
- **温め効果**: 難しい問題は一度寝かせてから再検討

## アウトプット例

```
【テーマ】: 新しいモバイルアプリのアイデア

【生成されたアイデア】:
1. 睡眠の質を音で改善するアプリ
2. ペットと飼い主のマッチングアプリ
3. 地域の困りごと解決プラットフォーム
...

【評価結果】:
優先度1: アイデア#3（実現可能性: 高、インパクト: 大）
優先度2: アイデア#1（新規性: 高、市場性: 中）
...
```

## 次のステップ

1. 選出されたアイデアの詳細化
2. プロトタイプやモックアップの作成
3. 実現可能性の詳細検証
4. 実装計画の策定