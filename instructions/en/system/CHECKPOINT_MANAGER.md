# Checkpoint Management System (Compact Version)

## Purpose
Effectively track and report task progress with minimal output

## Basic Rules
**Execute the following in every response:**

1. **Display the following 2 lines at the beginning**
```
`[Current Step/Total Steps] Current Status | Next: Next Action`
`📌 Log→checkpoint.log: [YYYY-MM-DD HH:MM:SS][TASK-xxxxxx][Status] Message`
```

2. **Actually append the content shown in line 2 to the checkpoint.log file**
   - Task start (START): Always append
   - Error occurrence (ERROR): Always append
   - Task completion (COMPLETE): Always append
   - Normal progress: No append needed (display only)

### Line 2 Details
- Task start: `📌 Log→checkpoint.log: [Time][TASK-xxxxxx][START] Task name (N steps estimated)`
- Normal progress: `📌 Log→checkpoint.log: Log only at start/error/completion`
- Error occurrence: `📌 Log→checkpoint.log: [Time][TASK-xxxxxx][ERROR] Error details`
- Task completion: `📌 Log→checkpoint.log: [Time][TASK-xxxxxx][COMPLETE] Result: details`

### File Logging Rules
Log important checkpoints to `checkpoint.log`:
- Task start
- Error occurrence
- Task completion

## Format Details

### Date/Time Retrieval
- **Important**: Always use actual current date/time for date/time notation (YYYY-MM-DD HH:MM:SS)
- Use the current date/time information provided by the AI system
- Do not use example or dummy dates/times (e.g., 2025-06-30 14:00:00)

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
[YYYY-MM-DD HH:MM:SS] [TASK-xxxxxx] [Status] Message
```

### Log Examples (Use actual date/time)
```
[Actual date/time] [TASK-8a3f2c] [START] Web application development started (5 steps estimated)
[Actual date/time] [TASK-8a3f2c] [ERROR] Dependency error: Missing packages
[Actual date/time] [TASK-8a3f2c] [COMPLETE] Completed: 3 APIs, 10 tests created
```

## Implementation Examples

### Coding Task Example
```
`[1/4] Requirements analyzed | Next: Implementation`
`📌 Log→checkpoint.log: [Actual date/time][TASK-b5d7e1][START] Python function implementation (4 steps)`
I've understood the requirements. I'll implement data processing functions in Python.

`[2/4] Implementation complete | Next: Testing`
`📌 Log→checkpoint.log: Log only at start/error/completion`
I've created the following code:
[Code]

`[3/4] Testing complete | Next: Documentation`
`📌 Log→checkpoint.log: Log only at start/error/completion`
All tests passed successfully.

`[4/4] All done | Result: 1 function, 3 tests`
`📌 Log→checkpoint.log: [Actual date/time][TASK-b5d7e1][COMPLETE] Result: 1 function, 3 tests`
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