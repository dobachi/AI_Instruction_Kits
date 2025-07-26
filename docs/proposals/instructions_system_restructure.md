# 指示書システム再構築提案: プリセット事前生成とinstructions整理

## 提案日: 2025-07-26

## 概要

AI指示書キットのinstructions以下の指示書システムを再構築し、プリセットの事前生成による効率化と従来指示書の整理を行う提案。モジュラーシステムの完成を受け、より効率的で保守性の高いシステムへの移行を目指す。

## 背景と課題

### 現在のシステム構造

1. **モジュラーシステム**: 48個のモジュールと9個のプリセットが利用可能
2. **従来の単一指示書**: instructions以下に30+の個別指示書が存在
3. **キャッシュシステム**: modular/cache/に一時的な生成ファイルを配置

### 特定された問題点

#### 1. プリセット生成の非効率性
- **毎回動的生成**: よく使われるプリセットも毎回生成処理が必要
- **レスポンス時間**: 生成に数秒〜十数秒かかる
- **一時性**: cacheディレクトリの内容はgit管理外

#### 2. 指示書の重複と管理複雑性
- **機能重複**: モジュラーシステムで再現可能な単一指示書が多数存在
- **保守負担**: 同じ機能を複数箇所で維持する必要
- **一貫性の欠如**: 単一指示書とモジュラー生成の出力に差異

#### 3. 利用体験の問題
- **選択の混乱**: ユーザーが単一指示書とモジュラーのどちらを使うべきか不明
- **最適化の機会損失**: プリセットの利点が活かしきれていない

## 提案する解決策

### 方針1: プリセット事前生成システム

#### 概要
よく使われるプリセットを事前に生成し、Git管理下に配置することで即座に利用可能にする。

#### 実装詳細

**新しいディレクトリ構造:**
```
instructions/
├── ja/
│   ├── system/           # システム管理（現状維持）
│   ├── presets/          # 🆕 事前生成プリセット
│   │   ├── web_api_production.md
│   │   ├── data_analyst.md
│   │   ├── cli_tool_basic.md
│   │   └── ...（9プリセット）
│   └── legacy/           # 🆕 保持する特別な指示書
│       ├── agent/
│       └── specialist/
├── en/
│   ├── system/
│   ├── presets/          # 🆕 英語版プリセット
│   └── legacy/
└── cache/                # 現状通り（動的生成用）
```

#### 対象プリセット
1. `web_api_production` - WebAPI開発（最重要）
2. `cli_tool_basic` - CLIツール開発（高頻度）
3. `data_analyst` - データ分析（高頻度）
4. `business_consultant` - ビジネスコンサル
5. `academic_researcher` - 学術研究
6. `technical_writer` - 技術文書作成
7. `project_manager` - プロジェクト管理
8. `startup_advisor` - スタートアップ支援
9. `blueprint_sample` - サンプル用途

#### プリセット一括生成スクリプト

**`scripts/generate-all-presets.sh`** を新規作成済み:

```bash
# 全プリセットを日英両言語で生成
./scripts/generate-all-presets.sh

# 日本語のみ生成
./scripts/generate-all-presets.sh --lang ja

# 特定のプリセットのみ生成
./scripts/generate-all-presets.sh --preset web_api_production

# ドライラン（実行内容の確認）
./scripts/generate-all-presets.sh --dry-run

# 生成後に検証も実行
./scripts/generate-all-presets.sh --validate
```

**スクリプトの主な機能:**
- 全プリセットの一括生成
- 日英両言語対応
- 既存ファイルのスキップ（--forceで上書き可能）
- 生成ファイルの自動検証
- Git操作の統合
- ドライラン機能
- 詳細なログ出力

### 方針2: 既存指示書の整理・分類

#### 削除対象（モジュラー置換可能）
```yaml
削除候補:
  coding/basic_code_generation.md:
    理由: "task_code_generation + 各種skillで完全に置き換え可能"
    代替: "cli_tool_basicプリセット + カスタマイズ"
  
  analysis/basic_data_analysis.md:
    理由: "data_analystプリセットで高機能版が利用可能"
    代替: "data_analystプリセット"
  
  writing/basic_text_creation.md:
    理由: "technical_writerプリセット + 関連スキルで代替"
    代替: "technical_writerプリセット"
  
  presentation/technical_design.md:
    理由: "task_presentation_design + skill_visual_communicationで代替"
    代替: "カスタムモジュール構成"
```

