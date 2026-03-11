# How Codex and Claude Can Be Used End-to-End in Salesforce: Strategy, Use Cases, Prompts, Governance, and Enterprise Implementation Guide

Author: Shivam Gupta  
Role: Salesforce Architect  
Website: pulsagi.com  
Document Type: Enterprise whitepaper + implementation guide + operational playbook  
Audience: Salesforce Architects, Developers, Admins, Business Analysts, QA Engineers, DevOps/Release Managers, Project Managers, Support Teams, CIO/CTO/Leadership

---

## Executive Summary

Codex and Claude are both high-value AI assistants for Salesforce delivery, but they are not interchangeable. Codex is strongest when the work is code-adjacent, repository-aware, implementation-specific, and execution-oriented. Claude is strongest when the work demands large-context synthesis, structured reasoning, long-form documentation, requirements analysis, policy interpretation, and multi-stakeholder communication. Enterprise Salesforce teams get the best results when they stop asking "Which model is best?" and start asking "Which model is best for this stage, artifact, and role?"

For Salesforce, AI assistants matter because delivery is not only coding. A typical program includes discovery workshops, process mapping, security design, admin configuration, Apex, LWC, Flow, integrations, testing, release management, support triage, documentation, and executive reporting. Teams lose time not only in writing code, but also in clarifying requirements, translating design decisions, reviewing change risk, documenting configuration, generating tests, and investigating production issues. AI can compress all of those non-trivial activities if used with discipline.

At a business level, Codex and Claude can improve:

- Delivery speed through faster drafting, prototyping, review, and troubleshooting
- Quality through more complete edge-case discovery, better documentation, and stronger testing support
- Cost efficiency by reducing repetitive delivery effort and shortening onboarding time
- Innovation capacity by letting teams spend more time on architecture and business outcomes instead of administrative overhead

At a technical level, these tools fit across the Salesforce lifecycle:

| Lifecycle Stage | Primary Value of Codex | Primary Value of Claude | Best Combined Pattern |
|---|---|---|---|
| Discovery | Structured analysis of existing metadata/code when available | Workshop synthesis, story writing, gap analysis | Claude frames, Codex validates technical feasibility |
| Architecture | Technical optioning tied to implementation constraints | Large-context design reasoning and tradeoff narratives | Claude drafts options, Codex pressure-tests execution |
| Development | Apex/LWC/Flow implementation, repo-aware edits, refactoring | Design explanation, review notes, legacy understanding | Claude explains intent, Codex produces concrete changes |
| Testing | Test classes, scenario coverage, defect reproduction support | Test strategy, risk-based coverage, traceability | Claude defines coverage model, Codex generates technical tests |
| DevOps | Deployment scripts, package manifests, risk summaries from diffs | Release communications, governance notes, rollout plans | Codex works in repo, Claude creates release narrative |
| Support | Log/code inspection and targeted fixes | Incident summaries, RCA narratives, KB drafts | Codex isolates defect path, Claude creates support artifacts |

### Key takeaways for enterprise teams

- Do not position AI as a developer-only tool. Salesforce value appears across architecture, admin work, QA, documentation, PM, and support.
- Use Codex where implementation precision, code change execution, and repository context matter.
- Use Claude where long-form reasoning, large document synthesis, design writing, and multi-audience communication matter.
- Use both together for end-to-end delivery: Claude for framing and decomposition, Codex for execution and technical refinement.
- Put governance first: no secrets, no tokens, no direct PII pasting, no blind trust in generated output, and mandatory human review for code, security, and architectural decisions.

---

## Table of Contents

