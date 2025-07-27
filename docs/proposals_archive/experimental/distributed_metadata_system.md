# 分散型メタデータシステム設計書

**作成日**: 2025-01-08  
**関連Issue**: [#2 指示書のモジュラライズとテンプレートシステムの導入](https://github.com/dobachi/AI_Instruction_Kits/issues/2)  
**バージョン**: 1.0

## 1. 概要

本設計書は、AI指示書キットにおける分散型メタデータシステムの実装仕様を定義します。このシステムは、既存の単体指示書を維持しながら、効率的な検索・管理機能を提供し、将来のモジュラーシステムとの統合を見据えた設計となっています。

### 1.1 背景と課題

現在のシステムでは：
- 指示書のメタデータがMarkdownファイル末尾に非構造化形式で記載
- プログラムによる解析・検索が困難
- カテゴリやタグによる分類機能が不足
- 指示書間の関連性や依存関係が不明確

### 1.2 解決方針

- **分散型アプローチ**: 各指示書ファイルと同じディレクトリに`.yaml`ファイルを配置
- **構造化データ**: YAML形式でメタデータを管理（モジュラーシステムとの一貫性）
- **段階的移行**: 既存システムを維持しながら新機能を追加
- **将来の拡張性**: モジュラーシステムとの統合を考慮

## 2. システムアーキテクチャ

### 2.1 ファイル構造

```
instructions/
├── ja/
│   ├── coding/
│   │   ├── basic_code_generation.md
│   │   ├── basic_code_generation.yaml    # 新規追加
│   │   └── ...
│   └── system/
│       ├── ROOT_INSTRUCTION.md
│       ├── ROOT_INSTRUCTION.yaml         # 新規追加
│       └── ...
└── en/
    └── (同様の構造)

scripts/
├── generate-metadata.sh      # メタデータ生成スクリプト（新規）
├── search-instructions.sh    # 検索スクリプト（新規）
├── select-instruction.py     # 既存スクリプト（更新）
└── ...
```

### 2.2 メタデータファイル仕様

#### 2.2.1 ファイル命名規則
- 形式: `{指示書ファイル名（.md除く）}.yaml`
- 例: `basic_code_generation.yaml`

#### 2.2.2 データ形式（YAML）

```yaml
# basic_code_generation.yaml
id: "coding_basic_code_generation"
name: "基本的なコード生成"
description: "プログラムコードの実装に関する基本的な指示"
version: "1.0.0"
category: "coding"
language: "ja"
tags:
  - "coding"
  - "basic"
  - "code-generation"
  - "programming"

# ファイル情報
file:
  name: "basic_code_generation.md"
  path: "ja/coding/basic_code_generation.md"
  size: 2048
  checksum: "a1b2c3d4e5f6..."
  last_modified: "2025-01-08T15:30:00+09:00"

# メタ情報
metadata:
  author: "dobachi"
  created: "2025-06-30"
  updated: "2025-01-08"
  license: "Apache-2.0"
  reference: ""

# 将来の拡張用（Phase 2以降）
dependencies: []
compatible_modules: []
variables: {}
```

#### 2.2.3 フィールド定義

| フィールド | 型 | 必須 | 説明 |
|-----------|-----|------|------|
| id | string | ✓ | 一意の識別子 |
| name | string | ✓ | 指示書の名前 |
| description | string | ✓ | 指示書の概要説明 |
| version | string | ✓ | バージョン（semver形式） |
| category | string | ✓ | カテゴリ名 |
| language | string | ✓ | 言語コード（ja/en） |
| tags | array | ✓ | タグのリスト |
| file | object | ✓ | ファイル情報 |
| metadata | object | ✓ | メタ情報 |
| dependencies | array | | 依存する指示書のID |
| compatible_modules | array | | 互換性のあるモジュール |
| variables | object | | カスタマイズ可能な変数 |

### 2.3 モジュラーシステムとの統合（将来）

モジュラーシステムのメタデータ形式と統一：

```yaml
# modules/tasks/web_api_development.yaml (モジュラーシステム)
id: "task_web_api"
name: "Web API開発"
description: "RESTful Web API開発の基本構造"
version: "1.0.0"
tags: ["api", "web", "backend"]
category: "tasks"
compatible_skills: ["error_handling", "validation", "authentication"]
variables:
  - name: "framework"
    description: "使用するフレームワーク名"
    type: "string"
    default: "FastAPI"
```

## 3. 実装コンポーネント

### 3.1 メタデータ生成スクリプト（generate-metadata.sh）

#### 機能
- 既存の指示書ファイルからメタデータを抽出
- `.yaml`ファイルを自動生成
- 一括処理と個別処理をサポート
- 既存メタデータの更新

#### 処理フロー
1. 指示書ファイルをスキャン
2. タイトル、説明、既存メタデータを抽出
3. カテゴリ、言語をパスから判定
4. タグを自動生成（カテゴリ、言語、キーワードから）
5. YAMLファイルとして出力

### 3.2 検索スクリプト（search-instructions.sh）

#### 機能
- キーワード検索
- カテゴリ/言語/タグによるフィルタリング
- 複数の出力形式（リスト/詳細/パスのみ）
- YAMLメタデータの高速パース

#### 検索アルゴリズム
1. `.yaml`ファイルを高速スキャン
2. フィルタ条件を適用
3. 関連性スコアでソート
4. 結果を指定形式で出力

### 3.3 既存スクリプトの更新（select-instruction.py）

#### 変更内容
- 新しいYAML形式への対応
- ファイル名規則の変更（`*.meta.yaml` → `*.yaml`）
- より豊富なメタデータの活用

## 4. 実装計画

### Phase 1: 基本実装（現在進行中）
- [x] メタデータ生成スクリプトの作成（YAML対応版）
- [x] 検索スクリプトの作成（YAML対応版）
- [ ] 既存スクリプトの更新
- [ ] 初期メタデータの生成
- [ ] 基本的な動作テスト

### Phase 2: 統合と最適化
- [ ] カタログキャッシュの実装
- [ ] 検索パフォーマンスの最適化
- [ ] モジュラーシステムとの統合
- [ ] ドキュメントの更新

### Phase 3: 高度な機能
- [ ] 依存関係管理
- [ ] バージョン管理
- [ ] 自動更新メカニズム
- [ ] WebUIの提供（オプション）

## 5. 移行戦略

### 5.1 段階的移行

1. **準備段階**
   - 新システムの実装
   - 既存ファイルへの影響なし

2. **共存段階**
   - `.yaml`ファイルの生成
   - 既存の末尾メタデータも維持
   - 両方の形式をサポート

3. **移行完了**
   - すべてのツールが`.yaml`を使用
   - 末尾メタデータは参考情報として保持

### 5.2 互換性の維持

- 既存のワークフローに影響を与えない
- 段階的な機能追加
- 明確な移行ガイドの提供

## 6. パフォーマンス考慮事項

### 6.1 設計目標
- 100個の指示書で検索時間 < 0.5秒
- 1000個の指示書で検索時間 < 2秒
- メタデータ生成: 1ファイル < 0.1秒

### 6.2 最適化手法
- YAMLの軽量パーサー使用
- ファイルシステムレベルでの分散
- 必要に応じたキャッシュ機能
- 並列処理の活用

## 7. セキュリティとプライバシー

- メタデータに機密情報を含めない
- ファイルアクセス権限の継承
- チェックサムによる整合性確認

## 8. 成功指標

1. **機能面**
   - すべての指示書にメタデータが生成される
   - 検索機能が期待通りに動作する
   - 既存システムとの互換性が保たれる

2. **パフォーマンス面**
   - 設計目標の達成
   - リソース使用量の最小化

3. **ユーザビリティ面**
   - 直感的な検索インターフェース
   - 明確なドキュメント
   - スムーズな移行体験

## 9. リスクと対策

| リスク | 影響 | 対策 |
|--------|------|------|
| メタデータの不整合 | 検索精度の低下 | チェックサム検証、定期的な再生成 |
| パフォーマンス劣化 | UXの低下 | キャッシュ機能、インデックス化 |
| 移行時の混乱 | 採用率の低下 | 段階的移行、詳細なガイド |
| YAML解析エラー | 機能停止 | エラーハンドリング、検証ツール |

## 10. 実装例

### 10.1 メタデータ生成の例

```bash
# 単一ファイルの処理
$ ./scripts/generate-metadata.sh instructions/ja/coding/basic_code_generation.md
✓ メタデータ生成: instructions/ja/coding/basic_code_generation.yaml

# 一括処理
$ ./scripts/generate-metadata.sh
=== AI指示書メタデータ生成開始 ===
対象ディレクトリ: instructions
✓ メタデータ生成: instructions/ja/coding/basic_code_generation.yaml
✓ メタデータ生成: instructions/ja/system/ROOT_INSTRUCTION.yaml
...
=== 完了 ===
生成されたメタデータファイル: 25
```

### 10.2 検索の例

```bash
# キーワード検索
$ ./scripts/search-instructions.sh python
検索結果: 3件
Python開発の専門家エージェント              [ja/agent]
基本的なコード生成                          [ja/coding]
データ分析                                  [ja/analysis]

# カテゴリとタグの組み合わせ
$ ./scripts/search-instructions.sh -c agent -t python -f detail
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
タイトル: Python開発の専門家エージェント
パス: instructions/ja/agent/python_expert.md
カテゴリ: agent
言語: ja
説明: Pythonの専門家として振る舞い、高品質なコードを提供
タグ: python,agent,expert,development
著者: dobachi
ライセンス: Apache-2.0
```

## 11. 今後の展望

このメタデータシステムは、AI指示書キットの基盤となる重要なコンポーネントです。将来的には：

1. **モジュラーシステムとの完全統合**
   - 統一されたメタデータ形式
   - モジュール間の依存関係管理
   - 動的な指示書生成

2. **コミュニティ機能**
   - 指示書の評価・レビュー
   - 使用統計の収集
   - 共有リポジトリ

3. **AI支援機能**
   - 自動タグ生成の改善
   - 関連指示書の推薦
   - 使用パターンの学習

---

**レビュー履歴**

| 日付 | レビュアー | コメント |
|------|-----------|----------|
| 2025-01-08 | - | 初版作成（YAML形式採用） |