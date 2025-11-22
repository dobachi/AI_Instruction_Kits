# Evidence Check

Verify the validity of references and citations in reports and academic papers, and fix identified issues.

## Execution Details

1. **Reference Existence Check**
   - Check if linked content exists
   - Attempt multiple access methods (WebFetch, alternatives)
   - Request human assistance when inaccessible

2. **Citation Consistency Check**
   - Verify content matches citations
   - Confirm accuracy of numerical data and objective information
   - Present correct information when mismatches found

3. **Contextual Appropriateness Check**
   - Verify citations are contextually appropriate
   - Confirm alignment with source intent

4. **Auto-fix and Human Assistance**
   - Present automatic fix proposals for correctable issues
   - Request user confirmation for AI-inaccessible content
   - Re-check after fixes applied

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
When there are 2+ references, launch multiple investigation agents
in parallel using the Task tool for efficient checking.
```

Each agent executes:
- Fetch content using WebFetch tool
- Verify consistency with citations
- Report results

### 4. Consistency Verification (Multi-stage Approach)

For each reference:

**Step 1: Access Attempts**
1. Attempt content fetch with WebFetch tool
2. If failed, try alternative approaches:
   - URL variations (http/https, with/without www)
   - Check Archive.org snapshots
   - Verify DOI redirects
3. If all fail:
   - Request manual verification from user
   - Ask via AskUserQuestion tool: "Can you access this URL?"
   - If accessible, request content summary from user

**Step 2: Content Verification**
1. Verify cited numbers/information exist in source
2. When mismatches found:
   - Identify correct information
   - Present fix proposal
   - Request user confirmation

**Step 3: Context Verification**
1. Evaluate appropriateness of citation usage
2. Check for misleading citations
3. Present improvement proposals when issues found

### 5. Generate Report and Fix Proposals

Output check results in the following format:

```markdown
## Evidence Check Results

### ✅ No Issues (X items)

| Location | Reference | Verification |
|----------|-----------|--------------|
| p.5 | https://example.com/data | Statistical data matches |

### 🔧 Auto-fixable (Y items)

| Location | Reference | Issue | Fix Proposal |
|----------|-----------|-------|--------------|
| p.20 | (Smith, 2020) | Shows 3.5%, source says 3.6% | Update to "3.6%" |
| p.30 | https://old-site.com | Broken link (new URL found) | Update to `https://new-site.com` |

**Apply fixes? [Y/n]**

### ⚠️ Human Verification Needed (Z items)

| Location | Reference | Issue | Action Required |
|----------|-----------|-------|-----------------|
| p.12 | https://paywalled.com | AI cannot access | Awaiting user verification |
| p.25 | (Jones, 2019) | Context appropriateness unclear | Expert review recommended |

**Items requiring verification:**

#### 📋 Item 1: p.12 paywalled content
- **URL**: https://paywalled.com/article
- **Citation**: "Market share is 45%"
- **Status**: Authentication required, AI cannot access
- **Request**: Can you access this URL? If so, please provide
  information about "market share" mentioned in the article.

#### 📋 Item 2: p.25 context verification
- **Citation**: "Jones (2019) states this method is effective"
- **Source**: "This method is effective only under specific conditions"
- **Issue**: Omitted conditions, potentially misleading
- **Proposal**: "Jones (2019) states this method is effective under specific conditions"

### ❌ Critical Issues (W items)

| Location | Reference | Issue | Recommended Action |
|----------|-----------|-------|-------------------|
| p.15 | https://404.com | Page not found (not in Archive.org) | Remove citation or find alternative |
| p.40 | (Black, 2018) | No matching content in source | Remove citation |

## Next Steps

1. **Apply Auto-fixes** (Select Y/n)
2. **Address Human Verification Items** (Respond to requests above)
3. **Fix Critical Issues** (Document editing required)
4. **Re-check** (Run evidence-check again after fixes)
```

### 6. Interactive Fix Process

When fixes are needed:

1. **Auto-fixable Items**
   - Request user confirmation (AskUserQuestion tool)
   - Apply automatic fixes with Edit tool when approved
   - Log fix details

2. **Human Verification Items**
   - Ask specific questions via AskUserQuestion tool
   - Receive user responses
   - Propose appropriate actions based on responses

3. **Critical Issues**
   - Discuss fix strategy with user
   - Present alternatives
   - Apply fixes based on agreed approach

4. **Re-check**
   - Automatically re-run check after fixes
   - Repeat until all issues resolved

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
When reference count is 2+:
  → Parallel check with Task tool (max 5 concurrent agents)

When reference count is 1:
  → Single check
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

## Notes and Best Practices

### AI Limitations and Workarounds

**Access Restrictions:**
- WebFetch cannot directly access some sites
- Workaround: Try multiple methods, request human assistance when all fail

**Dynamic Content:**
- JavaScript-required pages may not be properly fetched
- Workaround: Try Archive.org or cached sites

**Authenticated Content:**
- Paid content or member-only pages are AI-inaccessible
- Workaround: Request manual verification from user and obtain content summary

### Efficient Usage

1. **Staged Checking**:
   - First check entire document to identify errors
   - Fix identified issues
   - Re-check to verify

2. **Human Collaboration**:
   - Don't hesitate to request assistance for AI-inaccessible areas
   - Leverage user expertise (context appropriateness judgment)

3. **Regular Execution**:
   - After major document updates
   - Quality check before final submission
   - When adding references

## Error Handling

- **Network Error**: Suggest possible temporary issue
- **404 Error**: Report as broken link
- **Access Denied**: Suggest authentication may be required
- **Timeout**: Suggest slow site response

---

**Important**: This command checks technical validity of references,
but academic/professional content accuracy requires expert review.