1. [Executive Summary](#executive-summary)
2. [Introduction to AI Assistants in Salesforce](#section-2-introduction-to-ai-assistants-in-salesforce)
3. [Codex vs Claude for Salesforce](#section-3-codex-vs-claude-for-salesforce)
4. [End-to-End Salesforce Lifecycle Overview](#section-4-end-to-end-salesforce-lifecycle-overview)
5. [Use in Requirements Gathering and Discovery](#section-5-use-in-requirements-gathering-and-discovery)
6. [Use in Solution Design and Architecture](#section-6-use-in-solution-design-and-architecture)
7. [Use in Salesforce Admin Work](#section-7-use-in-salesforce-admin-work)
8. [Use in Apex Development](#section-8-use-in-apex-development)
9. [Use in LWC Development](#section-9-use-in-lwc-development)
10. [Use in Flow and Automation](#section-10-use-in-flow-and-automation)
11. [Use in Integrations](#section-11-use-in-integrations)
12. [Use in Data Migration and Data Quality](#section-12-use-in-data-migration-and-data-quality)
13. [Use in DevOps, Releases, and Environment Management](#section-13-use-in-devops-releases-and-environment-management)
14. [Use in QA and Testing](#section-14-use-in-qa-and-testing)
15. [Use in Documentation](#section-15-use-in-documentation)
16. [Use in Support and Maintenance](#section-16-use-in-support-and-maintenance)
17. [Use for Leadership, PM, and Delivery Management](#section-17-use-for-leadership-pm-and-delivery-management)
18. [Role-Based Usage Model](#section-18-role-based-usage-model)
19. [Prompt Library](#section-19-prompt-library)
20. [Sample End-to-End Workflows](#section-20-sample-end-to-end-workflows)
21. [Governance, Security, and Compliance](#section-21-governance-security-and-compliance)
22. [Quality Control and Human Review Model](#section-22-quality-control-and-human-review-model)
23. [Limitations and Failure Modes](#section-23-limitations-and-failure-modes)
24. [KPI and ROI Framework](#section-24-kpi-and-roi-framework)
25. [Implementation Roadmap](#section-25-implementation-roadmap)
26. [Recommended Operating Model](#section-26-recommended-operating-model)
27. [Final Recommendations](#section-27-final-recommendations)

---

## Section 2: Introduction to AI Assistants in Salesforce

### 2.1 From documentation lookup to delivery copilots

Salesforce teams historically relied on three things:

- product documentation
- internal architects and senior developers
- trial-and-error in sandboxes

AI assistants change that operating model. Instead of only searching for how a feature works, teams can ask an assistant to:

- convert workshop notes into user stories
- compare standard Salesforce options versus custom design
- generate an Apex selector pattern
- identify risks in a Flow design
- summarize a deployment diff into release notes
- create test scenarios from acceptance criteria
- produce an incident RCA draft from support logs

This is a meaningful shift. AI is no longer just retrieval. It is an accelerator for decomposition, synthesis, design, implementation, and communication.

### 2.2 Why Salesforce projects are a strong fit

Salesforce delivery has recurring patterns and structured artifacts. That makes it a strong environment for AI assistance.

Common artifact types:

- epics, user stories, acceptance criteria
- object models, field lists, sharing models
- Flows, validation rules, formulas, email templates
- Apex, test classes, queueables, schedulables
- LWCs, Jest tests, UI patterns
- API contracts, field mappings, payload schemas
- deployment manifests, release notes, smoke test lists
- runbooks, KB articles, onboarding docs

The work is also multidisciplinary. That creates many translation points where AI is useful:

- business need to Salesforce capability
- requirement to story
- story to design
- design to config/code
- code to test
- defect to root cause
- change set to release communication

Salesforce domain coverage where AI is especially useful:

- Sales Cloud process design, lead routing, opportunity management, forecasting support
- Service Cloud case processes, omni-channel, knowledge, entitlement, and escalation design
- Experience Cloud portal journeys, role/sharing design, onboarding, and self-service UX
- Marketing-related campaign operations, consent logic, segmentation documentation, and communication process mapping
- Platform development, custom app delivery, integrations, migration, support, and governance

### 2.3 Common Salesforce pain points AI can solve

| Pain Point | Typical Impact | AI Opportunity |
|---|---|---|
| Ambiguous requirements | rework, late clarification | structured discovery questions, assumptions logging, gap analysis |
| Over-customization | unnecessary build cost | standard-vs-custom option matrices |
| Weak documentation | onboarding delays, support dependency | instant draft generation for TDD, LLD, runbooks |
| Incomplete testing | escaped defects | scenario generation, negative-path coverage, traceability |
| Slow code review | bottlenecks | targeted review findings and refactoring suggestions |
| Flow sprawl | maintainability issues | naming standards, subflow decomposition, debug assistance |
| Integration uncertainty | production incidents | contract mapping, retry design, logging guidance |
| Release communication gaps | support confusion | release notes, impact summaries, backout plans |

### 2.4 Generic AI use versus Salesforce-specific use

Generic AI use looks like:

- "Write me an Apex trigger"
- "Explain Service Cloud"
- "Create a formula"

Salesforce-specific enterprise use looks like:

- "Given these 17 discovery notes, produce a lead qualification capability map for Sales Cloud, identify what should be standard, what needs custom Apex, and where approval routing must be externalized."
- "Review this repository and identify whether our trigger handler pattern bulkifies contact dedupe correctly under mixed insert/update conditions."
- "Generate a migration reconciliation checklist for these legacy customer status values mapped into Account, Contact, and custom enrollment objects."

The difference is context, precision, and governance. Enterprise value comes from structured prompts, project-specific input, and disciplined review.

### 2.5 Workflow overview by role

| Role | Typical AI Use |
|---|---|
| Architect | solution optioning, risk analysis, non-functional requirements, security model reviews |
| Developer | Apex/LWC generation, refactoring, debugging, test classes, integration handlers |
| Admin | formula drafting, Flow design, validation rules, report/dashboard definitions |
| Business Analyst | workshop prep, story decomposition, acceptance criteria, BRD/FRD creation |
| QA | test cases, edge cases, regression planning, defect summaries |
| DevOps | package manifests, release notes, backout plans, readiness checks |
| Support | RCA drafts, log interpretation, KB article generation |
| Leadership | status summaries, ROI framing, operating model decisions |

---

## Section 3: Codex vs Claude for Salesforce

### 3.1 Core positioning

- **Codex**: best when the task is grounded in code, files, repository structure, implementation diffs, local execution, or concrete technical edits.
- **Claude**: best when the task is broad, document-heavy, conceptually layered, or requires nuanced synthesis across large bodies of requirements, policy, or design material.

### 3.2 Comparison table

| Task Type | Codex Best For | Claude Best For | Recommended Choice | Notes |
|---|---|---|---|---|
| Apex generation | class creation, refactoring, tests, repo-aware changes | explain design patterns, compare alternatives | Codex | Human review required |
| LWC generation | scaffolding, component fixes, Jest support | UX flows, component documentation, state explanations | Codex + Claude | Claude can frame, Codex can implement |
| Requirements analysis | parsing artifacts tied to repo metadata | workshop notes, BRD/FRD drafting, ambiguity reduction | Claude | Claude is usually stronger here |
| Architecture docs | implementation cross-checks | long-form architecture narrative, pros/cons matrices | Claude + Codex | Use both for stronger decisions |
| Code review | actionable file-level findings | explanation and remediation plans | Codex | Especially when repo access exists |
| Flow design | technical decomposition, formula help | business logic phrasing, flow decision rationale | Both | Depends on artifact depth |
| Integration mapping | payload examples, stub code | end-to-end design docs, sequence reasoning | Both | Claude for design, Codex for implementation |
| Release notes | diff-based summaries from actual changes | polished business communication | Both | Codex extracts, Claude translates |
| Incident RCA | log/code analysis | executive-safe RCA narrative | Both | Strong combined pattern |
| Executive briefings | limited | strong | Claude | Better for long-form communication |

### 3.3 Deep comparison by capability

| Capability | Codex | Claude |
|---|---|---|
| Reasoning style | concrete, implementation-driven, pragmatic | expansive, structured, synthesis-heavy |
| Code generation | strong | capable but less repo-action oriented |
| Documentation generation | good | excellent for long-form and multi-audience |
| Refactoring quality | strong when code context is present | strong at conceptual cleanup, weaker at exact repo edits |
| Large context handling | good in practical file-level workflows | strong for large documents and broad reasoning |
| Debugging | strong with stack traces, repo, and code | good at root-cause hypotheses and explanation |
| System thinking | good from implementation boundary inward | strong from operating model and architecture outward |
| Prompt adherence | strong for direct tasks | strong for structured narrative and constrained outputs |
| Speed vs depth | efficient execution | deeper synthesis |
| Best fit | coding, review, technical edits | strategy, design, documentation, complex analysis |

### 3.4 When to use Codex

Use Codex when the work requires:

- actual file edits
- repo-aware code changes
- Apex class generation/refactoring
- LWC bug fixes
- diff review
- unit test writing
- deployment artifact generation
- line-by-line technical inspection

### 3.5 When to use Claude

Use Claude when the work requires:

- requirements synthesis from large workshop notes
- option analysis across multiple architectural choices
- executive-ready documentation
- long-form design guidance
- governance frameworks
- polished training or support documentation
- multi-role communication artifacts

### 3.6 When to use both together

Use both in this sequence for best enterprise results:

1. Claude synthesizes the problem, assumptions, decisions, risks, and artifact structure.
2. Codex executes the technical implementation, review, or file changes.
3. Claude turns outcomes into documentation, summaries, governance notes, or stakeholder communication.
4. Humans validate.

### 3.7 Limitations by tool

| Tool | Limitations |
|---|---|
| Codex | can over-focus on implementation if business context is weak; may need explicit design constraints |
| Claude | can produce elegant analysis that still needs technical pressure-testing in the repo or org context |

### 3.8 Decision tree

```text
Is the task primarily about code/files/diffs?
+- Yes -> Start with Codex
|  +- Need broader documentation or stakeholder output? -> Add Claude after implementation
|  +- Need design framing first? -> Use Claude briefly, then Codex
+- No -> Is the task primarily synthesis, design, or communication?
   +- Yes -> Start with Claude
   +- Mixed -> Claude for framing, Codex for technical execution
```

---

## Section 4: End-to-End Salesforce Lifecycle Overview

### 4.1 Lifecycle support model

AI can contribute at every stage of the Salesforce lifecycle:

- ideation
- discovery
- requirements gathering
- architecture and solution design
- estimation
- configuration and development
- testing
- deployment
- training and enablement
- support and maintenance
- optimization

### 4.2 Text lifecycle diagram

```text
Business Idea
  ->
Discovery Workshops
  ->
Requirements / Stories / Acceptance Criteria
  ->
Solution Design / Architecture / Security Review
  ->
Build Planning / Estimation / Sprint Decomposition
  ->
Admin Configuration / Apex / LWC / Integrations / Flow
  ->
Testing / QA / UAT / Regression
  ->
Release Planning / Deployment / Cutover
  ->
Training / Hypercare / Support
  ->
Optimization / Analytics / Backlog Refinement
```

### 4.3 Stage-by-stage contribution

| Stage | Claude Role | Codex Role | Human Review Required |
|---|---|---|---|
| Ideation | option framing, business capability mapping | feasibility hints | yes |
| Discovery | workshop prep, question sets, process analysis | technical fit checks | yes |
| Architecture | alternative evaluation, NFR framing | implementation feasibility review | yes |
| Development | pattern explanation | code generation and edits | yes |
| Testing | strategy, edge-case expansion | test implementation | yes |
| Deployment | release narratives, impact communications | package, scripts, risk from diffs | yes |
| Support | incident summary, RCA narrative | code/log inspection | yes |
| Optimization | trend analysis | targeted fixes and improvements | yes |

---

## Section 5: Use in Requirements Gathering and Discovery

### 5.1 Core uses

Codex and Claude can help with:

- converting business needs into epics, features, user stories, and tasks
- surfacing ambiguous statements and missing decisions
- generating acceptance criteria
- identifying edge cases and exception paths
- preparing workshop questions
- creating discovery questionnaires
- mapping business processes to Salesforce capabilities
- producing BRD/FRD drafts
- performing gap analysis between current state and target state

### 5.2 Recommended split

- Claude: discovery synthesis, BRD/FRD drafting, workshop questions, process decomposition
- Codex: validating whether requested behavior maps to current metadata/code patterns, identifying technical debt in existing implementation

### 5.3 Use case examples

#### Lead management

AI can:

- convert lead lifecycle workshops into stories like dedupe, routing, SLA follow-up, and conversion
- identify missing requirements such as round-robin logic, territory exceptions, duplicate handling, and assignment overrides
- map needs to Sales Cloud, Assignment Rules, Flow, duplicate rules, and custom objects where needed

**Sample prompt**

```text
Act as a senior Salesforce business analyst and solution architect.
Using the workshop notes below, create:
1. epics
2. features
3. user stories
4. acceptance criteria
5. edge cases
6. Salesforce feature mapping

Business domain: lead management
Priority: standard Salesforce first, custom only where necessary
Workshop notes:
[paste notes]
```

#### Loan processing

AI can:

- decompose intake, document validation, underwriting review, approval routing, and disbursement
- identify where standard objects are insufficient and custom objects are needed
- generate process questions around KYC, consent, audit, and exception handling

#### Customer service workflow

AI can:

- define service request lifecycle
- map case types, entitlement checks, escalation triggers, and omni-channel routing
- identify KB, bots, handoff, and SLA reporting needs

#### Approval flows

AI can:

- identify approval levels, delegated approvers, fallback approvers, bypass logic, and audit requirements
- draft approval matrices

#### Partner portal requirements

AI can:

- convert partner onboarding notes into Experience Cloud capability backlog
- identify profile, permission, sharing, and role model questions

### 5.4 Discovery framework

| Dimension | Questions AI should help surface |
|---|---|
| Process | What is the start, end, approval, and exception path? |
| Data | Which records are created, updated, validated, or migrated? |
| Security | Who can see, edit, approve, export, or escalate? |
| Integration | Which external systems are sources of truth? |
| Reporting | What metrics define success and operational control? |
| Compliance | What retention, masking, consent, or audit needs exist? |

### 5.5 Checklist

- Have all primary personas been identified?
- Are exception paths documented?
- Are success metrics defined?
- Are integration boundaries identified?
- Are compliance constraints captured?
- Are assumptions and open questions logged?

---

## Section 6: Use in Solution Design and Architecture

### 6.1 What AI can do well in architecture

AI can rapidly turn requirements into:

- solution options
- standard-vs-custom recommendations
- object and field models
- automation strategy options
- security model candidates
- integration patterns
- migration strategies
- multi-org versus single-org considerations
- NFR lists
- risk matrices

### 6.2 Standard versus custom analysis

**Prompt template**

```text
Act as a Salesforce solution architect.
Given these requirements, propose three solution options:
1. standard-first
2. hybrid
3. custom-heavy

For each option include:
- Salesforce features used
- custom build required
- pros
- cons
- risks
- scalability implications
- maintainability implications
- security considerations
- recommended option
```

### 6.3 Design areas

#### Object model and field design

AI can draft:

- entity relationships
- field purpose tables
- ownership rules
- indexing considerations
- archival concerns

#### Automation strategy

AI can help decide:

- record-triggered flow versus Apex
- before-save versus after-save flow
- when subflows are appropriate
- where async patterns are needed

#### Integration architecture

AI can outline:

- sync versus async tradeoffs
- middleware versus direct API
- platform event use
- retry and idempotency strategy
- ownership of transformation logic

#### Security model

AI can structure:

- role hierarchy
- profile/permission set strategy
- sharing model
- field-level security matrix
- sensitive data controls

#### Service architecture

AI can help with:

- omni-channel design
- case routing
- entitlement model
- escalation model
- service console design

#### Experience Cloud design

AI can support:

- audience segmentation
- external user sharing
- authentication patterns
- content architecture
- portal self-service journeys

#### Org strategy and operating topology

AI can help frame:

- single-org versus multi-org decision factors
- regional, business-unit, or regulatory partitioning needs
- integration and data residency implications
- support and CoE operating model consequences

#### Non-functional requirements and scalability

AI can draft NFR sets covering:

- transaction volumes
- latency expectations
- resiliency and retry posture
- auditability
- maintainability
- observability
- supportability
- large data volume considerations

#### Performance considerations

AI can help identify:

- Flow recursion and transaction depth risks
- unselective query patterns
- synchronous integration bottlenecks
- UI rendering and LWC state churn issues
- high-volume sharing recalculation concerns

#### Data migration planning

AI can structure:

- object sequencing
- mapping sheets
- validation rules to disable/enable
- cutover windows
- reconciliation metrics

### 6.4 Architecture review use

AI is valuable in architecture review boards for:

- design challenge questions
- anti-pattern detection
- tradeoff summaries
- readiness checklists
- ADR drafting

### 6.5 Pros/cons matrix example

| Option | Pros | Cons | Best Fit |
|---|---|---|---|
| Standard Sales Cloud routing | low maintenance, native reporting | limited custom prioritization logic | low complexity routing |
| Flow-based orchestration | admin-manageable, visible logic | can sprawl, harder to debug at scale | medium complexity |
| Apex orchestration | full control, complex logic support | higher maintenance, dev dependency | high complexity or heavy integration |

### 6.6 Human review required

- Validate every design option against actual licensing, org constraints, and integration ownership.
- Do not accept AI recommendations for sharing or encryption without security review.
- Pressure-test AI-generated designs against transaction volume and support model.

---

## Section 7: Use in Salesforce Admin Work

### 7.1 High-value admin use cases

- field creation planning
- validation rule drafting
- formula generation
- Flow design and naming
- Flow debugging
- page layout and Dynamic Forms recommendations
- report/dashboard definitions
- permission set design support
- email template drafting
- assignment and escalation rule logic
- knowledge setup
- case configuration
- sandbox setup checklists
- release note summarization

### 7.2 Examples

#### Validation rule

```text
Create a Salesforce validation rule for Opportunity that prevents stage moving to Closed Won when Primary_Contact__c is blank and Implementation_Date__c is in the past. Explain the logic in plain English and include test scenarios.
```

#### Formula support

```text
Create a Salesforce formula field that classifies a case as SLA Breached if Status is not Closed and NOW() is greater than Milestone_Target__c. Also provide null handling guidance.
```

#### Flow debugging

```text
Review this screen flow outcome summary and explain likely failure points:
- user sees generic fault message after submit
- records created sometimes duplicate
- one path skips approval task creation

Recommend debug steps, logging strategy, and design fixes.
```

### 7.3 Admin best practices

- Always ask AI for both formula/Flow logic and plain-English explanation.
- Request test scenarios with every admin artifact.
- Ask for naming conventions, descriptions, and maintenance notes.
- Review performance impact before implementing complex Flow loops.

### 7.4 Do and don't

| Do | Don't |
|---|---|
| use AI to draft formulas and explain them | paste confidential customer records |
| use AI for sandbox/release checklists | trust generated Flow logic without testing |
| use AI to improve field descriptions and documentation | allow AI to define security access without review |

---

## Section 8: Use in Apex Development

### 8.1 Where AI is most valuable

AI is highly effective in Apex when used for:

- class scaffolding
- trigger/handler structure
- service layer and selector patterns
- queueables, batches, schedulables
- invocable methods
- REST resources
- callout code
- platform event subscribers
- wrapper classes
- test data setup and test classes
- refactoring and readability improvements
- code review and defect isolation

### 8.2 Target patterns

- trigger framework
- domain/service separation
- selector pattern for SOQL centralization
- utility classes
- custom metadata-driven logic
- error normalization
- retry strategies

### 8.3 Example scenarios

#### Contact lookup by email/phone

Use AI to generate:

- normalized search utility
- bulk-safe lookup service
- test coverage for duplicate hits and no-hit scenarios

**Prompt**

```text
Create Apex using a service layer and selector pattern to find contacts by normalized email or phone.
Requirements:
- bulk-safe
- with sharing
- null-safe
- return wrapper with match confidence and source field
- include tests
- avoid SOQL in loops
```

#### Loan eligibility service

Use AI to:

- create a service class that evaluates applicant data
- externalize thresholds into custom metadata
- design a response wrapper for UI and integration reuse

#### External API callout

Use AI to:

- create named credential-based callout service
- add timeout handling and response parsing
- generate `HttpCalloutMock` tests

#### Batch data cleanup

Use AI to:

- generate a batch class to normalize duplicate data or archive stale records
- design retry/resume pattern where appropriate

#### Case assignment engine

Use AI to:

- compare Flow, custom metadata, and Apex routing options
- implement a metadata-driven assignment service

#### Reusable utility framework

Use AI to:

- refactor repeated date formatting, error handling, or mapping logic into a utility layer

### 8.4 Apex review checklist

- Is the code bulkified?
- Is sharing behavior correct?
- Are limits considered?
- Are SOQL/DML in loops avoided?
- Are nulls handled explicitly?
- Are callouts mocked in tests?
- Is error handling user-safe and support-friendly?
- Is custom metadata used where hard-coded business rules should not exist?

### 8.5 Human review required

Never deploy AI-generated Apex without:

- peer review
- static analysis
- governor limit review
- positive and negative test execution
- security review if handling sensitive data

### 8.6 Anti-patterns

- gigantic all-in-one triggers
- hidden side effects in helper methods
- hard-coded IDs and endpoints
- tests that only assert non-null
- logic that ignores mixed bulk operations

---

## Section 9: Use in LWC Development

### 9.1 LWC use cases

- component scaffolding
- HTML/JS/CSS generation
- wire adapter usage
- imperative Apex calls
- event communication
- reusable components
- datatable patterns
- wizard flows
- modals
- file upload
- responsive layouts
- accessibility improvements
- Jest tests
- debugging rendering issues

### 9.2 Example use cases

#### Intake form

AI can draft:

- form sections
- client-side validation
- Apex submission contract
- UX copy

#### Contact creation wizard

AI can generate:

- multi-step navigation
- validation summary banner
- save/resume behavior
- toast/error handling

#### Dashboard widgets

AI can produce:

- KPI cards
- chart data transformation
- refresh logic
- empty state UX

#### Document upload screen

AI can support:

- file validation
- progress display
- upload error messaging

#### Custom portal component

AI can help with:

- Experience Cloud constraints
- external user-friendly messaging
- responsive design for smaller form factors

### 9.3 LWC prompt example

```text
Create a Lightning Web Component for a 3-step customer intake wizard.
Requirements:
- mobile responsive
- accessible labels and keyboard navigation
- validate email, phone, and required documents
- use imperative Apex save on final step
- show inline errors and a summary banner
- include Jest tests outline
```

### 9.4 Best practices

- Ask for accessibility considerations every time.
- Ask for performance considerations when using datatables or repeated renders.
- Request both component code and explanation of state transitions.
- Validate security, field access, and data exposure assumptions.

---

## Section 10: Use in Flow and Automation

### 10.1 Flow-related uses

- decision logic drafting
- naming convention enforcement
- screen copy/help text
- auto-launched flow planning
- subflow decomposition
- error path design
- failed flow troubleshooting
- Flow documentation
- process-to-Flow conversion
- Flow versus Apex decisions

### 10.2 Prompt example

```text
Design a record-triggered flow for Case that:
- runs on create and update
- routes high-priority cases to an escalation queue
- creates a follow-up task when customer SLA risk is high
- avoids recursion
- includes fault paths
- uses maintainable naming conventions

Provide the recommended elements, decisions, entry criteria, and documentation notes.
```

### 10.3 Flow governance guidance

- prefer before-save for simple field updates
- use subflows for repeated business logic
- avoid overly complex loops in large-volume transactions
- document every fault path
- define ownership for every major automation

### 10.4 Flow vs Apex decision table

| Scenario | Prefer Flow | Prefer Apex |
|---|---|---|
| simple record update | yes | no |
| admin-maintained branching | yes | maybe |
| complex cross-object orchestration | maybe | yes |
| heavy-volume logic | risky | often yes |
| complex external callouts | limited | yes |

---

## Section 11: Use in Integrations

### 11.1 AI support areas

- API design
- payload mapping
- JSON schema generation
- authentication pattern explanation
- named credentials planning
- sequence diagrams
- retry/error handling
- logging strategy
- event-driven architecture
- webhook handling
- middleware collaboration

### 11.2 Integration examples

#### Loan origination system

AI can help define:

- application creation payload
- underwriting update events
- idempotent retry strategy
- reconciliation rules

#### Payment gateway

AI can help define:

- tokenized payment flow
- safe error categories
- PCI-sensitive fields to never expose

#### Identity provider

AI can help with:

- SSO/SAML/OIDC explanation
- user provisioning flow
- role mapping model

#### ERP integration

AI can generate:

- account/order/invoice mapping sheets
- ownership matrix
- sync frequency tradeoffs

#### Communication tools

AI can design:

- SMS/email event flow
- consent checks
- communication logging strategy
- campaign response integration patterns for marketing operations
- audience segmentation data handoff guidance

### 11.3 MuleSoft and API-led guidance

Where MuleSoft or another middleware layer exists, AI can help define:

- experience, process, and system API separation
- ownership of transformation logic
- replay and dead-letter handling
- API versioning policy
- support model between Salesforce, middleware, and source systems

### 11.4 Sequence diagram prompt

```text
Create a text sequence diagram for Salesforce integrating with ERP for order fulfillment.
Include:
- order created in Salesforce
- middleware transformation
- ERP acknowledgment
- failure handling
- retry
- status update back into Salesforce
```

### 11.5 Integration checklist

- What is the system of record?
- Is the pattern sync or async?
- How are retries handled?
- Is idempotency required?
- What gets logged?
- Who owns schema changes?
- What is the timeout strategy?
- What is the support model?

---

## Section 12: Use in Data Migration and Data Quality

### 12.1 High-value uses

- source-to-target mapping drafts
- cleansing rules
- dedupe logic
- validation planning
- sequencing plans
- mock datasets
- UAT data strategy
- data quality dashboards
- reconciliation logic
- cutover and rollback planning

### 12.2 Example prompt

```text
Act as a Salesforce data migration architect.
Create a source-to-target mapping and migration checklist for:
- legacy customer table
- contact table
- loan table
- communication preference table

Target: Salesforce Account, Contact, Opportunity, custom Loan__c
Include:
- transformations
- default values
- dedupe rules
- validation rules impact
- load sequence
- reconciliation checks
```

### 12.3 Migration operating principles

- migrate reference data before transactional data
- define survivorship rules early
- plan for inactive/archived records
- separate cleansing from loading
- define reconciliation reports before cutover

### 12.4 Data quality dashboard ideas

- duplicate rate by source
- mandatory field completeness
- invalid email rate
- orphan child records
- status value normalization coverage

---

## Section 13: Use in DevOps, Releases, and Environment Management

### 13.1 AI use cases

- deployment plans
- package manifest drafts
- change risk summaries
- release notes
- regression scope identification
- environment readiness checklists
- user communication drafts
- backout plans
- branching strategy guidance
- CI/CD explanation
- Copado process documentation

### 13.2 Example prompt

```text
Given this deployment scope, generate:
1. deployment checklist
2. pre-deploy validation
3. smoke test scope
4. rollback plan
5. support notification draft
6. release note summary for business users
```

### 13.3 Release manager checklist

- metadata validated in lower environments
- permission changes reviewed
- data scripts sequenced
- smoke tests agreed
- backout criteria defined
- support team briefed
- user communication approved

### 13.4 Merge conflict help

AI can explain:

- why metadata conflicts happened
- which profile/permission set merges are risky
- how to compare Flow versions safely
- how to isolate high-risk deployment components

---

## Section 14: Use in QA and Testing

### 14.1 Core uses

- test scenario generation
- test case generation
- negative testing
- edge-case identification
- regression suite planning
- UAT scripts
- defect summary creation
- traceability matrix drafts
- risk-based testing plans
- automation test ideas

### 14.2 Example scenarios

| Process | QA Questions AI Can Help Generate |
|---|---|
| Lead conversion | What happens if duplicate account exists, required fields missing, owner inactive, or integration unavailable? |
| Contact creation | What if dedupe triggers, phone invalid, user lacks permission, or flow faults? |
| Case escalation | What if entitlement missing, queue full, SLA timestamp null, or omni-channel unavailable? |
| Approval process | What if delegated approver absent, approval recalled, or threshold changed mid-flight? |
| API failure handling | What if external timeout occurs, duplicate retry happens, or partial response returns? |

### 14.3 Prompt example

```text
Generate a risk-based test suite for Salesforce lead conversion.
Include:
- happy path
- negative path
- edge cases
- permission-based scenarios
- integration dependencies
- regression priorities
- suggested automation candidates
```

### 14.4 Human review required

- QA leads must validate business risk ranking.
- Test data assumptions must match actual org rules.
- AI-generated test coverage is not a substitute for domain expertise.

---

## Section 15: Use in Documentation

### 15.1 Documents AI can accelerate

- technical design documents
- low-level designs
- architecture decision records
- admin guides
- runbooks
- support guides
- onboarding documents
- release notes
- troubleshooting guides
- knowledge articles
- README files
- API docs
- inline code comments
- handover packs

### 15.2 Documentation operating model

| Document Type | Draft by | Technical Validate by | Business Validate by |
|---|---|---|---|
| TDD/LLD | Claude | Architect/Lead | BA/Product Owner |
| Runbook | Claude | Support Lead/Developer | Ops Manager |
| Release notes | Claude | Release Manager | Product Owner |
| Code comments/README | Codex | Developer | n/a |
| API docs | Codex + Claude | Integration Lead | BA if external consumers exist |

### 15.3 Best practice

- generate first draft with AI
- require named human owner
- store docs in version control or controlled repository
- maintain changelog and review date

---

## Section 16: Use in Support and Maintenance

### 16.1 Support use cases

- incident analysis
- log interpretation
- impact analysis
- root cause drafts
- bug triage
- troubleshooting playbooks
- user issue summaries
- knowledge article creation
- trend detection from recurring incidents

### 16.2 Example prompt

```text
Analyze the following Salesforce production incident notes and logs.
Provide:
1. probable root cause
2. impacted user groups
3. immediate containment options
4. permanent fix options
5. support-friendly explanation
6. KB article draft
```

### 16.3 Support anti-patterns

- pasting raw customer PII into prompts
- using AI to communicate RCA before technical validation
- skipping incident timelines and evidence

---

## Section 17: Use for Leadership, PM, and Delivery Management

### 17.1 Management use cases

- project planning
- estimate decomposition
- RAID logs
- sprint planning summaries
- steering committee packs
- executive summaries
- stakeholder communication drafts
- adoption plans
- training plans

### 17.2 Example outputs

- project milestone summary
- risk summary by workstream
- sprint objective draft
- executive one-page decision memo
- training rollout plan

### 17.3 Prompt example

```text
Create a steering committee summary for a Salesforce transformation.
Include:
- progress since last meeting
- top risks
- decisions required
- dependencies
- budget/scope watch items
- next 30-day priorities

Audience: CIO, business sponsor, enterprise architect, PMO
```

---

## Section 18: Role-Based Usage Model

### Salesforce Admin

- Key use cases: formulas, Flow logic, page layouts, reports, release notes
- High-value prompts: "draft validation rules with examples", "explain this Flow fault path"
- Benefits: faster configuration drafting, better documentation
- Risks: incorrect security assumptions, inefficient automation logic
- Best practices: always request test scenarios and performance notes

### Salesforce Developer

- Key use cases: Apex/LWC/test classes/refactoring
- High-value prompts: "review this trigger for bulk and sharing issues"
- Benefits: faster implementation and review
- Risks: subtle limit/security defects
- Best practices: static analysis and peer review mandatory

### Technical Lead

- Key use cases: code review standards, refactoring plans, release risk analysis
- Benefits: team acceleration, consistency
- Risks: over-trusting generated fixes
- Best practices: use AI to augment review, not replace it

### Solution Architect

- Key use cases: option analysis, NFRs, security model, integration patterns
- Benefits: faster architecture artifacts
- Risks: elegant but unvalidated design assumptions
- Best practices: cross-check with org constraints and enterprise standards

### Enterprise Architect

- Key use cases: operating model, platform strategy, multi-org decisions, governance
- Benefits: better standardization
- Risks: abstract outputs disconnected from delivery reality
- Best practices: tie recommendations to measurable controls

### QA Engineer

- Key use cases: test matrices, edge cases, defect summaries
- Benefits: broader coverage
- Risks: shallow tests if prompts are weak
- Best practices: combine business risk and system dependency views

### Business Analyst

- Key use cases: stories, acceptance criteria, discovery packs, BRD/FRD
- Benefits: stronger requirement clarity
- Risks: missing domain nuance
- Best practices: use AI to expose questions, not invent answers

### Delivery Manager

- Key use cases: status, RAID, release comms, planning artifacts
- Benefits: lower reporting overhead
- Risks: over-polished but inaccurate summaries
- Best practices: verify with workstream leads before sharing

### Support Analyst

- Key use cases: triage summaries, incident patterns, KB articles
- Benefits: faster issue handling
- Risks: unsupported RCA assumptions
- Best practices: require evidence references in every support draft

### Product Owner

- Key use cases: backlog shaping, priority articulation, acceptance readiness
- Benefits: clearer stories and release communication
- Risks: AI-generated priorities that miss business nuance
- Best practices: keep final prioritization human-owned

---

## Section 19: Prompt Library

### Requirements

```text
Act as a Salesforce business analyst.
Convert the following business requirement into epics, features, user stories, acceptance criteria, assumptions, open questions, and edge cases.
Prioritize standard Salesforce functionality.
Requirement:
[paste]
```

### Architecture

```text
Act as a Salesforce solution architect.
Given the requirements below, propose solution options with pros/cons, risks, scalability considerations, integration implications, and a recommended approach.
[paste]
```

### Admin configuration

```text
Design the Salesforce admin solution for this requirement.
Include:
- objects/fields
- validation rules
- Flow outline
- page layout or Dynamic Forms recommendations
- permission set impacts
- reporting impacts
```

### Apex generation

```text
Generate Apex for the following requirement using enterprise patterns:
- with sharing unless justified otherwise
- bulk-safe
- null-safe
- service layer
- test class included
- error handling included
Requirement:
[paste]
```

### LWC generation

```text
Create an LWC for the following use case.
Include:
- HTML
- JS
- CSS
- Apex interface assumptions
- accessibility notes
- performance considerations
- Jest tests outline
```

### Flow design

```text
Design a Salesforce Flow for this process.
Include:
- trigger type
- entry criteria
- decisions
- subflows
- fault paths
- naming conventions
- maintainability recommendations
```

### Integrations

```text
Create an integration design for Salesforce and [system].
Include:
- system of record
- API pattern
- auth model
- payload mapping
- retries
- logging
- error handling
- support ownership
```

### Test classes

```text
Create comprehensive Salesforce Apex tests for this class.
Cover:
- happy path
- validation failures
- limit-sensitive behavior
- bulk scenarios
- security assumptions
```

### Test scenarios

```text
Generate business and system test scenarios for this process.
Include:
- positive
- negative
- edge
- role-based
- integration failure
- data quality
```

### Documentation

```text
Turn the following implementation notes into a technical design document.
Audience: architects, developers, admins, support
Include assumptions, dependencies, design decisions, risks, and operational notes.
```

### Release notes

```text
Summarize these deployment changes into:
1. technical release notes
2. business release notes
3. support impact summary
4. rollback considerations
```

### Support troubleshooting

```text
Analyze this incident evidence and produce:
- probable root cause
- impact
- immediate workaround
- long-term fix
- required teams
- draft knowledge article
```

### Data migration

```text
Create a migration plan for these source datasets into Salesforce.
Include mappings, transformations, load order, validation impacts, reconciliation, and rollback considerations.
```

### Security reviews

```text
Review this Salesforce solution for security and compliance risks.
Consider:
- field access
- sharing
- secrets
- integration auth
- PII exposure
- auditability
- admin bypass risks
```

### Code review

```text
Review this Salesforce code with a senior code-review mindset.
Prioritize:
- bugs
- regressions
- bulkification
- security
- readability
- missing tests
```

### Performance review

```text
Review this design for Salesforce performance risks.
Focus on:
- limits
- large data volume
- query selectivity
- Flow recursion
- UI performance
- integration latency
```

### Refactoring

```text
Refactor this Salesforce implementation for maintainability.
Keep behavior unchanged.
Improve structure, naming, reuse, error handling, and tests.
```

### User story writing

```text
Write a user story for Salesforce implementation using:
As a
I want
So that

Also provide acceptance criteria, dependencies, and test notes.
```

### Acceptance criteria creation

```text
Create detailed acceptance criteria for this Salesforce requirement.
Include business rules, permissions, edge cases, and reporting expectations.
```

---

## Section 20: Sample End-to-End Workflows

### 20.1 New Salesforce feature delivery

| Step | Tool | Output |
|---|---|---|
| workshop note synthesis | Claude | epics, stories, questions |
| architecture optioning | Claude | option matrix |
| technical feasibility check | Codex | fit with existing repo/org patterns |
| implementation | Codex | config/code changes |
| documentation | Claude | TDD, release notes |
| testing support | Claude + Codex | test cases + test classes |
| release package | Codex | manifests/checklists |

**Review checkpoints**

- BA validates stories
- Architect validates design
- Dev lead validates implementation
- QA validates coverage
- Release manager validates deployment

### 20.2 Custom Apex + LWC feature

1. Claude drafts capability and UX story.
2. Codex implements Apex service, LWC, and tests.
3. Claude creates user guide and support notes.
4. Human review validates security, UX, and performance.

### 20.3 Integration project delivery

1. Claude creates integration option matrix and sequence narrative.
2. Codex builds callout/service classes, payload mappings, and tests.
3. Claude documents support flow and operational ownership.

### 20.4 Production incident troubleshooting

1. Claude summarizes incident evidence and forms RCA hypotheses.
2. Codex inspects code, logs, and diffs to isolate likely defect path.
3. Claude drafts business and executive communication.
4. Human lead confirms containment and permanent fix plan.

### 20.5 Documentation and handover package creation

1. Claude turns implementation notes into runbooks/admin guides.
2. Codex extracts technical details from actual repo files.
3. Claude produces a final handover pack for support and operations.

---

## Section 21: Governance, Security, and Compliance

### 21.1 Core enterprise risks

- sensitive data exposure
- PII or PCI pasted into prompts
- secrets or tokens exposed
- confidential code or architecture leakage
- hallucinated features or unsafe recommendations
- legal/IP issues from uncontrolled use
- non-compliant vendor usage

### 21.2 Prompt hygiene rules

- never paste secrets, auth tokens, certificates, private keys
- never paste raw customer PII unless policy explicitly allows sanitized handling
- minimize copied production data
- redact identifiers where not necessary
- prefer synthetic examples

### 21.3 Governance framework

| Control Area | Required Practice |
|---|---|
| Acceptable use | define approved and prohibited use cases |
| Data handling | redact PII, no secrets, no raw production dumps |
| Human review | mandatory for code, security, architecture, compliance |
| Auditability | log how AI is used in critical delivery flows |
| Training | teach prompt hygiene and validation discipline |
| Vendor review | legal, security, procurement review |
| IP/confidentiality | define what can be shared externally |

### 21.4 Regulated industry considerations

For banking, insurance, healthcare, public sector, and similar environments:

- define approved data classes for AI use
- require security/legal review before scaling usage
- keep prompt templates sanitized by design
- add compliance signoff to high-risk artifacts
- avoid using AI as final authority on policy interpretation

### 21.5 Security review workflow

```text
Use case proposed
  ->
Data classification check
  ->
Vendor/policy fit check
  ->
Approved prompt/data templates
  ->
Pilot with human review
  ->
Audit and expand
```

---

## Section 22: Quality Control and Human Review Model

### 22.1 Why blind trust is dangerous

AI can be fluent and still be wrong. In Salesforce that can mean:

- incorrect sharing
- broken bulk behavior
- bad migration logic
- missing test coverage
- unsupported architectural assumptions

### 22.2 Code validation checklist

- compiles
- passes tests
- meets org coding standards
- bulk-safe
- sharing-safe
- no hard-coded secrets/IDs
- negative paths covered

### 22.3 Architecture validation checklist

- licensing fit confirmed
- standard-first assumption reviewed
- NFRs covered
- support model defined
- security impacts reviewed
- data ownership clear

### 22.4 Security validation checklist

- least privilege enforced
- sensitive fields identified
- logging does not leak secrets
- integration auth model approved
- external user access reviewed

### 22.5 Test validation checklist

- positive/negative/edge cases
- role-based behavior
- integration failure cases
- data quality cases
- traceability to requirements

### 22.6 Documentation review checklist

- technically accurate
- audience-appropriate
- includes assumptions and dependencies
- includes support/runbook content where needed
- reviewed by named owner

### 22.7 Signoff model

| Artifact | Minimum Signoff |
|---|---|
| Apex/LWC | Developer + lead reviewer |
| Architecture | Solution architect + security if relevant |
| Migration plan | Data lead + architect + release manager |
| Runbook | Support lead + technical owner |
| Release notes | Release manager + product owner |

---

## Section 23: Limitations and Failure Modes

### 23.1 Common failure modes

- hallucinated Salesforce features
- incorrect Apex syntax or unsupported methods
- poor bulkification
- incomplete edge case handling
- misunderstanding org-specific patterns
- outdated assumptions about platform capabilities
- weak security assumptions
- superficial test coverage
- over-engineering or under-engineering

### 23.2 Mitigation strategies

| Failure Mode | Mitigation |
|---|---|
| hallucinated feature | verify against current Salesforce docs and org setup |
| unsafe code | code review + static analysis + tests |
| weak architecture | review with architect and existing standards |
| poor requirements interpretation | confirm assumptions explicitly |
| low-quality tests | add traceability and risk-based review |

---

## Section 24: KPI and ROI Framework

### 24.1 Suggested KPI areas

| KPI Area | Example Measures |
|---|---|
| Developer productivity | time to first draft, PR cycle time, test generation time |
| Delivery speed | story turnaround, design doc turnaround, release prep duration |
| Quality | escaped defect rate, regression coverage, code review findings |
| Documentation | doc completion time, onboarding time reduction |
| Support | MTTR, RCA turnaround, KB article creation time |
| Architecture consistency | exceptions to standards, rework due to design changes |

### 24.2 ROI framing

Measure AI value through:

- hours saved on repetitive artifacts
- reduced rework from better requirement clarity
- faster onboarding of new team members
- lower incident handling effort
- improved delivery predictability

### 24.3 Sample KPI table

| Metric | Baseline | Target After AI Adoption | Owner |
|---|---|---|---|
| story drafting turnaround | 2 days | 4 hours | BA lead |
| first-pass TDD creation | 3 days | 1 day | architecture lead |
| Apex unit test drafting | 6 hours | 2 hours | dev lead |
| release note prep | 4 hours | 1 hour | release manager |
| RCA draft turnaround | 1 day | 2 hours | support lead |

---

## Section 25: Implementation Roadmap

### Phase 1: individual productivity

- Objectives: prove value safely
- Actions: pilot with architects, senior devs, BAs
- Owners: CoE lead, delivery lead
- Success measures: faster artifact drafting, positive feedback
- Risks: ungoverned usage, inflated expectations

### Phase 2: team standardization

- Objectives: repeatable patterns
- Actions: standard prompts, review checklists, role guidance
- Owners: tech lead, BA lead, QA lead
- Success measures: consistent artifact quality
- Risks: inconsistent adoption

### Phase 3: governance and templates

- Objectives: secure and auditable usage
- Actions: acceptable use policy, redaction standards, prompt libraries
- Owners: security, enterprise architecture, CoE
- Success measures: approved usage model
- Risks: over-restriction or under-control

### Phase 4: scaled enterprise adoption

- Objectives: multi-team rollout
- Actions: training, approved use cases, KPI tracking, documentation repository
- Owners: platform leadership
- Success measures: measurable productivity and quality improvement
- Risks: uneven maturity across teams

### Phase 5: continuous optimization

- Objectives: improve prompts, controls, workflows
- Actions: review KPIs, refine templates, expand safe use cases
- Owners: CoE and delivery leadership
- Success measures: sustained value and lower defects
- Risks: stagnation, tool sprawl

---

## Section 26: Recommended Operating Model

### 26.1 Where each tool fits

| Area | Codex | Claude |
|---|---|---|
| repo-aware implementation | primary | secondary |
| architecture writing | secondary | primary |
| long-form documentation | secondary | primary |
| technical review from code | primary | secondary |
| workshop synthesis | secondary | primary |
| release communication | supporting | primary |

### 26.2 Standard operating model

1. Use approved prompt templates.
2. Classify input data before using AI.
3. Keep implementation work traceable.
4. Require review for any production-impacting artifact.
5. Store validated outputs in controlled repositories.

### 26.3 Center of excellence model

The Salesforce AI enablement CoE should own:

- approved use cases
- prompt library
- review checklists
- training
- KPI reporting
- vendor/policy coordination
- maturity roadmap

### 26.4 Repository and documentation practices

- keep AI-generated artifacts in version control
- record human reviewer
- tag templates and patterns as approved
- maintain reference examples by domain

### 26.5 Training model

- intro training for all delivery roles
- advanced pattern training for architects/devs
- security and prompt hygiene training for everyone
- periodic refreshers based on incidents and lessons learned

---

## Section 27: Final Recommendations

### 27.1 When to start

Start now, but start narrowly. The right first move is not "AI for everything." The right first move is a controlled pilot in a Salesforce workstream with visible repetitive effort.

### 27.2 What to pilot first

- user story and acceptance criteria drafting
- architecture option summaries
- Apex/LWC test generation
- release notes and runbooks
- incident RCA drafts

### 27.3 What not to do

- do not paste secrets or raw customer-sensitive data
- do not let AI define security or compliance unreviewed
- do not treat AI output as production-ready by default
- do not measure success only by token usage or number of prompts

### 27.4 How to scale safely

- define approved use cases
- standardize prompts and review checklists
- train teams
- track KPIs
- review incidents and near misses
- evolve the operating model deliberately

### 27.5 Final balanced recommendation

Codex and Claude should be adopted as complementary enterprise delivery tools for Salesforce, not as replacements for architecture judgment, development skill, or governance discipline. Codex is the stronger implementation engine when the work is code- and repo-centered. Claude is the stronger strategy and synthesis engine when the work is document-heavy, cross-functional, and conceptually broad. Used together under clear governance, they can improve delivery speed, raise quality, reduce documentation drag, strengthen support readiness, and create a more mature Salesforce engineering system.

The real opportunity is not just writing code faster. It is running the full Salesforce lifecycle with better clarity, stronger artifacts, better review discipline, and more reusable team knowledge.

---

## Appendix A: Enterprise Maturity Model

| Level | Description |
|---|---|
| Level 1 | Individual ad hoc use, no standards |
| Level 2 | Team templates and repeated prompt usage |
| Level 3 | Governance, review checklists, approved use cases |
| Level 4 | Cross-team operating model and KPI tracking |
| Level 5 | Continuous optimization and CoE-led enterprise enablement |

## Appendix B: Human Review Required Notes

- Human review required for all code, architecture, security, migration, release, and support RCA outputs.
- Human review required before any externally shared stakeholder or customer-facing communication.
- Human review required whenever assumptions touch regulatory, contractual, or legal interpretation.

## Appendix C: Practical Anti-Patterns

- Asking AI for "best practice" without org or business context
- Generating code without test and review prompts
- Using AI to justify decisions already made politically
- Copying production data into prompts because it is "faster"
- Publishing AI-generated documentation without technical owner signoff
