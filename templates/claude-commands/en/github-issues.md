---
description: "Check GitHub Issues and organize tasks"
---

# GitHub Issue Check & Organization

Check GitHub Issues for this repository and organize tasks to be done.

## Execution Content

1. **GitHub CLI Authentication Check**
   ```bash
   !gh auth status 2>/dev/null || echo "⚠️ GitHub CLI authentication required: gh auth login"
   ```

2. **Get Open Issues List**
   ```bash
   !echo "📋 Open Issues:"
   !gh issue list --state open --limit 30 --json number,title,labels,assignees,createdAt --template '{{range .}}#{{.number}}: {{.title}}{{if .labels}} [{{range $i, $e := .labels}}{{if $i}}, {{end}}{{.name}}{{end}}]{{end}}{{if .assignees}} (Assigned: {{range $i, $e := .assignees}}{{if $i}}, {{end}}{{.login}}{{end}}){{end}}{{"\n"}}{{end}}'
   ```

3. **Issue Count by Label**
   ```bash
   !echo -e "\n📊 Count by Label:"
   !gh issue list --state open --json labels --jq '[.[] | .labels[].name] | group_by(.) | map({label: .[0], count: length}) | sort_by(.count) | reverse | .[] | "\(.label): \(.count) issues"' | head -10
   ```

4. **Recent Issues (Last 7 days)**
   ```bash
   !echo -e "\n🆕 Recently Created Issues (Last 7 days):"
   !gh issue list --state open --search "created:>$(date -d '7 days ago' +%Y-%m-%d 2>/dev/null || date -v-7d +%Y-%m-%d)" --limit 10 --json number,title,createdAt --template '{{range .}}#{{.number}}: {{.title}} ({{.createdAt | time "2006-01-02"}}){{"\n"}}{{end}}'
   ```

5. **High Priority Issues**
   ```bash
   !echo -e "\n🔥 High Priority Issues:"
   !gh issue list --state open --label "priority:high,bug,critical" --limit 10 --json number,title,labels --template '{{range .}}#{{.number}}: {{.title}} [{{range $i, $e := .labels}}{{if $i}}, {{end}}{{.name}}{{end}}]{{"\n"}}{{end}}'
   ```

6. **Task Organization Suggestions**
   Organize and suggest tasks based on:
   - Priority (judged from labels and creation date)
   - Relevance (grouping similar issues)
   - Implementation order (considering dependencies)
   - Effort estimation

## Usage

```
/github-issues
```

No arguments required. GitHub CLI must be configured.

## Notes

- GitHub CLI authentication required (`gh auth login`)
- Appropriate permissions required for private repositories
- Display is limited when there are many issues (max 10-30 per category)