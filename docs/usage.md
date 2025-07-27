---
layout: default
title: AI Instruction Kits
description: 使用ガイド - 詳細な使い方とベストプラクティス
lang: ja
---

# 使用ガイド

AI Instruction Kitsの詳細な使い方とベストプラクティスをご紹介します。

## 📖 基本的な使い方

### 1. 単一の指示書を使う場合

特定の指示書を直接参照する最もシンプルな方法：

```bash
# Claude の場合
claude "instructions/ja/coding/basic_code_generation.md を参照して、フィボナッチ数列を生成するコードを書いて"

# ChatGPT/Gemini の場合（ファイルをアップロード後）
"指示書に従って、RESTful APIを設計してください"
```

### 2. 複数の指示書を組み合わせる場合

ROOT_INSTRUCTION.mdを使用すると、AIが自動的に適切な指示書を選択：

```bash
claude "ROOT_INSTRUCTION.md を参照して、売上データを分析してレポートを作成"
```

### 3. プロジェクト統合後の使い方

セットアップ完了後は、シンプルに：

```bash
claude "CLAUDE.mdを参照して、ユーザー認証機能を実装"
```

## 🎯 効果的な使い方

### パターン1: 段階的適用

複雑なタスクを段階的に処理：

```markdown
ステップ1: instructions/ja/analysis/basic_data_analysis.md でデータを分析
ステップ2: instructions/ja/writing/basic_text_creation.md で報告書作成
ステップ3: instructions/ja/creative/basic_creative_work.md で改善提案
```

### パターン2: 役割分担

メインとサポートの指示書を組み合わせ：

```markdown
メイン: instructions/ja/coding/basic_code_generation.md
サポート: instructions/ja/general/basic_qa.md （技術的質問への回答用）
```

### パターン3: エージェント型の活用

特定の専門家として振る舞わせる：

```bash
claude "instructions/ja/agent/python_expert.md を参照して、
このPythonコードを最適化してください"
```

## ⚙️ カスタマイズ

### PROJECT.mdの編集

プロジェクト固有の設定を追加：

```markdown
## プロジェクト固有の追加指示

### コーディング規約
- ESLint設定: .eslintrc.js に従う
- 命名規則: キャメルケース
- コメント: JSDoc形式

### テスト要件
- カバレッジ: 80%以上
- E2Eテスト: Cypressを使用

### ビルド設定
- ビルドコマンド: npm run build
- リントコマンド: npm run lint
- テストコマンド: npm run test
```

### 新しい指示書の追加

1. テンプレートをコピー：
```bash
cp templates/ja/instruction_template.md instructions/ja/[category]/my_instruction.md
```

2. 内容を編集

3. メタデータを生成：
```bash
./scripts/generate-metadata.sh instructions/ja/[category]/my_instruction.md
```

4. ROOT_INSTRUCTION.mdに追加（オプション）

## 🔍 検索機能の活用（新機能）

### 基本的な検索

```bash
# キーワード検索
./scripts/search-instructions.sh python

# カテゴリで絞り込み
./scripts/search-instructions.sh -c coding

# 言語で絞り込み
./scripts/search-instructions.sh -l ja

# 詳細情報を表示
./scripts/search-instructions.sh -f detail marp
```

### 🆕 AI分析によるモジュール推奨

```bash
# タスクを自然言語で指定してAIが最適なモジュールを推奨
./scripts/generate-instruction.sh --metadata \
  --prompt "RESTful APIとデータベース統合を含むWebサービス開発"

# プリセットをカスタマイズ
./scripts/generate-instruction.sh --preset web_api_production \
  --modules skill_testing skill_deployment \
  --variable framework=FastAPI
```

### 複合検索

```bash
# 日本語のコーディング指示書を検索
./scripts/search-instructions.sh -l ja -c coding

# Pythonに関するエージェント型指示書を詳細表示
./scripts/search-instructions.sh -c agent -f detail python
```

### Python APIを使った検索

```python
# scripts/select-instruction.pyを使用
python3 scripts/select-instruction.py --search "API開発"
python3 scripts/select-instruction.py --category agent
python3 scripts/select-instruction.py --id ja_agent_python_expert
```

