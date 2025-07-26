## Fintech Domain

### Core Compliance
{{#if regulatory_jurisdiction}}
**Jurisdiction**: {{regulatory_jurisdiction}}
{{/if}}

- **PCI DSS**: Card data security (Level: {{compliance_level}})
- **KYC/AML**: Identity verification, transaction monitoring
- **Data Protection**: Encryption, access control, audit logs

### Product Requirements

{{#if product_type}}
{{#eq product_type "payment"}}
- Real-time authorization
- Fraud detection (ML)
- PCI DSS compliance
{{/eq}}
{{#eq product_type "lending"}}
- Credit scoring
- Automated underwriting
- Regulatory compliance
{{/eq}}
{{#eq product_type "investment"}}
- Portfolio management
- Risk analysis
- Best execution
{{/eq}}
{{#eq product_type "crypto"}}
- Wallet security
- AML screening
- Tax reporting
{{/eq}}
{{/if}}

### Technical Standards

- **APIs**: REST/GraphQL, OAuth 2.0
- **Security**: End-to-end encryption, tokenization
- **Availability**: 99.99%+ uptime, zero-downtime deployment
- **Transactions**: ACID compliance, audit trail

### Integration Modules

**Required**:
- `skill_authentication`
- `skill_error_handling`
- `skill_api_design`
- `quality_production`