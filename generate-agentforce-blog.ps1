$ErrorActionPreference = 'Stop'

$root = Join-Path $PSScriptRoot 'agentforce-blog'
$articlesDir = Join-Path $root 'articles'
$assetsDir = Join-Path $root 'assets'
$diagramsDir = Join-Path $assetsDir 'diagrams'

New-Item -ItemType Directory -Force -Path $root, $articlesDir, $assetsDir, $diagramsDir | Out-Null

function Write-Utf8File {
  param(
    [string]$Path,
    [string]$Content
  )

  Set-Content -Path $Path -Value $Content -Encoding UTF8
}

$siteCss = @'
:root{--bg:#f5f1e8;--surface:rgba(255,255,255,.9);--border:#ddd4c4;--ink:#1f2937;--muted:#5f6b7a;--accent:#0b5cab;--accent-strong:#083d77;--accent-soft:#e8f1fb;--gold:#a86b00;--shadow:0 22px 60px rgba(15,23,42,.12);--radius:22px;--content-width:760px}*,*::before,*::after{box-sizing:border-box}html{scroll-behavior:smooth}body{margin:0;font-family:"Source Sans 3",sans-serif;color:var(--ink);background:radial-gradient(circle at top left,rgba(11,92,171,.16),transparent 32%),radial-gradient(circle at top right,rgba(168,107,0,.14),transparent 28%),linear-gradient(180deg,#fcfbf8 0%,var(--bg) 100%);line-height:1.75}a{color:var(--accent);text-decoration:none}a:hover{color:var(--accent-strong)}img{max-width:100%;display:block}.page-shell{width:min(1180px,calc(100% - 32px));margin:0 auto}.site-header{position:sticky;top:0;z-index:30;backdrop-filter:blur(18px);background:rgba(252,251,248,.82);border-bottom:1px solid rgba(221,212,196,.8)}.header-inner{width:min(1180px,calc(100% - 32px));margin:0 auto;min-height:72px;display:flex;align-items:center;justify-content:space-between;gap:24px}.brand{display:flex;flex-direction:column;gap:2px}.brand-mark{font-family:"Merriweather",serif;font-size:1.15rem;font-weight:700;color:var(--ink)}.brand-sub{font-size:.85rem;color:var(--muted)}.nav-links{display:flex;gap:18px;flex-wrap:wrap}.nav-links a{font-size:.95rem;color:var(--muted)}.hero{padding:64px 0 40px}.hero-card{background:linear-gradient(135deg,rgba(255,255,255,.96),rgba(244,248,252,.9));border:1px solid rgba(221,212,196,.9);box-shadow:var(--shadow);border-radius:34px;overflow:hidden}.hero-grid{display:grid;grid-template-columns:minmax(0,1.2fr) minmax(320px,.8fr)}.hero-copy,.hero-media,.article-hero-copy,.article-hero-media,.content-card,.toc-card{padding:34px}.eyebrow{display:inline-flex;align-items:center;gap:10px;border-radius:999px;background:var(--accent-soft);color:var(--accent-strong);padding:8px 14px;font-size:.88rem;font-weight:600;letter-spacing:.02em}.hero h1,.article-title{font-family:"Merriweather",serif;line-height:1.18;letter-spacing:-.02em}.hero h1{margin:18px 0 16px;font-size:clamp(2.4rem,5vw,4.25rem)}.hero p,.article-standfirst,.section-intro,.article-card p,.card p,.content-card p,.content-card li,.author-copy span,.author-copy a,.reading-meta,.toc-card ol,.related-card p{color:var(--muted)}.hero p{margin:0 0 18px;font-size:1.1rem;max-width:62ch}.hero-actions{display:flex;gap:14px;flex-wrap:wrap;margin-top:28px}.button{display:inline-flex;align-items:center;justify-content:center;min-height:46px;padding:0 18px;border-radius:999px;font-weight:700;border:1px solid transparent}.button-primary{background:var(--accent);color:#fff}.button-secondary{color:var(--ink);border-color:var(--border);background:rgba(255,255,255,.8)}.hero-media{background:linear-gradient(180deg,rgba(11,92,171,.08),rgba(11,92,171,.02)),linear-gradient(135deg,rgba(8,61,119,.95),rgba(15,118,110,.84));color:#fff;display:flex;flex-direction:column;justify-content:space-between;gap:28px}.hero-metrics{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:16px}.metric{padding:18px;border-radius:20px;background:rgba(255,255,255,.08);border:1px solid rgba(255,255,255,.12)}.metric strong{display:block;font-size:1.4rem;margin-bottom:6px}.metric span{color:rgba(255,255,255,.82);font-size:.94rem}.hero-portrait{border-radius:26px;overflow:hidden;min-height:320px}.hero-portrait img{width:100%;height:100%;object-fit:cover}.section{padding:34px 0}.section-heading{margin:0 0 18px;font-family:"Merriweather",serif;font-size:clamp(1.8rem,3vw,2.5rem)}.section-intro{margin:0;max-width:70ch;font-size:1.05rem}.card-grid,.article-list,.related-grid{display:grid;gap:22px}.card-grid{grid-template-columns:repeat(auto-fit,minmax(260px,1fr));margin-top:30px}.card,.article-card,.toc-card,.content-card,.related-card{background:var(--surface);border:1px solid rgba(221,212,196,.95);border-radius:var(--radius);box-shadow:0 14px 36px rgba(148,163,184,.08)}.card{padding:24px}.card h3,.article-card h3,.related-card h3,.toc-card h2,.content-card h2,.content-card h3,.section-heading{font-family:"Merriweather",serif}.card h3{margin:0 0 10px;font-size:1.2rem}.article-list{grid-template-columns:repeat(auto-fit,minmax(300px,1fr));margin-top:28px}.article-card{overflow:hidden}.article-card img{width:100%;aspect-ratio:16/9;object-fit:cover}.article-card-body{padding:24px}.article-meta{display:flex;gap:12px;flex-wrap:wrap;margin-bottom:12px;color:var(--muted);font-size:.9rem}.article-kicker{color:var(--gold);text-transform:uppercase;letter-spacing:.08em;font-weight:700;font-size:.78rem}.article-card h3{margin:0 0 10px;font-size:1.35rem}.article-card p{margin:0 0 18px}.article-page{padding:42px 0 56px}.article-hero{display:grid;grid-template-columns:minmax(0,1.18fr) minmax(280px,.82fr);gap:28px;align-items:stretch}.article-hero-copy,.article-hero-media{border:1px solid rgba(221,212,196,.95);border-radius:30px;box-shadow:var(--shadow)}.article-hero-copy{background:rgba(255,255,255,.88)}.article-title{margin:14px 0 18px;font-size:clamp(2.2rem,4vw,3.4rem)}.article-standfirst{margin:0;font-size:1.1rem;max-width:62ch}.author-block{display:flex;align-items:center;gap:16px;margin-top:28px;padding-top:22px;border-top:1px solid rgba(221,212,196,.95)}.author-avatar{width:64px;height:64px;border-radius:50%;object-fit:cover}.author-copy strong{display:block;font-size:1rem}.reading-meta{display:flex;gap:18px;flex-wrap:wrap;margin-top:18px;font-size:.95rem}.article-hero-media{background:linear-gradient(180deg,rgba(255,255,255,.72),rgba(232,241,251,.9))}.article-hero-media img{width:100%;border-radius:22px;aspect-ratio:4/3;object-fit:cover}.article-layout{display:grid;grid-template-columns:minmax(0,240px) minmax(0,var(--content-width));gap:28px;align-items:start;margin-top:28px}.toc-card{position:sticky;top:92px}.toc-card h2{margin:0 0 14px;font-size:1.18rem}.toc-card ol{margin:0;padding-left:20px}.toc-card li+li,.content-card li+li{margin-top:10px}.content-card section+section{margin-top:34px}.content-card h2{margin:0 0 14px;font-size:1.8rem}.content-card h3{margin:24px 0 10px;font-size:1.22rem}.content-card ul,.content-card ol{padding-left:22px}.content-card p,.content-card li{font-size:1.04rem;color:#334155}.diagram{margin:24px 0;padding:20px;border-radius:24px;background:linear-gradient(180deg,rgba(232,241,251,.88),rgba(255,255,255,.94));border:1px solid rgba(148,163,184,.22)}.diagram figcaption{margin-top:12px;color:var(--muted);font-size:.95rem}pre{overflow-x:auto;padding:18px;border-radius:18px;background:#0f172a;color:#e2e8f0;font-size:.93rem;line-height:1.6;border:1px solid rgba(15,23,42,.6)}code{font-family:"IBM Plex Mono",monospace}p code,li code{color:var(--accent-strong);background:rgba(11,92,171,.08);padding:2px 6px;border-radius:6px}blockquote{margin:22px 0;padding:18px 22px;border-left:4px solid var(--accent);background:rgba(11,92,171,.06);border-radius:0 18px 18px 0;color:#1e3a5f}.callout{padding:20px 22px;border-radius:22px;background:linear-gradient(180deg,rgba(168,107,0,.08),rgba(255,255,255,.88));border:1px solid rgba(168,107,0,.2)}.related-section{margin-top:40px}.related-grid{grid-template-columns:repeat(auto-fit,minmax(220px,1fr));gap:18px}.related-card{padding:20px}.related-card h3{margin:0 0 8px;font-size:1.05rem}.site-footer{padding:30px 0 48px;color:var(--muted);font-size:.95rem}.footer-inner{width:min(1180px,calc(100% - 32px));margin:0 auto;display:flex;justify-content:space-between;gap:18px;flex-wrap:wrap;border-top:1px solid rgba(221,212,196,.95);padding-top:24px}@media (max-width:980px){.hero-grid,.article-hero,.article-layout{grid-template-columns:1fr}.toc-card{position:static}}@media (max-width:720px){.header-inner,.page-shell,.footer-inner{width:min(100% - 24px,1180px)}.hero-copy,.hero-media,.article-hero-copy,.article-hero-media,.content-card,.toc-card{padding:24px}.nav-links{gap:12px}.hero h1,.article-title{line-height:1.22}}
'@

$diagramTemplate = @'
<svg xmlns="http://www.w3.org/2000/svg" width="1200" height="700" viewBox="0 0 1200 700" role="img" aria-labelledby="title desc"><title>{0}</title><desc>{1}</desc><defs><linearGradient id="bg" x1="0%" x2="100%" y1="0%" y2="100%"><stop offset="0%" stop-color="#0b5cab"/><stop offset="100%" stop-color="#0f766e"/></linearGradient><linearGradient id="card" x1="0%" x2="100%" y1="0%" y2="100%"><stop offset="0%" stop-color="#ffffff" stop-opacity="0.98"/><stop offset="100%" stop-color="#e8f1fb" stop-opacity="0.96"/></linearGradient></defs><rect width="1200" height="700" rx="32" fill="#f8fafc"/><rect x="30" y="30" width="1140" height="640" rx="28" fill="url(#bg)"/><rect x="90" y="110" width="240" height="120" rx="24" fill="url(#card)"/><rect x="480" y="110" width="240" height="120" rx="24" fill="url(#card)"/><rect x="870" y="110" width="240" height="120" rx="24" fill="url(#card)"/><rect x="220" y="360" width="240" height="120" rx="24" fill="url(#card)"/><rect x="610" y="360" width="240" height="120" rx="24" fill="url(#card)"/><path d="M330 170 H480" stroke="#dbeafe" stroke-width="10" stroke-linecap="round"/><path d="M720 170 H870" stroke="#dbeafe" stroke-width="10" stroke-linecap="round"/><path d="M600 230 V360" stroke="#dbeafe" stroke-width="10" stroke-linecap="round"/><path d="M330 480 H610" stroke="#dbeafe" stroke-width="10" stroke-linecap="round"/><text x="110" y="150" font-family="'Source Sans 3', sans-serif" font-size="24" fill="#0f172a" font-weight="700">{2}</text><text x="110" y="184" font-family="'Source Sans 3', sans-serif" font-size="20" fill="#475569">{3}</text><text x="500" y="150" font-family="'Source Sans 3', sans-serif" font-size="24" fill="#0f172a" font-weight="700">{4}</text><text x="500" y="184" font-family="'Source Sans 3', sans-serif" font-size="20" fill="#475569">{5}</text><text x="890" y="150" font-family="'Source Sans 3', sans-serif" font-size="24" fill="#0f172a" font-weight="700">{6}</text><text x="890" y="184" font-family="'Source Sans 3', sans-serif" font-size="20" fill="#475569">{7}</text><text x="240" y="400" font-family="'Source Sans 3', sans-serif" font-size="24" fill="#0f172a" font-weight="700">{8}</text><text x="240" y="434" font-family="'Source Sans 3', sans-serif" font-size="20" fill="#475569">{9}</text><text x="630" y="400" font-family="'Source Sans 3', sans-serif" font-size="24" fill="#0f172a" font-weight="700">{10}</text><text x="630" y="434" font-family="'Source Sans 3', sans-serif" font-size="20" fill="#475569">{11}</text><text x="90" y="72" font-family="'Merriweather', serif" font-size="34" fill="#ffffff" font-weight="700">{0}</text></svg>
'@

$diagrams = @(
  @{ File = 'agentforce-architecture.svg'; Params = @('Agentforce Reference Architecture','A high-level architecture view showing prompts, orchestration, enterprise systems, and trust controls.','Channels','Service, sales, Slack','Reasoning','Planner and prompts','Actions','Flow, Apex, APIs','Data','CRM and Data Cloud','Trust Layer','Policy and observability') },
  @{ File = 'agent-reasoning-flow.svg'; Params = @('Agent Reasoning Flow','A multi-step reasoning sequence for grounding, planning, acting, and validating.','Intent','Classify the request','Context','Retrieve trusted facts','Plan','Select safe actions','Act','Execute Flow or Apex','Validate','Summarize and log') },
  @{ File = 'prompt-builder-ui.svg'; Params = @('Prompt Builder Design','A conceptual prompt builder layout with instructions, context, and output schema.','Instructions','Role, tone, policy','Grounding','CRM records and docs','Template','Variables and examples','Output','Schema and fallback','Evaluation','Test runs and scoring') }
)

$articles = @(
  @{ slug='agentforce-architecture'; file='agentforce-architecture.html'; title='What is Salesforce Agentforce - Complete Architecture Guide'; summary='A complete technical guide to Agentforce architecture, runtime components, enterprise grounding, and delivery patterns.'; image='https://images.unsplash.com/photo-1551288049-bebda4e38f71?auto=format&fit=crop&w=1400&q=80'; diagram='../assets/diagrams/agentforce-architecture.svg'; diagramAlt='Agentforce reference architecture diagram'; readTime='16 min read'; category='Architecture'; date='2026-03-11'; focus='architecture' },
  @{ slug='build-first-agent'; file='build-first-agent.html'; title='How to Build Your First AI Agent in Salesforce Agentforce'; summary='Step-by-step guidance for creating, grounding, testing, and deploying a first Agentforce implementation.'; image='https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&w=1400&q=80'; diagram='../assets/diagrams/agent-reasoning-flow.svg'; diagramAlt='First Agentforce build flow diagram'; readTime='15 min read'; category='Implementation'; date='2026-03-11'; focus='first-agent' },
  @{ slug='prompt-builder'; file='prompt-builder.html'; title='Agentforce Prompt Builder Deep Dive'; summary='An implementation-level exploration of Prompt Builder templates, context layering, evaluation, and operational discipline.'; image='https://images.unsplash.com/photo-1498050108023-c5249f4df085?auto=format&fit=crop&w=1400&q=80'; diagram='../assets/diagrams/prompt-builder-ui.svg'; diagramAlt='Prompt Builder user interface diagram'; readTime='15 min read'; category='Prompting'; date='2026-03-11'; focus='prompt-builder' },
  @{ slug='agent-actions-apex'; file='agent-actions-apex.html'; title='Creating Custom Agent Actions with Apex'; summary='A practical guide to building secure, testable Apex actions for Agentforce orchestration.'; image='https://images.unsplash.com/photo-1515879218367-8466d910aaa4?auto=format&fit=crop&w=1400&q=80'; diagram='../assets/diagrams/agentforce-architecture.svg'; diagramAlt='Custom Apex action architecture diagram'; readTime='16 min read'; category='Apex'; date='2026-03-11'; focus='apex-actions' },
  @{ slug='external-api'; file='external-api.html'; title='Integrating Agentforce with External APIs'; summary='Patterns for connecting Agentforce to external systems with named credentials, flows, middleware, and guardrails.'; image='https://images.unsplash.com/photo-1558494949-ef010cbdcc31?auto=format&fit=crop&w=1400&q=80'; diagram='../assets/diagrams/agentforce-architecture.svg'; diagramAlt='Agentforce external API integration diagram'; readTime='16 min read'; category='Integrations'; date='2026-03-11'; focus='external-api' },
  @{ slug='support-agent'; file='support-agent.html'; title='Building Autonomous Customer Support Agents'; summary='How to design a support agent that grounds on knowledge, resolves cases safely, and escalates with full context.'; image='https://images.unsplash.com/photo-1521791055366-0d553872125f?auto=format&fit=crop&w=1400&q=80'; diagram='../assets/diagrams/agent-reasoning-flow.svg'; diagramAlt='Customer support agent reasoning flow'; readTime='15 min read'; category='Service'; date='2026-03-11'; focus='support-agent' },
  @{ slug='security-governance'; file='security-governance.html'; title='Agentforce Security, Governance and Trust Layer'; summary='A security-first look at policy enforcement, auditability, data minimization, and operational governance for Agentforce.'; image='https://images.unsplash.com/photo-1516321497487-e288fb19713f?auto=format&fit=crop&w=1400&q=80'; diagram='../assets/diagrams/agentforce-architecture.svg'; diagramAlt='Security and trust layer diagram'; readTime='16 min read'; category='Security'; date='2026-03-11'; focus='security' },
  @{ slug='data-cloud-agent'; file='data-cloud-agent.html'; title='Using Agentforce with Data Cloud'; summary='A detailed implementation guide for grounding Agentforce on unified profiles, calculated insights, and real-time segmentation.'; image='https://images.unsplash.com/photo-1460925895917-afdab827c52f?auto=format&fit=crop&w=1400&q=80'; diagram='../assets/diagrams/agentforce-architecture.svg'; diagramAlt='Data Cloud and Agentforce architecture'; readTime='15 min read'; category='Data Cloud'; date='2026-03-11'; focus='data-cloud' },
  @{ slug='advanced-reasoning'; file='advanced-reasoning.html'; title='Advanced Multi-Step AI Agent Reasoning'; summary='Techniques for decomposing tasks, validating intermediate steps, and orchestrating reliable multi-hop Agentforce workflows.'; image='https://images.unsplash.com/photo-1518186285589-2f7649de83e0?auto=format&fit=crop&w=1400&q=80'; diagram='../assets/diagrams/agent-reasoning-flow.svg'; diagramAlt='Advanced multi-step reasoning flow diagram'; readTime='16 min read'; category='Reasoning'; date='2026-03-11'; focus='reasoning' },
  @{ slug='production-deployment'; file='production-deployment.html'; title='Deploying Agentforce to Production'; summary='A production-readiness guide covering promotion strategy, testing, monitoring, rollback, and operational ownership.'; image='https://images.unsplash.com/photo-1451187580459-43490279c0fa?auto=format&fit=crop&w=1400&q=80'; diagram='../assets/diagrams/agentforce-architecture.svg'; diagramAlt='Production deployment and operations diagram'; readTime='16 min read'; category='DevOps'; date='2026-03-11'; focus='production' }
)

function Get-IntroParagraphs {
  param([string]$Topic,[string]$Angle)
  return @(
    "Salesforce Agentforce matters because enterprise teams do not need another isolated chatbot; they need an execution surface that can reason over business context, stay inside platform controls, and complete work across Salesforce workflows. In practical terms, that means combining language understanding with CRM records, metadata, automation, and operational policy. The most useful framing is to treat Agentforce as an orchestration layer sitting between human intent and governed business actions.",
    "For architects, admins, and developers, the design question is not whether an LLM can produce fluent output. The harder question is how you bound that output with trusted data, deterministic automations, explicit approvals, and observability. $Angle. That is why successful Agentforce implementations start from architecture, identity, and process design before they focus on polished conversational experiences.",
    "A strong $Topic implementation usually follows the same pattern: define the business objective, identify the records and actions the agent can use, design prompts that encode policy and tone, expose actions through Flow or Apex, and then measure outcomes with operational telemetry. This pattern keeps the solution explainable and creates a handoff model that admins, architects, developers, and service leaders can all understand."
  )
}

function Get-FocusLine {
  param([string]$Focus)
  switch ($Focus) {
    'architecture' { 'The architectural lens is the best starting point because Agentforce spans prompting, identity, orchestration, automation, and analytics. Teams that skip this model often end up with brittle agent behavior that feels impressive in demos but unstable in production.' }
    'first-agent' { 'For a first implementation, the architecture should stay intentionally small. A narrow slice with one channel, one prompt family, one data grounding path, and a handful of safe actions creates the fastest route to a credible first release.' }
    'prompt-builder' { 'Prompt Builder sits at the center of the runtime contract because it translates business instructions into structured model input. It is not just a text editor; it is where tone, constraints, grounding, and output shape are made explicit.' }
    'apex-actions' { 'When custom actions are implemented in Apex, the architecture must separate reasoning from execution. The agent decides when to invoke an action, but the Apex code still owns validation, security, idempotency, and failure handling.' }
    'external-api' { 'External integrations shift the architecture from purely in-platform automation to distributed systems. Once the agent depends on outside APIs, latency, retry behavior, contract versioning, and partial failure become first-class concerns.' }
    'support-agent' { 'Support agents require a service architecture rather than a generic assistant architecture. Knowledge retrieval, entitlement checks, case updates, escalation logic, and post-interaction summaries all need to work together as one operational flow.' }
    'security' { 'Security architecture should be treated as a product feature, not an afterthought. Agentforce only earns trust when every prompt, retrieval step, and action invocation stays within explicit policy and generates evidence for review.' }
    'data-cloud' { 'Data Cloud changes the architecture by improving context quality. Instead of retrieving isolated CRM objects, the agent can reason over a more complete profile that includes unified identities, events, calculated insights, and segments.' }
    'reasoning' { 'Advanced reasoning is best modeled as a state machine. The agent should move through grounded steps such as classify, retrieve, plan, act, verify, and summarize instead of attempting to solve everything in one opaque generation.' }
    'production' { 'Production deployment architecture matters because agent systems are living systems. You are not just shipping HTML and Apex; you are shipping prompts, permissions, monitoring, rollback procedures, and behavior contracts that need disciplined change control.' }
  }
}

function Get-StepList {
  param([string]$Focus)
  switch ($Focus) {
    'architecture' { return @('Clarify the business capability and define measurable outcomes such as time-to-resolution, case deflection, or lead routing speed.','Inventory data sources the agent can trust, including Salesforce objects, knowledge content, and any external systems that need controlled access.','Model the allowed actions with Flow, Apex, or invocable integrations, and write down validation requirements for each action.','Define prompt templates, grounding rules, and response schemas before any user-facing channel is enabled.','Configure security boundaries, including profiles, permission sets, named credentials, and agent-specific audit requirements.','Test the agent with scenario packs that cover happy paths, ambiguous requests, and policy edge cases.','Roll out to a pilot audience with observability dashboards and an escalation path to human operators.') }
    'first-agent' { return @('Enable the required Salesforce features in a sandbox and confirm the org has the right Agentforce-related setup completed.','Choose a narrow use case, such as summarizing an account and logging a follow-up task, rather than a broad support assistant.','Create the agent persona, define its purpose, and map the exact records it can reference.','Build a prompt template with clear instructions, input variables, grounding context, and output format expectations.','Add one or two safe actions implemented with Flow or Apex so the agent can do more than just answer questions.','Run iterative test conversations, tune the prompt, and review every failed response to improve grounding and fallback behavior.','Promote only after the pilot shows reliable accuracy, readable summaries, and safe action execution.') }
    'prompt-builder' { return @('Start with the business intent and write a concise system instruction that defines the role, audience, and non-negotiable rules.','Declare prompt variables that come from Salesforce records or user input and keep naming consistent with downstream flows.','Attach grounding context such as object fields, knowledge articles, or retrieval snippets, and document why each data source is allowed.','Specify the desired output shape, including sections, bullet style, required fields, or JSON formatting when downstream automation depends on parsing.','Create representative evaluation cases that include strong examples, weak examples, and adversarial requests.','Review prompt revisions like code changes, with version notes, owner names, and rollback awareness.','Publish the prompt only after output quality, latency, and safety behavior meet the acceptance bar.') }
    'apex-actions' { return @('Define a user story that justifies a custom action instead of a standard Flow action.','Create an Apex service class with explicit input validation and selective SOQL queries.','Expose a narrowly scoped invocable or Aura-enabled method that returns a predictable response contract.','Wrap external effects with defensive checks so the same action can safely be retried.','Add unit tests for successful execution, validation failure, permission failure, and bulk safety where relevant.','Register the action inside the agent design and describe when the model should call it versus when it should ask for more information.','Monitor real invocations to refine both the Apex contract and the prompt instructions that select it.') }
    'external-api' { return @('Choose the integration pattern: direct callout from Apex, Flow with External Services, or middleware for more complex orchestration.','Configure named credentials and external credentials so secrets stay outside prompts and code.','Define a stable request and response contract, including timeout behavior and error categories.','Implement transformation logic that turns model intent into deterministic API parameters.','Create retries and fallbacks for recoverable failures, while avoiding duplicate side effects.','Expose the integration as a controlled agent action with clear usage boundaries in the prompt.','Instrument latency, error rate, and downstream impact before scaling the integration to more users.') }
    'support-agent' { return @('Identify the support journeys that are safe for automation, such as order lookup, troubleshooting guidance, or case summarization.','Map knowledge sources, entitlement rules, and customer identifiers required to serve those journeys accurately.','Design the agent to retrieve facts first, then decide whether it should answer, create a task, update a case, or escalate.','Connect the agent to service flows so operational work lands in the same systems agents and humans already use.','Create escalation triggers based on sentiment, confidence, policy keywords, or unresolved troubleshooting loops.','Run pilot sessions with real service agents reviewing outputs and editing summaries to surface failure modes.','Expand autonomy only after metrics show strong containment, low rework, and clear auditability.') }
    'security' { return @('Classify the data the agent can see and label sensitive records, fields, and documents before prompt design starts.','Define least-privilege execution identities, including any named credentials or service principals for external actions.','Build prompt and action policies that explain what the agent must refuse, redact, or escalate.','Create audit logging for prompts, retrievals, actions, and user-visible responses so reviews are evidence-based.','Test prompt injection, sensitive data exfiltration, and unauthorized action attempts as part of pre-release validation.','Establish change management for prompts and action definitions, including approvals for high-impact modifications.','Review production telemetry regularly and update controls when new usage patterns emerge.') }
    'data-cloud' { return @('Define the customer and account use cases that benefit from unified profile context rather than isolated CRM records.','Map source systems into Data Cloud and confirm identity resolution rules are stable enough for production use.','Publish the calculated insights, segments, or profile attributes the agent needs for grounding.','Reference those data products in prompts or actions with clear explanations of freshness and intended use.','Test how the agent behaves when profile data is incomplete, conflicting, or delayed.','Document where operational actions still happen inside core Salesforce objects even when context comes from Data Cloud.','Measure whether richer context improves conversion, service quality, or analyst productivity enough to justify the added complexity.') }
    'reasoning' { return @('Break the target workflow into explicit reasoning stages such as classify, retrieve, plan, act, validate, and summarize.','Design prompts or sub-prompts that correspond to those stages instead of using one monolithic instruction.','Use structured intermediate outputs so each stage can be inspected, logged, and verified.','Gate high-impact actions behind validation rules, confidence checks, or human approval points.','Tune retrieval so the reasoning chain is grounded on trusted facts rather than latent model assumptions.','Simulate long or ambiguous requests to ensure the agent can recover gracefully instead of compounding mistakes.','Track per-step latency and error sources because multi-step systems often degrade through accumulation rather than one obvious fault.') }
    'production' { return @('Separate development, test, and production environments and treat prompts and action definitions as release-managed assets.','Create smoke tests for the highest-value user journeys and include both answer quality and action safety checks.','Define rollback procedures for prompts, flows, Apex, and integration credentials before the first release.','Implement observability for conversation volume, task success, latency, escalation rate, and policy violations.','Train operational owners on what they can tune in metadata versus what needs code or security review.','Release to a limited cohort first, then expand based on measured stability and support readiness.','Run post-release reviews to update prompts, controls, and runbooks with production evidence.') }
  }
}

function Get-CodeBlock {
  param([string]$Focus)
  switch ($Focus) {
    'apex-actions' {
      return @"
<h3>Custom Apex action example</h3>
<pre><code class="language-apex">public with sharing class GetAccountDetails {
    @AuraEnabled
    public static Account fetchAccount(Id accountId) {
        if (accountId == null) {
            throw new AuraHandledException('Account Id is required');
        }
        return [
            SELECT Id, Name, Industry, Type, Owner.Name
            FROM Account
            WHERE Id = :accountId
            LIMIT 1
        ];
    }
}</code></pre>
<p>The important detail is not the syntax itself; it is the contract discipline around the action. Inputs are validated, the query is selective, and the response shape is predictable enough for the agent prompt to reference safely.</p>
<h3>Test class outline</h3>
<pre><code class="language-apex">@IsTest
private class GetAccountDetailsTest {
    @IsTest
    static void fetchesExpectedAccount() {
        Account acc = new Account(Name = 'Acme Energy', Industry = 'Utilities');
        insert acc;
        Test.startTest();
        Account result = GetAccountDetails.fetchAccount(acc.Id);
        Test.stopTest();
        System.assertEquals('Acme Energy', result.Name);
        System.assertEquals('Utilities', result.Industry);
    }
}</code></pre>
"@
    }
    'external-api' {
      return @"
<h3>Named credential callout example</h3>
<pre><code class="language-apex">public with sharing class ShippingStatusService {
    public class ShipmentStatus {
        @AuraEnabled public String trackingNumber;
        @AuraEnabled public String status;
        @AuraEnabled public String lastUpdated;
    }

    @InvocableMethod(label='Get shipment status')
    public static List&lt;ShipmentStatus&gt; getStatus(List&lt;String&gt; trackingNumbers) {
        List&lt;ShipmentStatus&gt; results = new List&lt;ShipmentStatus&gt;();
        for (String trackingNumber : trackingNumbers) {
            HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:Logistics_API/v1/shipments/' + EncodingUtil.urlEncode(trackingNumber, 'UTF-8'));
            req.setMethod('GET');
            req.setTimeout(5000);
            HttpResponse res = new Http().send(req);
            if (res.getStatusCode() == 200) {
                results.add((ShipmentStatus) JSON.deserialize(res.getBody(), ShipmentStatus.class));
            }
        }
        return results;
    }
}</code></pre>
<h3>Flow-style response mapping</h3>
<pre><code class="language-json">{
  "action": "getShipmentStatus",
  "inputs": {
    "trackingNumber": "{!Case.Tracking_Number__c}"
  },
  "responseMap": {
    "status": "$.status",
    "lastUpdated": "$.lastUpdated"
  }
}</code></pre>
"@
    }
    'prompt-builder' {
      return @"
<h3>Prompt template example</h3>
<pre><code class="language-text">Role:
You are a Salesforce service operations agent helping support specialists resolve customer issues.

Instructions:
- Ground every recommendation in the supplied CRM and knowledge context.
- If a required fact is missing, ask one concise clarifying question.
- Never invent an entitlement, order status, or policy exception.

Inputs:
- customerProfile
- openCases
- latestInteraction
- policySnippets

Output format:
1. Situation summary
2. Recommended next action
3. Risks or missing data
4. Suggested follow-up message</code></pre>
<h3>Prompt evaluation fixture</h3>
<pre><code class="language-json">{
  "testCase": "Missing entitlement information",
  "expectedBehavior": [
    "asks for missing contract context",
    "does not promise replacement shipment",
    "references service policy language"
  ]
}</code></pre>
"@
    }
    default {
      return @"
<h3>Flow integration example</h3>
<pre><code class="language-xml">&lt;Flow xmlns="http://soap.sforce.com/2006/04/metadata"&gt;
  &lt;actionCalls&gt;
    &lt;name&gt;SummarizeCustomerContext&lt;/name&gt;
    &lt;label&gt;Summarize Customer Context&lt;/label&gt;
    &lt;actionName&gt;agentforce__SummarizeContext&lt;/actionName&gt;
    &lt;inputParameters&gt;
      &lt;name&gt;recordId&lt;/name&gt;
      &lt;value&gt;
        &lt;elementReference&gt;`$Record.Id&lt;/elementReference&gt;
      &lt;/value&gt;
    &lt;/inputParameters&gt;
  &lt;/actionCalls&gt;
&lt;/Flow&gt;</code></pre>
<h3>Prompt template example</h3>
<pre><code class="language-text">You are an Agentforce assistant for Salesforce operations.

Goals:
- explain the current business situation
- recommend the next best action
- call an action only when the required identifiers are present

Context:
{!`$Record.Name}
{!relatedRecords}
{!policySummary}</code></pre>
"@
    }
  }
}

