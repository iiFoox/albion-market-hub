# 24 — CLI Unificado do Operador

> Versao do Framework: 8.7.0
> Quando usar: voce quer um unico ponto de comando para instalacao, update, validacao, release, pacote e diagnostico.

---

## Proposito

O CLI unificado encapsula as ferramentas existentes do HEPHAESTUS sem mudar o modelo de seguranca delas.

Caminho do CLI:

```text
.agents/tools/hephaestus.ps1
```

## Comandos Comuns

Doctor:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action doctor -Root .
```

Validar:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action validate -Root .
```

Bootstrap:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action bootstrap -Root . -TargetRoot .
```

Inicio diario:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action daily -Root . -DailyMode start
```

Pre-release gate:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action gate -Root . -Version 8.7.0
```

Gerar pacote:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action package -Root . -Version 8.7.0
```

Gerar evidencia de release:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action evidence -Root . -Version 8.7.0 -PackagePath HEPHAESTUS-Framework-v8.7.0.zip
```

Instalacao dry-run:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action install -SourceRoot . -TargetRoot C:\Project\Destino
```

Instalacao apply:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action install -SourceRoot . -TargetRoot C:\Project\Destino -Apply
```

Update dry-run:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action update -SourceRoot . -TargetRoot C:\Project\Destino
```

Update apply:

```powershell
powershell -ExecutionPolicy Bypass -File .agents/tools/hephaestus.ps1 -Action update -SourceRoot . -TargetRoot C:\Project\Destino -Apply
```

## Modelo de Seguranca

- Instalacao e update continuam em dry-run salvo quando `-Apply` estiver presente.
- Update mantem backup por padrao.
- O CLI nao deleta pacotes nem telemetria.
- O CLI nao exige acesso de rede.
- O lancador diario encapsula checks existentes e nao ignora gates de release.
