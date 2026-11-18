---
name: domotz-security-compliance
description: "Domotz security and compliance facts. Use for any security, privacy, compliance or AI-data question about Domotz, and to answer a vendor security questionnaire. Covers certifications, data residency, encryption, access control, SSO and MFA, logging, incidents, subprocessors, GDPR and NIS-2, and how Domotz and the AI clients connected to it handle customer data."
---
# Domotz security and compliance

## How to use this skill

- Answer from the facts on this page. For a questionnaire, answer each question from these facts, mark the ones they don't cover as "ask Domotz", and never invent a control, a certificate or a date.
- Point users to https://trust.domotz.com for certifications, documents and the subprocessor list. Some documents, such as the SOC 2 report, are shared on request under NDA.
- If nothing here answers the question, say so plainly and give the right contact below. Never guess, and never promise that someone will follow up.
- Contacts: support@domotz.com for general questions; privacy@domotz.com for privacy, the DPA and data deletion; it-security@domotz.com to report a vulnerability. Live service status: https://status.domotz.com.

## Company and product

- Headquarters: United States.
- Domotz is a software-as-a-service platform for remote network monitoring and management:
  - the Domotz web and mobile apps;
  - Domotz Cloud, which stores the network data and history and offers a REST API;
  - the Collector, software (or the preinstalled Domotz Box) that discovers and monitors the local network and connects out to Domotz Cloud;
  - the AI Agent, an assistant inside the web app (see "AI and large language models");
  - an MCP server, through which customers can connect their own AI clients.
- Domotz has a dedicated security and compliance team.

## Certifications and frameworks

- ISO/IEC 27001:2022 certified.
- SOC 2 Type II, maintained through annual audits (2026 report).
- GDPR and CCPA compliant. NIS-2 compliant, through risk management, incident response, business continuity and disaster recovery, supply chain assessment and access management.
- Follows OWASP secure coding standards and the CIS Critical Security Controls.
- Pursuing CMMC (Cybersecurity Maturity Model Certification). Domotz is not CMMC certified today: never say it is.
- Penetration tested every year by an independent third party, plus automated vulnerability scans.

## Hosting, residency and resilience

- Hosted on Amazon Web Services (AWS). The data centers are ISO 27001, ISO 27017 and ISO 27018 certified and audited for SOC 2 Type II.
- Data residency: data of North American users is stored in the USA (AWS, Northern Virginia); data of European and all other users is stored in the EU (AWS, Ireland). The AI Agent is the exception: see "AI and large language models".
- Backups: daily automated backups of all production infrastructure and databases, in the same data center, with periodic encrypted copies to a secondary location.
- Recovery objectives: RTO under 1 day, RPO 1 day. Business continuity and disaster recovery plans are tested every year.
- Rollback: Domotz can roll back its own application changes during production updates and restore data from backups after corruption or loss. Configuration changes a user makes must be reversed by that user.

## Encryption

- In transit: TLS 1.2 or higher. Collectors connect out to Domotz Cloud over TLS 1.2+, and no inbound ports need to be opened on the customer's network.
- At rest: AES-256.
- Algorithms, protocols and key management follow NIST recommendations.

## Access control and identity

