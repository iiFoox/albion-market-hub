# 06 — Fluxo Avançado (DEEP)

> **Nível:** 🟠 Avançado  
> **Complexidade:** DEEP  
> **Agentes ativos:** 8-10 (todos participam)  
> **Quando usar:** Mudança arquitetural, migração, performance, auth, real-time

---

## Pipeline DEEP — Todos os Agentes no Máximo

```
Orchestrator (DEEP)
  → Researcher: pesquisa profunda + risk analysis
  → Planner: plano faseado + rollback strategy
  → Builder: implementação + red-team do próprio código
  → UI/UX Specialist: design review completo
  → Platform Guardian: verificação completa cross-platform
  → Validator: security audit + adversarial testing
  → Documentation: ADR + API docs + changelog
  → Project Manager: telemetria + evolução
  → Delivery: commit + minor version bump
```

---

## Exemplo: Implementar Sistema de Autenticação Completo

### Seu prompt:
```markdown
DEEP: Implemente autenticação completa no app Flutter:

1. Login com email/senha
2. Registro com validação
3. Recuperação de senha (forgot password)
4. JWT com refresh token
5. Auto-login (token persistido)
6. Logout (limpar tokens e sessão)
7. Proteção de rotas (redirect para login se não autenticado)
8. Biometric login (fingerprint/face — mobile only)

API backend já existe:
- POST /auth/login → { accessToken, refreshToken }
- POST /auth/register → { user }
- POST /auth/forgot-password → { message }
- POST /auth/refresh → { accessToken }

Plataformas: Android + Windows + Web
```

### Chain-of-Thought do Researcher:
```
PENSANDO:

1. Que tipo de autenticação estamos implementando?
   → JWT com refresh token. Padrão bem estabelecido.

2. Quais são os riscos?
   → Token storage: precisa ser seguro (não localStorage puro no web)
   → Refresh token rotation: server precisa invalidar tokens antigos
   → Biometric: só funciona em mobile — precisa fallback em desktop/web
   → CORS: web vai ter issues se API não estiver configurada

3. Quais packages são necessários?
   → dio (HTTP) — cross-platform ✅
   → flutter_secure_storage — Android ✅, iOS ✅, Windows ✅, Web ⚠️ (usa localStorage)
   → local_auth (biometric) — Android ✅, iOS ✅, Windows ❌, Web ❌
   → go_router (proteção de rotas) — cross-platform ✅

4. Qual arquitetura?
   → AuthRepository (interface) + AuthRepositoryImpl
   → TokenService (gerencia JWT, refresh, storage)
   → AuthNotifier/BLoC (estado global de auth)
   → RouteGuard (redirect para login)

5. Riscos de segurança (Validator vai auditar):
   → Token em memória (não em variável global)
   → Refresh token com fingerprint do device
   → Limpar tokens no logout (inclusive em secure storage)
   → SSL pinning (considerar para produção)

CONCLUSÃO: Complexidade DEEP confirmada. Precisa de plan faseado.
```

### Plano Faseado do Planner:
```
FASE 1 (Foundation) — Implementar sem UI:
├── TokenService (armazenamento seguro, refresh logic)
├── AuthRepository (interface + implementação)
├── ApiInterceptor (adiciona JWT, faz refresh automático)
└── Testes unitários de toda a camada

FASE 2 (UI — Auth Screens):
├── LoginScreen + LoginViewModel
├── RegisterScreen + RegisterViewModel
├── ForgotPasswordScreen + ViewModel
└── Design review com UI/UX Specialist

FASE 3 (Route Protection):
├── AuthNotifier (estado global)
├── GoRouter redirect guard
├── SplashScreen (verifica token ao abrir app)
└── Auto-login flow

FASE 4 (Biometric — Mobile Only):
├── BiometricService (com conditional import)
├── Fallback para pin/password em desktop
├── Platform Guardian verifica compatibilidade
└── Settings toggle para ativar/desativar

FASE 5 (Security Hardening):
├── Validator security audit
├── Token rotation verification
├── Secure storage audit
├── Platform-specific security review

ROLLBACK STRATEGY:
- Cada fase é independente
- Se fase 4 falhar → auth funciona sem biometric
- Branch separado até aprovação
```

---

## Mais Exemplos DEEP

### Migração de Arquitetura:
```markdown
DEEP: Migre o app de arquitetura monolítica para Clean Architecture:

Estado atual:
- Tudo em lib/ sem separação de camadas
- Lógica de negócio misturada com UI
- API calls direto nos widgets

Estado desejado:
- Separação: data / domain / presentation
- Repository pattern com interfaces
- UseCases para lógica de negócio
- ViewModels/Controllers separados

Regras:
- NÃO quebrar funcionalidade existente
- Migrar módulo por módulo
- Manter testes passando a cada módulo migrado
```

### Implementar Offline-First:
```markdown
DEEP: Implemente suporte offline-first no app:

1. Cache local com drift (SQLite cross-platform)
2. Sync queue: operações offline são enfileiradas
3. Sync automático quando volta a ter internet
4. Conflict resolution: server wins por padrão
5. Indicador visual de status online/offline
6. Funciona em: Android, Windows, Web

Preciso de plano faseado com rollback strategy.
```

---

## Próximo

→ [07-FLUXO-CRITICO.md](07-FLUXO-CRITICO.md) — Produção, financeiro, compliance
