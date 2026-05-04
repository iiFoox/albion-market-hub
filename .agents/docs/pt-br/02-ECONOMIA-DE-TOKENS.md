# 02 — Economia de Tokens

> **Nível:** 🟢 Iniciante  
> **Tempo de leitura:** 8 minutos  
> **Por que é importante:** O framework tem ~175 arquivos. Carregar tudo desperdiça 60-80% do contexto disponível.

---

## O Problema

LLMs têm janelas de contexto limitadas (128K-200K tokens). Se carregarmos todo o framework, sobra pouco espaço para o código real do seu projeto — que é o que realmente precisa ser analisado.

## A Solução: Smart Loading Protocol

O framework tem 4 "tiers" de carregamento. Cada um carrega apenas os arquivos necessários:

```
┌──────────┬──────────┬───────────────┬──────────────────────┐
│  Nível   │ Arquivos │ Contexto      │ Quando usar          │
│          │ Carregados│ Economizado  │                      │
├──────────┼──────────┼───────────────┼──────────────────────┤
│ LITE     │  ~8-10   │ ~75-80%       │ Bug fix, typo, config│
│ STANDARD │  ~22-28  │ ~55-60%       │ Features, CRUD       │
│ DEEP     │  ~50-55  │ ~30-35%       │ Arquitetura          │
│ CRITICAL │  ~90+    │ ~5-10%        │ Produção, financeiro │
└──────────┴──────────┴───────────────┴──────────────────────┘
```

---

## Como Usar na Prática

### ✅ CERTO — Especifique o nível:

```markdown
Carregue o framework HEPHAESTUS no nível LITE.
Preciso corrigir o bug de null pointer no login_screen.dart.
```

### ❌ ERRADO — Carregar tudo:

```markdown
Leia todos os protocolos, todas as configs, toda a memória, 
todos os agentes, todos os prompts do framework HEPHAESTUS.
Agora corrija um typo.
```

> ⚠️ O exemplo errado carrega ~175 arquivos para corrigir um typo. O exemplo certo carrega ~8 arquivos.

---

## O que cada Tier carrega

### Tier 1: LITE (para tarefas simples)
```
SEMPRE carrega (core):
├── config/framework.yaml           ← Config global
├── config/complexity-routing.yaml  ← Regras de roteamento
├── memory/context-db/session.md    ← Estado da sessão
└── orchestrator/system-prompt.md   ← Prompt do roteador

LITE adiciona:
├── builder/system-prompt.md        ← Prompt do Builder
├── validator/system-prompt.md      ← Prompt do Validator
├── delivery/system-prompt.md       ← Prompt do Delivery
└── protocols/commit-gate.md        ← Regras de commit

CONDICIONAL (só se keywords de UI):
├── ui-ux-specialist/system-prompt.md
└── platform-guardian/system-prompt.md

Total: ~8-10 arquivos | Economia: ~75-80%
```

### Tier 2: STANDARD (para features)
```
Tudo do LITE + :
├── researcher/system-prompt.md
├── planner/system-prompt.md
├── documentation/system-prompt.md
├── project-manager/system-prompt.md
├── protocolos de triage e complexidade
├── tech-cards relevantes
├── Flutter profile (se ativo)
└── memory entries recentes

Total: ~22-28 arquivos | Economia: ~55-60%
```

### Tier 3: DEEP (para arquitetura)
```
Tudo do STANDARD + :
├── Deep reasoning prompts (todos)
├── Design review, compatibility check
├── Architecture patterns relevantes
├── Security KB (se relevante)
├── Flutter profile completo
├── Known issues database
└── Blueprints (se novo projeto)

Total: ~50-55 arquivos | Economia: ~30-35%
```

### Tier 4: CRITICAL (para produção)
```
TUDO. Sem exceção.
Total: ~90+ arquivos | Economia: ~5-10%
```

---

## Dicas Práticas

### 1. Comece SEMPRE pelo LITE — o framework escala sozinho! 🚀
```
Carregue LITE. [sua tarefa aqui]
```
Você **não precisa adivinhar** o nível certo. O framework detecta automaticamente se precisa escalar.

### 2. Auto-Escalação com Delta Loading (NOVIDADE v4.0.1)