function Get-BestPracticeItems {
  param([string]$Focus)
  switch ($Focus) {
    'architecture' { return @('Design for bounded capability before broad autonomy.','Keep retrieval sources explicit and reviewable.','Use deterministic automations for state changes and irreversible actions.','Version prompts, flows, and action contracts together.','Treat telemetry as part of the product, not a post-launch add-on.') }
    'first-agent' { return @('Start with one measurable use case.','Resist adding too many actions in the first release.','Capture failed prompts and review them weekly.','Document fallback behavior for ambiguous requests.','Pilot with expert users before opening the audience.') }
    'prompt-builder' { return @('Keep instructions short, concrete, and ranked by priority.','Prefer structured outputs when downstream automation consumes the response.','Ground prompts on a minimal trusted context set.','Maintain evaluation fixtures for every prompt revision.','Separate policy text from style guidance so each can evolve independently.') }
    'apex-actions' { return @('Validate every input even when the agent prompt already asks for it.','Return stable response structures with explicit fields.','Avoid hidden side effects in helper classes.','Write tests for failure states, not only the happy path.','Keep agent-invocable methods smaller than generic service classes.') }
    'external-api' { return @('Use named credentials instead of hard-coded endpoints or secrets.','Normalize downstream errors into categories the agent can handle.','Make action prompts clear about what the external system can and cannot do.','Protect against duplicate submissions with idempotency patterns.','Measure latency because model orchestration magnifies slow integrations.') }
    'support-agent' { return @('Ground support answers on current knowledge content.','Escalate early when confidence is low or policy is unclear.','Log summaries back to the case so humans inherit context.','Separate troubleshooting guidance from transactional commitments.','Review containment metrics alongside re-open rates.') }
    'security' { return @('Minimize sensitive data exposure in prompts and logs.','Apply least privilege to users, integrations, and actions.','Test prompt injection with realistic attack strings.','Require approvals for policy or trust-layer changes.','Retain evidence for audits and incident reviews.') }
    'data-cloud' { return @('Publish only the profile attributes that materially improve decisions.','Document freshness expectations for each context element.','Handle identity ambiguity explicitly in prompts.','Keep operational writes in systems with clear ownership.','Watch for cost and latency growth as more datasets are added.') }
    'reasoning' { return @('Decompose complex tasks into inspectable stages.','Use intermediate schemas rather than free-form chain output.','Add validation between planning and execution.','Limit the number of tools available per stage.','Optimize for recovery from partial failure.') }
    'production' { return @('Promote prompts with the same discipline as code.','Define rollback before launch.','Use canary releases for risky behavior changes.','Give support teams runbooks, not just admin screens.','Review production conversations to continuously tune quality.') }
  }
}

