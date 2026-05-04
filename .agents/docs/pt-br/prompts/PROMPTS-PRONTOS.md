# Prompts Prontos para Copiar e Usar

> **Propósito:** Templates prontos para uso imediato. Copie, preencha os [campos], e use.

---

## SETUP (Primeira vez / Novo chat)

### Setup completo:
```
Você é o framework HEPHAESTUS v8.0.0.
Leia os seguintes arquivos:
1. .agents/AGENTS.md
2. .agents/config/framework.yaml
3. .agents/protocols/smart-loading-protocol.md
4. .agents/protocols/adaptive-complexity-protocol.md
5. .agents/docs/pt-br/22-MAPA-DE-EXPERIENCIA-DO-OPERADOR.md
Confirme: nº de agentes, profile ativo, nível de loading e melhor guia para minha intenção.
Responda em pt-BR.
```

### Retomada rápida:
```
HEPHAESTUS v8.0.0 — carregue nível [LITE/STANDARD].
Leia .agents/config/framework.yaml e .agents/memory/context-db/session-checkpoint.md.
Tarefa: [descreva a tarefa].
```

### Instalar ou atualizar:
```
HEPHAESTUS v8.0.0 — me guie pela instalacao/update.
Leia .agents/docs/pt-br/20-WIZARD-DE-INSTALACAO-E-UPDATE.md.
Comece com dry-run. Nao aplique mudancas ate eu aprovar.
```

### Mapa do operador:
```
HEPHAESTUS v8.0.0 — leia .agents/docs/pt-br/22-MAPA-DE-EXPERIENCIA-DO-OPERADOR.md.
Minha intencao e: [instalar/atualizar/iniciar projeto/projeto real/release/retomar].
Me diga o menor conjunto de guias para carregar.
```

---

## 🟢 LITE — Tarefas Simples

### Bug fix:
```
LITE: Corrija [descrição do bug] no arquivo [caminho/arquivo.dart].
Atualmente: [comportamento atual]
Esperado: [comportamento esperado]
```

### Typo:
```
LITE: Corrija o texto "[texto errado]" para "[texto correto]" em [arquivo].
```

### Config:
```
LITE: Mude [configuração] de [valor atual] para [novo valor] em [arquivo].
```

### Rename:
```
LITE: Renomeie [nome antigo] para [nome novo] em todo o projeto.
```

---

## 🟡 STANDARD — Features

### Nova tela:
```
STANDARD: Crie a tela de [nome] com:
- [elemento 1]
- [elemento 2]
- [elemento N]
Stack: Flutter multi-platform.
Seguir design tokens do profile.
Estados: loading, error, empty, data.
Responsive: mobile + tablet + desktop.
```

### CRUD completo:
```
STANDARD: Implemente CRUD de [entidade]:
- Model: [campo1, campo2, campo3...]
- API: [endpoints]
- Telas: Lista + Detalhe + Form (criar/editar) + Delete confirm
- Validação de formulário completa
- Estados: loading, error, empty em todas as telas
```

### Integração de API:
```
STANDARD: Integre a API [nome]:
- Endpoint: [URL]
- Method: [GET/POST/PUT/DELETE]
- Request: [body/params]
- Response: [formato esperado]
- Error handling: [tipos de erro]
- Preciso de: Model, Repository, UseCase, e atualizar a tela [X]
```

### Refactor:
```
STANDARD: Refatore [módulo/componente]:
Estado atual: [descrição]
Estado desejado: [descrição]
Regras: não quebrar funcionalidade, manter testes passando.
```

---

## 🟠 DEEP — Arquitetura

### Migração:
```
DEEP: Migre [componente/padrão/tecnologia]:
De: [estado atual]
Para: [estado desejado]
Regras:
- Faseamento (não tudo de uma vez)
- Rollback strategy definida
- Testes a cada fase
- Zero downtime se produção
```

### Sistema complexo:
```
DEEP: Implemente [sistema complexo]:
Requisitos funcionais:
1. [req 1]
2. [req 2]

Requisitos não-funcionais:
- Performance: [meta]
- Segurança: [nível]
- Plataformas: [lista]

Preciso de:
- Research das opções
- Plano faseado com rollback
- Security audit
- Test coverage > [X]%
```

### Offline-first:
```
DEEP: Implemente offline-first para [feature]:
- Cache local: [tecnologia]
- Sync strategy: [quando/como]
- Conflict resolution: [server wins / client wins / merge]
- Queue para operações offline
- Indicador visual online/offline
```

---

## 🔴 CRITICAL — Produção

### Pagamento:
```
CRITICAL: Implemente [gateway de pagamento]:
- Planos: [lista]
- Trial: [sim/não, duração]
- Webhook events: [lista]
- PCI-DSS: tokens via SDK, nunca armazenar cartão
- LGPD: [requisitos]
- Test coverage > 90%
- Security audit OWASP
- Rollback strategy
```

---

## 🎨 UI — Visual

### Nova tela:
```
UI WORKFLOW: Crie a tela de [nome] com:
- [elementos visuais]
Seguir design tokens. Responsive. Acessível.
Estados: loading, error, empty.
```

### Design review:
```
Faça design review completa de [arquivo.dart]:
□ Design tokens
□ Responsive
□ Acessibilidade
□ Estados
□ Dark mode
□ Performance visual
```

### Design system:
```
UI WORKFLOW (DEEP): Crie o design system:
- Paleta de cores (light + dark)
- Escala tipográfica
- Sistema de espaçamento (8px grid)
- Border radius
- Elevação/shadow
- Componentes: Button, Card, TextField, Avatar, Badge
```

---

## 🔧 DEBUG

### Bug simples:
```
LITE: Bug — [descrição]. Arquivo: [arquivo]. Erro: [mensagem de erro].
```

### Bug complexo:
```
STANDARD: Bug — [descrição]
Sintomas: [o que acontece]
Quando: [condição de disparo]
Erro: [stack trace]
Já tentei: [tentativas]
Preciso de root cause e fix.
```

### Performance:
```
DEEP: Performance degradada em [componente]:
- Sintoma: [lag, lentidão, FPS baixo]
- Condição: [quando acontece]
- Métrica: [FPS, tempo de load]
Preciso de: profiling, root cause, e otimização.
```

---

## 💾 SALVAMENTO

### Salvar estado:
```
Salve o estado da sessão:
1. Atualize session-checkpoint.md com: o que foi feito, onde paramos, próximos passos
2. Atualize learning-store com learnings desta sessão
3. Confirme que tudo foi salvo
```

### Backup completo:
```
Faça backup:
1. Commit tudo que está pendente
2. Push para remote
3. Confirme que tudo está seguro
```

---

## 📊 EVOLUÇÃO

### Retrospectiva:
```
Faça retrospectiva desta sessão:
- O que funcionou bem?
- O que poderia melhorar?
- Padrões novos para registrar?
- Decisões que se mostraram certas/erradas?
Registre tudo na memória.
```

### Feedback:
```
Feedback: [a decisão de X foi boa/ruim porque Y].
Registre no learning-store.
```