O framework agora tem um **protocolo de auto-escalação inteligente**. Funciona assim:

```
Você pede LITE
    │
    ▼
Framework carrega ~8 arquivos (rápido!)
    │
    ▼
Triage: todos os agentes avaliam em ~100 palavras
    │
    ▼
Escalation Check: "Preciso de mais profundidade?"
    │
    ├── NÃO → Continua LITE (zero desperdício!)
    │
    └── SIM → Delta Load: carrega APENAS os arquivos extras
              (não recarrega o que já está no contexto)
              Notifica você: "⚡ Auto-Escalation: LITE → STANDARD"
```

**Exemplo real:**
```
Você: "LITE: Adicione campo de telefone no cadastro"

Framework (internamente):
→ Triage mostra 3 agentes como RELEVANT (UI/UX, Validator, Platform)
→ TRIGGER: ≥3 agentes necessários → escala para STANDARD
→ Delta Load: carrega +14 arquivos (não recarrega os 8 já carregados)
→ Notifica: "⚡ Auto-Escalation: LITE → STANDARD — campo de telefone
   precisa de máscara, validação, e verificação cross-platform"
→ Continua com pipeline STANDARD
```

**Os 12 triggers de escalação:**

| De → Para | Trigger | Exemplo |
|-----------|---------|---------|
| LITE → STANDARD | ≥3 agentes RELEVANT | Bug que vira feature |
| LITE → STANDARD | Criar arquivo novo | Fix que precisa de ViewModel novo |
| LITE → STANDARD | ≥2 módulos afetados | Fix toca model + UI |
| STANDARD → DEEP | Problema de segurança | CRUD com SQL injection |
| STANDARD → DEEP | Platform FAIL | Package não roda no Web |
| STANDARD → DEEP | ≥3 fases no plano | Feature complexa demais |
| STANDARD → DEEP | Memória negativa | "Última vez que fizemos X, deu Y" |
| STANDARD → DEEP | Conflito entre agentes | Builder vs UI/UX discordam |
| DEEP → CRITICAL | Dados financeiros/saúde | Qualquer menção a pagamento |
| DEEP → CRITICAL | Segurança HIGH severity | Auth bypass encontrado |
| DEEP → CRITICAL | Escopo de produção | Deploy com dados reais |

> 💡 **Dica de ouro:** Sempre comece com LITE. Se for simples, fica rápido. Se for complexo, o framework escala sozinho carregando apenas o delta. Você **nunca desperdiça tokens**.

### 3. Use keywords certas
O framework usa keywords para decidir o nível:
- **LITE keywords:** fix, typo, rename, style, format, config
- **STANDARD keywords:** add, create, implement, feature, integrate
- **DEEP keywords:** migrate, architecture, redesign, scale, auth
- **CRITICAL keywords:** payment, financial, health, production, security

### 4. Override manual
Você pode forçar um nível:
```
Use DEEP pipeline para implementar o dark mode.
```
Ou rebaixar:
```
Isto é só um quick fix, use LITE.
```

### 5. Em chats longos, recarregue se necessário
Após muitas mensagens, o contexto pode ficar poluído. Peça:
```
Recarregue o framework no nível STANDARD para a próxima tarefa.
```

---

## Tabela de Referência Rápida

| Situação | Nível | Prompt sugerido |
|----------|-------|-----------------|
| Corrigir typo | LITE | "LITE: corrija o typo em X" |
| Ajustar cor de botão | LITE | "LITE: mude a cor do botão Y para primary" |
| Criar tela nova | STANDARD | "STANDARD: crie a tela de perfil do usuário" |
| Adicionar CRUD | STANDARD | "STANDARD: implemente CRUD de produtos" |
| Integrar API de pagamento | DEEP | "DEEP: integre Stripe com subscription" |
| Migrar banco de dados | DEEP | "DEEP: migre schema X para Y" |
| Deploy em produção | CRITICAL | "CRITICAL: deploy para produção com dados reais" |

---

## Próximo

→ [03-NOVO-CHAT-RETOMADA.md](03-NOVO-CHAT-RETOMADA.md) — Como criar chats e retomar contexto
