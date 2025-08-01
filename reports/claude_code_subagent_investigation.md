# Claude Code サブエージェント機能調査報告書

**作成日**: 2025-07-27  
**作成者**: AI指示書キット開発チーム  
**文書種別**: 技術調査報告書

## エグゼクティブサマリー

### 主要な発見事項
1. Claude Codeには`general-purpose`サブエージェントが利用可能で、複雑なマルチステップタスクの自律的実行が可能
2. サブエージェントはTaskツールを通じて起動し、すべてのツール(*)にアクセス可能
3. AI指示書キットプロジェクトでの活用により、指示書の自動分析・最適化が期待できる

### 推奨事項
- 複雑な検索や複数ラウンドの調査が必要な場合にサブエージェントを活用
- カスタムスラッシュコマンドと連携した自動化ワークフローの構築
- 指示書の品質チェックや最適化タスクでの積極的活用

## 1. 調査の背景と目的

### 背景
AI指示書キットプロジェクトは、AIへの指示書を構造的に管理・提供するシステムです。プロジェクトの規模拡大に伴い、以下の課題が顕在化しています：

- 指示書間の重複や不整合の検出
- 新規指示書作成時の既存資産の活用
- 指示書の品質チェックの自動化

### 目的
Claude Codeのサブエージェント機能を調査し、上記課題の解決にどのように活用できるかを明確にすることが本調査の目的です。

## 2. サブエージェント機能の技術仕様

### 2.1 基本仕様

| 項目 | 内容 |
|------|------|
| **エージェントタイプ** | general-purpose |
| **アクセス可能ツール** | すべて (*) |
| **起動方法** | Taskツール経由 |
| **ステートレス性** | 各起動は独立（状態を保持しない） |
| **通信方法** | 最終レポートのみ（対話不可） |

### 2.2 パラメータ仕様

```typescript
interface TaskParameters {
  description: string;    // 3-5語の簡潔な説明
  prompt: string;        // 詳細なタスク指示
  subagent_type: string; // "general-purpose"
}
```

### 2.3 制約事項

1. **ステートレス実行**: サブエージェントは起動ごとに独立しており、前回の実行結果を記憶しない
2. **単方向通信**: 追加の指示や対話的なやり取りは不可能
3. **結果の非表示性**: サブエージェントの結果は自動的にユーザーに表示されない

## 3. 使用方法の詳細

### 3.1 基本的な使用方法

```python
# サブエージェントの起動例
task_params = {
    "description": "指示書重複チェック",
    "prompt": """
    instructionsディレクトリ内のすべての指示書を分析し、
    以下の観点で重複を検出してください：
    1. 機能の重複
    2. 内容の類似性
    3. 統合可能な指示書の組み合わせ
    
    結果は構造化された形式で報告してください。
    """,
    "subagent_type": "general-purpose"
}
```

### 3.2 効果的な指示の書き方

#### 良い例：具体的で構造化された指示
```
タスク: instructions/ja/配下のMarkdownファイルを分析
目的: コード例の品質チェック

チェック項目:
1. シンタックスの正確性
2. 実行可能性
3. ベストプラクティスへの準拠

出力形式:
- ファイルパスと問題点のリスト
- 改善提案
- 優先度（High/Medium/Low）
```

#### 悪い例：曖昧で非構造的な指示
```
指示書をチェックして問題があったら教えて
```

## 4. 活用シナリオの比較分析

### 4.1 シナリオ比較表

| シナリオ | サブエージェント使用 | 直接実行 | 推奨度 |
|---------|-------------------|---------|---------|
| **指示書の重複検出** | 複数ファイルの横断的分析が効率的 | 手動での比較は困難 | ★★★ |
| **品質チェック** | 一括チェックと構造化レポート | 個別チェックの繰り返し | ★★★ |
| **新規指示書生成** | 既存資産の分析と提案 | テンプレートベース | ★★☆ |
| **単一ファイル編集** | オーバーヘッドが大きい | シンプルで効率的 | ★☆☆ |

### 4.2 判断基準

サブエージェントを使用すべき場合：
- 複数ファイルの横断的な分析が必要
- 複雑な判断ロジックが必要
- 探索的なタスク（正解が明確でない）
- 大量の繰り返し処理

直接実行すべき場合：
- 単一ファイルの編集
- 明確な手順が決まっているタスク
- リアルタイムの対話が必要
- 小規模な変更

## 5. 実装例

### 5.1 指示書品質チェッカー