#### 保持対象（特殊機能・高頻度利用）
```yaml
保持:
  system/:
    理由: "システムコア機能、代替不可"
    場所: "instructions/ja/system/（現状維持）"
  
  agent/code_reviewer.md:
    理由: "コードレビュー特化、高頻度利用"
    場所: "instructions/ja/legacy/agent/"
  
  agent/python_expert.md:
    理由: "Python特化エージェント、専門性高い"
    場所: "instructions/ja/legacy/agent/"
  
  presentation/marp_specialist.md:
    理由: "Marp特化、技術特殊性高い"
    場所: "instructions/ja/legacy/specialist/"
```

### 方針3: ハイブリッド運用システム

#### 使い分け基準
```yaml
プリセット事前生成版:
  用途: "標準的なタスク、高速応答が必要"
  例: "Webアプリ作って", "データ分析して", "CLIツール作成"
  
動的生成（従来通り）:
  用途: "特殊要件の組み合わせ、カスタマイズ重視"
  例: "ML + API + A/Bテスト", "特殊なスキル組み合わせ"
  
レガシー指示書:
  用途: "高度に特化した機能、頻繁利用"
  例: "コードレビュー依頼", "Marpスライド作成"
```

#### ROOT_INSTRUCTION更新
プリセット優先の判定ロジックを更新：
1. プリセット事前生成版をまず確認
2. カスタマイズが必要なら動的生成
3. 特殊機能ならレガシー指示書

## 実装計画

### Phase 1: プリセット事前生成（1週間）

#### Day 1-2: インフラ構築
1. **生成スクリプト作成** ✅ 完了
   - `scripts/generate-all-presets.sh` 作成済み
   - 全機能実装完了

2. **ディレクトリ構造準備**
   ```bash
   mkdir -p instructions/ja/presets
   mkdir -p instructions/en/presets
   ```

#### Day 3-4: プリセット生成・配置
1. **初回生成実行**
   ```bash
   # ドライランで確認
   ./scripts/generate-all-presets.sh --dry-run
   
   # 実際に生成
   ./scripts/generate-all-presets.sh --validate
   ```

2. **生成結果の確認**
   - 各プリセットの内容確認
   - トークン数チェック
   - 必須要素の検証

#### Day 5: テストと調整
1. **実際の使用テスト**
   - 各プリセットでタスク実行
   - パフォーマンス測定
   - ユーザビリティ確認

2. **微調整**
   - 必要に応じてプリセット定義を修正
   - 再生成と検証

### Phase 2: 指示書整理（1週間）

#### Day 6-7: 分析・分類
1. **使用頻度分析**
   ```bash
   # 既存指示書の利用パターン分析
   find instructions -name "*.md" -type f | grep -v system | sort
   ```

2. **移行計画作成**
   - 削除対象リスト確定
   - レガシー移行対象確定
   - 移行手順書作成

#### Day 8-9: 段階的移行
1. **レガシーディレクトリ作成**
   ```bash
   mkdir -p instructions/ja/legacy/agent
   mkdir -p instructions/ja/legacy/specialist
   ```

2. **ファイル移動・削除**
   - Git mvでファイル移動
   - 削除ファイルのリダイレクト情報作成

#### Day 10: システム統合
1. **ROOT_INSTRUCTION更新**
   - プリセット優先ロジックの実装
   - パス更新

2. **ドキュメント作成**
   - 移行ガイド
   - 新システム使用方法

### Phase 3: 自動化・最適化（3日）

#### Day 11: CI/CD統合
1. **GitHub Actions設定**
   ```yaml
   name: Regenerate Presets
   on:
     push:
       paths:
         - 'modular/ja/modules/**'
         - 'modular/en/modules/**'
         - 'modular/presets/**'
   
   jobs:
     regenerate:
       runs-on: ubuntu-latest
       steps:
         - uses: actions/checkout@v3
         - name: Generate presets
           run: ./scripts/generate-all-presets.sh
         - name: Commit changes
           uses: EndBug/add-and-commit@v9
   ```

2. **自動検証**
   - プリセット整合性チェック
   - 破壊的変更の検出

