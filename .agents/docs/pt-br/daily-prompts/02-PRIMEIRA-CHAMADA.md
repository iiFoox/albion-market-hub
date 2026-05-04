# 02 — Primeira Chamada: Inicializando o Framework no Projeto

> **Quando usar:** Primeiro chat depois de colocar o .agents/ no projeto.
> **Objetivo:** Fazer o framework reconhecer o projeto, configurar Git/GitHub, e planejar o trabalho.
> **Tempo estimado:** 15-30 minutos

---

## Fase 1: Ativação do Framework

Cole este prompt no seu primeiro chat com o assistente de IA:

```
Você é o sistema multi-agente HEPHAESTUS. Leia a pasta .agents/ deste projeto para entender sua arquitetura completa:

1. Leia .agents/GETTING_STARTED.md para a visão geral
2. Leia .agents/ROADMAP.md para o estado atual do framework
3. Leia .agents/config/framework.yaml para a configuração
4. Leia .agents/config/agent-registry.yaml para os agentes disponíveis
5. Leia .agents/protocols/ para entender os protocolos

Após ler, confirme:
- Quantos agentes você identificou
- Quantos protocolos
- Que versão do framework é esta

Depois, execute o REPOSITORY BOOTSTRAP PROTOCOL do Delivery Agent:
- Verifique se Git está instalado
- Verifique se este projeto tem repositório Git
- Verifique se tem remote configurado (GitHub)
- Se algo estiver faltando, me guie passo a passo para configurar

Não prossiga até que o repositório esteja configurado e verificado.
```

### O que vai acontecer:
1. O assistente vai ler todos os arquivos de configuração
2. Vai confirmar que identificou os 8 agentes e 10 protocolos
3. Vai executar o bootstrap de repositório do Delivery Agent
4. Se Git não estiver instalado → vai orientar instalação
5. Se não tiver repo → vai orientar `git init`
6. Se não tiver GitHub → vai orientar criação passo a passo
7. Quando tudo estiver OK → confirma "Repository Bootstrap COMPLETE ✅"

---

## Fase 2: Apresentação do Projeto

Após o bootstrap do repositório, apresente seu projeto. Use este template:

```
Agora que o framework está ativo e o repositório configurado, vou apresentar o projeto:

## Sobre o Projeto
- **Nome:** [nome do projeto]
- **Tipo:** [web app / mobile app / API / SaaS / outro]
- **Descrição:** [2-3 frases sobre o que o projeto faz]
- **Stack desejada:** [Next.js + PostgreSQL / React Native + Firebase / outro]
- **Público-alvo:** [quem vai usar]
- **Estágio:** [novo do zero / existente com código / protótipo / produção]

## Contexto Organizacional
- **Equipe:** [só eu / 2-3 devs / time maior]
- **Prazo:** [sem prazo definido / 1 mês / 3 meses]
- **Prioridade:** [qualidade / velocidade / ambos]

## Requisitos Principais
1. [requisito 1]
2. [requisito 2]
3. [requisito 3]
...

## Requisitos de Segurança/Compliance
- [Nenhum especial / PCI-DSS / HIPAA / LGPD / outro]

Com base nisso:
1. Defina o MATURITY PROFILE adequado (startup/PME/enterprise/regulated/legacy)
2. Identifique qual INDUSTRY PROFILE ativar (se aplicável)
3. Recomende a arquitetura usando o decision tree do knowledge base
4. Proponha um plano de fases inicial

Use o pipeline DEEP para esta análise.
```

### O que vai acontecer:
1. O **Researcher** vai analisar o stack e riscos do projeto
2. O **Planner** vai criar o plano de fases com critérios de aceite
3. O framework vai definir o maturity profile (startup/enterprise/etc.)
4. Se houver compliance → ativa o industry profile adequado
5. Vai recomendar arquitetura baseada nos 9 patterns da knowledge base
6. Vai entregar um plano estruturado com fases, milestones e entregas

---

## Fase 3: Salvar o Estado Inicial

Após a apresentação e planejamento:

```
Perfeito. Agora vamos salvar este estado inicial:

1. Atualize a memória do framework (.agents/memory/) com:
   - Context DB: stack escolhido, arquitetura definida, maturity profile
   - Knowledge Graph: conexões entre tecnologias do projeto
   - Learning Store: decisões iniciais tomadas
   - Evolution Log: registro de genesis do projeto

2. Execute o Delivery Agent para fazer o commit inicial:
   - Message: "chore: initialize HEPHAESTUS framework + project planning"
   - Inclua todos os arquivos do .agents/ e qualquer arquivo de projeto criado
   - Push para o repositório remoto

3. Confirme que tudo foi salvo e sincronizado.
```

---

## Checklist de Primeira Chamada

Ao final deste processo, você deve ter:

- [x] Framework lido e reconhecido pelo assistente
- [x] Git instalado e configurado
- [x] Repositório GitHub criado e conectado
- [x] Maturity profile definido
- [x] Industry profile ativado (se aplicável)
- [x] Arquitetura recomendada
- [x] Plano de fases criado
- [x] Memória inicializada
- [x] Commit inicial feito e pushed

**Próximo passo:** Vá para [03-USO-DIARIO.md](./03-USO-DIARIO.md)
