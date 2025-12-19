# Reference Management (Reference)

After verification, manage references according to project specifications.

## Workflow

### Step 1: Check Project Specifications

First, review the reference management rules of the target document or project:

- Reference list format (style, placement)
- Cross-reference notation (footnotes, inline, numbered references)
- Citation style (APA, IEEE, custom format, etc.)

### Step 2: Add to Reference List

Add confirmed sources to the reference list:

```markdown
## References

1. [Title](URL) - Author/Organization, Publication date/Access date
2. Book Title, Author, Publisher, Year, Pages
```

### Step 3: Add Cross-References in Text

Add references to relevant sections in the text:

```markdown
<!-- Footnote style -->
Japan's population is approximately 120 million[^1].

[^1]: Statistics Bureau of Japan "Population Estimates" 2024

<!-- Inline style -->
Japan's population is approximately 120 million (Statistics Bureau of Japan, 2024).

<!-- Numbered reference style -->
Japan's population is approximately 120 million [1].
```

### Step 4: Update Existing References

When existing references have issues:

| Issue | Action |
|-------|--------|
| Broken link | Update to Wayback Machine URL or add note |
| Content mismatch | Correct citation or remove statement |
| Outdated info | Update to latest version or add "as of YYYY" note |

## Citation Style Examples

### APA Format
```
Author (Year). Title. Publisher.
Statistics Bureau of Japan (2024). Population Estimates. https://www.stat.go.jp/...
```

### IEEE Format
```
[1] Author, "Title," Publisher, Year.
[1] Statistics Bureau of Japan, "Population Estimates," 2024. [Online]. Available: https://...
```

### Markdown Footnote Format
```markdown
Statement in text[^1].

[^1]: Source information
```

## Checklist

- [ ] Added sources to reference list
- [ ] Added cross-references in text
- [ ] Reference format complies with project specifications
- [ ] Verified that links work correctly
- [ ] Recorded access date (for web resources)

## Notes

### For Web Resources
- Always record access date
- Include Wayback Machine archive link if possible
- Prefer persistent URLs (PDFs, DOIs)

### Citation Validity
- Prefer primary sources (avoid citing secondary sources)
- Consider copyright (stay within fair use)
- Verify citation is used in proper context

## Output Format

```markdown
## Reference Management Report

### Added References
| # | Source | Referenced in Text |
|---|--------|-------------------|
| 1 | [Statistics Bureau](https://...) | Line 3 "population is..." |

### Updated References
| # | Original | Update |
|---|----------|--------|
| 1 | [1] old URL | Updated to new URL |

### Verification
- [x] All links verified
- [x] Citation format unified
```
