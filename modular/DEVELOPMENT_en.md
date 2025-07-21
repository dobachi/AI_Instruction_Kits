# Modular System Development Guide

## Overview

This document is a comprehensive guide for developing various modules in the AI Instruction Kits modular system. It explains module types, development processes, quality standards, and best practices.

## Module Types

### 1. Core
Essential modules that define the basic structure of the system
- `role_definition`: Role definition
- `constraints`: Constraints
- `output_format`: Output format

### 2. Tasks
Define specific work content
- Examples: `code_generation`, `data_analysis`, `documentation`

### 3. Skills
Provide specific abilities or techniques
- Examples: `api_design`, `testing`, `error_handling`

### 4. Methods
Define work approaches or methodologies
- Examples: `agile`, `lean`, `design_thinking`

### 5. Domains
Industry-specific knowledge and conventions
- Examples: `fintech`, `healthcare`, `education`

### 6. Roles
Define AI behavior and personas
- Examples: `mentor`, `reviewer`, `consultant`

### 7. Quality
Define quality levels and standards
- Example: `production` (production quality)

### 8. Expertise
Deep expertise and latest best practices
- Examples: `software_engineering`, `machine_learning`

## Development Process

### Phase 1: Planning

#### 1.1 Determining Module Type
```yaml
Decision criteria:
  Core: Required for basic system operation
  Tasks: Generate specific deliverables
  Skills: Specific technical abilities
  Methods: Processes and procedures
  Domains: Industry-specific knowledge
  Roles: AI behavior
  Quality: Quality standards
  Expertise: Deep expertise (including latest trends)
```

#### 1.2 Scope Definition
- Clarify functionality to provide
- Set boundaries with other modules
- Identify dependencies

### Phase 2: Research & Investigation

#### 2.1 Information Gathering
```bash
# Storage location for research results
docs/references/[category]/[module_name]_research.md
```

#### 2.2 Best Practices Research
- Verify industry standards
- Understand latest trends (especially for Expertise modules)
- Collect implementation examples

### Phase 3: Design

#### 3.1 Structure Design
```markdown
## Basic Structure (Common to all modules)
1. Overview
2. Main Functions/Principles
3. Implementation Details
4. Usage Examples
5. Best Practices (if applicable)
```

#### 3.2 Variable Design
```yaml
Variable design principles:
  - Clear naming: [category]_[specific_function]
  - Appropriate default values: Most common settings
  - Extensibility: Consider future additions
  - Use of enum type: Clear choices
```

### Phase 4: Implementation

#### 4.1 Creating Markdown Files
```markdown
# [Module Name]

## Overview
[Clear and concise description]

## [Main Section]
### 1. [Subsection]
[Detailed content]

## Variable Usage Examples
### Pattern 1: [Usage Scenario]
```yaml
[Variable configuration example]
```
```

#### 4.2 Creating YAML Metadata
```yaml
id: [category]_[name]
name: [Name]
description: [Detailed description]
version: 1.0.0
category: [category]
subcategory: [subcategory]

variables:
  - name: "[variable_name]"
    description: "[Description]"
    type: "enum"
    values: [...]
    default: "[default_value]"

dependencies:
  required: []
  optional: []

compatible_tasks: []

tags: []

examples: []
```

### Phase 4.5: Creating Concise Version

#### Importance of Creating Concise Versions
Creating a concise version based on the detailed version enables a well-founded summary based on deep understanding.

#### 4.5.1 Creation Process
```yaml
Steps:
  1. Confirm detailed version completion: Including broad and deep research with best practices
  2. Extract essence: Identify the most important concepts and patterns
  3. Focus on practicality: Restructure as a quick reference that's immediately usable
  4. Size target: 20-30% or less of the detailed version (considering token efficiency)
```

#### 4.5.2 Components of Concise Version
```markdown
## Elements to Retain
- Core concept definitions (1-2 sentences)
- Key patterns in tabular format
- Essential best practices (bullet points)
- Basic usage examples (minimal)

## Elements to Remove/Simplify
- Detailed implementation code → API signatures only
- Theoretical explanations → Practical points only
- Comprehensive lists → Top 3-5 items only
- Step-by-step guides → Overview level only
```