function Get-TOCItems {
  return @(
    @{ id = 'introduction'; title = 'Introduction' },
    @{ id = 'architecture'; title = 'Architecture explanation' },
    @{ id = 'configuration'; title = 'Step-by-step configuration' },
    @{ id = 'code-examples'; title = 'Code examples' },
    @{ id = 'operating-model'; title = 'Operating model and delivery guidance' },
    @{ id = 'best-practices'; title = 'Best practices' },
    @{ id = 'conclusion'; title = 'Conclusion' }
  )
}

function Get-OpsParagraph {
  param([string]$Focus)
  switch ($Focus) {
    'architecture' { return 'Operationally, architecture reviews should verify that every advertised capability maps to a real action, every action has a permission model, and every high-risk request has an escalation path. This avoids the common trap where the agent sounds capable but cannot complete work safely once the conversation leaves the happy path.' }
    'first-agent' { return 'In the first release, observability beats breadth. Instrument prompt outcomes, action invocation counts, latency, and user corrections. Those signals tell you whether the agent is ready for a second use case or whether the first use case still has unresolved quality debt.' }
    'prompt-builder' { return 'Prompt operations become much easier when every template has an owner, a business purpose, a release date, and a rollback note. That metadata sounds bureaucratic until multiple teams begin sharing prompt assets across service, sales, and internal operations.' }
    'apex-actions' { return 'Apex actions should be reviewed with the same rigor as any integration service. Pay attention to governor limits, sharing context, exception types, and how the action behaves under repeated invocation. Agent systems make retries and repeated clarifications more likely than a traditional UI flow does.' }
    'external-api' { return 'Once external APIs enter the design, service-level objectives need to include partner dependencies. If the agent response depends on a 4-second API with a 2 percent error rate, users will feel that behavior immediately. A resilient integration posture is therefore part of the conversational experience.' }
    'support-agent' { return 'Support operations need closed-loop learning. Review unresolved interactions, compare containment against customer satisfaction, and let service agents annotate where the AI helped versus where it slowed the process down. Those annotations are often more useful than generic accuracy scores.' }
    'security' { return 'Governance only works if it is operationalized. Define who can change prompts, who can approve new actions, who reviews suspicious transcripts, and how incidents are triaged. Without ownership, a trust layer turns into a diagram rather than a control system.' }
    'data-cloud' { return 'Data Cloud grounding works best when the profile story is easy to explain. If an agent recommends an offer or a next action, the delivery team should be able to trace that recommendation back to a specific segment membership, calculated insight, or profile attribute.' }
    'reasoning' { return 'In advanced reasoning systems, most quality defects are coordination defects. The agent may retrieve the right facts but plan the wrong action, or it may plan correctly but summarize poorly. That is why per-stage evaluation is more useful than one blended quality score.' }
    'production' { return 'Production readiness also includes ownership on the human side. Decide who watches the dashboards, who receives escalations when action failures spike, and who can temporarily disable an unsafe capability. Operational clarity is part of the architecture, not an afterthought.' }
  }
}

