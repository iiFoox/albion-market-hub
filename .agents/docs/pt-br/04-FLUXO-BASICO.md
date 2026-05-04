# 04 — Fluxo Básico (LITE)

> **Nível:** 🟢 Iniciante  
> **Complexidade:** LITE  
> **Agentes ativos:** 2-3 (Orchestrator + Builder + Validator)  
> **Quando usar:** Bug fix, typo, rename, config, ajuste simples

---

## Como Funciona o Pipeline LITE

```
Você → Orchestrator (classifica LITE)
                   → Builder (implementa)
                   → Validator (verifica)
                   → Delivery (commita)
                   → Resultado para você
```

**Tempo total:** Mínimo (1-2 respostas da LLM)

---

## Exemplos Práticos com Prompts Reais

### Exemplo 1: Corrigir um bug

**Seu prompt:**
```
LITE: O campo de email no login está aceitando strings vazias. 
Corrija em lib/features/auth/login_screen.dart.
```

**O que acontece internamente:**
```
📊 Orchestrator:
   Complexidade: LITE (keyword "corrija", scope: 1 arquivo)
   Pipeline: Builder → Validator → Delivery

🔨 Builder:
   - Abre login_screen.dart
   - Encontra validação do campo email
   - Adiciona: if (email.trim().isEmpty) return 'Email obrigatório';
   - Verifica consistência com outros campos

✅ Validator:
   - Roda testes existentes
   - Verifica que a validação funciona
   - Confirma: PASS

📦 Delivery:
   - Commit: fix(auth): add email empty validation on login screen
   - Version: patch bump
```

### Exemplo 2: Renomear variável

**Seu prompt:**
```
LITE: Renomeie a variável 'usr' para 'currentUser' em todo o projeto.
```

### Exemplo 3: Ajustar configuração

**Seu prompt:**
```
LITE: Mude o timeout de API de 10s para 30s no api_config.dart.
```

### Exemplo 4: Corrigir tipografia

**Seu prompt:**
```
LITE: O botão de "Cadastrarr" tem um R a mais. Corrija para "Cadastrar" 
em lib/features/register/register_screen.dart.
```

### Exemplo 5: Bug visual simples

**Seu prompt:**
```
LITE: O card de produto está com padding assimétrico. 
Uso correto: EdgeInsets.all(16). Arquivo: product_card.dart.
```

> 💡 Note que neste caso o UI/UX Specialist pode ser acionado opcionalmente, fazendo uma verificação rápida de design token compliance.

---

## Prompts Prontos para LITE

### Template genérico:
```
LITE: [ação] em [arquivo/localização].
[Detalhes adicionais se necessário]
```

### Template com contexto:
```
LITE: Corrija [problema] no arquivo [caminho/arquivo.dart].
Atualmente: [comportamento atual]
Esperado: [comportamento esperado]
```

### Template multi-arquivo (ainda LITE):
```
LITE: Renomeie [X] para [Y] nos seguintes arquivos:
- lib/services/auth_service.dart
- lib/models/user_model.dart
Mantenha as importações funcionando.
```

---

## Quando NÃO é LITE

Se o seu pedido envolve qualquer um destes itens, **não é LITE**:
- ❌ Criar algo novo (arquivo, classe, feature) → STANDARD
- ❌ Mudar arquitetura → DEEP
- ❌ Integrar com API externa → STANDARD
- ❌ Dados financeiros/saúde → CRITICAL
- ❌ Múltiplos módulos afetados → STANDARD ou DEEP

---

## Próximo

→ [05-FLUXO-INTERMEDIARIO.md](05-FLUXO-INTERMEDIARIO.md) — Features, CRUD, integrações
