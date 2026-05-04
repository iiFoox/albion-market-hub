# AI/ML Application Profile

> **Category:** Profile / Architecture-Specific
> **Usage:** Applied for projects integrating AI models, LLMs, or ML pipelines

---

## Activation Trigger
```
ACTIVATE WHEN:
→ Project integrates with LLMs (OpenAI, Anthropic, Google AI)
→ Project has ML model training or inference
→ Project processes data for ML pipelines
→ User mentions: AI, ML, LLM, modelo, inteligência artificial, GPT, embeddings
```

## LLM Integration Patterns

### API Client with Retry and Fallback
```typescript
class LLMClient {
  private providers = [
    { name: 'openai', client: new OpenAI(), model: 'gpt-4o' },
    { name: 'anthropic', client: new Anthropic(), model: 'claude-sonnet' },
  ];

  async complete(prompt: string, options?: LLMOptions): Promise<string> {
    for (const provider of this.providers) {
      try {
        return await withRetry(
          () => provider.client.chat({ model: provider.model, messages: [{ role: 'user', content: prompt }] }),
          { maxRetries: 2, baseDelayMs: 1000 }
        );
      } catch (error) {
        logger.warn(`${provider.name} failed, trying next provider`, { error });
        continue;
      }
    }
    throw new Error('All LLM providers failed');
  }
}
```

### Prompt Management
```typescript
// Version-controlled prompts (not hardcoded strings)
const PROMPTS = {
  'summarize-v1': {
    system: 'You are a concise summarizer. Output in bullet points.',
    template: 'Summarize the following text in {{maxPoints}} key points:\n\n{{text}}',
    maxTokens: 500,
    temperature: 0.3,
  },
  'classify-v2': {
    system: 'You are a text classifier. Output ONLY the category name.',
    template: 'Classify this support ticket:\n\n{{ticket}}\n\nCategories: {{categories}}',
    maxTokens: 50,
    temperature: 0,
  },
};

// Prompt rendering
function renderPrompt(name: string, variables: Record<string, string>): string {
  const prompt = PROMPTS[name];
  return prompt.template.replace(/\{\{(\w+)\}\}/g, (_, key) => variables[key] || '');
}
```

### Cost Control
```
RULES:
→ Set monthly budget limits per API key
→ Cache identical requests (same prompt = same response for deterministic queries)
→ Use cheapest model that meets quality requirements
→ Track cost per feature (which features consume most tokens?)
→ Rate limit AI features per user (prevent abuse)

MODEL SELECTION:
→ Simple classification/extraction: gpt-4o-mini or haiku (cheapest)
→ Complex reasoning: gpt-4o or sonnet (balanced)
→ Critical/high-stakes: o1 or opus (highest quality)
```

## RAG (Retrieval-Augmented Generation) Pattern

```
PIPELINE:
1. INGEST: Split documents → generate embeddings → store in vector DB
2. QUERY: Generate query embedding → search similar documents → create context
3. GENERATE: Send context + query to LLM → get grounded response

COMPONENTS:
→ Vector DB: Pinecone, Weaviate, pgvector (PostgreSQL extension)
→ Embeddings: OpenAI text-embedding-3-small, or local (sentence-transformers)
→ Chunking: split by paragraphs (500-1000 tokens per chunk with 100 overlap)
```

## MLOps Patterns

```
MODEL LIFECYCLE:
1. Data Collection → clean, validate, version
2. Training → experiment tracking (MLflow, W&B)
3. Evaluation → metrics, bias testing, A/B testing
4. Deployment → model serving (FastAPI, TensorFlow Serving)
5. Monitoring → drift detection, performance degradation alerts

KEY PRINCIPLES:
→ Version EVERYTHING: data, code, models, configs
→ Reproducibility: same input → same model
→ Monitoring: model performance degrades over time (data drift)
→ A/B testing: new model runs alongside old model before full rollout
```
