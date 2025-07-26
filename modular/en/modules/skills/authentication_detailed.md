## Authentication & Authorization

### Authentication Methods

{{#if auth_method}}
**Selected Method**: {{auth_method}}
{{else}}
Choose and implement one of the following:
{{/if}}

1. **JWT (JSON Web Token)**
   - Stateless authentication
   - Token expiration settings
   - Refresh token implementation

2. **OAuth 2.0**
   - Third-party authentication support
   - Proper scope configuration
   - Authorization code flow implementation

3. **API Key**
   - Simple implementation
   - Key rotation functionality
   - Integration with rate limiting

### Security Best Practices

1. **Password Policy**
   {{#if password_policy}}- {{password_policy}}{{/if}}
   - Minimum length: {{password_min_length}}
   - Complexity requirements (uppercase, lowercase, numbers, special characters)
   - Password history checking

2. **Session Management**
   - Session timeout: {{session_timeout}}
   - Secure cookie settings (HttpOnly, Secure, SameSite)
   - CSRF token usage

3. **Access Control**
   - Role-based permission management
   - Principle of least privilege
   - Audit log recording

### Error Handling

- Appropriate messages for authentication failures
- Brute force attack protection
- Account lockout functionality

### Data Protection

- Password hashing (bcrypt, Argon2, etc.)
- Sensitive information encryption
- Secure communication (HTTPS required)