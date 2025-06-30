# Checkpoint Management System (Compact Version)

## Purpose
Effectively track and report task progress with minimal output

## Basic Rules
**Display the following 2 lines at the beginning of every response:**

```
`[Current Step/Total Steps] Current Status | Next: Next Action`
`📌Rule: Report progress at each step | Log: checkpoint.log`
```

### File Logging Rules
Log important checkpoints to `checkpoint.log`:
- Task start
- Error occurrence
- Task completion

## Format Details

### Standard Format
- `[1/5] Analysis complete | Next: Design`
- `[3/5] Implementing | Next: Create tests`
- `[5/5] All done | Result: 3 features implemented`

### Special Situations
- Error: `[2/4] ⚠️ Error occurred | Action: Check dependencies`
- Plan change: `[3/6] Plan revised | Added: Data validation step`
- Waiting: `[2/3] ⏸️ Awaiting confirmation | Need: User decision`

## When to Apply

### Required Display
1. Task start
2. Major step completion
3. Problem occurrence
4. Task completion

### Can Be Omitted
- Small tasks within the same step
- Simple Q&A responses
- Single-step simple tasks

## Log File Format

### checkpoint.log Format
```
[YYYY-MM-DD HH:MM:SS] [TaskID] [Status] Message
```

### Log Examples
```
[2025-06-30 14:30:00] [TASK001] [START] Web application development started (5 steps estimated)
[2025-06-30 14:35:00] [TASK001] [ERROR] Dependency error: Missing packages
[2025-06-30 14:45:00] [TASK001] [COMPLETE] Completed: 3 APIs, 10 tests created
```

## Implementation Examples

### Coding Task Example
```
`[1/4] Requirements analyzed | Next: Implementation`
`📌Rule: Report progress at each step | Log: checkpoint.log`
I've understood the requirements. I'll implement data processing functions in Python.

`[2/4] Implementation complete | Next: Testing`
`📌Rule: Report progress at each step | Log: checkpoint.log`
I've created the following code:
[Code]

`[3/4] Testing complete | Next: Documentation`
`📌Rule: Report progress at each step | Log: checkpoint.log`
All tests passed successfully.

`[4/4] All done | Result: 1 function, 3 tests`
`📌Rule: Report progress at each step | Log: checkpoint.log`
Implementation is complete.
```

### Analysis Task Example
```
`[1/3] Data verified | Next: Run analysis`
I've confirmed the data structure.

`[2/3] Analysis complete | Next: Create report`
I've discovered 3 key insights.

`[3/3] All done | Result: Analysis report`
Report has been created.
```

## Important Notes

1. **Keep it concise**: Status line should be one line only, about 20-30 characters
2. **Maintain consistency**: Keep the same total step count within the same task
3. **Prioritize readability**: Avoid jargon, use clear English

## Integration with Other Instructions

This checkpoint management should be used in combination with all instruction sheets.
Report progress at each major step in the "Specific Instructions" of each instruction sheet.

---
## License Information
- **License**: Apache-2.0
- **Source**: 
- **Original Author**: dobachi
- **Created**: 2025-06-30