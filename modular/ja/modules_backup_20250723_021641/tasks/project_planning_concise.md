# プロジェクト計画モジュール（簡潔版）

## コア概念
伝統的ウォーターフォールからアジャイルまで、様々な規模・種類のプロジェクトに対する体系的計画立案。成功への道筋を明確化。

## プロジェクト憲章

### 憲章の核心要素
```yaml
基本情報:
  - プロジェクト名: {{project_name}}
  - 開始日: {{start_date}}
  - 終了予定日: {{end_date}}
  - PM: {{project_manager}}

目的: {{project_purpose}}
ビジネス価値: {{business_value}}
成功基準: {{success_criteria}}
```

### スコープ定義
| 要素 | 内容 |
|------|------|
| **In Scope** | {{in_scope_items}} |
| **Out of Scope** | {{out_of_scope_items}} |
| **前提条件** | {{assumptions}} |
| **制約条件** | {{constraints}} |

## WBS（Work Breakdown Structure）

### WBS作成手順
1. 最終成果物定義
2. 主要成果物に分解
3. 作業パッケージレベルまで細分化
4. 各要素に固有ID割当

### タイムライン管理
```yaml
ガントチャート要素:
  - タスク名
  - 開始日/終了日
  - 期間
  - 先行タスク
  - 担当者
  - 進捗率

マイルストーン:
  - {{milestone_1_name}}: {{milestone_1_date}}
  - {{milestone_2_name}}: {{milestone_2_date}}
  - {{milestone_3_name}}: {{milestone_3_date}}
```

## リソース計画

### リソースマトリックス
| リソースタイプ | 要件 | 数量/工数 |
|---------------|------|----------|
| **人的リソース** | {{required_roles}} | {{required_effort}} |
| **物的リソース** | {{equipment_needs}} | - |
| **ソフトウェア** | {{software_tools}} | - |
| **施設** | {{facilities}} | - |

## 予算・コスト管理

### コスト内訳
```yaml
人件費:
  - 内部: {{internal_cost}}
  - 外部: {{external_cost}}

物件費:
  - ハードウェア: {{hardware_cost}}
  - ソフトウェア: {{software_cost}}

その他:
  - 出張/交通費: {{travel_cost}}
  - 研修費: {{training_cost}}

予備費: {{contingency}}
```

## リスク管理

### リスク評価マトリックス
| リスク | 発生確率 | 影響度 | スコア | 対応策 |
|--------|----------|---------|--------|----------|
| {{risk_1}} | {{probability_1}} | {{impact_1}} | {{score_1}} | {{mitigation_1}} |
| {{risk_2}} | {{probability_2}} | {{impact_2}} | {{score_2}} | {{mitigation_2}} |

### リスク対応戦略
- **回避**: リスク完全排除
- **軽減**: 確率/影響低減
- **転嫁**: 第三者移転（保険等）
- **受容**: リスク認識し受入

## プロジェクト管理方法論

### 主要アプローチ比較
| 方法論 | 特徴 | 適用場面 |
|--------|------|----------|
| **ウォーターフォール** | 順次的、段階的 | 要件明確、変更少 |
| **アジャイル（スクラム）** | 反復的、増分的 | 要件流動的、柔軟性必要 |
| **カンバン** | 継続的流れ、WIP制限 | 運用・保守、継続改善 |
| **ハイブリッド** | 複数方法論組合せ | 大規模複雑プロジェクト |

## 品質保証

### 品質管理計画
```yaml
品質基準: {{quality_standards}}
品質メトリクス: {{quality_metrics}}
レビュープロセス: {{review_process}}
テスト戦略: {{test_strategy}}
```

## ステークホルダー管理

### ステークホルダー分析
| ステークホルダー | 関心事項 | 影響力 | 関与度 | コミュニケーション |
|-----------------|----------|---------|---------|------------------|
| {{stakeholder_1}} | {{interest_1}} | {{influence_1}} | {{engagement_1}} | {{comm_strategy_1}} |

## クリティカルパス

### クリティカルパス特定
1. すべてのタスクと期間リスト化
2. 先行/後続関係明確化
3. 最早/最遅開始時刻計算
4. フロートゼロのパス特定

## ベストプラクティス

### 成功のための鍵
1. **段階的詳細化**: 初期概要→進行に応じ詳細化
2. **ベースライン設定**: 承認計画を基準管理
3. **定期的見直し**: 週次/月次ステータス確認
4. **変更管理**: 変更要求評価と承認プロセス
5. **教訓文書化**: 完了後の振り返り

## チェックリスト

### プロジェクト計画完成度
- [ ] プロジェクト憲章作成
- [ ] WBS完成
- [ ] タイムライン設定
- [ ] リソース計画完了
- [ ] 予算計画承認
- [ ] リスク分析と対策
- [ ] ステークホルダー分析
- [ ] クリティカルパス特定

---
**モジュール作成日**: 2025-01-21
**カテゴリ**: tasks/project_planning
**バージョン**: 1.0.0-concise