#### Day 12-13: 運用開始・監視
1. **リリース**
   - 変更のアナウンス
   - 使用方法の周知

2. **監視とフィードバック**
   - 利用状況の追跡
   - パフォーマンス測定
   - ユーザーフィードバック収集

## 期待される効果

### 1. パフォーマンス向上
- **応答時間**: プリセット利用時に90%短縮（生成時間0秒）
- **システム負荷**: 動的生成の頻度削減

### 2. 保守性向上
- **一元管理**: プリセットのGit管理により変更履歴追跡
- **品質担保**: 事前検証によるプリセット品質の確保
- **複雑性削減**: 重複指示書の削除による管理負荷軽減
- **自動更新**: スクリプトによる一括再生成が可能

### 3. 利用体験向上
- **明確な使い分け**: プリセット vs カスタム vs レガシーの明確化
- **即座の利用開始**: 生成待ち時間の削除
- **予測可能性**: 事前生成により出力内容が予測可能

### 4. 開発効率向上
- **標準化**: 一般的なタスクの標準的なアプローチ確立
- **再利用性**: プリセットのテンプレート化効果
- **学習コスト削減**: 推奨プリセットによる学習負荷軽減
- **メンテナンス簡易化**: 一括生成スクリプトによる更新作業の自動化

## リスク分析と対策

### リスク1: プリセット更新の複雑性
**リスク**: モジュール更新時にプリセットの再生成が必要
**対策**: 
- generate-all-presets.shによる一括再生成
- CI/CDによる自動再生成システム
- 変更検知の自動化

### リスク2: 指示書削除による互換性問題
**リスク**: 既存ユーザーの依存指示書削除で利用不可
**対策**: 
- 段階的削除
- リダイレクト情報の提供
- 移行期間の設定（2週間）
- レガシーディレクトリでの保持

### リスク3: プリセットの肥大化
**リスク**: プリセット数増加によるディスク使用量増大
**対策**: 
- 利用頻度に基づく選別
- 定期的な見直し（四半期ごと）
- 圧縮可能な形式の検討

## 成功指標

### 量的指標
- プリセット応答時間: 現在10-30秒 → 0-2秒
- instructions管理ファイル数: 現在70+ → 40以下
- プリセット利用率: 80%以上
- 生成スクリプト実行時間: 全プリセット30秒以内

### 質的指標
- ユーザー満足度: 応答速度向上の実感
- 開発効率: 標準タスクの実行時間短縮
- 保守負荷: 指示書管理工数の削減
- 更新容易性: モジュール変更時の対応時間短縮

## 実装済みコンポーネント

### generate-all-presets.sh
- ✅ 全プリセット一括生成
- ✅ 多言語対応（ja/en）
- ✅ ドライラン機能
- ✅ 既存ファイル保護
- ✅ 生成後検証
- ✅ Git統合
- ✅ 詳細ログ出力
- ✅ エラーハンドリング

## 次のステップ

1. **このプロポーザルのレビュー・承認**
2. **GitHub Issue作成**（詳細タスク分解）
3. **Phase 1実装開始**（プリセット事前生成）
   - generate-all-presets.sh実行
   - 生成結果の確認
   - 必要に応じた調整

---

## 補足情報

### 現在のプリセット一覧
1. blueprint_sample
2. web_api_production 
3. data_analyst
4. startup_advisor
5. cli_tool_basic
6. business_consultant
7. academic_researcher
8. project_manager
9. technical_writer

### 現在のモジュール統計
- **core**: 3モジュール
- **tasks**: 20モジュール  
- **skills**: 24モジュール
- **quality**: 1モジュール
- **合計**: 48モジュール

### generate-all-presets.sh使用例
```bash
# 基本的な使用
./scripts/generate-all-presets.sh

# 検証付き生成
./scripts/generate-all-presets.sh --validate

# 特定言語のみ
./scripts/generate-all-presets.sh --lang ja

# 強制上書き
./scripts/generate-all-presets.sh --force --validate

# CI/CDでの使用
./scripts/generate-all-presets.sh --no-git
```

---

## ライセンス情報
- **ライセンス**: Apache-2.0
- **作成日**: 2025-07-26
- **作成者**: AI Instruction Kits Project