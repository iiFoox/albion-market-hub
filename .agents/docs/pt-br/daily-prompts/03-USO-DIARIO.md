# 03 — Uso Diário: Trabalhando com o HEPHAESTUS

> **Quando usar:** Todo dia de trabalho, após a inicialização já ter sido feita.
> **Objetivo:** Guia prático de como pedir coisas, trabalhar com o pipeline, e aproveitar o framework.

---

## Como Pedir Coisas ao Framework

### Pedido Simples (Pipeline LITE)
Para coisas rápidas, basta pedir diretamente:

```
Fix o typo no botão de login — está escrito "Logn" em vez de "Login".
```

```
Atualize a variável de ambiente DATABASE_URL no .env.example 
para incluir o parâmetro connection_limit=20.
```

```
Adicione um comentário explicando a lógica do cálculo de desconto 
em src/services/pricing.ts.
```

O framework vai classificar como **LITE**, usar Builder + Validator, resolver rápido e commitar automaticamente.

---

### Pedido Médio (Pipeline STANDARD)
Para features normais, dê contexto suficiente:

```
Implemente uma página de configurações do usuário com:
- Alteração de nome e email
- Upload de avatar
- Toggle de dark mode
- Salvamento no banco de dados

Use o padrão de formulário que já temos no projeto.
```

O framework vai ativar **Researcher → Planner → Builder → Validator → Documentation → Delivery**.

---

### Pedido Complexo (Pipeline DEEP)
Para mudanças arquiteturais ou features complexas, dê o máximo de contexto:

```
Preciso migrar nosso sistema de autenticação de sessions para JWT.

Requisitos:
- Access token (15 min) + Refresh token (7 dias)
- Refresh token rotation com reuse detection
- Blacklist de tokens revogados no Redis
- Manter backward compatibility com sessions atuais por 30 dias
- Migration gradual com feature flag

Contexto:
- Temos ~5000 usuários ativos
- App mobile consumindo a API (precisa de token-based)
- Produção em AWS

Use pipeline DEEP. Quero análise de risco completa antes de implementar.
```

---

### Pedido Crítico (Pipeline CRITICAL)
Para pagamentos, segurança ou produção:

```
Implementar integração com Stripe para pagamentos por assinatura.

Use pipeline CRITICAL.
Ative o Fintech Profile.
Quero:
- Análise de compliance (PCI-DSS)
- Security audit completo
- Plano de rollback
- Feature flag para rollout gradual
```

---

## Dicas de Uso Diário

### 1. Sempre diga O QUÊ, não COMO
```
❌ "Crie um arquivo user.service.ts com uma classe UserService que..."
✅ "Preciso de um serviço de usuários com CRUD completo, validação e error handling."
```
O framework sabe COMO implementar. Você diz O QUÊ precisa e PORQUÊ.

### 2. Mencione restrições quando existirem
```
✅ "Implemente busca de produtos. Restrição: precisa funcionar com a tabela 
   products existente que já tem 500K registros."
```

### 3. Peça para consultar a knowledge base
```
✅ "Antes de implementar, consulte o database-playbook para a melhor 
   estratégia de paginação para tabelas grandes."
```

### 4. Use os workflows quando souber qual quer
```
✅ "Use /quick-fix para corrigir o bug de validação do email."
✅ "Use /research-only para avaliar se devemos migrar de REST para GraphQL."
✅ "Use /review-only para auditar a segurança do módulo de pagamento."
```

### 5. Force o nível de complexidade quando necessário
```
✅ "Use pipeline DEEP para esta feature, mesmo que pareça simples."
✅ "Isso é só um fix rápido, use LITE."
```

### 6. Peça para o PM rastrear
```
✅ "PM: registre que estamos começando o módulo de notificações. 
   Estimativa: 3 dias. Milestone: v1.2.0."
```

---

## Padrão de Sessão de Trabalho

### Manhã — Início do Dia
```
1. Abrir novo chat
2. Usar prompt de RETOMADA (arquivo 05)
3. Revisar status do projeto
4. Começar a trabalhar nas tarefas
```

### Durante o Dia — Trabalho Normal
```
— Pedidos de feature, fix, refactoring
— O framework vai classificar, executar e commitar automaticamente
— Se a sessão for longa, o PM mantém telemetria
```

### Final do Dia — Encerramento
```
1. Usar prompt de ENCERRAMENTO (arquivo 04)
2. Framework salva estado, commita tudo, gera resumo
3. Fechar o chat
```

---

## Situações Especiais

### "O framework está sendo pesado demais para essa task"
```
Reduza para LITE: a complexidade desta tarefa é baixa.
Apenas Builder + Validator são necessários.
```

### "Quero que todos os agentes participem nesta"
```
Use pipeline CRITICAL para esta tarefa. 
Quero todos os agentes com deep reasoning ativado.
```

### "Quero mudar a stack do projeto"
```
Preciso avaliar migração de [stack atual] para [nova stack].
Use /research-only primeiro.
Depois discutimos se vale a pena antes de implementar.
```

### "Detectei um bug em produção"
```
BUG EM PRODUÇÃO — URGENTE:
[descrição do bug]
[logs/erros relevantes]
[impacto: quantos usuários afetados]

Use pipeline CRITICAL. Priorize diagnóstico e hotfix.
Consulte incident-archetypes para padrões conhecidos.
```

**Próximo passo:** Vá para [04-ENCERRAMENTO-DE-CHAT.md](./04-ENCERRAMENTO-DE-CHAT.md)
