# AI Instruction Root File

This file serves as an entry point for selectively loading instructions from this repository.

## Usage

Select the necessary instructions from below and have the AI load them:

### 1. General Tasks
- [ ] **Basic Question Answering**: `instructions/en/general/basic_qa.md`
  - When accurate fact-based answers are needed

### 2. Coding
- [ ] **Basic Code Generation**: `instructions/en/coding/basic_code_generation.md`
  - When program implementation is needed

### 3. Writing
- [ ] **Basic Text Creation**: `instructions/en/writing/basic_text_creation.md`
  - When business documents or articles need to be created

### 4. Analysis
- [ ] **Basic Data Analysis**: `instructions/en/analysis/basic_data_analysis.md`
  - When insights from data are needed

### 5. Creative
- [ ] **Basic Creative Work**: `instructions/en/creative/basic_creative_work.md`
  - When creative ideas or solutions are needed

## Selection Methods

### Method 1: Direct Reference
```
Please follow these instructions:
- instructions/en/coding/basic_code_generation.md
- instructions/en/analysis/basic_data_analysis.md
```

### Method 2: Specify Task Type
```
Task Type: Coding, Analysis
Language: English
```

### Method 3: For Composite Tasks
```
Main Task: Data Analysis
Supporting Tasks: Documenting results, Generating visualization code
```

## Notes
- If there are conflicting instructions, prioritize more specific ones
- Instructions can be combined as needed
- Select appropriate instructions based on task nature

---
## License Information
- **License**: Apache-2.0
- **Source**: 
- **Original Author**: dobachi
- **Created Date**: 2025-06-30