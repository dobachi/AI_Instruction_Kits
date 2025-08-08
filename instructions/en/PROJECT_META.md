# AI Instruction Kits Development Support Configuration

This project is a meta-project for developing and improving the AI instruction system itself.
When starting a task, please load `instructions/en/system/ROOT_INSTRUCTION.md`.

## ⚠️ Important: Path Translation

When using instructions in this project itself, **path translation is required**:

### Normal Project Usage (via submodule)
```
instructions/ai_instruction_kits/instructions/en/system/ROOT_INSTRUCTION.md
scripts/checkpoint.sh
```

### Usage in This Project Itself
```
instructions/en/system/ROOT_INSTRUCTION.md
scripts/checkpoint.sh
```

### Path Conversion Rules
- `instructions/ai_instruction_kits/instructions/` → `instructions/`
- `instructions/ai_instruction_kits/` → root directory

## Project Overview
- **Purpose**: Development of a system to structurally manage and provide instructions to AI
- **Language**: Japanese priority (maintaining English version simultaneously)
- **License**: Apache-2.0 (individual instructions have their own licenses)

## Development Principles

### 1. Structural Clarity
- Directory structure must be intuitively understandable
- Naming conventions must be consistent
- Categorization must be practical

### 2. Ease of Use
- Minimal steps to start using
- Easy integration with existing projects
- Documentation must include examples

### 3. Extensibility
- Easy to add new instruction types
- Flexible customization
- Ability to support other AI tools

## Important Development Considerations

### When Editing Files
1. **Japanese-English Synchronization**: Always update English version when updating Japanese version
2. **Examples First**: Prioritize concrete examples over abstract explanations
3. **Backward Compatibility**: Don't break existing usage methods
4. **Path Descriptions**: Paths in instructions should assume submodule usage

### When Adding New Features
1. First implement and verify in Japanese version
2. Create English version
3. Update samples and templates
4. Update README and documentation

### Testing and Verification
1. Verify setup-project.sh works correctly
2. Verify each instruction functions independently
3. Verify ROOT_INSTRUCTION and MODULE_COMPOSER coordination
4. Verify path consistency (operation in submodule environment)

## Project-Specific Instructions

### Coding Standards
- Shell scripts: POSIX compliant, error handling required
- Markdown: Maximum 3 heading levels, language specification for code blocks
- Filenames: snake_case (lowercase letters and underscores)

### Commit Messages
```
<type>: <description>

- feat: New feature
- fix: Bug fix
- docs: Documentation update
- refactor: Refactoring
- test: Test addition/modification
```

### Pull Requests
- Clearly state purpose and scope of changes
- Include related issue numbers
- Confirm both Japanese and English updates

## Frequently Used Commands

```bash
# Add new instruction (Japanese)
cp templates/ja/instruction_template.md instructions/ja/<category>/<name>.md

# Add new instruction (English)
cp templates/en/instruction_template.md instructions/en/<category>/<name>.md

# Integration test
bash scripts/setup-project.sh

# Execute checkpoint in this project itself
bash scripts/checkpoint.sh

# Clean commit (without AI messages)
bash scripts/commit.sh "commit message"

# File consistency check (future implementation)
# bash scripts/validate-instructions.sh
```

## Current Issues and Future Improvements

1. Mechanism to reduce duplication between instructions
2. Version control and update notifications
3. Mechanism to accept community contributions
4. Enhanced automated testing
5. Performance optimization (when loading large numbers of instructions)
6. Automatic path conversion feature (for meta usage)

---
## License Information
- **License**: Apache-2.0
- **Created**: 2025-01-03