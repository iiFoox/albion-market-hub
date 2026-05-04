---
id: "kg-seed-flutter-002"
type: "design-pattern"
created: "2026-04-23T14:40:00-03:00"
project_context: "any-flutter-project"
tags: ["flutter", "architecture", "folder-structure", "naming"]
---

## Flutter Project Structure Decision Tree

### By Project Size

#### Small (< 10 screens, solo dev)
```
lib/
├── main.dart
├── core/
│   ├── theme/app_theme.dart
│   ├── router/app_router.dart
│   └── constants/
├── data/
│   ├── models/
│   ├── repositories/
│   └── services/
├── presentation/
│   ├── screens/
│   └── widgets/
└── utils/
```

#### Medium (10-30 screens, small team)
```
lib/
├── main.dart
├── core/
│   ├── theme/
│   ├── router/
│   ├── di/injection.dart
│   ├── network/api_client.dart
│   └── constants/
├── features/
│   ├── auth/
│   │   ├── data/        (models, repos, datasources)
│   │   ├── domain/      (entities, repo interfaces, usecases)
│   │   └── presentation/(screens, viewmodels, widgets)
│   ├── products/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── [feature_n]/
├── shared/
│   ├── widgets/
│   ├── extensions/
│   └── utils/
└── l10n/
```

#### Large (30+ screens, multiple teams)
```
lib/
├── main.dart
├── app/
│   ├── app.dart
│   ├── router/
│   └── di/
├── core/
│   ├── network/
│   ├── storage/
│   ├── theme/
│   ├── errors/
│   └── platform/ (conditional imports)
├── features/  (each feature is independent module)
│   ├── auth/
│   ├── products/
│   ├── cart/
│   ├── profile/
│   └── [feature_n]/
├── shared/
│   ├── domain/  (shared entities)
│   ├── data/    (shared repos)
│   └── presentation/ (shared widgets)
└── l10n/
```

## Naming Conventions
```
Files:     snake_case.dart
Classes:   PascalCase
Variables: camelCase
Constants: camelCase or SCREAMING_SNAKE_CASE
Widgets:   PascalCase (same as class)
Tests:     [file]_test.dart
Screens:   [name]_screen.dart
ViewModels: [name]_viewmodel.dart (or [name]_controller.dart)
Repos:     [name]_repository.dart
Models:    [name]_model.dart
```

## Usage
Researcher and Planner should reference this when setting up new features or projects.
