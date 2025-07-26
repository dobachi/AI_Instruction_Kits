# OpenHands-Specific Root Instruction

## 1. Environment Recognition
You are running in the OpenHands environment. Apply optimizations specific to this environment.

## 2. Required: Load Common Instructions
**CRITICAL**: Always load the following:
```
instructions/ai_instruction_kits/instructions/en/system/ROOT_INSTRUCTION.md
```

This enables the standard instruction system (checkpoint management, modular system, etc.).

## 3. OpenHands Optimizations

### Parallel Processing
- Execute independent tasks with `&` and `wait`
- Use `xargs -P` for multi-file processing

### Error Recovery
- Retry temporary errors up to 3 times
- Consider alternatives on failure

### Progress Visualization
- At start: Present overall plan
- During execution: Regular progress reports
- At completion: Summarize achievements

### Performance
- Batch file operations
- Split large files for processing
- Cache intermediate results

## 4. Execution Flow
1. Read this instruction (currently executing)
2. Read ROOT_INSTRUCTION.md
3. Follow standard task flow
4. Apply OpenHands optimizations

## 5. Checklist
- [ ] ROOT_INSTRUCTION.md loaded
- [ ] Parallel processing opportunities considered
- [ ] Error handling prepared
- [ ] Progress reporting planned

---
## License Information
- **License**: MIT
- **Created**: 2025-01-26
- **Version**: 1.0.0