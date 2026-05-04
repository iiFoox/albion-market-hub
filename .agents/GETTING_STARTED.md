# GETTING STARTED — HEPHAESTUS Agent Framework

> **This guide is written in Portuguese (pt-BR)** because it is user-facing.  
> All technical framework files remain in English.

---

## 📋 Índice

1. [Pré-requisitos](#1-pré-requisitos)
2. [Instalação do Framework em um Novo Projeto](#2-instalação-do-framework-em-um-novo-projeto)
3. [Verificação da Instalação](#3-verificação-da-instalação)
4. [Inicialização do Projeto (Primeira Chamada)](#4-inicialização-do-projeto-primeira-chamada)
5. [Prompt de Início de Projeto (Template)](#5-prompt-de-início-de-projeto-template)
6. [Fluxo Completo: Do Zero à Primeira Feature](#6-fluxo-completo-do-zero-à-primeira-feature)
7. [Referência Rápida de Comandos](#7-referência-rápida-de-comandos)
8. [FAQ](#8-faq)

---

## 1. Pré-requisitos

- **IDE/Editor:** VS Code, Cursor, ou qualquer editor compatível com AI coding assistants
- **AI Assistant:** Gemini CLI, Cursor AI, Copilot, ou qualquer assistente que leia arquivos `.md` do workspace
- **Git:** Instalado e configurado
- **Arquivo:** `HEPHAESTUS-Framework-v5.2.0.zip`

---

## 2. Instalação do Framework em um Novo Projeto

### Passo 1: Crie a pasta do novo projeto

```powershell
# Windows (PowerShell)
mkdir D:\PROJETOS\MeuNovoProjeto
cd D:\PROJETOS\MeuNovoProjeto
```

```bash
# Linux/Mac
mkdir -p ~/projetos/meu-novo-projeto
cd ~/projetos/meu-novo-projeto
```

### Passo 2: Inicialize o Git (se ainda não existe)

```powershell
git init
```

### Passo 3: Copie o ZIP do framework para a raiz do projeto

```powershell
# Windows — copie o zip para a raiz do projeto
Copy-Item "CAMINHO\HEPHAESTUS-Framework-v5.2.0.zip" -Destination "."
```

### Passo 4: Extraia o ZIP na raiz do projeto

```powershell
# Windows (PowerShell)
Expand-Archive -Path ".\HEPHAESTUS-Framework-v5.2.0.zip" -DestinationPath "." -Force
```

```bash
# Linux/Mac
unzip HEPHAESTUS-Framework-v5.2.0.zip -d .
```

> **⚠️ IMPORTANTE:** Após extrair, a estrutura deve ficar assim:
> ```
> MeuNovoProjeto/
> ├── .agents/          ← ✅ Framework extraído aqui
> │   ├── AGENTS.md
> │   ├── GETTING_STARTED.md
> │   ├── config/
> │   ├── agents/
> │   ├── memory/
> │   ├── telemetry/
> │   ├── protocols/
> │   └── workflows/
> ├── .git/
> └── (seus arquivos do projeto virão aqui)
> ```
>
> Se ficou `.agents/.agents/` (pasta duplicada), mova o conteúdo interno um nível acima.

### Passo 5: Remova o ZIP (opcional — ele já fez seu trabalho)

```powershell
Remove-Item ".\HEPHAESTUS-Framework-v5.2.0.zip"
```

### Passo 6: Atualize o .gitignore

Crie ou atualize o `.gitignore` na raiz do projeto:

```gitignore
# OS
.DS_Store
Thumbs.db
Desktop.ini

# IDEs
.vscode/
.idea/

# Dependencies
node_modules/
dist/
build/

# Environment
.env
.env.*

# Telemetry logs (auto-generated, large)
.agents/telemetry/logs/**/*.md
!.agents/telemetry/logs/.gitkeep
```

### Passo 7: Commit inicial do framework

```powershell
git add .agents/
git add .gitignore
git commit -m "chore: add HEPHAESTUS Agent Framework v5.2.0"
```

---

## 3. Verificação da Instalação

Antes de começar, verifique que o framework está completo:

```powershell
# Conte os arquivos do framework (deve ser 114+ arquivos)
(Get-ChildItem -Path ".agents" -Recurse -File).Count
```

**Checklist de verificação:**
- [ ] `.agents/AGENTS.md` existe
- [ ] `.agents/config/framework.yaml` existe
- [ ] `.agents/config/agent-registry.yaml` existe
- [ ] `.agents/config/framework-manifest.yaml` existe
- [ ] `.agents/memory/MEMORY.md` existe
- [ ] `.agents/telemetry/TELEMETRY.md` existe
- [ ] 10 pastas em `.agents/agents/`
- [ ] 13 arquivos em `.agents/protocols/`
- [ ] 9 arquivos em `.agents/workflows/`
- [ ] 4 entries bootstrap em `.agents/memory/`
- [ ] Guias de uso diario em `.agents/docs/pt-br/daily-prompts/`

---

## 4. Inicialização do Projeto (Primeira Chamada)

### Como o Framework se Ativa

O framework é ativado **automaticamente** quando o AI assistant lê os arquivos do workspace.
A maioria dos assistentes AI (Gemini CLI, Cursor, etc.) lê o diretório `.agents/` e reconhece:

1. `AGENTS.md` como o arquivo raiz de instruções do agente
2. Os `AGENT.md` dentro de cada pasta de agente como definições de sub-agentes
3. Os `workflows/*.md` como workflows disponíveis

**NÃO é necessário instalar dependências, rodar scripts, ou configurar nada.** O framework é 100% baseado em arquivos Markdown/YAML que instruem o AI assistant.

### A Primeira Interação

Quando você abrir o projeto no seu editor e iniciar uma conversa com o AI assistant, **a primeira mensagem deve ser o prompt de inicialização do projeto** (veja a seção 5 abaixo).

Este prompt vai:
1. ✅ Acionar o **Orchestrator** para classificar complexidade e executar triage
2. ✅ Disparar o **Universal Triage** de todos os 8 agentes
3. ✅ Ativar o **Researcher** para mapear o contexto tecnológico
4. ✅ Ativar o **Planner** para criar o plano de desenvolvimento
5. ✅ Ativar o **Documentation** para documentar as decisões iniciais
6. ✅ Ativar o **Project Manager** para registrar o início do projeto
7. ✅ Ativar o **Delivery Agent** para bootstrap do repositório Git/GitHub

---

## 5. Prompt de Início de Projeto (Template)

### 🔑 O PROMPT MÁGICO — Copie e Use

Copie o template abaixo, preencha as partes entre `[colchetes]`, e envie como sua **primeira mensagem** ao AI assistant:

---

```
Estou iniciando um novo projeto e preciso que você siga rigorosamente o 
framework HEPHAESTUS Agent Framework definido em .agents/AGENTS.md.

Leia o arquivo .agents/AGENTS.md por completo antes de responder.

## Premissa do Projeto

**Nome do Projeto:** [Nome do seu projeto]

**Descrição:** 
[Descreva em 2-5 frases o que o projeto faz, para quem é, e qual problema resolve]

**Tipo de Aplicação:** 
[Web App | Mobile App | Desktop App | API/Backend | CLI Tool | Full-Stack | Outro]

**Plataformas Alvo:** 
[Web | iOS | Android | Windows | Linux | macOS | Multi-plataforma]

**Tecnologias Preferidas (se houver):**
[Liste tecnologias que você quer usar, ou escreva "a definir pelo framework"]

**Banco de Dados (se houver preferência):**
[PostgreSQL | MySQL | MongoDB | SQLite | Redis | "a definir pelo framework"]

**Requisitos Principais:**
1. [Requisito 1]
2. [Requisito 2]  
3. [Requisito 3]
[Adicione quantos precisar]

**Requisitos Não-Funcionais:**
- Performance: [requisitos se houver]
- Segurança: [requisitos se houver]
- Escalabilidade: [requisitos se houver]
- Acessibilidade: [requisitos se houver]

**Público Alvo:** 
[Quem vai usar o sistema]

**Referências/Inspirações (se houver):**
[Links ou nomes de produtos similares]

## Instrução de Execução

Execute o workflow /full-pipeline seguindo as diretrizes do .agents/AGENTS.md:

1. **Orchestrator:** Analise esta requisição e coordene o pipeline completo
2. **Self-Evaluation:** Todos os agentes devem se auto-avaliar
3. **Researcher:** Pesquise o contexto tecnológico e mapeie riscos
4. **Planner:** Crie o plano de desenvolvimento completo do projeto com:
   - Arquitetura proposta
   - Estrutura de pastas
   - Stack tecnológica recomendada
   - Fases de desenvolvimento
   - Critérios de aceitação
5. **Documentation:** Documente todas as decisões iniciais
6. **Project Manager:** Registre o início do projeto na memória

Aguardo o plano completo antes de iniciar a implementação.
```

---

### 📝 Exemplo Preenchido

```
Estou iniciando um novo projeto e preciso que você siga rigorosamente o 
framework HEPHAESTUS Agent Framework definido em .agents/AGENTS.md.

Leia o arquivo .agents/AGENTS.md por completo antes de responder.

## Premissa do Projeto

**Nome do Projeto:** TaskFlow

**Descrição:** 
Um aplicativo de gerenciamento de tarefas e projetos para equipes pequenas.
Permite criar projetos, adicionar tarefas com prioridade e deadline, 
atribuir responsáveis, e visualizar o progresso em um dashboard Kanban.

**Tipo de Aplicação:** Full-Stack (Web App com possível Mobile futuro)

**Plataformas Alvo:** Web (responsivo), futuramente iOS e Android

**Tecnologias Preferidas:**
- Frontend: Next.js com TypeScript
- Backend: a definir pelo framework
- Styling: TailwindCSS

**Banco de Dados:** PostgreSQL

**Requisitos Principais:**
1. Autenticação de usuários (email + OAuth Google)
2. CRUD de projetos e tarefas
3. Dashboard Kanban com drag-and-drop
4. Notificações em tempo real
5. Filtros e busca avançada
6. Convite de membros por email

**Requisitos Não-Funcionais:**
- Performance: carregamento < 2s
- Segurança: OWASP compliance
- Escalabilidade: suportar 10k usuários simultâneos
- Acessibilidade: WCAG 2.1 AA

**Público Alvo:** 
Times de 3-20 pessoas em startups e pequenas empresas

**Referências/Inspirações:**
Trello, Linear, Notion (board view)

## Instrução de Execução

Execute o workflow /full-pipeline seguindo as diretrizes do .agents/AGENTS.md:

1. **Orchestrator:** Analise esta requisição e coordene o pipeline completo
2. **Self-Evaluation:** Todos os agentes devem se auto-avaliar
3. **Researcher:** Pesquise o contexto tecnológico e mapeie riscos
4. **Planner:** Crie o plano de desenvolvimento completo do projeto com:
   - Arquitetura proposta
   - Estrutura de pastas
   - Stack tecnológica recomendada
   - Fases de desenvolvimento
   - Critérios de aceitação
5. **Documentation:** Documente todas as decisões iniciais
6. **Project Manager:** Registre o início do projeto na memória

Aguardo o plano completo antes de iniciar a implementação.
```

---

## 6. Fluxo Completo: Do Zero à Primeira Feature

```
📁 Criar pasta do projeto
    │
    ▼
📦 Extrair framework (.agents/)
    │
    ▼
🔧 git init + commit inicial
    │
    ▼
💬 Enviar PROMPT DE INÍCIO (Seção 5)
    │
    ▼
🧠 Orchestrator analisa e monta pipeline
    │
    ▼
🔬 Researcher mapeia contexto e tecnologias
    │
    ▼
📋 Planner cria plano completo do projeto     ◄── VOCÊ ESTÁ AQUI
    │                                               Revise o plano
    ▼                                               Aprove ou peça ajustes
✅ Você aprova o plano
    │
    ▼
💬 "Aprovo o plano. Comece pela Fase 1, Step 1."
    │
    ▼
🔨 Builder implementa o código
    │
    ▼
✅ Validator testa e valida
    │
    ▼
📖 Documentation documenta
    │
    ▼
📊 Project Manager registra telemetria
    │
    ▼
🎉 Primeira feature entregue!
    │
    ▼
💬 "Próximo step do plano."  (repita até completar)
```

---

## 7. Referência Rápida de Comandos

### Iniciar um projeto novo
```
Leia .agents/AGENTS.md e execute /full-pipeline para: [sua premissa]
```

### Pedir uma feature
```
Preciso implementar [descreva a feature]. Execute /full-pipeline.
```

### Quick fix (bug simples)
```
Execute /quick-fix: [descreva o problema]
```

### Pesquisa tecnológica
```
Execute /research-only: [o que precisa pesquisar]
```

### Revisão de código
```
Execute /review-only: [o que precisa revisar]
```

### Ver estado do projeto
```
Consulte a memória do projeto em .agents/memory/context-db/ e me dê um resumo.
```

### Ver evolução do framework
```
Execute uma avaliação de evolução do framework conforme .agents/protocols/evolution-protocol.md
```

### Forçar consulta a todos os agentes
```
Quero que TODOS os agentes façam self-evaluation para: [sua questão]
```

---

## 8. FAQ

### Q: E se o AI assistant não ler o AGENTS.md automaticamente?
**R:** Comece sua mensagem com: `Leia o arquivo .agents/AGENTS.md por completo antes de responder.`

### Q: Preciso instalar algo?
**R:** Não. O framework é 100% baseado em arquivos de texto (Markdown/YAML). Ele instrui o AI assistant, não executa código.

### Q: E se eu quiser adicionar um novo agente?
**R:** Crie uma nova pasta em `.agents/agents/[nome-do-agente]/` com `AGENT.md`, `capabilities.yaml`, e a pasta `prompts/`. Depois registre no `agent-registry.yaml`.

### Q: O framework funciona com qualquer AI?
**R:** Sim, desde que o AI assistant leia arquivos do workspace. Funciona melhor com assistentes que suportam context de projeto (Gemini CLI, Cursor, Copilot Workspace, etc.).

### Q: E se eu quiser customizar o framework para um projeto específico?
**R:** Edite livremente os arquivos dentro de `.agents/`. As customizações mais comuns são:
- `framework.yaml` — ajustar tecnologias e plataformas prioritárias
- `agent-registry.yaml` — adicionar/remover agents
- `workflows/` — criar workflows específicos do projeto

### Q: Os bootstrap entries de memória precisam ser resetados para cada projeto novo?
**R:** Não. Os bootstrap entries são genéricos e aplicáveis a qualquer projeto. Eles vão sendo complementados com entries específicos do projeto conforme o framework é usado.

### Q: Posso usar em projetos que já existem?
**R:** Sim! Basta extrair o `.agents/` na raiz do projeto existente. Na primeira mensagem, descreva o projeto existente e peça ao Researcher para mapear o contexto atual.

---

## Dicas Importantes

> **💡 TIP 1:** Sempre espere o Planner terminar o plano COMPLETO antes de pedir para o Builder implementar. Plano incompleto = implementação ruim.

> **💡 TIP 2:** Quando aprovar o plano, peça para implementar step-by-step, não tudo de uma vez. Ex: "Implemente o Step 1 do plano."

> **💡 TIP 3:** Se o AI não seguir o framework, relembre: "Siga as diretrizes do .agents/AGENTS.md incluindo self-evaluation de todos os agentes."

> **💡 TIP 4:** Após cada feature grande, peça: "Atualize a memória do projeto em .agents/memory/ com o que aprendemos."

> **💡 TIP 5:** Periodicamente (semanalmente), peça: "Project Manager, gere um relatório de evolução do framework."
