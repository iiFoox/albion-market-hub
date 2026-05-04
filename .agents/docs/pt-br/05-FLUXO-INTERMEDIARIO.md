# 05 — Fluxo Intermediário (STANDARD)

> **Nível:** 🟡 Intermediário  
> **Complexidade:** STANDARD  
> **Agentes ativos:** 5-8 (Researcher + Planner + Builder + UI/UX + Platform + Validator + Docs)  
> **Quando usar:** Feature nova, CRUD, integração simples, refactor médio

---

## Como Funciona o Pipeline STANDARD

```
Você → Orchestrator (classifica STANDARD)
                   → Researcher (analisa contexto e dependências)
                   → Planner (cria plano de execução)
                   → Builder (implementa)
                   → UI/UX Specialist (revisa visual, se aplicável)
                   → Platform Guardian (verifica plataformas, se aplicável)
                   → Validator (testa e audita)
                   → Documentation (documenta)
                   → Project Manager (registra métricas)
                   → Delivery (commita)
                   → Resultado para você
```

---

## Exemplo Completo: Criar Tela de Perfil do Usuário

### Seu prompt:
```markdown
STANDARD: Crie a tela de perfil do usuário com:
- Avatar (com opção de trocar foto)
- Nome, email, telefone (editáveis)
- Botão salvar
- Botão sair (logout)

Stack: Flutter multi-platform (Android + Windows + Web)
Arquitetura: seguir o profile flutter-multiplatform ativo
```

### O que cada agente faz:

#### 🔬 Researcher
```
PENSANDO:
→ Existe tela de perfil similar no projeto? Não
→ Existe modelo de User já definido? Verificar...
→ Tem API de perfil? Verificar endpoints existentes
→ Image picker funciona em todas as plataformas? Verificar known-issues.md
   → Android: ✅ | Windows: ⚠️ file dialog only | Web: ⚠️ HTML input
→ Risco: médio (envolve upload de imagem cross-platform)

OUTPUT: Contexto mapeado, riscos identificados, recomendações:
- Usar file_picker em vez de image_picker (melhor suporte desktop)
- Criar fallback para web (sem câmera, só upload)
```

#### 📐 Planner
```
PLANO DE EXECUÇÃO:

Fase 1 — Model & Repository
├── Verificar/criar UserModel com campos: name, email, phone, avatarUrl
├── Criar ProfileRepository (interface + implementação)
└── Criar UpdateProfileUseCase

Fase 2 — UI
├── Criar ProfileScreen com Form
├── Criar ProfileViewModel/Controller
├── Criar AvatarPicker widget (com platform adapter)
└── Aplicar design tokens do ui-standards.md

Fase 3 — Navigation
├── Adicionar rota /profile no GoRouter
└── Adicionar item "Perfil" no navigation menu

CRITÉRIOS DE ACEITE:
- [ ] Tela renderiza com dados do usuário logado
- [ ] Campos são editáveis e validados
- [ ] Avatar pode ser trocado em Android, Windows e Web
- [ ] Botão salvar chama API e mostra feedback
- [ ] Logout limpa sessão e redireciona para login
```

#### 🔨 Builder
```
IMPLEMENTAÇÃO:
1. lib/features/profile/data/models/profile_model.dart
2. lib/features/profile/data/repositories/profile_repository_impl.dart
3. lib/features/profile/domain/entities/profile.dart
4. lib/features/profile/domain/repositories/profile_repository.dart
5. lib/features/profile/domain/usecases/update_profile.dart
6. lib/features/profile/presentation/screens/profile_screen.dart
7. lib/features/profile/presentation/viewmodels/profile_viewmodel.dart
8. lib/features/profile/presentation/widgets/avatar_picker.dart
9. lib/core/router/app_router.dart (atualizado)
```

#### 🎨 UI/UX Specialist
```
DESIGN REVIEW:
✅ Cores: Usando ColorScheme — nenhum hard-coded
✅ Tipografia: TextTheme corretamente aplicado
⚠️ Avatar: Tamanho fixo 120px em mobile, deveria ser responsivo
⚠️ Form: Falta estado de "salvando" (loading no botão)
❌ Acessibilidade: Faltam Semantics labels no avatar e botão logout
❌ Estado vazio: Sem tratamento para avatar null (mostrar placeholder)

VEREDICTO: NEEDS_CHANGES (2 críticos, 2 avisos)
→ Builder corrige baseado neste feedback
```

#### 🛡️ Platform Guardian
```
PLATAFORM CHECK:
- file_picker v6.0: Android ✅ | Windows ✅ | Web ✅
- Fallback de câmera no web: ✅ configurado
- Conditional import para storage do avatar: ✅
- kIsWeb check antes de Platform.is*: ✅

VEREDICTO: PASS (todas as plataformas OK)
```

#### ✅ Validator
```
TESTES:
- Unit tests: ProfileModel, UpdateProfileUseCase ✅
- Widget test: ProfileScreen renders correctly ✅
- Widget test: Avatar picker shows dialog ✅
- Widget test: Form validation works ✅

VEREDICTO: PASS
```

---

## Mais Exemplos STANDARD

### Criar CRUD:
```
STANDARD: Implemente CRUD completo de Produtos com:
- Model: id, name, description, price, imageUrl, category
- API: GET /products, GET /products/:id, POST, PUT, DELETE
- Telas: Lista com busca, Detalhe, Form (criar/editar)
- Validação de formulário
- Estado de loading, erro e vazio em todas as telas
```

### Integrar API:
```
STANDARD: Integre a API de CEP dos Correios (viacep.com.br):
- Ao digitar CEP no form de endereço, preencher automaticamente os campos
- Tratar todos os erros (CEP inválido, sem internet, timeout)
- Adicionar debounce de 500ms no input
- Usar design tokens para o feedback visual
```

### Refactor médio:
```
STANDARD: Refatore o módulo de autenticação:
- Extrair lógica do LoginScreen para LoginViewModel
- Criar AuthRepository com interface
- Mover tokens JWT para SecureStorage
- Manter todos os testes passando
```

---

## Próximo

→ [06-FLUXO-AVANCADO.md](06-FLUXO-AVANCADO.md) — Arquitetura, migrações, refactors grandes
