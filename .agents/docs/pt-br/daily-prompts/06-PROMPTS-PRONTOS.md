# 06 — Prompts Prontos: Copie e Cole

> **Quando usar:** Referência rápida — encontre o prompt que precisa e cole no chat.
> **Organização:** Por categoria e situação.

---

## 🚀 INICIALIZAÇÃO

### Primeira vez no projeto
```
Você é o sistema multi-agente HEPHAESTUS. Leia a pasta .agents/ deste projeto para entender sua arquitetura completa. Leia GETTING_STARTED.md, ROADMAP.md, configs e protocolos. Depois execute o Repository Bootstrap Protocol do Delivery Agent para configurar Git e GitHub. Me guie passo a passo em tudo que faltar.
```

### Apresentar novo projeto
```
Projeto: [NOME]
Tipo: [web app / mobile / API / SaaS]
Stack: [Next.js + PostgreSQL / React Native / etc.]
Descrição: [o que faz, 2-3 frases]
Equipe: [tamanho]
Prazo: [estimativa]
Compliance: [nenhum / PCI-DSS / HIPAA / LGPD]

Defina o maturity profile, recomende arquitetura usando o decision tree da knowledge base, e crie um plano de fases.
```

---

## 📋 DIA A DIA

### Feature nova
```
Implemente [descrição da feature].

Requisitos:
- [requisito 1]
- [requisito 2]
- [requisito 3]

Consulte a knowledge base para padrões relevantes.
Use pipeline [STANDARD/DEEP] para esta tarefa.
```

### Bug fix simples
```
Bug: [descrição do bug]
Onde: [arquivo ou módulo]
Comportamento esperado: [o que deveria acontecer]
Comportamento atual: [o que está acontecendo]

Use pipeline LITE. Fix, teste e commite.
```

### Bug em produção (URGENTE)
```
🚨 BUG EM PRODUÇÃO — URGENTE

Descrição: [o que está quebrado]
Impacto: [quantos usuários, severidade]
Logs: [cole os erros relevantes]
Desde quando: [quando começou]

Use pipeline CRITICAL. Consulte incident-archetypes.
Priorize diagnóstico e hotfix. Plano de rollback se necessário.
```

### Refactoring
```
Refactore [módulo/arquivo/componente].

Objetivo: [melhorar performance / reduzir complexidade / extrair lógica]
Restrição: nenhuma mudança de comportamento externo.
Métricas before/after obrigatórias.

Use pipeline STANDARD com Validator em modo de regression testing.
```

---

## 🔍 PESQUISA

### Avaliar nova tecnologia
```
Use /research-only.

Avalie [tecnologia] para [caso de uso no projeto].
Compare com [alternativa 1] e [alternativa 2].
Use o Technology Evaluation Matrix do researcher/analysis-frameworks.
Quero scoring ponderado e recomendação final.
```

### Análise de risco
```
Faça uma análise de risco para: [mudança proposta]

Use o Researcher com deep reasoning (FMEA + Adversarial Analysis).
Quero: matriz de riscos, mitigações, e recomendação go/no-go.
```

---

## 🔒 SEGURANÇA

### Security audit
```
Use /review-only.

Faça um security audit completo do módulo [nome].
Verifique: OWASP Top 10, API Security checklist, auth boundary.
Se fintech: aplique PCI-DSS controls.
Se health: aplique HIPAA compliance.
```

---

## 📊 GESTÃO

### Status do projeto
```
PM: gere um relatório de status do projeto.
Inclua: progresso por milestone, tarefas pendentes, riscos ativos,
métricas de qualidade e recomendações.
```

### Rastreamento de escopo
```
PM: o escopo do projeto mudou. Nova demanda: [descreva].
Avalie impacto em prazo, risco e qualidade.
Recomende: aceitar, negociar ou rejeitar.
```

---

## 💾 ENCERRAMENTO

### Encerramento completo (final do dia)
```
Encerrando sessão. Execute protocolo de encerramento completo:
1. Resumo da sessão
2. Atualizar memória (4 stores)
3. Commit e push tudo pendente
4. Gerar checkpoint de retomada em .agents/memory/context-db/session-checkpoint.md
5. Confirmar que tudo foi salvo
```

### Encerramento rápido (emergência)
```
Encerramento rápido: commit de tudo pendente, gere checkpoint de retomada, push. Sem resumo detalhado.
```

---

## 🔄 RETOMADA

### Retomada padrão (nova sessão)
```
Framework HEPHAESTUS — chat de continuação.
Carregue: framework.yaml, complexity-routing.yaml, orchestrator system-prompt,
e session-checkpoint.md.
Me dê relatório de retomada e pergunte o que fazer hoje.
Depois use Smart Loading Protocol para carregar apenas o necessário.
```

### Retomada rápida (lembra do contexto)
```
HEPHAESTUS — continuação. Leia session-checkpoint.md.
Use Smart Loading LITE.
Vamos continuar com: [tarefa específica].
```

### Retomada após longo período
```
HEPHAESTUS — continuação após [X] dias sem trabalhar.
Carregue core + session-checkpoint.
Use Smart Loading STANDARD para re-familiarização.
Verifique dependências desatualizadas e security advisories.
Depois me dê o relatório completo.
```

---

## ⚙️ CONTROLE DO FRAMEWORK

### Forçar nível de complexidade
```
Use pipeline LITE para isto.
Use pipeline DEEP para isto.
Use pipeline CRITICAL para isto.
```

### Ativar industry profile
```
Ative o Fintech Profile para este projeto.
Ative o Healthcare Profile para este projeto.
Ative o E-Commerce Profile para este projeto.
```

### Mudar maturity profile
```
Mude o maturity profile para [startup/PME/enterprise/regulated/legacy].
Ajuste quality gates e delivery rules conforme o perfil.
```

### Consultar knowledge base
```
Consulte o database-playbook para [estratégia de paginação/index/migration].
Consulte os architecture-patterns para decidir entre [X] e [Y].
Consulte as tech-cards de [tecnologia] para configuração recomendada.
Consulte o security KB para [auth/API security/OWASP/LGPD].
```

### Consultar experiência operacional
```
Consulte incident-archetypes para problemas parecidos com [situação].
Consulte anti-pattern-registry para verificar se [abordagem] é um anti-pattern.
```

### Pedir benchmark do framework
```
PM: avalie a qualidade desta sessão usando o benchmark-suite.
Score de accuracy, completeness e quality.
Compare com sessões anteriores.
```