function Get-ConclusionParagraph {
  param([string]$Focus)
  switch ($Focus) {
    'architecture' { return 'Agentforce is easiest to understand when you stop treating it as a single AI feature and start treating it as a governed system made of channels, prompts, data, actions, and trust controls. That framing helps architects design for reliability, not novelty. Once those layers are clear, the platform becomes much easier to scale across service, sales, and internal operations.' }
    'first-agent' { return 'The best first Agentforce project is the one that proves execution quality, not the one that tries to automate everything at once. Start small, ground the model carefully, expose only safe actions, and measure the result. That creates a practical base for broader AI capability on Salesforce.' }
    'prompt-builder' { return 'Prompt Builder is where business intent becomes runtime behavior. Teams that treat prompts as governed assets, with clear context, explicit output structure, and repeatable evaluation, get far more stable Agentforce experiences. The payoff is not just better wording; it is better system behavior.' }
    'apex-actions' { return 'Custom Apex actions let Agentforce move from conversation into real business work, but they also introduce execution risk if they are loosely designed. Keep the boundary sharp: the model reasons, Apex validates and acts, and telemetry tells you where to refine the system. That discipline is what makes custom actions production-worthy.' }
    'external-api' { return 'External APIs expand what Agentforce can do, but they also expose the agent to the realities of distributed systems. Use clear contracts, secure credentials, defensive retries, and observability from day one. When integration design is disciplined, the agent can coordinate work beyond Salesforce without losing trust.' }
    'support-agent' { return 'Autonomous support is not about replacing agents with a generic bot. It is about creating a service system that can retrieve the right facts, take safe actions, and escalate cleanly when human judgment is needed. Agentforce becomes valuable when it reduces effort without hiding operational truth.' }
    'security' { return 'Security and governance are not accessories around Agentforce; they are the conditions that make enterprise adoption possible. If teams can explain what the agent can access, what it can do, and how every action is reviewed, trust grows. That trust is what lets AI move from pilots into core workflows.' }
    'data-cloud' { return 'Data Cloud gives Agentforce better memory, better segmentation, and a more complete business picture, but only when the context is curated intentionally. Ground the agent on high-value profile attributes, keep the explanation path clear, and continue executing operational changes through governed platform services. That is how richer context becomes better outcomes.' }
    'reasoning' { return 'Advanced reasoning should make an agent more inspectable, not more mysterious. By decomposing work into grounded stages, validating intermediate decisions, and monitoring each step, teams can deliver sophistication without surrendering control. That is the right standard for enterprise AI on Salesforce.' }
    'production' { return 'Production deployment is where Agentforce stops being an experiment and becomes a service capability. The difference is not only testing; it is release discipline, rollback planning, observability, and clear operational ownership. When those pieces exist, teams can improve the agent confidently over time instead of fearing each change. Mature teams also document who can pause unsafe behavior, how prompts roll back, and how production evidence feeds the next release.' }
  }
}