### メタデータの管理

```bash
# 全指示書のメタデータを再生成
./scripts/generate-metadata.sh

# メタデータの整合性チェック（ファイルサイズやチェックサムを確認）
ls -la instructions/**/*.yaml
```

### 組織用カスタマイズ例

```markdown
# 社内プロジェクト用設定
## ベース指示書
- instructions/ja/coding/basic_code_generation.md

## 追加ルール
- 社内コーディング規約に従う
- セキュリティガイドラインを遵守
- コメントは英語で記述
- 機密情報は含めない
```

## 📊 チェックポイント機能の活用（拡張版）

### 作業の記録

チェックポイント機能により、タスクと指示書使用が詳細に記録されます：

```bash
# タスク管理
scripts/checkpoint.sh start "新機能実装" 5
scripts/checkpoint.sh progress TASK-123 3 5 "実装完了" "テスト作成"
scripts/checkpoint.sh complete TASK-123 "5機能実装、テスト20個作成"

# 指示書使用の追跡（新機能）
scripts/checkpoint.sh instruction-start "instructions/ja/presets/web_api_production.md" "API開発" TASK-123
scripts/checkpoint.sh instruction-complete "instructions/ja/presets/web_api_production.md" "3エンドポイント実装" TASK-123

# AI向け簡潔モード（新機能）
scripts/checkpoint.sh ai pending
scripts/checkpoint.sh ai progress TASK-123 3 5 "実装中" "テスト作成"
```

### 進捗の可視化

```bash
# 統計表示（新機能）
scripts/checkpoint.sh stats

# 指示書使用履歴（新機能）
scripts/checkpoint.sh history

# 本日の作業
grep "$(date +%Y-%m-%d)" checkpoint.log

# タスクの詳細
scripts/checkpoint.sh summary TASK-123
```

## 🆕 Claude Code カスタムコマンド

Claude Codeユーザーは以下のコマンドが利用可能：

```bash
# チェックポイント管理
/checkpoint start "新機能実装" 5
/checkpoint progress 3 5 "実装完了" "テスト作成"

# コミット関連
/commit-and-report "バグ修正完了"  # コミット＆Issue報告
/commit-safe "ドキュメント更新"    # クリーンコミット（AI署名なし）

# 指示書管理
/reload-instructions  # 指示書の再読み込み
```

## 🔍 トラブルシューティング

### Q: 指示が競合する場合は？

A: より具体的な指示を優先。PROJECT.mdで優先順位を明記。

```markdown
## 指示の優先順位
1. PROJECT.md（最優先）
2. 個別タスクの指示
3. カテゴリ別指示書
4. 基本指示書
```

### Q: 指示書が長すぎる場合は？

A: 必要な部分のみ抜粋するか、要約版を作成。

```bash
# 特定セクションのみ使用
"instructions/ja/coding/basic_code_generation.mdの「エラーハンドリング」セクションを参照"
```

### Q: 言語を混在させたい場合は？

A: 各指示で明示的に言語を指定。

```markdown
- 日本語で説明: instructions/ja/general/basic_qa.md
- 英語でコード: instructions/en/coding/basic_code_generation.md
```

## 🎯 ベストプラクティス

### 1. 適切な指示書の選択
- タスクに最も適した指示書を選ぶ
- 必要以上に多くの指示書を使わない
- 明確な目的を持って組み合わせる

### 2. カスタマイズの管理
- PROJECT.mdに集約
- バージョン管理で変更履歴を記録
- チームで共有

### 3. フィードバックループ
- 使用結果を評価
- 指示書を継続的に改善
- ベストプラクティスを文書化

## 📚 さらに詳しく

- [機能詳細](features) - すべての機能の詳細説明
- [クイックスタート](quickstart) - 5分で始める方法
- [GitHub](https://github.com/dobachi/AI_Instruction_Kits) - ソースコード

<div style="margin-top: 3em; padding: 1em; background-color: #f0f8ff; border-radius: 8px;">
  <h3>💡 ヒント</h3>
  <p>最初は基本的な指示書から始めて、徐々に高度な機能を使っていくことをお勧めします。</p>
</div>