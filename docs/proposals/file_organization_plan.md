# プロポーサルファイル整理計画

**作成日**: 2025-07-27  
**概要**: 既存のプロポーサルファイルの整理と今後の管理方針

## 現状分析

現在、`docs/proposals/`に25個のファイルが存在。議論の過程で作成されたが、一部は古くなったり、最終案に統合されたりしている。

## 整理方針

### 1. アーカイブディレクトリの作成
```
docs/
├── proposals/              # アクティブな提案書
│   └── current/           # 実装予定・実装中
└── proposals_archive/      # 過去の提案書
    ├── superseded/        # 新しい提案に置き換えられたもの
    ├── completed/         # 実装完了したもの
    └── experimental/      # 実験的・参考用
```

### 2. ファイル分類と処理

#### A. 最新・アクティブ（currentに残す）
- `comprehensive_system_design_summary.md` - **最新の統合設計**
- `ai_autonomous_instruction_generation.md` - AI自律実行の最新提案
- `three_systems_separation_design.md` - 3システム分離の基本設計

#### B. 実装完了（completed/へ移動）
- `claude_custom_commands.md` - 実装済み
- `modular_file_naming_revision.md` - 実装済み
- `module_docs_consolidation_plan.md` - 実装済み

#### C. 統合・置き換え済み（superseded/へ移動）
- `checkpoint_system_detailed_design.md` → comprehensive_system_design_summaryに統合
- `modular_system_detailed_design.md` → comprehensive_system_design_summaryに統合
- `realistic_parallel_system_approaches.md` → comprehensive_system_design_summaryに統合
- `task_template_detailed_design.md` → ai_autonomous_instruction_generationに統合

#### D. 参考・実験的（experimental/へ移動）
- `ai_driven_modular_system.md` - 初期のアイデア
- `distributed_metadata_system.md` - 将来の可能性
- `openhands_integration_design.md` - 外部ツール連携案
- `openhands_oss_models.md` - 外部ツール調査

#### E. 課題・分析系（experimental/へ移動）
- `critical_evaluation_module_*.md` - モジュール評価の分析
- `legacy_instruction_analysis.md` - レガシー分析
- `module_*_issue.md` - 各種課題分析
- `modular_token_reduction.md` - トークン削減の検討
- `large_module_refactoring_plan.md` - リファクタリング計画

#### F. その他
- `index.md` - 更新して残す
- `academic_modules_implementation_plan.md` - 実装計画として残す
- `instructions_system_restructure.md` - 参考として残す
- `modular_advanced_features.md` - 将来機能として残す

## 実行スクリプト

```bash
#!/bin/bash
# organize_proposals.sh

# ディレクトリ作成
mkdir -p docs/proposals/current
mkdir -p docs/proposals_archive/{superseded,completed,experimental}

# A. アクティブなファイルを移動
mv docs/proposals/comprehensive_system_design_summary.md docs/proposals/current/
mv docs/proposals/ai_autonomous_instruction_generation.md docs/proposals/current/
mv docs/proposals/three_systems_separation_design.md docs/proposals/current/

# B. 実装完了を移動
mv docs/proposals/claude_custom_commands.md docs/proposals_archive/completed/
mv docs/proposals/modular_file_naming_revision.md docs/proposals_archive/completed/
mv docs/proposals/module_docs_consolidation_plan.md docs/proposals_archive/completed/

# C. 統合済みを移動
mv docs/proposals/checkpoint_system_detailed_design.md docs/proposals_archive/superseded/
# ... (他のファイルも同様)

# index.mdを更新
cat > docs/proposals/index.md << 'EOF'
# 提案書一覧

## アクティブな提案（current/）
- [システム設計総合まとめ](current/comprehensive_system_design_summary.md) - **最新**
- [AI自律実行システム](current/ai_autonomous_instruction_generation.md)
- [3システム分離設計](current/three_systems_separation_design.md)

## アーカイブ
- [実装完了](../proposals_archive/completed/) - 実装済みの提案
- [統合済み](../proposals_archive/superseded/) - 新しい提案に置き換え
- [実験的](../proposals_archive/experimental/) - 参考・研究用

## 提案書作成ガイドライン
1. 新規提案は`proposals/`直下に作成
2. 議論・レビュー後、適切なディレクトリへ移動
3. ファイル名: `<topic>_<type>.md` (例: system_design_proposal.md)
EOF

echo "提案書の整理が完了しました"
```

## 今後の運用ルール

### 1. 新規提案書
- まず`proposals/`直下に作成
- レビュー後、適切な場所へ移動

### 2. ステータス管理
```yaml
# 各提案書の先頭に記載
---
status: draft|review|active|completed|superseded
created: 2025-07-27
updated: 2025-07-27
superseded_by: [ファイル名]  # 置き換えられた場合
---
```

### 3. 定期的な整理
- 四半期ごとにアーカイブを見直し
- 不要なファイルは削除検討

## 推奨アクション

1. **最初にindex.mdを確認・更新**
2. **organize_proposals.shを実行**
3. **READMEに提案書の場所を明記**
4. **今後は新しい運用ルールに従う**

この整理により、現在アクティブな提案と過去の議論が明確に分離され、必要な情報へのアクセスが容易になります。