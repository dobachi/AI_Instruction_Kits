# モジュラー指示書システム

## 概要

このディレクトリは、AI指示書をモジュール化して動的に組み合わせるためのシステムです。

## ディレクトリ構造

```
modular/
├── modules/           # モジュールファイル
│   ├── core/         # コアモジュール
│   ├── tasks/        # タスクモジュール
│   ├── skills/       # スキルモジュール
│   └── quality/      # 品質モジュール
├── templates/         # テンプレートファイル
│   ├── presets/      # プリセット定義
│   └── custom/       # カスタムテンプレート
├── cache/            # 生成済み指示書キャッシュ
└── composer.py       # モジュール合成エンジン
```

## メタデータシステム

各モジュールは同名の`.yaml`ファイルでメタデータを管理します：

- `modules/tasks/web_api_development.md` - モジュール本体
- `modules/tasks/web_api_development.yaml` - メタデータ

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

```bash
# モジュール一覧を表示
./scripts/generate-instruction.sh --list

# モジュールを指定して生成
./scripts/generate-instruction.sh --modules task_web_api skill_tdd

# プリセットを使用
./scripts/generate-instruction.sh --preset web_api_production

# キャッシュを更新
./scripts/generate-instruction.sh --refresh-cache
```

## 開発者向け

新しいモジュールを追加する手順：

1. 適切なカテゴリディレクトリにモジュールファイル（.md）を作成
2. 同名のメタデータファイル（.yaml）を作成
3. キャッシュを更新: `./scripts/generate-instruction.sh --refresh-cache`

---
## ライセンス情報
- **ライセンス**: MIT
- **作成日**: 2025-01-08