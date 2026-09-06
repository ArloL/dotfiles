# Azure OpenAI

The resource is managed by hand in the Foundry portal, not by terraform.
`ChatModelConfiguration` and `EmbeddingConfiguration` name the models and
embeddings the backend calls.

Each model runs the `Microsoft.DefaultV2` content filter until another
guardrail is assigned. As of 2026-09-06 dev runs `hsp-tender-text-high-only`
and prod still runs `DefaultV2`. Embedding calls are never filtered.

The filter only costs us tenders. No user talks to the model and every response
is validated JSON, so a hit drops a tender instead of protecting anyone. The
backend counts drops under `hsp.degraded` as `*_content_filtered`.

`hsp-tender-text-high-only` changes two things: the four harm categories block
at high severity instead of medium, and protected material detection is off,
since tenders quote public documents. High is the loosest threshold without
Microsoft's modified content filter approval.

Indirect prompt injection stays open. `visit_link` fetches arbitrary pages and
mail ingestion reads untrusted senders. Azure's shield for that inspects only
text wrapped in its document delimiters, and the backend wraps none, so it
needs a backend change first.
