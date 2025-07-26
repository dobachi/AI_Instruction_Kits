# モジュール開発クイックスタート

## 概要

AI指示書キットのモジュール開発を始めるための最短ガイドです。10分で最初のモジュールを作成できます。

## 必要な前提知識

- Markdown記法の基礎
- YAMLの基本的な書き方
- ターミナル/コマンドラインの基本操作

## Step 1: 開発環境の確認

```bash
# プロジェクトルートに移動
cd /path/to/AI_Instruction_Kits

# 検証スクリプトが動作するか確認
./scripts/validate-modules.sh --help
```

## Step 2: 最初のモジュールを作成

### 2.1 テンプレートをコピー

```bash
# 簡単なタスクモジュールを作成する例
cp templates/ja/task_template.md modular/ja/modules/tasks/my_first_task.md
cp templates/ja/task_template.yaml modular/ja/modules/tasks/my_first_task.yaml
```

### 2.2 YAMLメタデータを編集

`modular/ja/modules/tasks/my_first_task.yaml` を開いて編集：

```yaml
id: "task_my_first_task"
name: "私の最初のタスク"
version: "1.0.0"
category: "tasks"
description: "モジュール作成の学習用サンプルタスク"
author: "あなたの名前"
created_date: "2025-01-26"
updated_date: "2025-01-26"

# モジュールタイプ（詳細版か簡潔版か）
module_type: "concise"

# タグ（検索用）
tags:
  - "sample"
  - "learning"
  - "basic"

# 依存関係（必要に応じて）
dependencies: []

# 対象ユーザー
target_users:
  - "モジュール開発初心者"
  - "学習者"
```

### 2.3 Markdownファイルを編集

`modular/ja/modules/tasks/my_first_task.md` を開いて編集：

```markdown
---
# フロントマター（YAMLと同じ内容）
id: "task_my_first_task"
name: "私の最初のタスク"
version: "1.0.0"
---

# 私の最初のタスク

## 目的
{{task_objective}}

## 手順

### 1. 準備
- {{prerequisite_1}}
- {{prerequisite_2}}

### 2. 実行
1. {{step_1}}
2. {{step_2}}
3. {{step_3}}

### 3. 確認
- {{validation_criteria}}

## 出力形式

```
{{output_format}}
```

## 使用例

**入力**:
```
objective: "簡単なWebページを作成する"
step_1: "HTMLファイルを作成"
step_2: "CSSでスタイリング"
step_3: "ブラウザで確認"
```

**出力**:
```html
<!DOCTYPE html>
<html>
<head>
    <title>{{page_title}}</title>
</head>
<body>
    <h1>{{main_heading}}</h1>
    <p>{{content}}</p>
</body>
</html>
```

## 注意事項
- {{important_note}}
- セキュリティを考慮すること
```

## Step 3: 検証

### 3.1 基本検証

```bash
# メタデータの妥当性をチェック
./scripts/validate-modules.sh
```

### 3.2 サイズチェック

```bash
# サイズ基準に適合しているかチェック
./scripts/validate-modules.sh --check-size
```

期待される出力：
```
🔍 モジュールメタデータ検証を開始します...
📏 サイズチェック: 有効
📂 言語: ja
  📁 カテゴリ: tasks
    ✓ my_first_task.yaml
```

## Step 4: 改善のサイクル

1. **検証結果を確認**
   - エラーがあれば修正
   - 警告があれば検討

2. **内容を充実**
   - より具体的な手順を追加
   - 実用的な例を増やす
   - 変数プレースホルダーを適切に配置

3. **再検証**
   - サイズ基準（簡潔版: 50-200行）を確認
   - 内容の一貫性をチェック

## よくある問題と解決法

### Q1: 「module_id命名規則違反」の警告が出る
```
A: idがカテゴリのプレフィックスで始まっていない
解決: tasks カテゴリなら "task_" で始める
例: "task_my_first_task"
```

### Q2: サイズが基準を超えている
```
A: 簡潔版は200行以下に抑える
解決: 
- 冗長な説明を削除
- 詳細は別の詳細版モジュールに移動
- 重要なポイントのみ残す
```

### Q3: 変数プレースホルダーの使い方が分からない
```
A: {{variable_name}} 形式で記述
例: {{task_name}}、{{output_format}}
ユーザーがカスタマイズできる部分に使用
```

## 次のステップ

1. **[02-development-guide.md](./02-development-guide.md)** で詳細な開発方法を学ぶ
2. **[03-template-guide.md](./03-template-guide.md)** でテンプレートを活用する
3. **[examples/](./examples/)** で他のモジュール例を参考にする
4. より複雑なモジュールに挑戦する

## チェックリスト

作成したモジュールが以下を満たしているか確認：

- [ ] YAMLメタデータが正しく設定されている
- [ ] idの命名規則に従っている（カテゴリプレフィックス）
- [ ] サイズ基準に適合している（簡潔版: 50-200行）
- [ ] 変数プレースホルダーが適切に使用されている
- [ ] 実用的な例が含まれている
- [ ] validate-modules.sh で検証が通る
- [ ] 目的と手順が明確に記載されている

---

これで最初のモジュールが完成です！🎉

次は [02-development-guide.md](./02-development-guide.md) でより高度な開発方法を学びましょう。