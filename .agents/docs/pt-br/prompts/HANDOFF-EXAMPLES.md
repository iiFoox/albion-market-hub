# Handoff Examples — Perfeitos vs. Rejeitados

> **Propósito:** Exemplos de transferência de trabalho entre agentes  
> **Mostra:** Handoffs bem-sucedidos e handoffs que foram rejeitados com motivo

---

## O que é um Handoff

Handoff é quando um agente termina seu trabalho e transfere o resultado para o próximo agente no pipeline. O agente receptor pode **aceitar** ou **rejeitar** o handoff.

```
Agent A → [Handoff Package] → Agent B
                                ↓
                          ACCEPT or REJECT
```

---

## HANDOFF 1: Pesquisador → Planejador ✅ ACEITO

### Contexto: Feature "Favoritos" no app de produtos

```markdown
## HANDOFF: researcher → planner
type: COMPLETION
priority: NORMAL
status: COMPLETE

### O que o Researcher entregou:
CONTEXT MAP:
- Product model: exists (lib/data/models/product_model.dart)
- User model: exists (lib/data/models/user_model.dart)
- API endpoints: GET /favorites, POST /favorites, DELETE /favorites/:id
- Database: Supabase (PostgreSQL), table 'favorites' already exists
- Current navigation: GoRouter with bottom nav (3 tabs)
- Auth: JWT implemented, user ID available via AuthNotifier

RISK ASSESSMENT:
- Low risk: API already exists, just need client integration
- Medium: offline support may be needed (not in requirement)
- Low: no platform-specific features involved

RECOMMENDATIONS:
- Use existing ProductRepository, extend with favorites methods
- Add FavoritesTab to bottom nav (4th tab)
- Consider optimistic updates for better UX
```

### Planejador avalia:
```
CHAIN-OF-THOUGHT:
1. Context map is complete — model, API, DB all documented ✅
2. Risk assessment is reasonable — low to medium ✅
3. Recommendations are actionable — I can plan from this ✅
4. Missing nothing critical for planning
5. → ACEITO
```

```yaml
handoff_response:
  accepted: true
  agent: planner
  message: "Context sufficient for planning. Proceeding with task decomposition."
```

---

## HANDOFF 2: Pesquisador → Planejador ❌ REJEITADO

### Contexto: Feature "Notificações Push"

```markdown
## HANDOFF: researcher → planner
type: COMPLETION
status: COMPLETE

### O que o Researcher entregou:
CONTEXT MAP:
- Notifications: not implemented yet
- Firebase messaging exists in pubspec but not configured
- iOS Push certificates: unknown status
- Android: firebase-messaging in build.gradle

RECOMMENDATIONS:
- Use firebase_messaging package
```

### Planejador avalia:
```
CHAIN-OF-THOUGHT:
1. Context map is INCOMPLETE:
   ❌ Firebase project exists? Not documented
   ❌ google-services.json configured? Not checked
   ❌ iOS certificates status "unknown" — need answer
   ❌ Backend push sending infrastructure? Not researched
   ❌ What notification types are needed? Not clarified
2. Risk assessment: MISSING entirely
3. Recommendations: Too vague — "use firebase_messaging" is not enough
4. I CANNOT plan without knowing the backend infrastructure
5. → REJEITADO — preciso de mais contexto
```

```yaml
handoff_response:
  accepted: false
  agent: planner
  reason: "Insufficient context. Missing: (1) Firebase project config status, (2) iOS certificate status, (3) Backend push infrastructure, (4) Notification types required. Please complete research."
  required_from_sender:
    - "Firebase project configuration status for all platforms"
    - "iOS push certificate and provisioning profile status"
    - "Backend infrastructure for sending notifications"
    - "Types of notifications: silent, alert, data, or combination"
```

**O que acontece:** Researcher recebe o reject, pesquisa os itens faltantes, e envia novo handoff.

---

## HANDOFF 3: Builder → UI/UX Specialist ✅ ACEITO

### Contexto: Tela de login implementada

