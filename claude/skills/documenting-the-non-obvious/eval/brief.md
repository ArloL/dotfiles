# Task

Write the file `docs/AZURE-OPENAI.md` for the `hsp-infrastructure` repository. Output only the Markdown document.

The repository holds terraform, GitHub Actions deploy workflows and Grafana dashboards for the Haeger Sales Platform (HSP). Its README links each file under `docs/` with a one-line hook. Existing docs there are `ALERTS.md`, `MONITORING.md` and `SECRETS.md`. The application code lives in two other repos, `hsp-backend` (Spring Boot, Java, langchain4j) and `hsp-frontend`.

The reader is an engineer on the team who opens this repo. They may be new to the project and to Azure.

# Everything that is known

## The Azure resource

- HSP calls Azure OpenAI. Two Azure "resources" exist, `hsp-dev-resource` and `hsp-prod-resource`, both in region West Europe under the subscription "Haeger Sales Platform". Each has one Foundry project (`hsp-dev`, `hsp-prod`).
- Both were created by hand in the Microsoft Foundry portal (ai.azure.com) by a colleague in June 2026. Nothing in `hsp-infrastructure` references Azure at all: terraform does not manage the resource, no script touches it, no workflow deploys to it.
- In Azure a "deployment" is a named instance of a model that you call, e.g. a deployment named `gpt-4.1-mini` of the model gpt-4.1-mini. The backend's `ChatModelConfiguration` has `DEPLOYMENT = "gpt-4.1-mini"` and `CLASSIFICATION_DEPLOYMENT = "gpt-5.4-mini"`; `EmbeddingConfiguration` has `EMBEDDING_DEPLOYMENT = "text-embedding-3-small"`. The classification deployment is separate so its quota and load are the classifier's alone.
- The dev resource has seven deployments: text-embedding-3-small (created 19/06/2026), gpt-4.1-mini (19/06), gpt-5.4 (19/06), gpt-5.4-mini (19/06), text-embedding-3-large (06/09/2026), gpt-5.4-nano (06/09), gpt-5.6-luna (06/09). The extra ones are used by the Python experiment scripts under `hsp-backend/duplicate_experiments/` (`azure.py` has a price table for text-embedding-3-small, text-embedding-3-large, gpt-4.1-mini, gpt-4.1-nano, gpt-5.4-mini, gpt-5.4-nano).
- The API key and endpoint are in the backend's `application-secret.properties`, which comes from the team KeePass vault (documented in SECRETS.md).

## The content filter (Azure calls it a "guardrail")

- Every Azure OpenAI deployment has a content filter attached. Microsoft ships two built-in ones, `Microsoft.Default` and `Microsoft.DefaultV2`. A deployment gets `Microsoft.DefaultV2` unless something else is assigned.
- In the new Foundry portal, guardrails are under Build → Guardrails in the left nav. The list has columns Name, Type, Applied to, Last modified. Both built-ins show; `DefaultV2` showed "Applied to: text-embedding-3-small, gpt-4.1-mini, gpt-5.4, ..." on both resources before any change.
- The Create wizard has three steps: "Add controls", "Select agents and models", "Review".
- Step 1 controls, as the wizard shows them:
  - Jailbreak: checked by default, intervention point "User input", action Block.
  - Indirect prompt injections: unchecked by default. Sub-row "Spotlighting (Preview)".
  - Content harms: four rows, Hate*, Sexual*, Self-harm*, Violence*. The asterisk means mandatory; their checkboxes are greyed out and cannot be unticked. Each has a slider with positions labelled "Low blocking", "Medium blocking", "Highest blocking"; default is Medium. Intervention point dropdown "User input, Output". The Action dropdown shows "Block" and is disabled. A "Blocklists" row is unchecked.
  - Protected materials: two rows, "Protected material for code" and "Protected material for text", both checked by default, intervention point Output, action Block.
  - Sensitive data leakage: "PII (Preview)", unchecked.
  - Task drift: "Task adherence (Preview)", unchecked, intervention point "Tool call (Preview)".
  - Network: egress rules; an info banner says network controls only apply to hosted agents, prompt-based agents and models are not affected.
