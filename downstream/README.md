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
for repo in */; do
  [ -d "$repo/.git" ] || continue
  echo "=== $repo ==="
  (cd "$repo" && git submodule update --remote instructions/ai_instruction_kits && git add -A && git commit -m "chore: update ai_instruction_kits submodule" && git push)
done
```
