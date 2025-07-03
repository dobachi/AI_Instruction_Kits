# Basic Usage Examples

This document demonstrates basic usage patterns for the AI Instruction Kits Manager.

## 1. Direct Instruction Reference

The simplest way to use a specific instruction sheet directly.

```bash
# Coding task example
claude "Refer to instructions/en/coding/basic_code_generation.md and 
implement user authentication functionality"

# Analysis task example
claude "Refer to instructions/en/analysis/basic_data_analysis.md and 
analyze the sales data"
```

## 2. Automatic Selection with ROOT_INSTRUCTION

When referencing ROOT_INSTRUCTION, appropriate instruction sheets are automatically selected based on the task.

```bash
# AI automatically selects appropriate instructions
claude "Refer to instructions/en/system/ROOT_INSTRUCTION.md and 
develop a new web application"
```

## 3. Combining Multiple Instructions

For complex tasks, you can combine multiple instruction sheets.

```bash
# Data analysis followed by report creation
claude "Refer to instructions/en/system/ROOT_INSTRUCTION.md and 
analyze sales data, then create a report for executives"
```

## 4. Utilizing Checkpoint Management

For long-running tasks, progress is automatically tracked.

```bash
# Progress is automatically reported
claude "Refer to instructions/en/system/ROOT_INSTRUCTION.md and 
implement the following features for an e-commerce site:
1. User registration
2. Product catalog
3. Shopping cart
4. Checkout flow"
```

Expected output:
```
`[1/4] Requirements analyzed | Next: User registration`
`📌 Log→checkpoint.log: [2025-06-30 10:00:00][TASK001][START] E-commerce features (4 steps)`

Starting with user registration implementation...

`[2/4] User registration complete | Next: Product catalog`
`📌 Log→checkpoint.log: Log only at start/error/completion`

Implementing product catalog functionality...
```

## 5. Error Handling Example

How the system behaves when errors occur:

```bash
claude "Refer to instructions/en/system/ROOT_INSTRUCTION.md and 
establish database connection"
```

Error output example:
```
`[1/2] Attempting connection | Next: Establish connection`
`📌 Log→checkpoint.log: [2025-06-30 11:00:00][TASK002][START] DB connection (2 steps)`

Attempting to connect to database...

`[1/2] ⚠️ Error occurred | Action: Check configuration`
`📌 Log→checkpoint.log: [2025-06-30 11:00:15][TASK002][ERROR] Connection failed: Host unreachable`

Connection error occurred. Please check configuration.
```

## Important Notes

- Specify instruction paths accurately
- Be careful not to mix up Japanese (ja) and English (en) versions
- Todo lists are automatically created for complex tasks
- checkpoint.log file is automatically updated

---
## License Information
- **License**: Apache-2.0
- **Author**: dobachi
- **Created**: 2025-06-30