- Step 2 lists all deployments of the resource with checkboxes, and an "agents" list that says "No data available" because HSP uses no Foundry agents.
- Step 3 asks for a name and a "Streaming mode" dropdown (default "Default").
- Microsoft's docs: severity thresholds low/medium/high are configurable for every customer. Setting a harm category to "annotate only" or turning it off requires applying for "modified content filters" (a limited-access form that asks for the use case and is reviewed by Microsoft). This is why the Action dropdown is disabled.
- Microsoft's docs: the content filter runs on the prompt and the completion of chat/completions calls. Embedding requests are not run through the content filter. The portal nevertheless lets you assign a guardrail to an embedding deployment.
- Microsoft's docs on the indirect prompt injection shield ("Prompt Shields for documents"): it only examines text that the caller has wrapped in Azure's document delimiters (a `documents` array / `<documents>` markup in the prompt). Text that arrives as ordinary user-message content is not examined. The HSP backend uses langchain4j and passes tool results and mail bodies as ordinary message content; nothing wraps them in document delimiters.
- Protected material detection is Microsoft's check for known copyrighted text (song lyrics, articles, recipes, web content) and known source code in model output.

## What was done on 2026-09-06

- On `hsp-dev-resource` a guardrail named `hsp-tender-text-high-only` was created: the four harm sliders moved to "Highest blocking", both protected material rows unticked, jailbreak left on, everything else left off, streaming mode Default. It was applied to all seven deployments including the two embedding deployments (so that the "Applied to" column on DefaultV2 reads empty and nobody wonders why two deployments are different).
- `hsp-prod-resource` was not touched. Every prod deployment still runs `Microsoft.DefaultV2`. The intention is to move prod to the same guardrail soon; there is no gate or measurement planned before that.

## How the application uses the model

- HSP is a sales tool. It ingests tender/project postings for IT freelancers from two platforms (freelancermap.de, freelance.de) via saved-search e-mails and the platforms' own search APIs, classifies each with LLM agents (relevant / not relevant plus reasons, in German), extracts structured data, detects duplicates via embeddings, and shows the result to an internal sales team in an Angular UI.
- No end user ever types into the model. Every prompt is third-party German tender text or an inbound e-mail body. Every response is JSON that `OutputParsingGuard` validates against a schema before anything is stored or shown. Reasons in the JSON are shown to internal staff.
- Two tools are offered to the agents: `LookupMemoryTool` (looks up "memories" in the vector store) and `VisitLinkTool` (`visit_link`; fetches an arbitrary URL found in a mail with a browser-like User-Agent and extracts the page text).
- `ContentFilterGuard` in the backend catches langchain4j's `ContentFilteredException` wherever it appears in a cause chain. Its Javadoc says: "Azure's content filter occasionally flags legitimate German tender text as medium-severity hate/violence." Callers decide what skipping means: `TenderAnalysisService` records `TENDER_ANALYSIS_CONTENT_FILTERED` and skips analysis; `RedFlagService` stores a fallback classification with the German reason "Automatische Klassifikation nicht möglich (Inhaltsfilter des Modellanbieters); bitte manuell prüfen." and records `TENDER_CLASSIFICATION_CONTENT_FILTERED`; `MailIngestionService` drops the one tender and records `MAIL_TENDER_CONTENT_FILTERED`.
- Those are values of the `Degradation` enum, counted by a Micrometer counter `hsp.degraded` with tag `outcome` (one series per enum constant), described in `hsp-backend/docs/OBSERVABILITY.md`. That doc also says nothing scrapes the counter: it is reachable via `GET /actuator/metrics/hsp.degraded` from inside the docker compose network only, there is no Prometheus registry and no OTLP export. Grafana has dashboards and no alert rules.
- A `FOLLOWUPS.md` note in the backend from August 2026 says a run of 116–122 tenders had "nothing content-filtered", i.e. the rate is low but not zero.
