# HEPHAESTUS New Chat Start Prompt

Use this prompt to resume framework evolution in a fresh chat without losing context.

```text
Estamos trabalhando no projeto local:
c:\Project\SuperAgentsClaudiao

Quero continuar a evolução do HEPHAESTUS Agent Framework sem recomeçar do zero.

Contexto importante:
- O framework atual está na versão 8.7.0 — Practical First Project Walkthrough.
- A comunicação comigo deve ser em português brasileiro.
- Os artefatos técnicos, instruções internas do framework, código, configs e protocolos devem continuar em inglês.
- A documentação deve existir organizada em EN e PT-BR, mantendo paridade por meio de `.agents/docs/_translation-map.yaml`.
- A prioridade permanente é evoluir sem quebrar o que já está funcional, sem inflar consumo de tokens e sem transformar ideias aspiracionais em config ativa antes de existir enforcement real.
- Sempre que uma versão for concluída, atualizar docs EN/PT-BR, release note, changelog, roadmap, manifest/configs necessários, rodar validações, gerar zip da versão e criar/atualizar evidências.

Estado atual confirmado:
- Versão ativa: 8.7.0.
- Zip gerado: `HEPHAESTUS-Framework-v8.7.0.zip`.
- CLI unificado criado em `.agents/tools/hephaestus.ps1`.
- Ações do CLI:
  - `doctor`
  - `validate`
  - `gate`
  - `package`
  - `evidence`
  - `compare`
  - `install`
  - `update`
  - `daily`
  - `bootstrap`
- Release note criada: `.agents/releases/v8.7.0.md`.
- Docs criadas:
  - `.agents/docs/en/31-PRACTICAL-FIRST-PROJECT-WALKTHROUGH.md`
  - `.agents/docs/pt-br/31-PASSO-A-PASSO-PRATICO-DO-PRIMEIRO-PROJETO.md`
- Protocolo criado:
  - `.agents/protocols/practical-first-project-walkthrough-protocol.md`
- Checker criado:
  - `.agents/tools/check-first-project-walkthrough.ps1`
- Integrações atualizadas:
  - `doctor`
  - `pre-release gate`
  - Smart Loading group `first-project-walkthrough`
  - stability baseline critical capability list
  - docs index EN/PT-BR
  - complete reference EN/PT-BR

Validações da v8.7.0:
- `check-first-project-walkthrough`: PASS=27
- `check-guided-installer`: PASS=34
- `check-operator-runbook`: PASS=38
- `check-stability-baseline`: PASS=52
- `check-unified-cli`: PASS=20
- `framework-integrity`: PASS=289
- `documentation-parity`: PASS=112
- `kernel-contract`: PASS=49
- `pre-release gate`: PASS=47, INFO=38
- gate do pacote final: PASS=36, INFO=29
- release evidence bundle: PASS, evidence=12

Resumo do que já foi implementado nas versões recentes:
- v5.x: limpeza estrutural, documentação EN/PT-BR, token economy, memória, telemetry, routing tests, parity docs, pre-release gate.
- v6.0.0: estabilização do kernel do framework.
- v6.1.0: automação segura de install/update com dry-run e backup.
- v6.2.0: simulation harness isolado.
- v6.3.0: developer execution mode em simulação.
- v6.4.0: benchmark multi-cenário.
- v6.5.0: documentação contínua e calibração master/30+ anos dos agentes.
- v6.6.0: Project Discovery and Requirements Maturation.
- v6.7.0: Real Project Adapter.
- v6.8.0: Developer Execution on Real Local Project.
- v6.9.0: Benchmark Expansion.
- v7.0.0: Real Project Execution Hardening.
- v7.1.0: Command Allowlist and Quality Gate Runner.
- v7.2.0: Real Project Apply Scenario.
- v7.3.0: Documentation Agent Runtime Loop.
- v7.4.0: Release Evidence Bundle.
- v7.5.0: Operational Polish and Score Review.
- v7.6.0: Install and Update Wizard.
- v7.7.0: Optional Telemetry and Memory Proof.
- v7.8.0: Final Operator Experience Review.
- v7.9.0: Real Inter-Agent Communication Bus.
- v8.0.0: Unified Operator CLI and Doctor.
- v8.1.0: Core Contract Alignment and Drift Guard.
- v8.2.0: Operator Daily Launcher and First-Call Installer.
- v8.3.0: Project Bootstrap Assistant.
- v8.4.0: Stability Baseline and Regression Sentinel.
- v8.5.0: Operator Runbook and Recovery Guide.
- v8.6.0: Guided Installer and Repository Onboarding.
- v8.7.0: Practical First Project Walkthrough.

Próxima etapa:
Antes de implementar qualquer coisa, leia o estado real do repositório, especialmente:
- `.agents/ROADMAP.md`
- `.agents/config/framework.yaml`
- `.agents/config/framework-manifest.yaml`
- `.agents/releases/CHANGELOG.md`
- `.agents/AGENTS.md`
- docs EN/PT-BR relevantes

Depois proponha a próxima versão como v8.8.0, mantendo a lógica incremental. A próxima melhoria ainda está como “To Be Defined”, então avalie o framework atual e sugira a etapa mais valiosa sem quebrar:
- segurança operacional;
- clareza para o operador;
- automação real;
- validação;
- documentação viva;
- baixo consumo de tokens;
- capacidade de uso em projetos reais.

Regras de trabalho:
- Não remover ou reverter nada existente sem necessidade clara.
- Não quebrar compatibilidade.
- Não inflar configs com listas grandes ou features não enforceadas.
- Preferir protocolos/checkers/scripts compactos.
- Toda versão precisa ter release note, docs EN/PT-BR quando houver impacto ao operador, changelog, roadmap, manifest/configs atualizados, gate rodado e zip final.
- Usar `rg` para busca.
- Usar `apply_patch` para edições manuais.
- Se for rodar validação completa, usar o CLI unificado quando fizer sentido:
  `.agents\tools\hephaestus.ps1 -Action validate`
  `.agents\tools\hephaestus.ps1 -Action gate`
  `.agents\tools\hephaestus.ps1 -Action package`
  `.agents\tools\hephaestus.ps1 -Action evidence`

Quero que você continue daqui com uma análise curta do estado atual e a recomendação objetiva da próxima versão v8.8.0.
```
