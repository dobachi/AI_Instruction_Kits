## Fintech Domain

### Regulatory Frameworks

{{#if regulatory_jurisdiction}}
**Target Jurisdiction**: {{regulatory_jurisdiction}}
{{/if}}

#### Global Regulations
1. **PCI DSS (Payment Card Industry Data Security Standard)**
   - Secure handling of card information
   - 12 requirements and security assessment procedures
   - Compliance Level: {{compliance_level}}

2. **SOX (Sarbanes-Oxley Act)**
   - Financial reporting accuracy and transparency
   - Internal control documentation and assessment
   - Audit trail retention

3. **Basel III**
   - Capital requirements and liquidity standards
   - Risk management framework
   - Stress testing implementation

4. **MiFID II (Markets in Financial Instruments Directive)**
   - Enhanced transparency in investment services
   - Strengthened investor protection
   - Trade reporting obligations

#### Regional Regulations
{{#if regulatory_jurisdiction}}
{{#eq regulatory_jurisdiction "JP"}}
- **Payment Services Act**: Prepaid payment instruments, fund transfer
- **Act on Prevention of Transfer of Criminal Proceeds**: AML/CFT requirements
- **Personal Information Protection Act**: Proper handling of personal data
- **Financial Instruments and Exchange Act**: Investment advisory and agency
{{/eq}}
{{#eq regulatory_jurisdiction "US"}}
- **Dodd-Frank Act**: Systemic risk management
- **GLBA**: Financial privacy protection
- **Bank Secrecy Act**: AML requirements
- **Regulation E**: Electronic fund transfer protection
{{/eq}}
{{#eq regulatory_jurisdiction "EU"}}
- **PSD2**: Payment Services Directive
- **GDPR**: Data protection regulation
- **AMLD**: Anti-Money Laundering Directive
- **EMIR**: Derivatives regulation
{{/eq}}
{{/if}}

### Risk Management Framework

#### Risk Category: {{risk_category}}

1. **Credit Risk**
   - Credit evaluation models (scoring)
   - Probability of Default (PD) calculation
   - Loss Given Default (LGD) estimation
   - Exposure management

2. **Market Risk**
   - Value at Risk (VaR) calculation
   - Stress test scenarios
   - Hedge strategy implementation
   - Portfolio optimization

3. **Operational Risk**
   - Error reduction through process automation
   - BCP/DR planning
   - Cybersecurity measures
   - Internal fraud prevention

4. **Liquidity Risk**
   - Cash flow forecasting
   - Liquidity Coverage Ratio (LCR)
   - Net Stable Funding Ratio (NSFR)
   - Stress scenario analysis

### Product Type Requirements

{{#if product_type}}
#### Requirements for {{product_type}}
{{#eq product_type "payment"}}
- **Payment Processing**
  - Real-time authorization system
  - Fraud detection (machine learning models)
  - Chargeback management
  - Multi-currency support

- **Security Requirements**
  - Tokenization
  - 3D Secure authentication
  - End-to-end encryption
  - PCI DSS compliance
{{/eq}}

{{#eq product_type "lending"}}
- **Loan Management**
  - Credit scoring models
  - Automated underwriting workflow
  - Repayment schedule management
  - Delinquency and collection processes

- **Regulatory Requirements**
  - Interest rate cap compliance
  - Lending regulations compliance
  - Credit bureau integration
  - Digital contract documentation
{{/eq}}

{{#eq product_type "investment"}}
- **Investment Management**
  - Portfolio management
  - Risk analysis tools
  - Automated rebalancing
  - Performance measurement

- **Compliance**
  - Suitability principle
  - Disclosure obligations
  - Conflict of interest management
  - Best execution duty
{{/eq}}

{{#eq product_type "crypto"}}
- **Crypto Asset Management**
  - Wallet management (hot/cold)
  - Secure private key storage
  - Multi-signature implementation
  - DeFi protocol integration

- **Regulatory Compliance**
  - Travel rule compliance
  - AML/CFT screening
  - Crypto exchange licensing
  - Tax reporting support
{{/eq}}
{{/if}}

### Financial Modeling Standards

1. **Pricing Models**
   - Risk-Adjusted Return on Capital (RAROC)
   - Expected Loss (EL) calculation
   - Economic capital allocation
   - Pricing optimization

2. **Predictive Analytics**
   - Time series analysis (ARIMA, LSTM)
   - Machine learning models (XGBoost, Random Forest)
   - Model validation and backtesting
   - Explainable AI (SHAP, LIME)

### Digital Banking Trends

1. **Open Banking**
   - API design (REST, GraphQL)
   - OAuth 2.0 implementation
   - Data standardization (ISO 20022)
   - Third-party integration

2. **Embedded Finance**
   - Banking as a Service (BaaS) integration
   - White-label solutions
   - API-first design
   - Microservices architecture

3. **AI/ML Applications**
   - Advanced fraud detection
   - Personalized services
   - Chatbots/virtual assistants
   - Predictive analytics and recommendations

### Security and Compliance

1. **Data Protection**
   - Encryption (at rest, in transit)
   - Access control (RBAC, ABAC)
   - Audit log integrity
   - Data residency requirements

2. **Know Your Customer (KYC)**
   - eKYC processes
   - Biometric authentication integration
   - Risk-based authentication
   - Continuous Customer Due Diligence (CDD)

3. **Anti-Money Laundering (AML)**
   - Transaction monitoring
   - Sanctions list screening
   - Suspicious Transaction Reports (STR)
   - Risk assessment and scoring

### Integration Modules

- **Required Modules**
  - `skill_authentication`: Robust authentication system
  - `skill_error_handling`: Financial transaction error handling
  - `skill_api_design`: Financial API design
  - `quality_production`: Production environment quality assurance

- **Recommended Modules**
  - `task_data_analysis`: Financial data analysis
  - `skill_performance`: High-speed transaction processing
  - `task_report_writing`: Regulatory report creation
  - `skill_testing`: Financial system testing

### Domain-Specific Constraints

1. **Transaction Integrity**
   - ACID properties guarantee
   - Distributed transaction management
   - Event sourcing
   - Compensation transactions

2. **Audit Requirements**
   - Immutable audit logs
   - Timestamp accuracy
   - Data lineage tracking
   - Regulatory reporting

3. **Availability Requirements**
   - 99.99%+ uptime
   - Zero-downtime deployment
   - Geographic redundancy
   - Disaster recovery planning

### Validation Rules

1. **Amount Validation**
   - Unified currency formatting
   - Decimal place control
   - Negative value handling
   - Upper/lower limit checks

2. **Date Validation**
   - Business day calendar
   - Timezone handling
   - Settlement cycle management
   - Deadline management

3. **Account Validation**
   - Account number format
   - IBAN/SWIFT validation
   - Account status verification
   - Balance checks