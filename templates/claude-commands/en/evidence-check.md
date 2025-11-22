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
# Evidence Check Report

**Check Date**: 2025-01-22 14:30:00
**Target File**: docs/research-paper.md
**Total References**: 25

---

## 📊 Summary

| Status | Count | Percentage |
|--------|-------|------------|
| ✅ No Issues | 18 | 72% |
| 🔧 Auto-fixable | 3 | 12% |
| ⚠️ Human Verification Needed | 2 | 8% |
| ❌ Critical Issues | 2 | 8% |

---

## ✅ No Issues (18 items)

<details>
<summary>Show Details</summary>

### 1. Statistical Data Citation
- **File**: docs/research-paper.md:45
- **Citation Location**:
  ```
  The market size was approximately 1.2 trillion yen in 2023[1].
  ```
- **Reference**: [1] https://example.com/market-report-2023
- **Verification**:
  - ✓ Link accessible
  - ✓ Value "1.2 trillion yen" matches source
  - ✓ "2023" also matches
- **Verification Method**: WebFetch → Source comparison
- **Check Time**: 2025-01-22 14:31:15

### 2. Prior Research Citation
- **File**: docs/research-paper.md:78
- **Citation Location**:
  ```
  Smith et al. (2020) demonstrated the effectiveness of this method.
  ```
- **Reference**: Smith, J., Brown, A. (2020). "Effective Methods in AI"
- **Verification**:
  - ✓ Confirmed in literature database
  - ✓ Author names and year accurate
  - ✓ Citation context appropriate
- **Verification Method**: DOI search → Content verification
- **Check Time**: 2025-01-22 14:32:03

[... Details of remaining 16 items ...]

</details>

---

## 🔧 Auto-fixable (3 items)

### 1. Minor Numerical Discrepancy
- **File**: docs/research-paper.md:120
- **Citation Location**:
  ```markdown
  120: The growth rate is reported as an annual average of 3.5% (Smith, 2020).
  ```
- **Reference**: (Smith, 2020) https://example.com/growth-analysis
- **Issue**:
  - Document states: "3.5%"
  - Source states: "3.6%"
  - Difference: 0.1 percentage point
- **Source Quote**:
  ```
  The annual average growth rate was measured at 3.6% over the period.
  ```
- **Fix Proposal**:
  ```diff
  - The growth rate is reported as an annual average of 3.5% (Smith, 2020).
  + The growth rate is reported as an annual average of 3.6% (Smith, 2020).
  ```
- **Target**: docs/research-paper.md:120
- **Auto-fix Command**: Edit tool (old_string → new_string)
- **Verification Method**: WebFetch → Numerical extraction & comparison
- **Discovery Time**: 2025-01-22 14:33:21

### 2. Broken Link (New URL Found)
- **File**: docs/research-paper.md:145
- **Citation Location**:
  ```markdown
  145: See official site[2] for detailed data.
  145: [2]: https://old-site.com/data/report2023.pdf
  ```
- **Reference**: https://old-site.com/data/report2023.pdf
- **Issue**:
  - HTTP Status: 404 Not Found
  - Archive.org: Migration info found
  - New URL: https://new-site.com/resources/report2023.pdf
- **Verification Process**:
  1. WebFetch → 404 error
  2. Archive.org search → Redirect info discovered
  3. New URL verification → Access success, content match confirmed
- **Fix Proposal**:
  ```diff
  - [2]: https://old-site.com/data/report2023.pdf
  + [2]: https://new-site.com/resources/report2023.pdf
  ```
- **Target**: docs/research-paper.md:145
- **Auto-fix Command**: Edit tool
- **Verification Method**: Archive.org → New URL verification
- **Discovery Time**: 2025-01-22 14:34:45

### 3. Protocol Fix (HTTP→HTTPS)
- **File**: docs/research-paper.md:203
- **Citation Location**:
  ```markdown
  203: [5]: http://example.org/paper.pdf
  ```
