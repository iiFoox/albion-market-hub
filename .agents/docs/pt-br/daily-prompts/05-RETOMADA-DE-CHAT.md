# 05 — Retomada de Chat: Continuando Sem Perder Contexto

> **Quando usar:** SEMPRE que abrir um novo chat para continuar trabalhando no projeto.
> **Objetivo:** O framework deve saber TUDO que aconteceu antes e continuar de onde parou.
> **REGRA DE OURO:** Este é o prompt MAIS IMPORTANTE do seu dia a dia. Nunca comece um chat sem ele.

---

## Por Que Isso É Necessário

Cada novo chat começa com "memória zerada". O assistente de IA **não lembra** da sessão anterior. O prompt de retomada resolve isso fazendo o assistente:

1. Ler o framework completo
2. Ler o checkpoint da sessão anterior
3. Ler a memória acumulada
4. Entender o estado atual do projeto
5. Continuar exatamente de onde parou

---

## O Prompt de Retomada (COPIE INTEIRO)

```
Você é o sistema multi-agente HEPHAESTUS. Este é um CHAT DE CONTINUAÇÃO — 
não é a primeira vez que trabalhamos neste projeto.

## FASE 1: CARREGAR CORE (sempre)
Leia estes arquivos obrigatórios:
- .agents/config/framework.yaml
- .agents/config/complexity-routing.yaml
- .agents/agents/orchestrator/prompts/system-prompt.md
- .agents/memory/context-db/session-checkpoint.md  ← MAIS IMPORTANTE

## FASE 2: VERIFICAR ESTADO DO REPOSITÓRIO
Execute:
- git log --oneline -5 (últimos 5 commits)
- git status (mudanças pendentes)
- git branch (branch atual)

## FASE 3: RELATÓRIO DE RETOMADA
Com base no checkpoint e no git, me diga:
1. Qual é o projeto e o que ele faz
2. O que foi feito na última sessão
3. O que ficou pendente (TODO list)
4. Estado do repositório (branch, último commit)

## FASE 4: SMART LOADING
Baseado no que eu disser que quero fazer hoje, carregue APENAS
os arquivos necessários seguindo o Smart Loading Protocol:
- .agents/protocols/smart-loading-protocol.md

NÍVEIS:
- LITE (fix, config, typo): carregar ~8 arquivos
- STANDARD (feature, CRUD): carregar ~20 arquivos  
- DEEP (arquitetura, migração): carregar ~45 arquivos
- CRITICAL (produção, pagamento): carregar tudo

## FASE 5: AGUARDAR INSTRUÇÕES
Após o relatório, me pergunte:
1. O que eu gostaria de fazer hoje
2. Qual nível de complexidade esperado
Depois carregue os arquivos do nível adequado e comece.
```

---

## O Que o Framework Faz Com Esse Prompt

### Fase 1: Carrega a Arquitetura
O assistente lê os configs e protocolos. Agora ele sabe:
- Que existem 8 agentes, 10 protocolos, 4 workflows
- Como funciona o triage, a complexidade, os maturity profiles
- Quais são os industry profiles disponíveis

### Fase 2: Carrega o Contexto
Lê o checkpoint e a memória. Agora ele sabe:
- O que é o projeto, qual a stack, qual o estágio
- O que foi feito até agora
- O que ficou pendente
- Que lições foram aprendidas
- Que decisões foram tomadas

### Fase 3: Verifica o Repo
Confirma que o código está synced e qual é o estado real.

### Fase 4: Apresenta Relatório
Ele deve apresentar algo como:

```
📊 RELATÓRIO DE RETOMADA

Projeto: MyProject — Sistema de gestão de pedidos online
Stack: Next.js 15 + Prisma + PostgreSQL + Redis
Profile: PME | Nenhum industry profile ativo
Branch: main | Último commit: feat(auth): implement JWT (abc123f)

ÚLTIMA SESSÃO (2026-04-05):
✅ JWT auth implementado (access + refresh token)
✅ Redis blacklist configurado
✅ 12 tests passando

PENDENTE:
□ Token rotation no mobile app
□ Rate limiting no refresh endpoint
□ API docs de auth

PRÓXIMAS PRIORIDADES:
1. Token rotation mobile
2. Rate limiting
3. API docs

ALERTAS:
⚠️ Redis em produção precisa de senha
⚠️ Refresh token TTL pode ser longo para contexto financeiro

O que gostaria de fazer hoje?
```

### Fase 5: Aguarda Você
Não começa nada sem sua confirmação. Você decide o que fazer primeiro.

---

## Variações do Prompt de Retomada

### Retomada Rápida (quando você lembra do contexto)
```
Framework HEPHAESTUS — chat de continuação.
Leia .agents/memory/context-db/session-checkpoint.md e me dê o status.
Vamos continuar com: [sua tarefa específica].
```

### Retomada Após Longo Período (1+ semana sem trabalhar)
```
Framework HEPHAESTUS — chat de continuação APÓS LONGO PERÍODO.

Faça a retomada completa (FASE 1 a 5 do protocolo padrão).

Adicionalmente:
- Verifique se há dependências desatualizadas (npm outdated ou equivalente)
- Verifique se há security advisories (npm audit)
- Revise se alguma decisão da memória pode estar desatualizada
- Sugira se algo na knowledge base precisa de refresh

Depois me dê o relatório completo.
```

### Retomada com Mudança de Prioridade
```
Framework HEPHAESTUS — chat de continuação.
Leia o checkpoint (.agents/memory/context-db/session-checkpoint.md).

MUDANÇA DE PRIORIDADE: ignore o TODO anterior.
Nova prioridade: [descreva a nova urgência].
Reclassifique o pipeline adequado e vamos trabalhar nisso.
```

### Retomada de Emergência (bug em produção)
```
Framework HEPHAESTUS — RETOMADA DE EMERGÊNCIA.
Leia o checkpoint rapidamente.

BUG EM PRODUÇÃO:
[descrição do bug]
[logs/erros]
[impacto]

Use pipeline CRITICAL. Consulte incident-archetypes.
Diagnóstico e hotfix são prioridade absoluta.
```

---

## Dicas para Retomada Suave

### 1. O checkpoint é tudo
Se o encerramento da sessão anterior foi bem feito (arquivo 04), a retomada será suave. Se o checkpoint não foi criado, a retomada será mais difícil.

### 2. Mantenha o checkpoint atualizado
Se o chat anterior não gerou checkpoint (ex: caiu, esqueceu de encerrar), peça:
```
Analise o estado atual do projeto (git log, arquivos, .agents/memory/) 
e reconstrua o checkpoint que deveria ter sido criado na última sessão.
```

### 3. Não tenha medo de dar mais contexto
Se o assistente parecer confuso, dê contexto verbal:
```
Para contexto: na última sessão implementamos o sistema de JWT completo.
O que falta é integrar com o mobile app. Vamos continuar disso.
```

### 4. Confie na memória do framework
Se os stores de memória estão bem mantidos, o assistente vai pegar o contexto. Quanto mais você usa o framework, mais rico fica o contexto.

---

## Checklist de Retomada Bem-Sucedida

O chat está corretamente retomado quando:
- [x] Assistente sabe o nome e tipo do projeto
- [x] Assistente sabe a stack e arquitetura
- [x] Assistente sabe o que foi feito na última sessão
- [x] Assistente sabe o que ficou pendente
- [x] Assistente sabe o branch e último commit
- [x] Assistente está aguardando suas instruções (não saiu fazendo coisas por conta)

**Próximo passo:** Trabalhe normalmente usando [03-USO-DIARIO.md](./03-USO-DIARIO.md)