#### 4.5.3 File Naming
```bash
# Naming convention
modular/en/modules/[category]/[name].md          # Concise version (default)
modular/en/modules/[category]/[name]_detailed.md # Detailed version
```

### Phase 5: Quality Assurance

#### 5.1 Self-Review Checklist
```markdown
## General Checklist
- [ ] Overview is clear and understandable
- [ ] Structure is logical and consistent
- [ ] Implementation examples are functional
- [ ] Variables are properly defined
- [ ] Dependencies are accurate
- [ ] Tags are comprehensive

## Category-Specific Additional Checks
### Expertise Modules
- [ ] Reflects latest 2024-2025 information
- [ ] References authoritative sources
- [ ] Balance of theory and practice
- [ ] Implementable code examples

### Skills Modules
- [ ] Concrete implementation steps
- [ ] Error handling
- [ ] Performance considerations

### Methods Modules
- [ ] Clear processes
- [ ] Defined deliverables for each step
- [ ] Practical advice
```

#### 5.2 Testing
```bash
# Module generation test
python modular/composer.py \
  --modules [module_id] \
  --output test_output.md

# Content verification
- Correct generation
- Proper variable expansion
- Integration with other modules
```

### Phase 6: Internationalization

#### 6.1 Creating English Version
```bash
# File structure
modular/
├── ja/modules/[category]/[name].md
├── ja/modules/[category]/[name].yaml
├── en/modules/[category]/[name].md
└── en/modules/[category]/[name].yaml
```

#### 6.2 Translation Points
- Accuracy of technical terms
- Cultural context adjustment
- Keep code examples as-is

## Best Practices

### 1. Maintaining Consistency
- Unified structure
- Adherence to naming conventions
- Following style guide

### 2. Emphasis on Practicality
- Practice over theory
- Providing concrete examples
- Immediately usable content

### 3. Ensuring Maintainability
- Clear versioning
- Recording update history
- Minimizing dependencies

### 4. Collaboration
- Integration with other modules
- Reusable design
- Clear interfaces

## Category-Specific Guidelines

### Expertise Modules
See [expertise-module.md](../docs/en/developers/guides/expertise-module.md) for details

Features:
- Deep expertise
- Reflection of latest trends
- Comprehensive implementation examples
- Industry standard compliance

### Skills Modules
Features:
- Concrete technical implementation
- Step-by-step
- Including error handling
- Practical tips

### Methods Modules
Features:
- Process definition
- Roles and responsibilities
- Clear deliverables
- Implementation procedures

## Troubleshooting

### Problem: Module not loading correctly
```yaml
Check:
  - YAML syntax errors
  - Duplicate IDs
  - Missing required fields
  
Solution:
  - Validate with YAML linter
  - Check catalog_cache.json
  - Check error logs
```

### Problem: Variables not expanding
```yaml
Check:
  - Variable name matching
  - Default value settings
  - Type consistency
  
Solution:
  - Review variable definitions
  - Check template syntax
```

## Development Tools

### 1. Module Generation Testing
```bash
# Single module test
python modular/composer.py --modules [id]

# Multiple module integration test
python modular/composer.py --modules [id1] [id2] [id3]
```

### 2. Quality Check Tools (To be implemented)
```bash
# Structure check
scripts/validate-module.sh [module_path]

# Style check
scripts/check-style.sh [module_path]
```

## Contribution Guidelines

### 1. Proposing New Modules
1. Propose via Issue
2. Explain differentiation from existing modules
3. Present use cases

### 2. Improving Existing Modules
1. Start with small improvements
2. Maintain backward compatibility
3. Add tests

### 3. Review Process
1. Complete self-checklist
2. Create pull request
3. Address review feedback

## Future Outlook

### 1. Advancing Automation
- Module generation support tools
- Quality check automation
- Automatic dependency resolution

### 2. Ecosystem Expansion
- Community modules
- Module marketplace
- Rating and review system

### 3. Advanced Features
- Conditional module loading
- Dynamic module generation
- AI-powered module recommendations

---

Following this guide enables efficient development of high-quality, reusable modules. If you have questions or suggestions, please create an Issue.