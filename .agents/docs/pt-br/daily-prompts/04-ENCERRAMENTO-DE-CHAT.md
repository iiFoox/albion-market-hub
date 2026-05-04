# 04 — Encerramento de Chat: Salvar, Commitar e Fechar

> **Quando usar:** Final de cada sessão de trabalho, antes de fechar o chat.
> **Objetivo:** Garantir que NADA se perca — estado, memória, código, contexto.
> **REGRA DE OURO:** Nunca feche um chat sem executar este processo.

---

## O Prompt de Encerramento

Copie e cole este prompt completo no final da sua sessão:

```
Estou encerrando esta sessão de trabalho. Execute o PROTOCOLO DE ENCERRAMENTO completo:

## 1. RESUMO DA SESSÃO
Gere um resumo detalhado de tudo que foi feito nesta sessão:
- Tarefas completadas (com status)
- Tarefas iniciadas mas não terminadas (com % de progresso)
- Decisões arquiteturais tomadas
- Problemas encontrados e como foram resolvidos
- Próximos passos recomendados

## 2. ATUALIZAR MEMÓRIA
Atualize TODOS os stores de memória do framework:

a) Context DB (.agents/memory/context-db/):
   - Estado atual do projeto
   - Features implementadas
   - Stack e configurações atuais

b) Learning Store (.agents/memory/learning-store/):
   - Lições aprendidas nesta sessão
   - Problemas que encontramos e soluções
   - Padrões que funcionaram bem

c) Knowledge Graph (.agents/memory/knowledge-graph/):
   - Novas conexões entre módulos/tecnologias
   - Dependências descobertas

d) Evolution Log (.agents/memory/evolution-log/):
   - Registro desta sessão com timestamp
   - Métricas de telemetria (pipelines executados, quality score)

## 3. COMMIT E VERSIONAMENTO
Execute o Delivery Agent:
- Verifique se há mudanças não commitadas
- Se sim, faça commit com mensagem adequada (Conventional Commits)
- Determine o version bump correto (patch/minor/major)
- Atualize o CHANGELOG.md
- Push para o repositório remoto
- Confirme sync successful

## 4. GERAR CHECKPOINT DE RETOMADA
Crie um arquivo: .agents/memory/context-db/session-checkpoint.md
Com o seguinte conteúdo:
- Data e hora do encerramento
- Resumo do estado atual do projeto
- Lista de tarefas pendentes (TODO)
- Próximas prioridades recomendadas
- Alertas ou riscos identificados
- Contexto necessário para retomada
- Último commit hash e branch atual

Este arquivo será usado no próximo chat para retomar de onde paramos.

## 5. CONFIRMAÇÃO
Confirme que todos os itens acima foram executados:
□ Resumo gerado
□ Memória atualizada (4 stores)
□ Commit feito e pushed
□ Checkpoint de retomada criado
□ Nenhuma mudança pendente (working directory limpo)
```

---

## O Que o Framework Faz Com Esse Prompt

### Passo 1: Resumo
O PM gera um resumo executivo da sessão — como uma ata de reunião técnica.

### Passo 2: Memória
Cada store é atualizado:
- **Context DB** → "Hoje implementamos autenticação JWT. Stack atual: Next.js + Prisma + Redis."
- **Learning Store** → "Aprendemos que Prisma connection pool precisa de 20 mínimo para auth-heavy."
- **Knowledge Graph** → "JWT → Redis blacklist → token rotation → middleware de verificação."
- **Evolution Log** → "Sessão #12: 3 pipelines executados, quality score médio 4.3, 0 correction loops."

### Passo 3: Delivery
O Delivery Agent:
1. Detecta arquivo não commitados
2. Gera commit message: `feat(auth): implement JWT with refresh token rotation`
3. Determina version bump: `minor` (nova feature)
4. Atualiza CHANGELOG.md
5. `git push origin main`
6. Confirma: "✅ Push successful"

### Passo 4: Checkpoint
Cria o arquivo `session-checkpoint.md`:
```markdown
# Session Checkpoint
Date: 2026-04-05T18:00:00-03:00
Branch: main
Last Commit: abc123f

## Current State
- Auth JWT implementado (access + refresh token)
- Redis blacklist configurado
- Middleware de verificação funcionando
- Tests: 12/12 passing

## TODO (Pending)
- [ ] Implementar token rotation no mobile app
- [ ] Adicionar rate limiting no endpoint de refresh
- [ ] Documentar API de auth

## Next Priorities
1. Token rotation no mobile (blockeado por: nada)
2. Rate limiting (blockeado por: nada)
3. API docs (pode ser paralelo)

## Alerts
- Redis em produção precisa de senha configurada
- Refresh token TTL de 7 dias pode ser longo para fintech

## Context for Resumption
O sistema de auth está completo no backend. Falta integrar
com o mobile app e adicionar rate limiting. O Validator aprovou 
com nota 4.5/5. Security audit passou sem critical findings.
```

### Passo 5: Confirmação
O framework confirma cada item marcado como ✅.

---

## Quando Encerrar

| Situação | Ação |
|---|---|
| Final do dia de trabalho | Encerramento COMPLETO (todos os 5 passos) |
| Pausa rápida (voltar em 30 min) | Não precisa encerrar |
| Mudando de contexto (outro projeto) | Encerramento COMPLETO |
| Chat ficando muito longo (limite de contexto) | Encerramento COMPLETO + retomada em novo chat |
| Bug urgente interrompeu o trabalho | Encerramento RÁPIDO (commit + checkpoint) |

### Encerramento RÁPIDO (para emergências)
```
Encerramento rápido: salve o estado atual, faça commit de tudo 
que está pendente e gere o checkpoint de retomada.
Sem resumo detalhado — só salvar e fechar.
```

---

## Erros Comuns a Evitar

```
❌ Fechar o chat sem salvar → perde contexto e mudanças
❌ Não fazer o checkpoint → próximo chat não sabe onde parou
❌ Não dar push → mudanças ficam só local, risco de perda
❌ Ignorar tarefas pendentes → esquece o que faltava
❌ Não atualizar a memória → framework não aprende
```

**Próximo passo:** Quando abrir um novo chat, use [05-RETOMADA-DE-CHAT.md](./05-RETOMADA-DE-CHAT.md)
