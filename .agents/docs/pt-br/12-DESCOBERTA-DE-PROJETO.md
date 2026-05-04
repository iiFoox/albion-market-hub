# 12 — Descoberta de Projeto e Maturação de Requisitos

> Versao do Framework: 8.0.0
> Proposito: usar o HEPHAESTUS para amadurecer uma ideia antes da implementacao.

---

## O Que Este Modo Faz

O modo de Descoberta de Projeto transforma uma ideia inicial em uma direção de produto pronta para planejamento.

Em vez de aceitar uma descricao superficial e construir cedo demais, o HEPHAESTUS faz perguntas estruturadas, identifica contexto faltante, compara opcoes, registra decisoes e cria documentacao viva conforme o operador responde.

## Quando Usar

Use este modo quando voce estiver:

- começando um app, SaaS, plataforma, jogo, automacao, marketplace ou ferramenta interna;
- definindo um MVP;
- mudando a direcao de um projeto existente;
- inseguro sobre backend, dados, integracoes, custos, riscos legais/IP ou operacao em producao;
- preparando mais de um operador ou mais de um host de IA para trabalhar em paralelo.

## Prompt Recomendado

```text
HEPHAESTUS, ative o modo Project Discovery.

Quero amadurecer uma ideia de projeto antes da implementacao.
Faca uma pergunta por vez, questione premissas superficiais, documente decisoes,
compare opcoes com pros/contras e preserve a economia de tokens.

Comece me pedindo para descrever a historia do produto como eu imagino.
```

## O Que o HEPHAESTUS Vai Explorar

| Area | O Que Esclarece |
|---|---|
| Historia do Produto | O que o operador imagina e por que o produto deve existir |
| Problema | Dor, urgencia, workaround atual e valor |
| Usuarios | Personas, papeis, permissoes, incentivos e casos extremos |
| Jornadas | Fluxos passo a passo, caminhos alternativos e falhas |
| Regras de Negocio | Validacoes, politicas, excecoes e calculos |
| Backend | APIs, servicos, auth, jobs, armazenamento e operacao |
| Dados | Entidades, privacidade, ciclo de vida, backup, retencao e migracao |
| Integracoes | Servicos externos, pagamento, email, analytics, IA, mapas, storage |
| Custos | Inicio custo zero, limites de free tier, crescimento e lock-in |
| Legal/IP | Copyright, marcas, protecao de dados e limite de inspiracao |
| Mercado | Alternativas, diferenciacao e premissas de validacao |
| MVP | Escopo obrigatorio, escopo adiado e criterios de sucesso |
| Time/Git | Operadores, frentes paralelas, repositorio e estrategia de branch |
| Riscos | Tecnicos, legais, operacionais, financeiros, UX, mercado e entrega |

## Saida Esperada

O framework produz um Project Discovery Report com:

- historia do produto;
- problema e usuarios;
- casos de uso e jornadas;
- regras de negocio;
- premissas de backend e dados;
- integracoes;
- caminho de lancamento custo zero ou baixo custo;
- notas legais/IP;
- MVP e escopo futuro;
- estrategia de Git/workspace;
- riscos e mitigacoes;
- decisoes e perguntas abertas;
- status de prontidao para implementacao.

## Economia de Tokens

Este modo e condicional. Ele nao entra em tarefas normais de bug fix ou pequenas edicoes.

O HEPHAESTUS carrega protocolo, politica, workflow e templates de discovery apenas quando a descoberta e relevante. Em sessoes de continuidade, ele deve resumir respostas existentes em vez de recarregar todos os relatorios.

## Regra de Prontidao

Nao avance para planejamento de implementacao ate o operador confirmar a direcao do produto e as principais perguntas abertas estarem respondidas ou explicitamente aceitas como risco.