function New-ArticleBody {
  param($article)

  $intro = Get-IntroParagraphs -Topic $article.category -Angle "This guide focuses on the implementation tradeoffs, runtime boundaries, and delivery decisions that shape $($article.category.ToLower()) work in Agentforce"
  $stepsHtml = '<ol>'
  foreach ($step in (Get-StepList -Focus $article.focus)) { $stepsHtml += "<li>$step</li>" }
  $stepsHtml += '</ol>'
  $bestHtml = '<ul>'
  foreach ($item in (Get-BestPracticeItems -Focus $article.focus)) { $bestHtml += "<li>$item</li>" }
  $bestHtml += '</ul>'

  return @"
<section id="introduction"><h2>Introduction</h2><p>$($intro[0])</p><p>$($intro[1])</p><p>$($intro[2])</p></section>
<section id="architecture"><h2>Architecture explanation</h2><p>$(Get-FocusLine -Focus $article.focus)</p><p>$($article.title) typically breaks into five layers. The experience layer receives user requests from channels such as Service Console, Experience Cloud, or Slack. The reasoning layer interprets the request, selects the right prompt, and coordinates the next step. The grounding layer retrieves trusted data from CRM objects, knowledge articles, Data Cloud, or approved documents. The action layer executes Flow, Apex, or API operations. The governance layer enforces trust controls such as permission boundaries, audit logs, and response quality checks.</p><p>These layers are useful because they help teams decide where a problem belongs. If the answer is wrong, the issue may sit in grounding. If the action is unsafe, the problem sits in permissions or execution validation. If the result is verbose or inconsistent, the issue is often in prompting or output schema. Separating the architecture this way keeps debugging concrete, which is essential when an implementation grows across multiple teams.</p><figure class="diagram"><img src="$($article.diagram)" alt="$($article.diagramAlt)" loading="lazy" /><figcaption>Reference diagram for the major runtime layers involved in $($article.title).</figcaption></figure><p>In enterprise delivery, it also helps to think about control planes versus data planes. The control plane contains metadata, prompts, access policy, model selection, testing, and release procedures. The data plane contains the live customer conversation, retrieved records, outbound actions, and operational telemetry. This distinction prevents teams from mixing authoring concerns with runtime concerns and makes promotion across sandboxes significantly easier.</p><blockquote>The most reliable Agentforce implementations keep the model responsible for reasoning and language, while deterministic platform services remain responsible for data integrity, approvals, and side effects.</blockquote></section>
<section id="configuration"><h2>Step-by-step configuration</h2><p>Configuration work succeeds when the team treats Agentforce setup as a sequence of platform decisions rather than a single wizard. The steps below reflect the order that keeps dependencies visible and avoids rework later in the release.</p>$stepsHtml<p>$(Get-OpsParagraph -Focus $article.focus)</p></section>
<section id="code-examples"><h2>Code examples</h2><p>Enterprise teams need concrete implementation patterns because agent behavior eventually resolves into platform metadata and code. The examples below are representative patterns you can adapt inside a sandbox before promoting them through your normal release process.</p>$(Get-CodeBlock -Focus $article.focus)</section>
<section id="operating-model"><h2>Operating model and delivery guidance</h2><p>Agentforce projects become easier to sustain when the delivery model is explicit. Administrators typically own prompt authoring, channel setup, and low-code automations. Developers own custom actions, advanced integrations, and test harnesses. Architects own the capability boundary, trust assumptions, and release model. Service or sales operations leaders own business acceptance and the definition of success.</p><p>That separation matters because long-term quality depends on ownership. If everyone can tune everything, nobody can explain why behavior changed. If prompts, flows, and actions are versioned with release notes, then a regression can be traced back to a concrete modification. This is the same discipline teams already apply to code; Agentforce just expands the surface area that needs that discipline.</p><p>It is also useful to define an evidence loop. Capture representative transcripts, measure action success rate, compare containment against downstream business metrics, and review edge cases at a fixed cadence. Over time, this evidence loop becomes more valuable than intuition. It tells you whether a prompt change improved quality, whether a new action reduced manual effort, and whether an escalation rule is too sensitive or too lax.</p><p>Teams should also decide how documentation, enablement, and support ownership work after launch. A static runbook for incident handling, a changelog for prompt revisions, and a named owner for every high-impact action are simple controls that prevent ambiguity when the agent starts operating at scale.</p><div class="callout"><strong>Implementation note:</strong> Document the acceptance criteria for every agent capability in plain language. If the team cannot explain when the agent should answer, act, ask a clarifying question, or escalate, production quality will drift.</div></section>
<section id="best-practices"><h2>Best practices</h2>$bestHtml</section>
<section id="conclusion"><h2>Conclusion</h2><p>$(Get-ConclusionParagraph -Focus $article.focus)</p><p>For Salesforce teams, the practical lesson is consistent: start from business flow, ground the model on trusted enterprise context, expose only the actions you can govern, and measure what the agent actually changes in production. That is how Agentforce becomes a durable platform capability instead of a short-lived proof of concept.</p></section>
"@
}

