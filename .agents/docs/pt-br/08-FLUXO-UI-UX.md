# 08 — Fluxo UI/UX

> **Nível:** 🟡 Intermediário  
> **Workflow:** UI Workflow  
> **Agentes chave:** UI/UX Specialist + Builder + Platform Guardian  
> **Quando usar:** Criar telas, ajustar layout, design system, componentes, animações

---

## Pipeline UI

```
Orchestrator → UI/UX Specialist (guidance PRÉ-build)
             → Builder (implementa seguindo guidance)
             → UI/UX Specialist (review PÓS-build)
             → Platform Guardian (verifica plataformas)
             → Validator (testa)
             → Delivery (commita)
```

**Diferencial:** O UI/UX Specialist age DUAS VEZES — antes (guiando) e depois (revisando).

---

## Exemplo: Criar Design System do App

### Seu prompt:
```markdown
UI WORKFLOW: Crie o design system base do app:

1. Paleta de cores (light + dark mode)
2. Escala tipográfica (3-4 tamanhos de texto)
3. Sistema de espaçamento (8px grid)
4. Componentes base: AppButton, AppCard, AppTextField, AppAvatar
5. Tema Material Design 3

Estilo: moderno, clean, com gradientes sutis
Cores primárias: tons de azul/roxo (#6366F1 → #8B5CF6)
```

### UI/UX Specialist — PRÉ-BUILD Guidance:
```
GUIA PARA O BUILDER:

1. CORES — usar ColorScheme do Material 3:
   primary: #6366F1 (Indigo 500)
   secondary: #8B5CF6 (Violet 500)
   tertiary: #EC4899 (Pink 500)
   surface: #FAFAFA (light) / #1A1A2E (dark)
   
   Gerar com Material Theme Builder:
   → Cores tonal automáticas para light/dark

2. TIPOGRAFIA — escala Major Third (1.25):
   displayLarge: 57px / w400
   headlineMedium: 28px / w400
   titleLarge: 22px / w500
   bodyLarge: 16px / w400
   bodyMedium: 14px / w400
   labelLarge: 14px / w500

3. ESPAÇAMENTO — 8px grid:
   xs: 4px | sm: 8px | md: 16px | lg: 24px | xl: 32px

4. BORDER RADIUS — consistente:
   cards: 12px | buttons: 28px (full rounded) | chips: 8px | inputs: 8px

5. CADA COMPONENTE DEVE TER:
   - const constructor
   - Semantic label
   - Todos os estados (normal, hover, focus, pressed, disabled, loading)
   - Dark/light mode support
   - Responsive (adaptar a diferentes larguras)
```

---

## Checklist de Revisão Visual

O UI/UX Specialist usa este checklist em TODA revisão de UI:

```
□ Cores: Todas via ColorScheme/ThemeExtension (nenhum hard-code)?
□ Fontes: Todas via TextTheme (nenhum fontSize manual)?
□ Espaçamento: Segue grid de 8px?
□ Contraste: 4.5:1 texto normal, 3:1 texto grande?
□ Touch targets: ≥ 48x48dp em mobile?
□ Semantics: Labels em todos os elementos interativos?
□ Estados: loading, error, empty, disabled cobertos?
□ Dark mode: Funciona igual ao light?
□ Responsive: Mobile (360dp), Tablet (768dp), Desktop (1280dp)?
□ Overflow: Textos longos tratados (ellipsis/wrap)?
□ Animações: Suaves, com propósito, duration correto?
□ const: Constructors const onde possível?
```

---

## Prompts Prontos para UI

### Criar tela:
```
UI WORKFLOW: Crie a tela de [nome] com:
- [elemento 1]
- [elemento 2]
- [elemento N]
Seguir design tokens do ui-standards.md.
Responsive: mobile + tablet + desktop.
Estados: loading, error, empty, data.
```

### Ajustar componente:
```
LITE (UI): Ajuste o [componente] em [arquivo.dart]:
- [mudança 1]
- [mudança 2]
Usar tokens, não hard-code.
```

### Review visual:
```
Faça uma review UI/UX completa da tela [nome] em [arquivo.dart].
Verifique: tokens, responsividade, acessibilidade, estados, dark mode.
```

---

## Próximo

→ [09-CORRECAO-DE-ERROS.md](09-CORRECAO-DE-ERROS.md) — Debug e correção de erros
