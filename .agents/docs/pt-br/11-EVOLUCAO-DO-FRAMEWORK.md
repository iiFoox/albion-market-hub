# 11 — Evolução do Framework

> **Nível:** 🟠 Avançado  
> **Objetivo:** Fazer o HEPHAESTUS melhorar a cada uso

---

## Como o Framework Aprende

O HEPHAESTUS tem 4 sistemas de memória que evoluem a cada interação:

```
┌───────────────────────────────────────────────────────┐
│                    MEMORY SYSTEM                       │
├──────────────────┬────────────────────────────────────┤
│ Knowledge Graph  │ Padrões, relações, compatibilidades│
│                  │ "React com TypeScript usa Zod"      │
├──────────────────┼────────────────────────────────────┤
│ Learning Store   │ O que deu certo/errado e por quê   │
│                  │ "Usar file_picker > image_picker    │
│                  │  em desktop: suporte mais amplo"    │
├──────────────────┼────────────────────────────────────┤
│ Evolution Log    │ Como o framework cresceu            │
│                  │ "v4.0.0: adicionados UI/UX +        │
│                  │  Platform Guardian"                  │
├──────────────────┼────────────────────────────────────┤
│ Context DB       │ Estado atual do projeto             │
│                  │ "Tela de login pronta, falta perfil" │
└──────────────────┴────────────────────────────────────┘
```

---

## O Ciclo de Evolução

Toda execução do pipeline segue este ciclo:

```
1. ANTES DE AGIR:
   → Consulta memória: "Já fizemos algo parecido?"
   → Encontra padrões relevantes
   → Evita repetir erros passados

2. DURANTE A EXECUÇÃO:
   → Referencia decisões que usaram memória
   → Identifica novos padrões

3. DEPOIS DE COMPLETAR:
   → Armazena o que aprendeu
   → Atualiza contexto do projeto
   → Pontua: "Essa decisão foi boa? Sim/Não"
   → Registra no evolution log
```

---

## Como Você Alimenta a Evolução

### 1. Feedback explícito
```markdown
A solução funcionou bem. Registre no learning-store:
- Usar drift para SQLite cross-platform é a melhor opção
- flutter_secure_storage no web não é realmente seguro (usa localStorage)
- GoRouter redirect guard funciona melhor que wrapper widget
```

### 2. Correção de decisão
```markdown
A decisão de usar BLoC não foi boa para este projeto. É overengineering.
Registre no learning-store como decisão negativa.
Para projetos pequenos, preferir Riverpod ou ChangeNotifier.
```

### 3. Pedido de retrospectiva
```markdown
Faça uma retrospectiva desta sessão:
- O que funcionou bem?
- O que poderia melhorar?
- Que padrões novos devemos registrar?
- Algum agente não foi ativado e deveria?
- Alguma decisão passada se mostrou errada?

Registre tudo na memória.
```

### 4. Atualização da knowledge base
```markdown
Atualize o known-issues.md do Platform Guardian:
- Package X v3.0 agora suporta Windows (antes não suportava)
- Package Y tem bug no Android 14 (issue #1234 no GitHub)
```

---

## Prompts de Evolução

### Review de evolução semanal:
```markdown
DEEP: Faça uma review de evolução do framework:

1. Leia todo o learning-store
2. Leia o evolution-log
3. Identifique:
   - Padrões mais usados (devem virar templates)
   - Erros repetidos (devem virar guardrails)
   - Agentes subutilizados (por quê?)
   - Decisões que se mostraram certas (reforçar)
   - Decisões que se mostraram erradas (corrigir)
4. Proponha melhorias concretas no framework
5. Atualize a memória com as conclusões
```

### Calibração de agentes:
```markdown
O UI/UX Specialist tem sido muito rigoroso / muito leniente.
Ajuste os critérios de aprovação:
- [critério que precisa mudar]
Registre a calibração no evolution-log.
```

### Adicionar novo conhecimento:
```markdown
Adicione ao knowledge-graph:
- Padrão: [nome do padrão]
- Contexto: [quando usar]
- Implementação: [como fazer]
- Evidência: [por que funciona]
Fonte: [experiência neste projeto / documentação / etc.]
```

---

## Métricas de Evolução

O Project Manager trackeia:

| Métrica | O que mede | Meta |
|---------|-----------|------|
| Decisões reutilizadas | Quantas vezes a memória foi útil | Crescente |
| Erros repetidos | Erros que voltam após serem "resolvidos" | Zero |
| Pipeline efficiency | Agentes corretos na first try | > 90% |
| Fix loops | Quantas vezes Builder → Validator falha | < 2 em média |
| Cobertura de testes | % de código testado | > 80% |
| Visual debt | Issues de UI não resolvidos | Decrescente |
| Platform issues | Bugs de plataforma em produção | Zero |

---

## O Framework Que Se Melhora

```
Sessão 1: Framework novo, tudo genérico
                ↓
Sessão 5: Já conhece seu estilo de código, suas preferências
                ↓
Sessão 15: Já sabe os packages que funcionam no seu stack
                ↓
Sessão 30: Prevê problemas antes de acontecerem
                ↓
Sessão 50+: Funciona como um team member que conhece o projeto
```

> 💡 **Chave para a evolução:** Sempre dê feedback. Sempre salve o contexto. Sempre faça retrospectivas.