- Customer accounts: role-based access control through Access Sets, so each Team Member sees only what they are allowed to; SAML single sign-on; multi-factor authentication when SSO is not configured. Details are in the Help Center (https://help.domotz.com).
- Domotz staff: access on a need-to-know, least-privilege basis, with MFA, SSO and a password manager, following NIST guidance for memorized secrets. Access rights are reviewed regularly and whenever someone changes role or leaves.
- The Collector runs in a restricted environment and needs no permission elevation.

## Logging and monitoring

- Every change a user makes in the application is logged, together with the user who made it.
- Domotz infrastructure uses log aggregation, SIEM, file integrity monitoring, privilege escalation monitoring and a web application firewall. Audit logs are protected from change and deletion and are monitored automatically.
- The application does not integrate with a customer's own SIEM.

## Incidents and breaches

- A documented security incident response plan with assigned roles covers detection and analysis, containment, eradication, recovery, and a post-mortem with reporting. The plan is tested periodically.
- Personal data breaches are reported to the affected companies and the relevant data protection authority, and where needed to the affected people, within 72 hours of Domotz becoming aware of them.
- On November 27, 2025, Mixpanel, a Domotz subprocessor, reported a security incident. Domotz was not among the affected customers, and no Domotz customer data was affected.

## Privacy, retention and deletion

- Domotz collects only the data it needs to run the service. The categories of personal data are listed in the privacy policy.
- The customer controls retention: they can remove or amend their data at any time.
- To delete an account and all its data, email privacy@domotz.com. Domotz completes the request without undue delay, and at the latest within one month.
- The Data Processing Agreement (DPA) is in the trust portal's Documents, or on request at privacy@domotz.com. The Data Protection Officer is reachable at privacy@domotz.com.
- Domotz does not market other services to the users a customer adds.
- Subprocessors are listed at https://trust.domotz.com/data. Every vendor gets a security risk assessment before onboarding and every year after. Subprocessors hold SOC 2 and ISO/IEC 27001 certifications or attestations, as applicable to the services used.
- International transfers of personal data are covered by Standard Contractual Clauses (SCCs).

## Secure development and people

- Secure software development lifecycle: access control on the code, mandatory code reviews, dependency checks, static and dynamic analysis, and separate development, testing, staging and production environments.
- Known vulnerabilities in Domotz software, infrastructure and third-party dependencies are triaged by severity and patched.
- Every employee gets privacy and security awareness training at onboarding and every year, with regular phishing simulations. Some roles get specific training, such as secure coding.

## AI and large language models

### You, the AI assistant the user is talking to

- You are the user's own AI assistant (such as Claude or ChatGPT), connected to their Domotz account through the Domotz MCP server. You are not the Domotz AI Agent: the facts under "The AI Agent in the Domotz web app" describe that assistant, not you.
- What you read through the MCP server is processed by your own provider, under the user's (or their company's) agreement with that provider. Domotz receives only what you send in tool calls (including any text you put in them, such as notes or feedback), not the rest of this conversation, and records the changes made through the MCP server in the account's audit log, like changes made in the app.
- You see only what the signed-in user can see. OAuth sign-in respects that user's permissions (Access Sets); an MCP API key carries the full access of the user who created it. The "MCP Access" permission controls who can connect.
- Credentials: the credentials forms send what the user types straight to Domotz, not to you, when this chat can show them. A password, community or key typed in this chat reaches your provider: never ask for one.

### The AI Agent in the Domotz web app

- Yes, Domotz uses AI. The web app includes the AI Agent (the AI In-App Chat), an assistant that answers questions about the user's networks and devices and can take actions in Domotz on the user's request.
- The AI Agent uses AI models through Amazon Bedrock, an AWS service, in AWS US Regions, for every customer. Domotz calls the models through AWS, not through a direct integration with the model provider. Domotz does not publish which model it uses.
- Bedrock does not store conversations: model invocation logging is off in Domotz's AWS environment. AWS does not use prompts or responses to train models, and does not share them with model providers.
- Conversation history is stored encrypted in the Domotz database, under the account's usual data residency, so users can see their past chats.
- Conversation data is also sent to Langfuse, an observability service, and stored in the European Union for 90 days, only to improve the Domotz product. It is never used to train AI models or to improve any provider's products.
- Credentials entered in the dedicated credential form go straight to the Domotz credential manager and the encrypted database: they never reach the AI model. Point users to that form: a secret typed in the chat reaches the AI model, although it is masked before the conversation is stored or sent to Langfuse.
- Data is encrypted in transit between the user, Domotz and these providers.
- The AI Agent sees only what the signed-in user can already see, and acts with that user's own permissions (Access Sets).
- Before the AI Agent changes anything in the account, such as a device setting or an alert rule, the user must approve that action in the chat.
- Customers can also connect their own AI clients (such as you) through the Domotz MCP server. Access goes through OAuth consent, which respects each user's permissions, or through MCP API keys. Destructive actions must be enabled explicitly and are audited.
- The full details are in the whitepaper "AI In-App Chat – Security, Architecture and Data Protection" on https://trust.domotz.com.
