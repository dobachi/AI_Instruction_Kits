# downstream/

このディレクトリには、AI_Instruction_Kitsをサブモジュールとして利用しているプロジェクトのクローンを配置します。
`.gitignore`対象のため、Git管理には含まれません（このREADMEを除く）。

## 配置リポジトリ

| リポジトリ | URL |
|-----------|-----|
| ResearchTemplate | git@github.com:dobachi/ResearchTemplate.git |
| DevProjectTemplate | git@github.com:dobachi/DevProjectTemplate.git |
| PresentationTemplate | git@github.com:dobachi/PresentationTemplate.git |
| DeliberationTemplate | git@github.com:dobachi/DeliberationTemplate.git |

## サブモジュール一括更新

```bash
# プロジェクトルートから実行
bash scripts/update-downstream.sh

# ドライラン（確認のみ）
bash scripts/update-downstream.sh --dry-run

# 特定リポジトリのみ
bash scripts/update-downstream.sh ResearchTemplate
```