function New-ArticleHtml {
  param($article,$allArticles)
  $tocHtml = '<ol>'
  foreach ($item in (Get-TOCItems)) { $tocHtml += "<li><a href=""#$($item.id)"">$($item.title)</a></li>" }
  $tocHtml += '</ol>'
  $relatedHtml = ''
  foreach ($rel in ($allArticles | Where-Object { $_.file -ne $article.file } | Select-Object -First 3)) {
    $relatedHtml += "<a class=""related-card"" href=""./$($rel.file)""><div class=""article-kicker"">$($rel.category)</div><h3>$($rel.title)</h3><p>$($rel.summary)</p></a>"
  }
  $schema = @{
    '@context'='https://schema.org'; '@type'='BlogPosting'; headline=$article.title; description=$article.summary;
    author=@{ '@type'='Person'; name='Shivam Gupta'; url='https://pulsagi.com' };
    publisher=@{ '@type'='Person'; name='Shivam Gupta' };
    datePublished=$article.date; dateModified=$article.date; image=@($article.image);
    mainEntityOfPage="https://shivam.pulsagi.com/agentforce-blog/articles/$($article.file)";
    keywords=@('Salesforce Agentforce','Salesforce Architect','AI agents','CRM automation',$article.category)
  } | ConvertTo-Json -Depth 8
  $body = New-ArticleBody -article $article
  return @"
<!DOCTYPE html>
<html lang="en"><head><meta charset="UTF-8" /><meta name="viewport" content="width=device-width, initial-scale=1.0" /><title>$($article.title) | Salesforce Architect</title><meta name="description" content="$($article.summary)" /><meta name="author" content="Shivam Gupta" /><meta name="robots" content="index, follow" /><link rel="canonical" href="https://shivam.pulsagi.com/agentforce-blog/articles/$($article.file)" /><meta property="og:type" content="article" /><meta property="og:site_name" content="Salesforce Agentforce Blog" /><meta property="og:title" content="$($article.title)" /><meta property="og:description" content="$($article.summary)" /><meta property="og:url" content="https://shivam.pulsagi.com/agentforce-blog/articles/$($article.file)" /><meta property="og:image" content="$($article.image)" /><meta name="twitter:card" content="summary_large_image" /><meta name="twitter:title" content="$($article.title)" /><meta name="twitter:description" content="$($article.summary)" /><meta name="twitter:image" content="$($article.image)" /><link rel="preconnect" href="https://fonts.googleapis.com" /><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin /><link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Mono:wght@400;500&family=Merriweather:wght@700&family=Source+Sans+3:wght@400;600;700&display=swap" rel="stylesheet" /><link rel="stylesheet" href="../assets/site.css" /><script type="application/ld+json">$schema</script></head>
<body><header class="site-header"><div class="header-inner"><a class="brand" href="../index.html"><span class="brand-mark">Salesforce Agentforce Blog</span><span class="brand-sub">Shivam Gupta  -  Salesforce Architect</span></a><nav class="nav-links" aria-label="Primary"><a href="../index.html">Home</a><a href="../index.html#articles">Articles</a><a href="https://pulsagi.com" rel="noopener" target="_blank">Pulsagi</a></nav></div></header>
<main class="page-shell article-page"><section class="article-hero"><div class="article-hero-copy"><div class="eyebrow">$($article.category)  -  Salesforce Agentforce</div><h1 class="article-title">$($article.title)</h1><p class="article-standfirst">$($article.summary)</p><div class="reading-meta"><span>$($article.readTime)</span><span>Published March 11, 2026</span><span>By Shivam Gupta</span></div><div class="author-block"><img class="author-avatar" src="../../shivam.jpg" alt="Shivam Gupta" width="64" height="64" /><div class="author-copy"><strong>Shivam Gupta</strong><span>Salesforce Architect  -  Founder at <a href="https://pulsagi.com" rel="noopener" target="_blank">pulsagi.com</a></span></div></div></div><div class="article-hero-media"><img src="$($article.image)" alt="$($article.title)" loading="eager" /><p>Each guide combines architecture visuals, configuration detail, and implementation examples to help Salesforce teams move from concept to delivery.</p></div></section><div class="article-layout"><aside class="toc-card" aria-label="Table of contents"><h2>Table of contents</h2>$tocHtml</aside><article class="content-card">$body<section class="related-section"><h2>Related articles</h2><div class="related-grid">$relatedHtml</div></section></article></div></main>
<footer class="site-footer"><div class="footer-inner"><span>(c) 2026 Shivam Gupta. Salesforce Agentforce technical articles.</span><span><a href="../index.html">Browse all articles</a></span></div></footer></body></html>
"@
}

