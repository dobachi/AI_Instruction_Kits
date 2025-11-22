# Evidence Check

Verify the validity of references and citations in reports and academic papers.

## Execution Details

1. **Reference Existence Check**
   - Check if linked content exists
   - Verify accessibility

2. **Citation Consistency Check**
   - Verify content matches citations
   - Confirm accuracy of numerical data and objective information

3. **Contextual Appropriateness Check**
   - Verify citations are contextually appropriate
   - Confirm alignment with source intent

## Usage

```
/evidence-check [file path or text]
```

### Without Arguments (Full Check)

```
/evidence-check
```

Searches for document files (.md, .txt, .tex, etc.) under the current directory
and checks all references and citations.

### With Arguments (Specific Check)

```
/evidence-check docs/report.md
/evidence-check "Chapter 3 statistical data"
```

Checks only the specified file or relevant section.

## Execution Steps

### 1. Identify Target Files

When argument is specified:
- If file path: Target that file
- If text: Search for relevant sections

Without arguments:
- Search for document files under current directory
- Target .md, .txt, .tex, .docx, etc.

### 2. Extract References

Detect the following patterns:
- URL links: `http://...`, `https://...`
- Literature citations: `[1]`, `(Smith, 2020)`, `※Reference: ...`
- Footnote references: `^[...]`, footnote format
- Image/table sources: `Source: ...`, `出典: ...`

### 3. Parallel Checking (Multiple References)

**Parallel Processing Using Task Tool:**

```
When there are 5+ references, launch multiple investigation agents
in parallel using the Task tool for efficient checking.
```

Each agent executes:
- Fetch content using WebFetch tool
- Verify consistency with citations
- Report results

### 4. Consistency Verification

For each reference:
1. **Access Check**: Fetch content with WebFetch
2. **Content Check**: Verify cited numbers/information exist
3. **Context Check**: Verify appropriate use of citation

### 5. Generate Report

Output check results in the following format:

```markdown
## Evidence Check Results

### ✅ No Issues (X items)

| Location | Reference | Verification |
|----------|-----------|--------------|
| p.5 | https://example.com/data | Statistical data matches |

### ⚠️ Needs Review (Y items)

| Location | Reference | Issue |
|----------|-----------|-------|
| p.12 | https://old-site.com | Broken link |
| p.20 | (Smith, 2020) | Slight numerical discrepancy |

### ❌ Problems Found (Z items)

| Location | Reference | Issue |
|----------|-----------|-------|
| p.15 | https://404.com | Page not found |
| p.25 | (Jones, 2019) | Citation content mismatches source |

## Recommended Actions

1. Fix broken links
2. Re-verify numerical data
3. Correct or remove mismatched citations
```

## Usage Examples

### Example 1: Check Specific File

```
/evidence-check docs/research-paper.md
```

→ Check all references in research-paper.md

### Example 2: Check Specific Chapter

```
/evidence-check "Chapter 3 Experimental Results"
```

→ Check only references related to Chapter 3

### Example 3: Check Entire Project

```
/evidence-check
```

→ Check references in all document files

## Implementation Details

### Parallel Processing Criteria

```
When reference count is 5+:
  → Parallel check with Task tool (max 5 concurrent agents)

When reference count is < 5:
  → Sequential check
```

### Check Priority

**High Priority (Required):**
- Link existence verification
- Numerical data consistency

**Medium Priority (Recommended):**
- Contextual appropriateness
- Alignment with source intent

**Low Priority (Optional):**
- Citation format consistency
- Reference list completeness

## Notes

- Some sites may be inaccessible due to WebFetch limitations
- Dynamic content (JavaScript required) may not be properly fetched
- Paid content or authenticated pages cannot be checked
- Large numbers of references (50+) may take significant time

## Error Handling

- **Network Error**: Suggest possible temporary issue
- **404 Error**: Report as broken link
- **Access Denied**: Suggest authentication may be required
- **Timeout**: Suggest slow site response

---

**Important**: This command checks technical validity of references,
but academic/professional content accuracy requires expert review.
