# Claude Code エージェント機能活用ガイド

## 概要

このドキュメントでは、AI指示書キットでClaude Codeのエージェント機能（Task tool）を活用する方法を説明します。

## エージェント機能とは

Claude Codeのエージェント機能は、複雑なマルチステップタスクを自律的に実行するための機能です。Task toolを通じて起動され、指定されたタスクを独立して完了します。

### 利用可能なエージェントタイプ

1. **general-purpose**: 汎用エージェント
   - 複雑な検索、コード探索、マルチステップタスクの実行
   - すべてのツールにアクセス可能

2. **statusline-setup**: ステータスライン設定エージェント
   - Claude Codeのステータスライン設定用
   - Read, Editツールにアクセス

3. **output-mode-setup**: 出力モード設定エージェント
   - Claude Codeの出力モード作成用
   - Read, Write, Edit, Glob, LSツールにアクセス

## 実装済みツール

### 1. instruction-analyzer.sh

AI指示書の分析をエージェント経由で実行するシェルスクリプト。

```bash
# 使用例
./scripts/instruction-analyzer.sh --mode quality --lang ja
./scripts/instruction-analyzer.sh --mode duplicate --lang all
./scripts/instruction-analyzer.sh --mode optimize --output json
```

**分析モード:**
- `quality`: 品質チェック
- `duplicate`: 重複検出
- `optimize`: 最適化提案
- `all`: すべての分析を実行

### 2. agent_tasks.py

Pythonベースの詳細なエージェントタスク生成ツール。

```bash
# 使用例
python scripts/agent_tasks.py --mode quality --lang ja
python scripts/agent_tasks.py --mode coverage --format json
python scripts/agent_tasks.py --mode all --execute
```

**追加モード:**
- `coverage`: カバレッジ分析
- `dependency`: 依存関係分析

## Claude Code内での実行方法

### 基本的な使用方法

Claude Code内で以下のようにTask toolを呼び出します：

```javascript
// 品質チェックの実行
Task({
    description: "品質チェック-ja",
    prompt: `AI指示書キットの品質チェックを実行してください...`,
    subagent_type: "general-purpose"
})
```

### スクリプト経由の実行

1. **タスク定義の生成**
```bash
python scripts/agent_tasks.py --mode quality --execute > task.txt
```

2. **Claude Code内でタスクを実行**
生成されたタスク定義をClaude Codeにコピーして実行

## 活用シナリオ

### シナリオ1: 新しい指示書追加時の品質チェック

```bash
# 1. 新しい指示書を追加
cp templates/ja/instruction_template.md instructions/ja/development/new_instruction.md

# 2. 品質チェックを実行
./scripts/instruction-analyzer.sh --mode quality --lang ja

# 3. 結果を確認して修正
```

### シナリオ2: 定期的な重複検出

```bash
# 週次で実行
./scripts/instruction-analyzer.sh --mode duplicate --lang all --output yaml
```

### シナリオ3: リリース前の包括的分析

```bash
# すべての分析を実行
python scripts/agent_tasks.py --mode all --output report.json
```

## ベストプラクティス

### 1. タスクの粒度

- **大きすぎるタスク**: 全プロジェクトの分析 → タイムアウトのリスク
- **適切なサイズ**: 言語別、カテゴリ別の分析 → 効率的で管理しやすい
- **小さすぎるタスク**: 単一ファイルの分析 → オーバーヘッドが大きい

### 2. プロンプトの書き方

#### 良い例
```python
prompt = """
対象: instructions/ja/development/
チェック項目:
1. 必須セクションの有無
2. コード例の文法チェック
出力: JSON形式で構造化
"""
```

#### 悪い例
```python
prompt = "指示書をチェックして"  # 曖昧すぎる
```

### 3. 結果の処理

エージェントの結果は自動的にユーザーに表示されないため、明示的に処理が必要：

```python
# 結果の保存
result = run_agent_task(task)
save_to_file(result, "analysis_result.json")

# 結果の要約表示
summary = extract_summary(result)
print(f"分析完了: {summary['total_issues']}件の問題を検出")
```

## トラブルシューティング

### よくある問題と解決方法

1. **タスクがタイムアウトする**
   - 対象ファイルを減らす
   - 処理を分割する

2. **結果が期待と異なる**
   - プロンプトをより具体的にする
   - 出力形式を明確に指定する

3. **エージェントが利用できない**
   - Claude Codeのバージョンを確認
   - 権限設定を確認

## 今後の拡張計画

### Phase 1 (実装済み)
- [x] 基本的な分析スクリプト
- [x] Task定義生成ツール
- [x] ドキュメント整備

### Phase 2 (計画中)
- [ ] CI/CD統合
- [ ] 自動実行スケジューラー
- [ ] 結果の可視化ダッシュボード

### Phase 3 (将来)
- [ ] カスタムエージェントの開発
- [ ] 機械学習による最適化
- [ ] 他のAIツールとの連携

## 関連ドキュメント

- [Claude Code サブエージェント機能調査報告書](../reports/claude_code_subagent_investigation.md)
- [Claude Code公式ドキュメント](https://docs.anthropic.com/en/docs/claude-code)
- [AI指示書キット開発ガイド](../README.md)

## サポート

問題や質問がある場合は、GitHubのIssueで報告してください：
https://github.com/dobachi/AI_Instruction_Kits/issues