```bash
#!/bin/bash
# check-instruction-quality.sh

# サブエージェントを使用した品質チェック
claude_code_task() {
    cat << 'EOF'
以下のタスクを実行してください：

1. instructions/ja/配下のすべての.mdファイルを分析
2. 各ファイルについて以下をチェック：
   - 必須セクション（目的、手順、例）の有無
   - コード例の文法的正確性
   - 相互参照の整合性
3. 問題点を severity 別にレポート
4. 改善提案を含める

出力形式：
YAML形式で以下の構造：
- quality_report:
  - total_files: ファイル総数
  - issues:
    - high: 重大な問題のリスト
    - medium: 中程度の問題のリスト
  - summary:
    - pass_rate: 合格率（パーセンテージ）
    - common_issues: よくある問題のリスト
EOF
}
```

### 5.2 カスタムスラッシュコマンドの実装案

**コマンド名**: `/analyze-instructions`

**概要**: 指示書の包括的な分析を実行するカスタムコマンド

**使用方法**:
```bash
/analyze-instructions [options]
```

**オプション**:
- `--duplicates`: 重複検出モード
- `--quality`: 品質チェックモード
- `--suggest`: 改善提案モード
- `--all`: すべての分析を実行

**実装方針**:
Taskツールを使用してサブエージェントを起動し、指定されたモードに応じた分析を実行

### 5.3 CI/CD統合例

```yaml
# .github/workflows/instruction-quality.yml
name: Instruction Quality Check

on:
  pull_request:
    paths:
      - 'instructions/**/*.md'

jobs:
  quality-check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Run Quality Check via Subagent
        run: |
          # Claude Code CLIを使用してサブエージェントを起動
          # 品質チェックを実行し、結果をPRコメントとして投稿
```

## 6. ベストプラクティス

### 6.1 プロンプト設計
1. **明確な目的設定**: タスクの目的を最初に明記
2. **構造化された指示**: 番号付きリストや箇条書きを活用
3. **出力形式の指定**: 期待する結果の形式を明確に
4. **制約条件の明記**: 処理対象の範囲や条件を具体的に

### 6.2 エラーハンドリング
```python
# サブエージェント結果の処理例
def process_subagent_result(result):
    try:
        # 結果の検証
        if not result or "error" in result.lower():
            raise ValueError("サブエージェントでエラーが発生")
        
        # 構造化データの抽出
        parsed_result = parse_structured_output(result)
        
        # 後続処理
        return handle_parsed_result(parsed_result)
        
    except Exception as e:
        logger.error(f"サブエージェント結果の処理エラー: {e}")
        return fallback_processing()
```

### 6.3 パフォーマンス考慮事項
- 大量ファイルの処理時は、バッチ処理を検討
- 頻繁に実行するタスクは結果をキャッシュ
- 非同期実行での並列処理を活用

## 7. 今後の検討事項

### 7.1 拡張可能性
1. **専門特化型サブエージェント**: 指示書分析に特化したエージェントの開発
2. **対話型ワークフロー**: 複数のサブエージェントを連携させた高度な処理
3. **学習機能**: 過去の分析結果を活用した改善

### 7.2 導入ロードマップ
| フェーズ | 期間 | 内容 |
|---------|------|------|
| **Phase 1** | 1ヶ月 | 基本的な品質チェック機能の実装 |
| **Phase 2** | 2-3ヶ月 | CI/CD統合とカスタムコマンド |
| **Phase 3** | 3-6ヶ月 | 高度な分析機能と最適化 |

### 7.3 リスクと対策
| リスク | 影響 | 対策 |
|--------|------|------|
| **API制限** | 大規模分析の制約 | バッチ処理とキャッシング |
| **結果の一貫性** | 品質のばらつき | プロンプトの標準化 |
| **依存性** | 外部サービスへの依存 | フォールバック処理の実装 |

## 8. 結論

Claude Codeのサブエージェント機能は、AI指示書キットプロジェクトにおいて以下の価値を提供できます：

1. **効率化**: 複雑な分析タスクの自動化
2. **品質向上**: 体系的な品質チェックの実現
3. **スケーラビリティ**: プロジェクト規模拡大への対応

特に、指示書の品質管理と最適化において、サブエージェントの活用は大きな効果が期待できます。段階的な導入により、リスクを最小化しながら価値を最大化することを推奨します。

---

**付録**: 
- [サンプルコード集](#)
- [詳細API仕様](#)
- [トラブルシューティングガイド](#)