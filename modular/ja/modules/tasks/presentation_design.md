# プレゼンテーションデザインタスクモジュール（簡潔版）

## コア概念
視覚的に魅力的でメッセージが明確に伝わるプロフェッショナルなプレゼンテーション設計。目的とオーディエンスに最適化。

## プレゼンタイプ別構成

### 主要プレゼン形式
| タイプ | 構成 | 重点 |
|------|------|------|
| **セールス** | 課題→ソリューション→価値→CTA | ROIとベネフィット |
| **カンファレンス** | フック→背景→洞察→応用→展望 | 新知見と実践性 |
| **役員会** | サマリー→現状→提案→リスク→リソース→成果 | 結論先行、データ中心 |

## ビジュアルデザイン原則

### 視覚的階層の確立
```yaml
フォントサイズ:
  - 主見出し: 36-44pt
  - 副見出し: 28-32pt
  - 本文: 24-28pt（最小24pt）

色彩設計:
  - 主要色: 1-2色（ブランドカラー）
  - アクセント色: 1色
  - コントラスト比: WCAG AA以上（4.5:1）

レイアウト:
  - グリッドシステム
  - 余白の戦略的活用
  - 整列の統一
```

### スライドデザインベストプラクティス
| 原則 | 実践方法 |
|------|----------|
| **1スライド1メッセージ** | 各スライドの核心明確化 |
| **ビジュアル優先** | テキストより図解重視 |
| **読みやすさ** | 十分なコントラスト、適切な行間 |

## データビジュアライゼーション

### チャート選択ガイド
| 目的 | 適切なチャート | 使用上の注意 |
|------|----------------|-------------|
| **比較** | 棒グラフ、レーダーチャート | カテゴリ間の差異明確化 |
| **トレンド** | 折れ線グラフ、面グラフ | 時系列変化の強調 |
| **構成** | 円グラフ（5項目以下）、ツリーマップ | 全体に対する割合 |
| **相関** | 散布図、バブルチャート | 2-3変数の関係性 |

### データ表示原則
- データインクレシオ最大化
- 不要なグリッド線削除
- 直接ラベリング
- 色覚多様性への配慮

## アニメーションとトランジション

### 効果的な使用方法
```yaml
目的あるアニメーション:
  - 情報の段階的開示
  - 注目点の誘導
  - プロセスの可視化

控えめなトランジション:
  - フェード: 最も自然
  - スライド: 方向性を示す
  - ズーム: 詳細への注目

避けるべき効果:
  - 過度な回転・バウンス
  - ランダムなトランジション
  - 音声効果の過剰使用
```

## スピーカーノート

### 効果的なノート構成
| 要素 | 内容 |
|------|------|
| **キーポイント** | 各スライドの核心メッセージ |
| **タイミング指示** | セクション所要時間、インタラクション |
| **バックアップ情報** | 想定質問と回答、追加データ |

## アクセシビリティ対応

### 標準的対策
```yaml
視覚的配慮:
  - コントラスト比AA基準以上
  - 色だけに依存しない情報伝達
  - 読みやすいフォントサイズ
  - 代替テキスト提供

聴覚的配慮:
  - 音声コンテンツの字幕
  - 視覚的合図の併用
  - 事前資料配布

認知的配慮:
  - 明確な構造
  - 平易な言葉
  - 要約とまとめ
```

## 配布資料の準備

### 形式別最適化
| 形式 | 設定 | 用途 |
|------|------|------|
| **印刷用** | 3スライド/ページ、メモ欄、モノクロ | ハンドアウト |
| **デジタル** | PDF保護、ファイル最適化、リンク確認 | オンライン共有 |

## チェックリスト

### プレゼンテーション完成度
- [ ] 目的とオーディエンス分析
- [ ] 適切な構成フレームワーク選択
- [ ] ビジュアルデザイン統一
- [ ] データの効果的可視化
- [ ] アクセシビリティ対応
- [ ] スピーカーノート作成
- [ ] 配布資料準備
- [ ] 技術的動作確認

---
**モジュール作成日**: 2025-01-21
**カテゴリ**: tasks/presentation_design
**バージョン**: 1.0.0-concise