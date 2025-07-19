# Technical Documentation Task Module

## Task Overview

Create clear, comprehensive, and user-friendly technical documentation that enables users to understand and utilize technical information effectively.

## Documentation Target

- **Document Type**: {{document_type}}
- **Target Audience**: {{target_audience}}
{{#document_purpose}}
- **Document Purpose**: {{document_purpose}}
{{/document_purpose}}

## Documentation Best Practices

### 1. Understanding Your Audience

#### Audience Analysis
{{#audience_analysis}}
{{audience_analysis}}
{{/audience_analysis}}
{{^audience_analysis}}
1. **Technical Level**
   - Beginner, intermediate, or advanced classification
   - Clarifying prerequisite knowledge
   - Determining technical terminology usage level

2. **Usage Context**
   - Situations where documentation will be used
   - Required depth of information
   - Time constraint considerations

3. **Expected Outcomes**
   - Goals readers want to achieve
   - Required action steps
   - Success criteria definition
{{/audience_analysis}}

### 2. Structure and Navigation

#### Document Structure Design
1. **Hierarchical Organization**
   - Clear heading hierarchy (H1-H4)
   - Logical information flow
   - Modularized sections

2. **Navigation Elements**
   - Auto-generated table of contents
   - Cross-references
   - Search functionality considerations
   - Version control information

3. **Visual Structuring**
   - Appropriate use of whitespace
   - Lists and tables utilization
   - Effective placement of diagrams

### 3. Content Creation

#### Writing Principles
{{#writing_style}}
- {{writing_style}}
{{/writing_style}}
{{^writing_style}}
1. **Clarity**
   - Concise and direct expressions
   - Use of active voice
   - One idea per sentence principle

2. **Consistency**
   - Terminology standardization
   - Style guide adherence
   - Format standardization

3. **Specificity**
   - Avoiding abstract explanations
   - Examples and sample code
   - Step-by-step procedures
{{/writing_style}}

#### Content Elements
{{#content_elements}}
{{content_elements}}
{{/content_elements}}
{{^content_elements}}
- **Overview Section**: Document purpose and scope
- **Prerequisites**: Required environment and knowledge
- **Procedure Explanations**: Detailed steps
- **Examples and Samples**: Practical use cases
- **Troubleshooting**: Common problems and solutions
- **Reference**: Detailed specification information
{{/content_elements}}

### 4. Technical Considerations

#### Format and Standards
{{#documentation_format}}
- **Format Used**: {{documentation_format}}
{{/documentation_format}}
{{^documentation_format}}
Available formats:
- **Markdown**: Lightweight and easy to learn, version control friendly
- **DITA XML**: Large-scale structured documentation, reusability focused
- **HTML/CSS**: Web-based interactive documentation
- **PDF**: Fixed layout for printing and distribution
{{/documentation_format}}

#### Version Control and Updates
1. **Change History Management**
   - Detailed changelog
   - Version numbering system
   - Breaking changes declaration

2. **Continuous Updates**
   - Documentation and code synchronization
   - Feedback loop establishment
   - Regular reviews

### 5. API Documentation Specific Elements (When Applicable)

{{#api_documentation}}
#### Essential API Documentation Elements
1. **Authentication and Authorization**
   - Detailed authentication method explanations
   - API key acquisition procedures
   - Security best practices

2. **Endpoint Specifications**
   - HTTP methods and URLs
   - Request/response formats
   - Parameter detailed descriptions

3. **Code Examples**
   - Samples in multiple languages
   - Executable code snippets
   - Error handling examples

4. **Interactive Elements**
   - API explorer
   - Sandbox environment
   - Real-time testing capabilities
{{/api_documentation}}

### 6. Usability and Accessibility

#### Search and Navigation
- Powerful search functionality
- Contextual help
- Links to related information

#### Accessibility Support
{{#accessibility_requirements}}
- {{accessibility_requirements}}
{{/accessibility_requirements}}
{{^accessibility_requirements}}
- Screen reader compatibility
- Keyboard navigation
- Appropriate color contrast
- Alternative text provision
{{/accessibility_requirements}}

### 7. Quality Assurance

#### Review and Testing
1. **Technical Accuracy**
   - Expert review
   - Code example verification
   - Specification compliance check

2. **Readability**
   - Reader testing
   - Comprehension verification
   - Feedback collection

#### Measurement and Improvement
- Documentation usage analytics
- User satisfaction surveys
- Continuous improvement process

---