# Project Onboarding Wizard

> **Purpose:** Configure HEPHAESTUS for a new project in a single conversation.  
> **Usage:** Copy the prompt below into the first chat of a new project.  
> **Result:** Profile, checkpoint, seeds, and memory structure — ready to work.

---

## Onboarding Prompt (COPY THIS)

```
Você é o sistema HEPHAESTUS. Este é o PRIMEIRO CHAT deste projeto — configure o framework.

Leia: .agents/AGENTS.md

Em seguida, execute o Onboarding Wizard fazendo estas perguntas UMA POR VEZ:

1. PROJETO: Qual o nome e uma descrição curta do projeto?
2. STACK: Quais tecnologias principais? (linguagens, frameworks, banco de dados)
3. PLATAFORMAS: Quais plataformas alvo? (Web, Android, iOS, Windows, Linux, etc.)
4. MATURITY: Qual o perfil de maturidade? (startup | pme | enterprise | regulated | legacy)
5. REGRAS: Existem regras específicas que eu SEMPRE devo seguir? (ex: "nunca usar pacote X", "sempre validar no dispositivo real")
6. ESTRUTURA: Qual a estrutura de diretórios do projeto? (me mostre ou eu analiso)

Após coletar as respostas, GERE AUTOMATICAMENTE:

A) .agents/profiles/<projeto>/<projeto>-profile.md
   - Com nome, stack, plataformas, regras, memory authority apontando para .agents/memory/
   - Session Closing Protocol embutido

B) .agents/memory/context-db/<projeto>-project-state.md
   - Estado inicial do projeto

C) .agents/memory/context-db/<projeto>-session-checkpoint.md
   - Checkpoint da sessão de onboarding

D) .agents/memory/evolution-log/<projeto>-genesis.md
   - Registro de criação do projeto no framework

E) Atualizar .agents/memory/MEMORY-INDEX.md
   - Adicionar os novos entries

F) Atualizar .agents/config/framework.yaml
   - Adicionar o novo profile em active_profiles

Ao terminar, apresente um resumo do que foi configurado e pergunte:
"O framework está configurado. Qual é a primeira tarefa?"
```

---

## What Gets Generated

```
.agents/
├── profiles/
│   └── <projeto>/
│       └── <projeto>-profile.md          ← Project rules, memory authority, stack
├── memory/
│   ├── context-db/
│   │   ├── <projeto>-project-state.md    ← Initial project state
│   │   └── <projeto>-session-checkpoint.md ← First checkpoint
│   ├── evolution-log/
│   │   └── <projeto>-genesis.md          ← Creation milestone
│   └── MEMORY-INDEX.md                   ← Updated with new entries
└── config/
    └── framework.yaml                    ← Updated with new profile
```

---

## Profile Template (what the wizard generates)

```markdown
# Project Profile — [Project Name]

> **Project:** [name]
> **Stack:** [technologies]
> **Platforms:** [target platforms]
> **Maturity:** [startup | pme | enterprise | regulated | legacy]
> **Created:** [date]
> **Framework:** HEPHAESTUS v4.0.2+

---

## Project Identity
- **Name:** [name]
- **Description:** [description]
- **Root:** [path]

## Technology Stack
- **Languages:** [list]
- **Frameworks:** [list]
- **Database:** [list]
- **Infrastructure:** [list]

## Target Platforms
- [Platform 1]
- [Platform 2]

## Source Of Truth Rules

### Repository Rules
- Treat `[path]` as the project root.
- Apply project-specific rules to the entire repository.
- Preserve existing project patterns unless explicitly requested.

### Memory Authority — HEPHAESTUS PRIMARY
- **PRIMARY (WRITE):** `.agents/memory/` — ALL new learnings go HERE
- **Git** remains the source of truth for code history.

### Session Closing Protocol (MANDATORY)
Before ending ANY chat session:
1. **Update** `.agents/memory/context-db/[project]-session-checkpoint.md`
2. **Write** validated learnings to `.agents/memory/learning-store/`
3. **Record** architecture decisions in `.agents/memory/knowledge-graph/`
4. **Log** milestones in `.agents/memory/evolution-log/`

## Project-Specific Rules
[Rules collected from wizard question 5]

## Active Agents
[Auto-selected based on stack/platforms — e.g., ui-ux-specialist for Flutter]
```

---

## Quick Onboarding (for experienced users)

```
HEPHAESTUS — primeiro chat. Projeto: [nome], Stack: [tech], Plataformas: [lista].
Leia .agents/AGENTS.md e gere o profile, checkpoint e genesis automaticamente.
Regras especiais: [suas regras ou "nenhuma"].
Primeira tarefa: [o que fazer].
```

---

## Notes
- The wizard generates ONLY framework files — never touches project code
- If a profile for this project already exists, the wizard updates instead of overwriting
- The wizard auto-selects agents based on stack (e.g., Flutter → activates ui-ux-specialist + platform-guardian)
- Maturity profile determines quality gates and depth of analysis
