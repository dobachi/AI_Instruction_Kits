# モジュラー指示書システム

## 概要

このディレクトリは、AI指示書をモジュール化して動的に組み合わせるためのシステムです。

## ディレクトリ構造

```
modular/
├── ja/                # 日本語モジュール
│   ├── modules/       # モジュールファイル
│   │   ├── core/      # コアモジュール
│   │   ├── tasks/     # タスクモジュール
│   │   ├── skills/    # スキルモジュール
│   │   ├── quality/   # 品質モジュール
│   │   └── fragments/ # フラグメント
│   └── templates/     # テンプレートファイル
│       ├── presets/   # プリセット定義
│       └── custom/    # カスタムテンプレート
├── en/                # 英語モジュール
│   ├── modules/       # モジュールファイル
│   │   ├── core/      # コアモジュール
│   │   ├── tasks/     # タスクモジュール
│   │   ├── skills/    # スキルモジュール
│   │   ├── quality/   # 品質モジュール
│   │   └── fragments/ # フラグメント
│   └── templates/     # テンプレートファイル
│       ├── presets/   # プリセット定義
│       └── custom/    # カスタムテンプレート
├── cache/             # 生成済み指示書キャッシュ（言語共通）
└── composer.py        # モジュール合成エンジン
```

## メタデータシステム

各モジュールは同名の`.yaml`ファイルでメタデータを管理します：

- `ja/modules/tasks/web_api_development.md` - モジュール本体（日本語）
- `ja/modules/tasks/web_api_development.yaml` - メタデータ（日本語）
- `en/modules/tasks/web_api_development.md` - モジュール本体（英語）
- `en/modules/tasks/web_api_development.yaml` - メタデータ（英語）

### メタデータファイルの例

```yaml
id: "task_web_api"
name: "Web API開発"
description: "RESTful Web API開発の基本構造"
version: "1.0.0"
tags: ["api", "web", "backend"]
category: "tasks"
variables:
  - name: "framework"
    description: "使用するWebフレームワーク"
    type: "string"
    default: "FastAPI"
```

## 使用方法

### 言語の指定

`-l` または `--lang` オプションで言語を指定できます（デフォルト: ja）：

```bash
# 日本語モジュールを使用（デフォルト）
python modular/composer.py list modules

# 英語モジュールを使用
python modular/composer.py -l en list modules
```

### 基本的な使い方

```bash
# モジュール一覧を表示
./scripts/generate-instruction.sh --list

# モジュールを指定して生成
./scripts/generate-instruction.sh --modules task_web_api skill_tdd

# プリセットを使用（自動的に最適な方法を選択）
./scripts/generate-instruction.sh --preset web_api_production --output api_instruction.md
# → 事前生成版が最新なら即座に使用（0秒）
# → モジュールが更新されていれば自動再生成

# プリセットに追加モジュールを指定
./scripts/generate-instruction.sh --preset web_api_production --modules skill_caching

# キャッシュを更新
./scripts/generate-instruction.sh --refresh-cache
```

## 開発者向け

### 新しいモジュールを追加する手順

1. 適切なカテゴリディレクトリにモジュールファイル（.md）を作成
2. 同名のメタデータファイル（.yaml）を作成
3. **検証スクリプトを実行してメタデータの妥当性を確認**
   ```bash
   ./scripts/validate-modules.sh
   ```
4. エラーがあれば修正
5. キャッシュを更新: `./scripts/generate-instruction.sh --refresh-cache`

### モジュール検証

プロジェクトには、YAMLメタデータの妥当性を検証するスクリプトが含まれています。

#### 必須フィールド
- `id`: カテゴリプレフィックス付き（例: `task_`, `skill_`）
- `name`: モジュール名
- `version`: バージョン番号
- `description`: モジュールの説明

#### よくあるエラー
- `dependencies`は配列形式で記述する必要があります
- `id`はカテゴリに応じたプレフィックスが必要です
- すべての必須フィールドを含める必要があります

詳細は[モジュール作成ベストプラクティス](https://dobachi.github.io/AI_Instruction_Kits/docs/developers/best-practices/module-creation)を参照してください。

---
## ライセンス情報
- **ライセンス**: MIT
- **作成日**: 2025-01-08