foreach ($diagram in $diagrams) {
  Write-Utf8File -Path (Join-Path $diagramsDir $diagram.File) -Content ([string]::Format($diagramTemplate, $diagram.Params))
}

Write-Utf8File -Path (Join-Path $assetsDir 'site.css') -Content $siteCss

$indexCards = ''
foreach ($article in $articles) {
  $indexCards += "<article class=""article-card""><img src=""$($article.image)"" alt=""$($article.title)"" loading=""lazy"" /><div class=""article-card-body""><div class=""article-meta""><span class=""article-kicker"">$($article.category)</span><span>$($article.readTime)</span></div><h3>$($article.title)</h3><p>$($article.summary)</p><a class=""button button-secondary"" href=""./articles/$($article.file)"">Read article</a></div></article>"
}

$manifest = @{
  site='Salesforce Agentforce Blog'
  author='Shivam Gupta'
  articles=@(foreach ($article in $articles) { @{ title=$article.title; file=$article.file } })
} | ConvertTo-Json -Depth 5

$indexSchema = @{
  '@context'='https://schema.org'
  '@type'='Blog'
  name='Salesforce Agentforce Blog'
  description='A technical blog section by Shivam Gupta with detailed Salesforce Agentforce implementation guides.'
  url='https://shivam.pulsagi.com/agentforce-blog/'
  author=@{ '@type'='Person'; name='Shivam Gupta' }
} | ConvertTo-Json -Depth 5

