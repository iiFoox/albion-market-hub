# 01 — Primeiros Passos com o HEPHAESTUS

> **Nível:** 🟢 Iniciante  
> **Tempo de leitura:** 10 minutos  
> **Pré-requisito:** Nenhum

---

## O que é o HEPHAESTUS?

O HEPHAESTUS é um **framework de multi-agentes** que transforma qualquer LLM (Antigravity, Codex, ChatGPT, Claude, etc.) em um time completo de engenharia de software. Em vez de um assistente genérico, você passa a ter **10 especialistas** trabalhando juntos:

```
🎯 Orchestrator    → Roteia e coordena (igual um tech lead)
🔬 Researcher      → Pesquisa e analisa contexto (igual um arquiteto sênior)
📐 Planner         → Planeja e decompõe tarefas (igual um PM técnico)
🔨 Builder         → Implementa código (igual um dev sênior)
🎨 UI/UX Specialist → Garante qualidade visual (igual um designer de sistemas)
🛡️ Platform Guardian → Verifica compatibilidade (igual um QA de plataforma)
✅ Validator       → Testa e audita (igual um QA arquiteto)
📝 Documentation   → Documenta tudo (igual um technical writer)
📊 Project Manager → Monitora métricas (igual um PM sênior)
📦 Delivery        → Commita e versiona (igual um DevOps)
```

---

## Estrutura de Pastas

```
seu-projeto/
├── .agents/                    ← O framework mora aqui
│   ├── AGENTS.md               ← Definição master de todos os agentes
│   ├── agents/                 ← Definições individuais de cada agente
│   │   ├── orchestrator/
│   │   ├── researcher/
│   │   ├── planner/
│   │   ├── builder/
│   │   ├── ui-ux-specialist/   ← NOVO v4.0.0
│   │   ├── platform-guardian/  ← NOVO v4.0.0
│   │   ├── validator/
│   │   ├── documentation/
│   │   ├── project-manager/
│   │   └── delivery/
│   ├── config/                 ← Configurações do framework
│   ├── knowledge/              ← Base de conhecimento pré-carregada
│   ├── memory/                 ← Memória evolutiva
│   ├── profiles/               ← Perfis por indústria/stack
│   ├── protocols/              ← Regras de operação
│   ├── workflows/              ← Pipelines de execução
│   └── docs/                   ← DOCUMENTACAO OFICIAL
│       ├── en/
│       └── pt-br/              ← ESTE TUTORIAL
└── [seu código fonte]
```

---

## Como Funciona na Prática

### Passo 1: Instale ou atualize o framework, se necessario

Para instalar em projeto novo ou atualizar um projeto existente, use o guia atual:

[20 — Wizard de Instalacao e Update](20-WIZARD-DE-INSTALACAO-E-UPDATE.md)

### Passo 2: Abra um novo chat na sua ferramenta (Antigravity, Codex, etc.)
### Passo 3: Cole o prompt de inicialização

```markdown
Leia o arquivo .agents/AGENTS.md para entender o framework HEPHAESTUS.
Carregue o framework no nível LITE para começar.
Responda em português (pt-BR).
```

### Passo 4: Faça seu pedido normalmente

```
Corrija o erro de login que está dando null pointer no arquivo auth_service.dart
```

### Passo 5: O framework age automaticamente

O Orchestrator vai:
1. Classificar a complexidade (LITE — é um bug fix)
2. Consultar todos os agentes (triage rápido)
3. Montar o pipeline: Builder → Validator → Delivery
4. Executar e entregar o resultado

---

## Níveis de Complexidade

| Nível | Quando usar | Agentes ativos | Tokens |
|-------|-------------|----------------|--------|
| **LITE** | Bug fix, typo, config | 2-3 | Mínimo |
| **STANDARD** | Feature nova, CRUD, integração | 5-6 | Moderado |
| **DEEP** | Arquitetura, migração, refactor grande | 7-8 | Alto |
| **CRITICAL** | Produção, financeiro, compliance | Todos 10 | Máximo |

> 💡 **Dica:** Sempre comece com o nível mais baixo. O framework escala automaticamente se detectar que precisa de mais agentes.

---

## Seu Primeiro Use

### Exemplo: Corrigir um bug simples

**Você digita:**
```
Fix the null check error in login_screen.dart line 45
```

**O framework responde (internamente):**
```
📊 Classificação: LITE
🔄 Triage:
   - Builder: CRITICAL (precisa implementar)
   - Validator: RELEVANT (validar o fix)
   - UI/UX: NOT_NEEDED (sem mudança visual)
   - Platform Guardian: NOT_NEEDED (sem mudança de plataforma)
   - Todos os outros: NOT_NEEDED

🔨 Pipeline montado: Builder → Validator → Delivery
```

**Resultado final:**
```
✅ Bug corrigido em login_screen.dart:45
   - Adicionado null check: user?.email ?? ''
   - Testes passando
   - Commit: fix: add null check to login screen user email
   - Version: 1.2.1 (patch)
```

---

## Próximos Passos

1. → Leia [02-ECONOMIA-DE-TOKENS.md](02-ECONOMIA-DE-TOKENS.md) para aprender a gastar menos
2. → Leia [04-FLUXO-BASICO.md](04-FLUXO-BASICO.md) para exemplos práticos
3. → Vá direto para [prompts/PROMPTS-PRONTOS.md](prompts/PROMPTS-PRONTOS.md) se quiser usar agora

---

## Regras de Ouro

| Regra | Por quê |
|-------|---------|
| 🏷️ **Sempre diga o nível** | "Use LITE" ou "Use DEEP" — ajuda a economizar tokens |
| 📝 **Seja específico** | "Corrija X no arquivo Y" > "Corrija o bug" |
| 🔄 **Deixe o framework evoluir** | Ele aprende com cada uso via memória |
| 💾 **Salve o contexto** | Ao final do chat, peça para salvar o estado |
| 🇧🇷 **Fale em português** | O framework responde em pt-BR automaticamente |
