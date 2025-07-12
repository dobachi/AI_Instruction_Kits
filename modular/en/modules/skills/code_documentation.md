## Documentation Creation Guidelines

### Basic Policy
- **Language**: {{documentation_language}}
- **Target Audience**: Developers, designers, project stakeholders

### README.md

#### Required Sections
{{readme_sections}}

#### Recommended Structure
```markdown
# Project Name

## Overview
Brief description of project purpose and main features

## Demo
Screenshots or links to demo site

## Setup
### Requirements
- Operating environment requirements
- Dependencies

### Installation Steps
\`\`\`bash
# Installation command examples
\`\`\`

## Usage
Basic usage and code examples

## Project Structure
Directory structure explanation

## Developer Information
- Development environment setup
- How to run tests
- Contribution guidelines

## License
License information
```

### Code Comments

#### Style
{{code_comments_style}}

#### HTML Comments
```html
<!-- Section: Header -->
<header>
  <!-- Navigation menu -->
  <nav>...</nav>
</header>

<!-- Section: Main content -->
<main>
  <!-- Important: This part is dynamically generated -->
  <div id="dynamic-content"></div>
</main>
```

#### CSS Comments
```css
/* ==========================================================================
   Header styles
   ========================================================================== */

/* Navigation menu */
.nav {
  /* Flexbox horizontal layout */
  display: flex;
}

/* TODO: Add responsive support */
```

#### JavaScript Comments
```javascript
/**
 * Retrieve user information
 * @param {string} userId - User ID
 * @returns {Promise<Object>} User information object
 */
async function getUser(userId) {
  // Build API endpoint
  const endpoint = `/api/users/${userId}`;
  
  try {
    // Fetch data
    const response = await fetch(endpoint);
    return await response.json();
  } catch (error) {
    // Error handling
    console.error('Failed to retrieve user information:', error);
    throw error;
  }
}
```

### Other Documentation

#### CHANGELOG.md
- Changes by version
- Categorization of additions/changes/fixes/deletions
- Date records

#### CONTRIBUTING.md
- Contribution guidelines
- Coding standards
- Pull request procedures

#### API Documentation
- **Format**: {{api_doc_format}}
- Endpoint list
- Request/response examples
- Error code list