```markdown
## HANDOFF: builder → ui-ux-specialist
type: COMPLETION
status: READY_FOR_REVIEW

### Arquivos criados/modificados:
1. lib/features/auth/presentation/screens/login_screen.dart (NEW)
2. lib/features/auth/presentation/viewmodels/login_viewmodel.dart (NEW)  
3. lib/features/auth/presentation/widgets/social_login_button.dart (NEW)
4. lib/core/router/app_router.dart (MODIFIED — added /login route)

### Decisões de implementação:
- Used Form with GlobalKey<FormState> for validation
- Email regex validation + empty check
- Password min length 8 + empty check
- Loading state with circular progress on button
- Error state with SnackBar
- Social login buttons (Google, Apple) — visual only, not functional yet

### Self-assessment:
- Followed design tokens from ui-standards.md ✅
- Added Semantics labels ✅
- Not sure about responsive behavior on tablet ⚠️
```

### UI/UX Specialist avalia:
```
CHAIN-OF-THOUGHT:
1. Código entregue com 4 arquivos — escopo claro ✅
2. Self-assessment honesto (Builder sinalizou dúvida em responsive) ✅
3. Claims seguiu design tokens — vou verificar no review ✅
4. Tem informação suficiente para fazer design review
5. → ACEITO para review
```

---

## HANDOFF 4: Builder → UI/UX Specialist ❌ REJEITADO

### Contexto: Componente de tabela de dados

```markdown
## HANDOFF: builder → ui-ux-specialist
type: COMPLETION
status: READY_FOR_REVIEW

### Arquivos criados:
1. lib/shared/widgets/data_table_widget.dart (NEW)

### Notas:
- Created basic DataTable for product list
- Works on mobile
```

### UI/UX Specialist avalia:
```
CHAIN-OF-THOUGHT:
1. Só 1 arquivo listado — onde está o demo/usage?
2. "Works on mobile" — e tablet? Desktop? Web?
3. Nenhuma menção a design tokens
4. Nenhuma menção a estados (loading, error, empty)
5. Nenhuma menção a acessibilidade
6. Entrega incompleta — preciso de mais contexto para review
7. → REJEITADO — entrega não está pronta para review
```

```yaml
handoff_response:
  accepted: false
  agent: ui-ux-specialist
  reason: "Delivery incomplete for design review. Missing: (1) Responsive behavior description (tablet/desktop), (2) Design token usage confirmation, (3) State handling (loading/error/empty), (4) Accessibility implementation notes."
  required_from_sender:
    - "Add responsive behavior for all breakpoints"
    - "Confirm design token usage or flag deviations"
    - "Implement loading, error, and empty states"
    - "Add Semantics labels to interactive elements"
    - "Re-submit when above items are addressed"
```

---

## HANDOFF 5: UI/UX Specialist → Platform Guardian ✅ ACEITO

```markdown
## HANDOFF: ui-ux-specialist → platform-guardian
type: COMPLETION
status: UI_REVIEWED

### Design Review Result: APPROVED
- All design tokens correctly used
- Responsive verified: mobile ✅, tablet ✅, desktop ✅
- Accessibility: all labels present, contrast 4.5:1+
- States: all covered

### Platform concerns identified during review:
- Uses CachedNetworkImage — needs CORS check for web
- Uses Hero animation — verify on web renderer
- Adaptive navigation (bottom nav on mobile, rail on tablet)

### Files to check:
[list of files]
```

### Platform Guardian avalia:
```
CHAIN-OF-THOUGHT:
1. UI/UX already approved — visual quality confirmed ✅
2. Platform concerns pre-identified — useful starting point ✅
3. Files listed clearly — can start compatibility check ✅
4. → ACEITO
```

---

## Padrões de Handoff

### O que faz um handoff ser ACEITO:
| Fator | Exemplo |
|-------|---------|
| Contexto suficiente | "Modelo existe em X, API em Y, navegação em Z" |
| Self-assessment honesto | "Não tenho certeza sobre responsive no tablet" |
| Arquivos listados | "Criados: A, B, C. Modificados: D, E" |
| Decisões documentadas | "Usei BLoC porque já temos no projeto" |

### O que faz um handoff ser REJEITADO:
| Fator | Exemplo |
|-------|---------|
| Contexto insuficiente | "Não sei o status do Firebase" |
| Entrega incompleta | "Funciona no mobile" (e as outras plataformas?) |
| Sem self-assessment | Entregar sem dizer se seguiu padrões |
| Escopo indefinido | "Componente de tabela" (sem specs) |