$indexHtml = @"
<!DOCTYPE html>
<html lang="en"><head><meta charset="UTF-8" /><meta name="viewport" content="width=device-width, initial-scale=1.0" /><title>Salesforce Agentforce Blog | Shivam Gupta</title><meta name="description" content="Ten detailed Salesforce Agentforce articles covering architecture, prompt design, Apex actions, integrations, security, Data Cloud, reasoning, and production deployment." /><meta name="author" content="Shivam Gupta" /><meta name="robots" content="index, follow" /><link rel="canonical" href="https://shivam.pulsagi.com/agentforce-blog/" /><meta property="og:type" content="website" /><meta property="og:site_name" content="Salesforce Agentforce Blog" /><meta property="og:title" content="Salesforce Agentforce Blog | Shivam Gupta" /><meta property="og:description" content="Modern technical blog content about Salesforce Agentforce, written for architects, admins, and developers." /><meta property="og:url" content="https://shivam.pulsagi.com/agentforce-blog/" /><meta property="og:image" content="https://images.unsplash.com/photo-1551288049-bebda4e38f71?auto=format&fit=crop&w=1400&q=80" /><meta name="twitter:card" content="summary_large_image" /><meta name="twitter:title" content="Salesforce Agentforce Blog | Shivam Gupta" /><meta name="twitter:description" content="Ten detailed Salesforce Agentforce implementation guides for modern Salesforce teams." /><link rel="preconnect" href="https://fonts.googleapis.com" /><link rel="preconnect" href="https://fonts.gstatic.com" crossorigin /><link href="https://fonts.googleapis.com/css2?family=IBM+Plex+Mono:wght@400;500&family=Merriweather:wght@700&family=Source+Sans+3:wght@400;600;700&display=swap" rel="stylesheet" /><link rel="stylesheet" href="./assets/site.css" /><script type="application/ld+json">$indexSchema</script></head>
<body><header class="site-header"><div class="header-inner"><a class="brand" href="./index.html"><span class="brand-mark">Salesforce Agentforce Blog</span><span class="brand-sub">Shivam Gupta  -  Salesforce Architect</span></a><nav class="nav-links" aria-label="Primary"><a href="#articles">Articles</a><a href="https://shivam.pulsagi.com/">Main site</a><a href="https://pulsagi.com" rel="noopener" target="_blank">Pulsagi</a></nav></div></header><main class="page-shell"><section class="hero"><div class="hero-card"><div class="hero-grid"><div class="hero-copy"><div class="eyebrow">Salesforce Agentforce Technical Series</div><h1>Salesforce Agentforce articles for architects, admins, and developers.</h1><p>This section contains ten long-form technical articles about Salesforce Agentforce, written in a documentation-first blog format with step-by-step configuration, diagrams, and implementation examples.</p><p>The content is designed for readers who want practical delivery guidance: how the platform is structured, how to configure it, how to secure it, and how to deploy it responsibly.</p><div class="hero-actions"><a class="button button-primary" href="#articles">Browse articles</a></div></div><div class="hero-media"><div class="hero-metrics"><div class="metric"><strong>10</strong><span>Detailed technical articles</span></div><div class="metric"><strong>Architecture</strong><span>Patterns, trust, and runtime design</span></div><div class="metric"><strong>Implementation</strong><span>Prompting, Apex, APIs, and automation</span></div><div class="metric"><strong>Responsive</strong><span>Readable on desktop and mobile</span></div></div><div class="hero-portrait"><img src="https://images.unsplash.com/photo-1551288049-bebda4e38f71?auto=format&fit=crop&w=1400&q=80" alt="Salesforce Agentforce analytics dashboard" /></div></div></div></div></section><section class="section"><h2 class="section-heading">What this section includes</h2><p class="section-intro">The blog collection covers foundational architecture, first-build implementation, prompt design, custom Apex actions, external APIs, service automation, security and trust, Data Cloud grounding, multi-step reasoning, and production deployment.</p><div class="card-grid"><article class="card"><h3>Technical depth</h3><p>Each article follows a consistent structure with introduction, architecture explanation, configuration steps, diagrams, code examples, best practices, and conclusion.</p></article><article class="card"><h3>Practical coverage</h3><p>The series focuses on real delivery concerns including grounding, safe actions, governance, integrations, and rollout strategy for enterprise Salesforce teams.</p></article><article class="card"><h3>Author identity</h3><p>All content is attributed to Shivam Gupta with an author block aligned to the site identity of Salesforce Architect and founder of Pulsagi.</p></article></div></section><section class="section" id="articles"><h2 class="section-heading">Articles</h2><p class="section-intro">Open any article below to read the full guide. The layout is designed for fast reading without losing technical depth.</p><div class="article-list">$indexCards</div></section></main><footer class="site-footer"><div class="footer-inner"><span>(c) 2026 Shivam Gupta  -  Salesforce Agentforce Blog</span><span><a href="https://shivam.pulsagi.com/">Back to main site</a></span></div></footer></body></html>
"@

Write-Utf8File -Path (Join-Path $root 'index.html') -Content $indexHtml
Write-Utf8File -Path (Join-Path $root 'manifest.json') -Content $manifest

foreach ($article in $articles) {
  Write-Utf8File -Path (Join-Path $articlesDir $article.file) -Content (New-ArticleHtml -article $article -allArticles $articles)
}


