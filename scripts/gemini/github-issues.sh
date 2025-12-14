#!/bin/bash
set -e

if ! command -v gh &> /dev/null;
then
    echo "⚠️ 'gh' (GitHub CLI) コマンドが見つかりません。"
    echo "インストールしてください: https://github.com/cli/cli#installation"
    exit 1
fi

if ! gh auth status &> /dev/null;
then
    echo "⚠️ GitHub CLIが認証されていません。"
    echo "実行してください: gh auth login"
    exit 1
fi

echo "📋 オープンなIssue一覧 (最大30件):"
gh issue list --state open --limit 30 --json number,title,labels,assignees,createdAt --template '{{range .}}#{{.number}}: {{.title}}{{if .labels}} [{{range $i, $e := .labels}}{{if $i}}, {{end}}{{.name}}{{end}}]{{end}}{{if .assignees}} (担当: {{range $i, $e := .assignees}}{{if $i}}, {{end}}{{.login}}{{end}}){{end}}{"\n"}}{{end}}'

echo ""
echo "📊 ラベル別集計 (トップ10):"
gh issue list --state open --json labels --jq '[.[] | .labels[].name] | group_by(.) | map({label: .[0], count: length}) | sort_by(.count) | reverse | .[] | "\(.label): \(.count)件"' | head -10

# OSに応じてdateコマンドを使い分ける
DATE_CMD=""
if [[ "$(uname)" == "Darwin" ]]; then # macOS
    DATE_CMD="date -v-7d +%Y-%m-%d"
else # Linux
    DATE_CMD="date -d '7 days ago' +%Y-%m-%d"
fi

echo ""
echo "🆕 最近作成されたIssue（7日以内）:"
gh issue list --state open --search "created:>$(eval $DATE_CMD)" --limit 10 --json number,title,createdAt --template '{{range .}}#{{.number}}: {{.title}} ({{.createdAt | time "2006-01-02"}}){{"\n"}}{{end}}'

echo ""
echo "🔥 高優先度Issue (priority:high,bug,critical):"
gh issue list --state open --label "priority:high,bug,critical" --limit 10 --json number,title,labels --template '{{range .}}#{{.number}}: {{.title}} [{{range $i, $e := .labels}}{{if $i}}, {{end}}{{.name}}{{end}}]{{"\n"}}{{end}}'
