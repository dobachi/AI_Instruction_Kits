## Accessibility Implementation

### WCAG Compliance
- **Target Level**: WCAG 2.1 {{wcag_level}}
- **Support Priority**: {{screen_reader_support}}

### Perceivability

#### Text Alternatives
- Set alt attributes for all images
- Use empty alt for decorative images
- Add detailed descriptions for complex charts

#### Color and Contrast
- Minimum contrast ratio: {{color_contrast_ratio}}
- Don't rely solely on color for information
- Consider dark mode support

#### Structure and Semantics
- Use appropriate HTML elements
- Correct heading hierarchy
- Utilize landmark roles

### Operability

{{#if keyboard_navigation}}
#### Keyboard Navigation
- All functions accessible via keyboard
- Visual focus indicators
- Logical tab order
- Provide skip links
{{/if}}

#### Time Limits
- Pause function for auto-refresh
- Session timeout warnings
- Time limit extension options

#### Navigation Support
- Provide breadcrumb navigation
- Include sitemap
- Implement search functionality

### Understandability

#### Language and Text
- Specify page language (lang attribute)
- Use plain language
- Explain technical terms

#### Error Handling
- Clear error messages
- Suggest correction methods
- Provide input examples

### Robustness

#### Compatibility
- Standards-compliant HTML
- Appropriate use of ARIA
- Ensure assistive technology compatibility

#### Progressive Enhancement
- Ensure basic functionality
- Work without JavaScript
- Gradual feature enhancement