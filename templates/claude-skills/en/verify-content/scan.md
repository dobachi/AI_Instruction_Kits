# Identifying Verification Targets (Scan)

Systematically analyze text to identify statements requiring verification.

## Check Categories

### 1. Factual Statements
- Historical facts (dates, events, persons)
- Scientific facts (laws, principles, phenomena)
- Geographic facts (locations, distances, spatial relationships)
- Legal and regulatory statements

### 2. Quantitative Claims
- Numerical data (statistics, percentages, amounts)
- Dates and durations (specific dates, deadlines, frequency)
- Rankings and ratings
- Comparative figures (growth rates, ratios)

### 3. Definitive Expressions
- Assertions ("is", "are", "was")
- Emphatic language ("always", "never", "absolutely")
- Superlatives ("the only", "the first", "the largest")
- Causal claims ("because of", "due to", "results in")

### 4. Citations and References
- Quotes from individuals
- Literature and document citations
- Research and survey results
- Official announcements and statements

### 5. Comparisons and Evaluations
- Comparisons ("more than", "compared to")
- Evaluations ("superior", "problematic")
- Generalizations ("most", "many", "typically")

### 6. Existing References and Links
- Reference markers in text ([1], [^1], etc.)
- URL links
- Footnotes and annotations

## Output Format

```markdown
## Verification Targets

### Priority: High
| # | Statement | Type | Verification Needed | Potential Sources |
|---|-----------|------|---------------------|-------------------|
| 1 | "..." | Numerical Data | Verify source and accuracy | Official site, papers |

### Priority: Medium
| # | Statement | Type | Verification Needed | Potential Sources |
|---|-----------|------|---------------------|-------------------|

### Priority: Low
| # | Statement | Type | Verification Needed | Potential Sources |
|---|-----------|------|---------------------|-------------------|

### Existing Reference Check
| # | Reference | Link/Source | Verification Needed |
|---|-----------|-------------|---------------------|
| 1 | [1] | https://... | Link alive, content match |
```

## Priority Criteria

- **High**: Numerical data, citations, legal/regulatory statements, content affecting reader decisions
- **Medium**: General factual statements, comparisons, historical facts
- **Low**: Generalizations, subjective evaluations, widely known facts

## Notes

- This step only performs identification
- Actual verification is done in [verify.md](verify.md)
- Save results as Issues or documents for reference