- **Reference**: http://example.org/paper.pdf
- **Issue**:
  - HTTP access → Auto-redirects to HTTPS
  - Security recommendation: Use HTTPS
- **Fix Proposal**:
  ```diff
  - [5]: http://example.org/paper.pdf
  + [5]: https://example.org/paper.pdf
  ```
- **Target**: docs/research-paper.md:203
- **Auto-fix Command**: Edit tool
- **Verification Method**: HTTPS connection verification
- **Discovery Time**: 2025-01-22 14:35:12

**Apply fixes? [Y/n]**
→ Select Y to batch-fix all 3 items with Edit tool.

---

## ⚠️ Human Verification Needed (2 items)

### 1. Paid Content Access Restriction
- **File**: docs/research-paper.md:167
- **Citation Location**:
  ```markdown
  167: Industry share has reached 45% (Johnson, 2023).
  ```
- **Reference**: Johnson, M. (2023). https://journal.example.com/article/12345
- **Issue**:
  - AI Access: Failed (authentication required)
  - HTTP Status: 403 Forbidden (Paywall)
  - Attempted methods:
    1. WebFetch → Authentication error
    2. DOI search → Confirmed paid journal
    3. Archive.org → No snapshot
- **Citation Content**: "Industry share is 45%"
- **Verification Request**:
  ```
  Can you access this URL?
  https://journal.example.com/article/12345

  If accessible, please provide:
  1. Statements about "industry share" or "market share"
  2. Whether "45%" appears and its context
  3. Summary of relevant paragraph/section
  ```
- **Response Method**: AskUserQuestion tool
- **Discovery Time**: 2025-01-22 14:36:30

### 2. Context Appropriateness Question
- **File**: docs/research-paper.md:189
- **Citation Location**:
  ```markdown
  189: Jones (2019) states this method is effective.
  ```
- **Reference**: Jones, K. (2019). https://example.com/methods-study
- **Issue**:
  - Source text:
    ```
    This method is effective only under specific conditions,
    particularly when the sample size exceeds 1000 participants
    and the control group is properly isolated.
    ```
  - Citation problem: Omits conditions (sample size >1000, proper control group)
  - Potentially misleading: Yes
- **Context Comparison**:
  - Document claim: "This method is (generally) effective"
  - Source claim: "Effective only under specific conditions"
  - Gap: Over-generalization of applicability
- **Fix Proposals**:
  ```diff
  - Jones (2019) states this method is effective.
  + Jones (2019) states this method is effective when
  + the sample size exceeds 1000 participants.
  ```
  or
  ```diff
  - Jones (2019) states this method is effective.
  + Jones (2019) states this method is effective under specific conditions.
  ```
- **Verification Request**:
  ```
  Which fix proposal should we adopt?
  A) Specify concrete condition (sample size >1000)
  B) State "under specific conditions" concisely
  C) Other (free text)
  ```
- **Response Method**: AskUserQuestion tool
- **Discovery Time**: 2025-01-22 14:37:50

---

## ❌ Critical Issues (2 items)

### 1. Page Does Not Exist
- **File**: docs/research-paper.md:98
- **Citation Location**:
  ```markdown
  98: See reference material[3] for details.
  98: [3]: https://oldsite.example.com/report2022.html
  ```
- **Reference**: https://oldsite.example.com/report2022.html
- **Issue**:
  - HTTP Status: 404 Not Found
  - Attempted recovery methods:
    1. WebFetch → 404 error
    2. URL variation attempts → All failed
    3. Archive.org search → 0 snapshots
    4. Domain check → Site closed
- **Impact**: High (source completely lost)
- **Recommended Actions**:
  ```
  Options:
  1. Remove this citation and rewrite the section
  2. Find and replace with equivalent alternative source
  3. Keep with "unavailable" note (not recommended)
  ```
- **Target**: docs/research-paper.md:98
- **Required Work**: Document editing or alternative source research
- **Discovery Time**: 2025-01-22 14:38:45

