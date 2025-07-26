# レポートディレクトリ

このディレクトリには、システムの運用データとレポートが保存されます。

## 構造

```
reports/
├── presets/                    # プリセットシステム関連
│   ├── monitoring/            # モニタリングレポート
│   │   ├── daily/            # 日次レポート（自動生成）
│   │   ├── weekly/           # 週次サマリー
│   │   └── monthly/          # 月次詳細レポート
│   ├── feedback/             # ユーザーフィードバック
│   │   ├── current.md        # 現在のフィードバック
│   │   └── archive/          # 過去のフィードバック
│   └── logs/                 # ログファイル
│       ├── monitor.log       # 現在のモニタリングログ
│       └── archive/          # ローテート済みログ
└── README.md                 # このファイル
```

## Git管理ポリシー

### Git管理対象
- `feedback/current.md` - 重要なユーザーフィードバック
- `monitoring/weekly/` - 週次サマリーレポート
- `monitoring/monthly/` - 月次詳細レポート
- `README.md` - ドキュメント

### Git除外対象（.gitignore）
- `monitoring/daily/` - 日次自動生成レポート
- `logs/*.log` - ログファイル
- `logs/archive/` - アーカイブ済みログ
- 一時ファイル（*.tmp, *.bak）

## 使用方法

### モニタリングレポートの生成
```bash
# 詳細レポートを生成（monthly/に保存することを推奨）
./scripts/monitor-presets.sh report
```

### フィードバックの記録
`feedback/current.md`に直接記録するか、以下のフォーマットで追記：

```markdown
## YYYY-MM-DD - [プリセット名]
### [カテゴリ：良かった点/改善点/新規提案]
- 具体的な内容
```

### ログの確認
```bash
# 現在のログを確認
tail -f reports/presets/logs/monitor.log

# 特定の日付のログを検索
grep "2025-07-27" reports/presets/logs/monitor.log
```

## メンテナンス

### ログのローテーション（月次）
```bash
# 現在のログをアーカイブ
mv reports/presets/logs/monitor.log reports/presets/logs/archive/monitor-$(date +%Y%m).log
touch reports/presets/logs/monitor.log
```

### フィードバックのアーカイブ（四半期ごと）
```bash
# 現在のフィードバックをアーカイブ
cp reports/presets/feedback/current.md reports/presets/feedback/archive/feedback-$(date +%Y-Q%q).md
echo "# プリセットフィードバック" > reports/presets/feedback/current.md
```

## 関連ツール

- `scripts/monitor-presets.sh` - モニタリングとレポート生成
- `scripts/generate-all-presets.sh` - プリセット生成
- `.github/workflows/regenerate-presets.yml` - 自動化ワークフロー