# 03 — Novo Chat, Retomada e Salvamento de Contexto

> **Nível:** 🟢 Iniciante  
> **Tempo de leitura:** 8 minutos

---

## Quando Criar um Novo Chat

| Situação | Ação | Por quê |
|----------|------|---------|
| Começando o dia de trabalho | Novo chat + prompt de retomada | Contexto limpo |
| Mudando de tarefa completamente | Novo chat | Evita confusão de contexto |
| Chat ficou muito longo (50+ msgs) | Novo chat + retomada | LLM perde qualidade |
| Bug estranho após muitas mudanças | Novo chat | Reset de contexto |
| Continuando a mesma tarefa | Continue no mesmo chat | Manter contexto |

---

## Prompt de Inicialização (Novo Chat)

### Primeira vez no projeto (setup completo):
```markdown
Você é o framework HEPHAESTUS v4.0.0.

Leia os seguintes arquivos nesta ordem:
1. .agents/AGENTS.md (definição do framework)
2. .agents/config/framework.yaml (configuração)
3. .agents/protocols/smart-loading-protocol.md (economia de contexto)
4. .agents/protocols/adaptive-complexity-protocol.md (níveis de complexidade)

Depois de ler, me confirme:
- Quantos agentes você identificou
- Qual o profile ativo
- Qual o nível de loading atual

Responda em português (pt-BR).
```

### Retomada de sessão (voltando ao trabalho):
```markdown
Retome o framework HEPHAESTUS v4.0.0.

Leia:
1. .agents/config/framework.yaml
2. .agents/memory/context-db/session-checkpoint.md
3. .agents/protocols/smart-loading-protocol.md

Carregue no nível [LITE/STANDARD/DEEP] para trabalhar em: [descreva a tarefa].
Responda em pt-BR.
```

### Retomada rápida (já sabe o que fazer):
```markdown
HEPHAESTUS v4.0.0 — Nível LITE.
Leia .agents/config/framework.yaml e .agents/memory/context-db/session-checkpoint.md.
Tarefa: [descreva a tarefa].
```

---

## Como Salvar o Estado ao Final do Chat

### Antes de fechar o chat, peça:

```markdown
Salve o estado atual do projeto:
1. Atualize .agents/memory/context-db/session-checkpoint.md com:
   - O que foi feito nesta sessão
   - Onde paramos
   - Próximos passos pendentes
   - Decisões tomadas
2. Atualize .agents/memory/learning-store/ com learnings desta sessão
3. Atualize .agents/memory/knowledge-graph/ se houve padrões novos
```

### Template do session-checkpoint.md:
```markdown
# Session Checkpoint

## Última Atualização
- **Data:** [data/hora]  
- **Chat ID:** [se disponível]
- **Nível usado:** [LITE/STANDARD/DEEP/CRITICAL]

## O que foi feito
- [x] Tarefa 1
- [x] Tarefa 2
- [ ] Tarefa 3 (pendente)

## Onde Paramos
[Descrição precisa do estado atual]

## Decisões Tomadas
1. [Decisão 1]: [Justificativa]
2. [Decisão 2]: [Justificativa]

## Próximos Passos
1. [ ] [Próxima tarefa]
2. [ ] [Próxima tarefa]

## Notas Importantes
[Qualquer informação que o próximo chat precisa saber]
```

---

## Fluxo Completo de um Dia de Trabalho

```
MANHÃ:
┌─────────────────────────────────────────┐
│ 1. Abrir novo chat                      │
│ 2. Usar prompt de retomada              │
│ 3. Framework lê session-checkpoint.md   │
│ 4. Framework confirma estado e pendências│
│ 5. Começar a trabalhar                  │
└─────────────────────────────────────────┘

DURANTE O DIA:
┌─────────────────────────────────────────┐
│ - Fazer pedidos normalmente             │
│ - Para tasks diferentes, dizer o nível  │
│ - A cada commit, Delivery persiste      │
│ - Memory se atualiza automaticamente    │
└─────────────────────────────────────────┘

SE PRECISAR TROCAR DE CHAT:
┌─────────────────────────────────────────┐
│ 1. Pedir para salvar estado             │
│ 2. Verificar que checkpoint foi salvo   │
│ 3. Abrir novo chat                      │
│ 4. Usar prompt de retomada              │
└─────────────────────────────────────────┘

FIM DO DIA:
┌─────────────────────────────────────────┐
│ 1. Pedir salvamento completo            │
│ 2. Verificar commits pendentes          │
│ 3. Pedir backup se necessário           │
│ 4. Fechar chat                          │
└─────────────────────────────────────────┘
```

---

## Dicas

### 💡 Evite chats infinitos
Após ~50 mensagens, a qualidade das respostas degrada. Salve e crie novo chat.

### 💡 Nomeie suas sessões
Se a ferramenta permite, nomeie o chat: "HEPHAESTUS — Feature Login" — facilita encontrar depois.

### 💡 Um chat por contexto
Não misture "corrigir bug de login" com "criar sistema de pagamento" no mesmo chat.

### 💡 O checkpoint é seu amigo
Session checkpoint é o fio condutor entre chats. Quanto mais detalhado, melhor a retomada.

---

## Próximo

→ [04-FLUXO-BASICO.md](04-FLUXO-BASICO.md) — Como executar tarefas simples