### 2. Citation Content Mismatches Source
- **File**: docs/research-paper.md:234
- **Citation Location**:
  ```markdown
  234: Black (2018) reports that early intervention improves success rates by 80%.
  ```
- **Reference**: Black, R. (2018). https://example.com/intervention-study
- **Issue**:
  - Document states: "improves success rates by 80%"
  - Actual source content:
    ```
    Early intervention showed a 15% improvement in success rates
    compared to the control group (p < 0.05).
    ```
  - Mismatch: Numbers significantly different (15% vs 80%)
  - "80%" statement: Does not exist in source
- **Source-wide Search Results**:
  - "80%" → 0 matches
  - "eighty percent" → 0 matches
  - "improve.*success" → Only "15% improvement"
- **Possible Causes**:
  1. Confusion with different paper
  2. Memory error
  3. Incorrect calculation/interpretation
- **Impact**: Extremely high (factually incorrect claim)
- **Recommended Actions**:
  ```
  Required response:
  1. Correct to accurate number (15%)
  2. Or remove this citation
  3. Re-investigate "80%" source (possibly different paper)
  ```
- **Fix Proposal**:
  ```diff
  - Black (2018) reports that early intervention improves success rates by 80%.
  + Black (2018) reports that early intervention improves success rates by 15%.
  ```
- **Target**: docs/research-paper.md:234
- **Required Work**: User confirmation and fix strategy decision
- **Discovery Time**: 2025-01-22 14:40:12

---

## 📝 Fix History (Recorded after auto-fix application)

### Fix Session #1
**Execution Time**: 2025-01-22 14:45:00
**Executor**: AI (User approved)

| Item | File:Line | Fix Content | Status |
|------|-----------|-------------|--------|
| 1 | docs/research-paper.md:120 | 3.5% → 3.6% | ✅ Complete |
| 2 | docs/research-paper.md:145 | URL update | ✅ Complete |
| 3 | docs/research-paper.md:203 | HTTP→HTTPS | ✅ Complete |

**Fix Details**:

#### Fix #1
```diff
File: docs/research-paper.md
Line: 120

- The growth rate is reported as an annual average of 3.5% (Smith, 2020).
+ The growth rate is reported as an annual average of 3.6% (Smith, 2020).

Edit tool execution: Success
Verification: Re-check performed → Issue resolved
```

#### Fix #2
```diff
File: docs/research-paper.md
Line: 145

- [2]: https://old-site.com/data/report2023.pdf
+ [2]: https://new-site.com/resources/report2023.pdf

Edit tool execution: Success
Verification: New URL connection check → Access success
```

#### Fix #3
```diff
File: docs/research-paper.md
Line: 203

- [5]: http://example.org/paper.pdf
+ [5]: https://example.org/paper.pdf

Edit tool execution: Success
Verification: HTTPS connection check → Access success
```

**Post-fix re-check result**: 3 issues resolved.

---

## Next Steps

### Immediately Addressable
- [x] 🔧 3 auto-fixable items → Fixed

### User Action Required
- [ ] ⚠️ 2 human verification items
  - [ ] Item 1: Manual verification of paid content
  - [ ] Item 2: Select context fix proposal
- [ ] ❌ 2 critical issues
  - [ ] Item 1: Remove 404 citation or find alternative
  - [ ] Item 2: Fix mismatched data

### Recommended Workflow
1. Respond to ⚠️ items (via AskUserQuestion)
2. Fix ❌ items (manual or AI-assisted)
3. Re-run `/evidence-check` after all fixes
4. Repeat until 0 issues

---

## 📋 Additional Information

### Tools Used for Checking
- WebFetch: 23 executions (success: 20, failed: 3)
- Archive.org: 2 searches
- DOI search: 3 executions
- Grep: Reference pattern search

### Processing Time
- Total execution time: 2 min 15 sec
- Parallel processing: 5 agents used (max concurrent)

### Log Files
- Detailed log: `.evidence-check/log-2025-01-22-143000.json`
- Error log: `.evidence-check/errors-2025-01-22-143000.log`
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
