# スクラムフレームワークモジュール（簡潔版）

## コア概念
スクラムガイド2020準拠の経験主義的フレームワーク。透明性・検査・適応の3本柱に基づき、プロダクトゴールへの価値提供を最大化。統一されたスクラムチームによる自己管理と継続的改善を実現。

## スクラムの価値観と原則

### 5つの価値観
| 価値観 | 実践内容 |
|--------|----------|
| **確約** | プロダクトゴール・スプリントゴールへの共同コミット |
| **勇気** | 困難な問題への挑戦、率直なフィードバック |
| **集中** | スプリントゴールへの一点集中、WIP制限 |
| **公開** | 作業状況の完全可視化、透明な意思決定 |
| **尊敬** | 多様性の尊重、心理的安全性の確保 |

## スクラムチームとアカウンタビリティ

### チーム構成（10人以下推奨）
| 役割 | アカウンタビリティ | 主要活動 |
|------|-------------------|----------|
| **プロダクトオーナー** | プロダクト価値最大化 | バックログ管理、優先順位付け、ステークホルダー調整 |
| **スクラムマスター** | スクラム効果性向上 | ファシリテーション、障害除去、組織変革推進 |
| **開発者** | 品質の高いインクリメント作成 | 自己管理、日々の計画、技術的決定 |

## スクラムイベント

### イベント構成
| イベント | タイムボックス | 目的 |
|----------|---------------|------|
| **スプリント** | 1-4週間 | 価値のあるインクリメント作成 |
| **スプリントプランニング** | スプリント×2時間 | WHY(ゴール)とWHAT/HOW(バックログ)決定 |
| **デイリースクラム** | 15分 | スプリントゴールへの進捗確認と計画調整 |
| **スプリントレビュー** | スプリント×1時間 | インクリメントデモとフィードバック収集 |
| **スプリントレトロスペクティブ** | スプリント×45分 | プロセス改善と次スプリント計画 |

## スクラムアーティファクト

### 3つのアーティファクトと確約
| アーティファクト | 確約 | 内容 |
|-----------------|------|------|
| **プロダクトバックログ** | プロダクトゴール | 優先順位付けされた要求事項リスト |
| **スプリントバックログ** | スプリントゴール | 選択されたPBIと実現計画 |
| **インクリメント** | 完成の定義(DoD) | 動作する価値のあるプロダクト |

## 分散チーム向け実践

### リモートファースト戦略
```yaml
同期活動（30%）:
  - スプリントイベント
  - 重要な意思決定
  - チームビルディング

非同期活動（70%）:
  - 日常進捗更新
  - ドキュメントレビュー
  - 技術的詳細議論
```

### 必須ツールスタック
- **ビデオ会議**: Zoom, Teams, Meet
- **コラボレーション**: Miro, Mural
- **プロジェクト管理**: Jira, Azure DevOps
- **ドキュメント**: Confluence, Notion

## 主要メトリクス

### フローメトリクス
| 指標 | 目標値 | 用途 |
|------|--------|------|
| ベロシティ | 安定傾向 | 予測可能性 |
| サイクルタイム | 短縮傾向 | 効率性 |
| スプリントゴール達成率 | 80%以上 | 効果性 |
| 欠陥密度 | 減少傾向 | 品質 |

## スケーリングアプローチ

### フレームワーク選択
| 規模 | フレームワーク | 特徴 |
|------|---------------|------|
| 3-9チーム | Nexus | 統合チーム、共通スプリント |
| 大規模 | LeSS | 単一バックログ、フィーチャーチーム |
| 超大規模 | SAFe | 階層的、エンタープライズ向け |

## 実装チェックリスト

### フェーズ1: 基礎確立（1-3ヶ月）
- [ ] スクラムイベントの確立
- [ ] 役割とアカウンタビリティの明確化  
- [ ] チーム憲章の作成
- [ ] 基本メトリクス導入

### フェーズ2: 最適化（3-6ヶ月）
- [ ] 技術プラクティス向上（TDD、CI/CD）
- [ ] 自動化推進
- [ ] ステークホルダー連携強化
- [ ] メトリクス高度化

### フェーズ3: 拡張（6ヶ月以降）
- [ ] 複数チーム連携
- [ ] 組織的障害除去
- [ ] 文化変革推進
- [ ] 継続的イノベーション

## アンチパターン回避

### よくある落とし穴
- **スクラムゾンビ**: 形式だけ → 価値と成果にフォーカス
- **スクラムバット**: 言い訳 → 実験と学習の文化
- **ヒーロー文化**: 個人依存 → チーム能力向上

---
**モジュール作成日**: 2025-01-21
**カテゴリ**: methods/scrum
**バージョン**: 1.0.0-concise