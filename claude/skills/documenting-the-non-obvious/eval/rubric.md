# Rubric (from the author's feedback during the session)

Each item is pass/fail per document. Read the whole doc; do not grep.

R1 no-ui        No portal UI narration: no nav path (Build → Guardrails), no sliders, checkboxes, greyed rows, wizard steps, dropdowns, "Applied to" column, streaming mode.
R2 no-jargon    Does not use Azure's "deployment" as a noun for a model. Says models and embeddings (or similar plain words). Other portal vocabulary ("guardrail") is acceptable only where it names the thing being assigned.
R3 no-periphery Does not mention duplicate_experiments, the list of dev-only extra models, the German fallback reason string, the KeePass vault, Grafana alerting, creation dates of deployments, the Foundry project names, the region or subscription.
R4 no-plan      Does not invent a procedure or gate ("compare the counts", "once X, prod moves") that the facts do not support. Stating that prod still runs DefaultV2 as of a date is fine. Stating that prod will move soon is tolerable but not required.
R5 no-table     No table. (Only two settings differ; unchanged settings are not listed.)
R6 no-argument  No paragraph that argues the case against DefaultV2 with several supporting facts ("tuned for a public chatbot", "third-party German tender text", "cannot protect anyone; it can only ..."). One claim and its consequence at most.
R7 short        Body (excluding title) is at most 250 words.
R8 essentials   Contains all of: (a) resource is hand-managed / not terraform; (b) dated state of dev and prod; (c) embedding calls are not filtered; (d) the two settings that differ (harms block at high instead of medium; protected material off); (e) high is the loosest threshold without Microsoft's approval; (f) indirect prompt injection is not covered and would need a backend change (document delimiters) before any filter setting helps; (g) where filter drops are counted (hsp.degraded / *_content_filtered).
R9 shape        No paragraph opens on a pronoun or backward reference ("That is…", "This…", "Their…"); no heading over a single paragraph; no heading when the doc has one topic.

Gold: gold.md. Rejected draft: first-draft.md (fails R1? no; fails R3, R4, R5, R6, R7).
