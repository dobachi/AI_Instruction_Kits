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

3. ROOT_INSTRUCTION.mdに追加（オプション）

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

## 📊 チェックポイント機能の活用

### 作業の記録

チェックポイント機能により、以下が自動記録されます：

```bash
# 記録される内容
[時刻][タスクID][状態] タスク名 (推定ステップ数)
[時刻][タスクID][COMPLETE] 成果: 具体的な成果

# 確認方法
cat checkpoint.log
```

### 進捗の可視化

```bash
# 完了タスク数
grep "COMPLETE" checkpoint.log | wc -l

# 本日の作業
grep "$(date +%Y-%m-%d)" checkpoint.log

# エラーの確認
grep "ERROR" checkpoint.log
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