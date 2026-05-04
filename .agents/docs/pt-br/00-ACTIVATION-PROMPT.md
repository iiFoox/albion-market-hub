# Single Activation Prompt — HEPHAESTUS

> **Propósito:** Ativar o framework com o MÍNIMO de texto possível  
> **Para quem:** Usuário que já tem o framework configurado

---

## Quick Start (1 linha)

```
HEPHAESTUS v4.0.1 — ativar. Stack: Flutter. Tarefa: [descreva a tarefa].
```

Exemplo:
```
HEPHAESTUS v4.0.1 — ativar. Stack: Flutter. Tarefa: criar tela de perfil com edição de foto.
```

---

## O que o framework faz ao receber esse prompt:

```
1. Lê .agents/config/framework.yaml           → Versão, profiles ativos
2. Detecta profile: Flutter Multi-Platform     → Carrega targets (Android/Windows/Web)
3. Detecta keywords na tarefa                  → Classifica nível (LITE/STANDARD/DEEP/CRITICAL)
4. Smart Loading                               → Carrega APENAS os arquivos do tier
5. Triage leve                                 → Agentes avaliam participação (~100 palavras)
6. Auto-Escalation Check                       → Escala se trigger disparar
7. Monta pipeline                              → Menor time que entrega qualidade
8. Executa                                     → Pipeline roda
```

---

## Variações

### Tarefa simples (força LITE):
```
HEPHAESTUS LITE — corrigir typo "Cadastrarr" em register_screen.dart.
```

### Feature nova (auto-detecta STANDARD):
```
HEPHAESTUS — criar sistema de favoritos com toggle e lista.
```

### Tarefa complexa (força DEEP):
```
HEPHAESTUS DEEP — migrar state management de Provider para Riverpod.
```

### Retomada de sessão:
```
HEPHAESTUS — retomar. Leia .agents/memory/context-db/session-checkpoint.md.
```

### Com contexto extra:
```
HEPHAESTUS — ativar. Stack: Flutter. 
Projeto: GameForge Portal.
Tarefa: implementar sistema de chat real-time com WebSocket.
Prioridade: funcionar em Android + Web.
```

---

## Setup Completo (primeira vez no chat)

Se é a **primeira mensagem** de um chat novo e a LLM não conhece o framework:

```
Você é o framework HEPHAESTUS v4.0.1.
Leia: .agents/AGENTS.md e .agents/config/framework.yaml
Profile ativo: Flutter Multi-Platform.
Responda em pt-BR.
Tarefa: [descreva a tarefa].
```

Após o primeiro setup, nas próximas mensagens do mesmo chat, use o prompt de 1 linha.

---

## Dica: Sempre comece LITE

```
HEPHAESTUS — [tarefa simples ou complexa, tanto faz]
```

O framework auto-escala se precisar. Você **nunca precisa adivinhar** o nível certo.
Se for simples → fica LITE (rápido, barato).
Se for complexo → escala para STANDARD/DEEP (carregando apenas o delta).

---

## Cheat Sheet — Copie e Use

| Situação | Prompt |
|----------|--------|
| Bug fix rápido | `HEPHAESTUS LITE — fix [bug] em [arquivo]` |
| Feature nova | `HEPHAESTUS — criar [feature] com [requisitos]` |
| Tela nova | `HEPHAESTUS — criar tela de [nome] com [elementos]` |
| Refactor | `HEPHAESTUS — refatorar [módulo] de [atual] para [desejado]` |
| Design review | `HEPHAESTUS — review de design de [arquivo.dart]` |
| Migração | `HEPHAESTUS DEEP — migrar [de] para [para]` |
| Pagamento | `HEPHAESTUS CRITICAL — implementar [gateway] com [planos]` |
| Retomar | `HEPHAESTUS — retomar sessão anterior` |
| Salvar | `HEPHAESTUS — salvar estado da sessão` |
| Retrospectiva | `HEPHAESTUS — retrospectiva desta sessão` |
