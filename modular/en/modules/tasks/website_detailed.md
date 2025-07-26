## Static Website Development

Please create a high-quality static website according to the following requirements.

### Site Requirements
- **Site Type**: {{site_type}}
- **Design Style**: {{design_style}}
- **Page Count**: {{page_count}}

### Technical Requirements

#### HTML
- Use semantic HTML
- Proper heading hierarchy (h1-h6)
- Accessibility attributes (alt, aria-label, etc.)
{{#if seo_optimization}}
- Meta tag optimization (title, description, OGP)
- Implement structured data (as needed)
{{/if}}

#### CSS
{{#if css_framework}}
- Framework: Use {{css_framework}}
{{else}}
- Implement with custom CSS
- Maintainable design using CSS variables
{{/if}}
{{#if responsive_design}}
- Mobile-first design
- Breakpoints: 768px (tablet), 1024px (desktop)
{{/if}}
- Achieve {{design_style}} design

#### JavaScript
{{#if javascript_framework}}
- Framework: Use {{javascript_framework}}
{{else}}
- Implement with vanilla JavaScript
{{/if}}
- Progressive enhancement
- Proper event listener management

### Performance Requirements
{{#if loading_optimization}}
- Image optimization (appropriate format and size)
- CSS and JS minification
- Implement lazy loading
- Inline critical CSS
{{/if}}

### File Structure
```
project/
├── index.html
├── css/
│   └── style.css
├── js/
│   └── script.js
├── images/
│   └── (optimized image files)
└── README.md
```

### Deliverables
1. Fully functional website
2. Clean and maintainable code
3. Project documentation in README.md