# Runbook e Recuperacao do Operador

> Versao do Framework: 8.7.0
> Idioma: Portugues (Brasil)
> Escopo: Runbook operacional e fluxo de recuperacao

---

## Objetivo

Use este guia para operar o HEPHAESTUS no dia a dia, preparar release ou recuperar falhas de validacao, gate, pacote, instalacao ou update.

## Mapa de Comandos

| Intencao | Comando |
|---|---|
| Diagnosticar wiring do framework | `powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action doctor -Root .` |
| Validar manifest e arquivos obrigatorios | `powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action validate -Root .` |
| Rodar pre-release gate | `powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action gate -Root . -Version 8.7.0` |
| Criar pacote de release | `powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action package -Root . -Version 8.7.0` |
| Gerar evidencias de release | `powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action evidence -Root . -Version 8.7.0 -PackagePath HEPHAESTUS-Framework-v8.7.0.zip` |
| Comparar versoes instaladas | `powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action compare -SourceRoot . -TargetRoot <target>` |
| Instalar em projeto destino | `powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action install -SourceRoot . -TargetRoot <target>` |
| Atualizar projeto destino | `powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action update -SourceRoot . -TargetRoot <target>` |
| Iniciar operacao diaria | `powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action daily -Root . -DailyMode start` |
| Preparar prontidao de projeto | `powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action bootstrap -Root . -TargetRoot <target>` |

## Operacao Normal

1. Para comecar o dia, rode `daily` com `start`.
2. Para projeto novo ou recem-instalado, rode `bootstrap`.
3. Antes de confiar no estado do framework, rode `doctor`.
4. Antes de trabalho de release, rode `validate`.
5. Para prontidao de release, rode `gate`.
6. Depois que docs e configs estiverem finais, rode `package`.
7. Rode o gate do pacote com `-PackagePath`.
8. Rode `evidence` com o caminho do pacote final.

## Fluxo de Recuperacao

Quando um comando falhar, use esta ordem:

1. Rode `doctor` primeiro.
2. Leia o nome do check que falhou.
3. Se a falha for estrutural, rode `validate`.
4. Se a falha for deriva de documentacao, rode o checker de paridade.
5. Se a falha for de release, rode `gate` de novo depois de corrigir o ponto especifico.
6. Se o pacote mudou, rode `package`, gate do pacote e `evidence` de novo.

## Falhas Comuns

| Falha | Primeira resposta |
|---|---|
| Arquivo obrigatorio ausente | Restaurar ou criar o arquivo obrigatorio, depois rodar `validate`. |
| Deriva de versao | Alinhar `framework.yaml`, `framework-manifest.yaml`, indices de docs, release note e changelog. |
| Falha de paridade documental | Atualizar docs EN e PT-BR e `.agents/docs/_translation-map.yaml`. |
| Falha de gate | Corrigir o checker nomeado, depois rodar `gate` de novo. |
| Falha no gate do pacote | Recriar o ZIP depois de todas as mudancas de docs e manifest. |
| Falha de evidencia | Garantir que os relatorios latest existem, depois rodar `evidence` com o pacote final. |
| Incerteza em instalacao ou update | Rodar sem `-Apply` primeiro, revisar o dry-run e aplicar apenas depois de aprovacao. |

## Regras de Seguranca

- Nao mutar projetos destino durante recuperacao sem aprovacao explicita de Apply.
- Nao remover arquivos apenas para fazer a validacao passar.
- Nao adicionar config aspiracional sem checker, runner, protocolo ou enforcement real.
- Manter evidencias de recuperacao compactas.

## Validacao

Rode:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/check-operator-runbook.ps1 -Root .
```
