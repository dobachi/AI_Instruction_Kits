# Source Verification (Verify)

Verify identified statements using reliable sources.

## Verification Process

### Step 1: Identify Sources

1. Gather related information via web search
2. Prioritize official sites, academic papers, reputable media
3. Obtain multiple independent sources

### Step 2: Retrieve and Verify Actual Content

**Important**: Do not trust AI search results blindly. Always verify by retrieving actual page content.

#### Using WebFetch Tool
```
WebFetch: Retrieve actual content from URL
```

#### For AI-Blocked Sites
When WebFetch is blocked, use CLI tools:

```bash
# Fetch page with curl
curl -s -L "https://example.com/page" | head -200

# Specify User-Agent if needed
curl -s -L -A "Mozilla/5.0" "https://example.com/page"

# Extract text from HTML (if w3m available)
curl -s -L "https://example.com/page" | w3m -dump -T text/html

# Extract specific elements (with grep)
curl -s -L "https://example.com/page" | grep -A5 "keyword"
```

### Step 3: Verify and Judge

For each item, confirm:

| Check Item | Description |
|------------|-------------|
| Consistency | Does source content match the original statement? |
| Accuracy | Are numbers and dates correct? |
| Context | Is the citation used in proper context? |
| Currency | Is the information current? (especially for statistics, regulations) |

## Verdict Criteria

| Verdict | Condition |
|---------|-----------|
| ✅ Accurate | Confirmed by reliable source, content matches |
| ⚠️ Needs Revision | Mostly accurate but requires minor corrections |
| ❌ Incorrect | Contradicts facts or significantly misleading |
| ❓ Unverifiable | No reliable source found or inaccessible |

## Output Format

```markdown
### Item 1: "[Statement]"

**Verdict**: ✅ Accurate / ⚠️ Needs Revision / ❌ Incorrect / ❓ Unverifiable

**Verification Details**:
- Source checked: [URL/document name]
- Retrieval method: WebFetch / curl
- Date checked: YYYY-MM-DD

**Findings**:
[Comparison between source information and original statement]

**Recommended Action**:
[Specific suggestions if correction needed]
```

## Handling Broken Links and Misidentification

- For 404 errors, check Wayback Machine (archive.org) for archived versions
- Watch for redirects to similar URLs (content may differ)
- Consider possible domain changes

```bash
# Check Wayback Machine
curl -s "https://archive.org/wayback/available?url=example.com/page"
```

## Source Reliability Assessment

| Level | Source Type | Treatment |
|-------|-------------|-----------|
| High | Official announcements, academic papers, government statistics | Use primarily |
| Medium | Major media, expert opinions | Cross-verify with multiple sources |
| Low | Personal blogs, SNS | Use as supplementary only |

## When Verification Fails

- Clearly mark as "Unverifiable"
- Document why verification was not possible
- Suggest alternative verification methods if available
- Consider removing the statement or adding a caveat
