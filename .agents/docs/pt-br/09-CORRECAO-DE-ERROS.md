# 09 — Correção de Erros e Debug

> **Nível:** 🟡 Intermediário  
> **Quando usar:** Bug reports, erros de compilação, comportamentos inesperados, crashes

---

## Tipos de Erro e Como Abordar

| Tipo de Erro | Nível | Abordagem |
|-------------|-------|-----------|
| Typo, null pointer simples | LITE | Direto: Builder corrige |
| Bug com investigação | STANDARD | Researcher analisa → Builder corrige |
| Bug afetando múltiplos módulos | DEEP | Researcher + Planner + Builder |
| Bug em produção | CRITICAL | Todos os agentes, rollback ready |
| Erro de compilação | LITE | Builder resolve dependência |
| Performance degradada | DEEP | Researcher profila → Planner planeja → Builder otimiza |

---

## Template: Bug Report para o Framework

### Bug simples (LITE):
```
LITE: Bug — [descrição curta]
Arquivo: [caminho/arquivo.dart]
Linha: [número ou região]
Comportamento atual: [o que acontece]
Comportamento esperado: [o que deveria acontecer]
```

### Bug com investigação (STANDARD):
```
STANDARD: Bug — [descrição]

Sintomas:
- [sintoma 1]
- [sintoma 2]

Quando acontece:
- [condição de disparo]

Quando NÃO acontece:
- [condição onde funciona]

Erros no console:
```
[cole o erro aqui]
```

Suspeita: [sua hipótese, se tiver]
```

### Bug complexo ou intermitente (DEEP):
```
DEEP: Bug intermitente — [descrição]

Contexto:
- Plataforma: [Android/Windows/Web]
- Versão do Flutter: [versão]
- Frequência: [sempre/às vezes/raro]
- Acontece depois de: [ação específica]

Passos para reproduzir:
1. [passo 1]
2. [passo 2]
3. [resultado inesperado]

Stack trace:
```
[cole o stack trace]
```

Já tentei:
- [tentativa 1] → não resolveu porque [motivo]
- [tentativa 2] → piorou porque [motivo]

Quero:
- Root cause analysis (5 Whys do Researcher)
- Fix plan faseado (Planner)
- Implementação com testes de regressão (Builder + Validator)
```

---

## Framework de Debug: 5 Whys (Researcher)

Para bugs complexos, o Researcher aplica o método "5 Whys":

```
BUG: App crasha ao abrir a tela de produtos no Windows

Why 1: Por que crasha?
→ NullPointerException no product_list_screen.dart:89

Why 2: Por que dá null?
→ A variável productList.value retorna null antes dos dados carregarem

Why 3: Por que os dados não carregaram?
→ O fetch da API falha silenciosamente no Windows

Why 4: Por que falha silenciosamente?
→ O error handler usa dart:io HttpException, que não é a mesma classe que dio lança

Why 5: Por que usa dart:io HttpException?
→ O try/catch foi escrito pra mobile e nunca foi testado em desktop

ROOT CAUSE: Tratamento de erro platform-specific não coberto.
FIX: Usar tipos de exceção do dio (DioException) em vez de dart:io.
PREVENTION: Platform Guardian deveria ter flaggado o uso de dart:io.
```

---

## Fix Loop: Builder → Validator → Builder

Quando o Validator rejeita um fix:

```
CICLO 1:
Builder implementa fix → Validator encontra regressão
                       → Volta para Builder com instruções específicas

CICLO 2:
Builder corrige a regressão → Validator verifica novamente
                             → Encontra edge case
                             → Volta para Builder

CICLO 3 (máximo):
Builder corrige edge case → Validator aprova
                          → Delivery commita

REGRA: Máximo 3 ciclos. Se não resolver em 3:
→ Escalate para Researcher (investigação mais profunda)
→ Ou escalar nível (LITE → STANDARD, STANDARD → DEEP)
```

---

## Prompts Prontos para Debug

### Erro de compilação:
```
LITE: Erro de compilação:
```
[cole o erro completo]
```
```

### App crasha:
```
STANDARD: App crasha em [plataforma] ao [ação].
Stack trace:
```
[stack trace]
```
Preciso de root cause e fix.
```

### Performance:
```
DEEP: A tela [nome] está lenta (lag no scroll).
- Lista com ~100 itens
- Cada item tem imagem + texto
- FPS cai para ~30 durante scroll rápido
Preciso de profiling e otimização.
```

### Bug que não consigo entender:
```
DEEP: Ajuda! Bug que não entendo:
[descreva tudo que sabe]
[cole todos os erros]
[diga o que já tentou]
Use 5 Whys para encontrar a causa raiz.
```

---

## Próximo

→ [10-BACKUP-COMMITS-VERSIONAMENTO.md](10-BACKUP-COMMITS-VERSIONAMENTO.md) — Git, commits, versionamento
