# React Native 0.76 — Tech Card

> **Category:** Mobile Framework (Cross-platform)
> **Current Version:** 0.76.x (New Architecture stable)
> **Platforms:** iOS, Android

---

## Quick Setup
```bash
npx -y @react-native-community/cli init MyApp --template react-native-template-typescript
```

## Key Features (0.76 — New Architecture)
- **Fabric Renderer** — new native rendering system (faster, concurrent)
- **TurboModules** — lazy-loaded native modules (faster startup)
- **Codegen** — type-safe bridge from TypeScript to native code
- **Bridgeless Mode** — direct JS ↔ native communication
- **React 19 support** — Server Components, Suspense, transitions

## Top 10 Best Practices

1. **Use TypeScript** — type safety across JS/native boundary
2. **Use React Navigation** — standard navigation library (`@react-navigation/native`)
3. **Use FlatList** — not ScrollView for lists (virtualized rendering)
4. **Use `react-native-mmkv`** — 30x faster than AsyncStorage
5. **Minimize bridge crossings** — batch native calls, use TurboModules
6. **Use Reanimated** — 60fps animations on native thread (`react-native-reanimated`)
7. **Image optimization** — use `react-native-fast-image` with caching
8. **Use `expo-`** modules — well-maintained, tested on both platforms
9. **Test on real devices** — emulator doesn't catch all performance issues
10. **Use Flipper or React DevTools** — debug layout, network, performance

## Top 10 Gotchas

1. ❌ **ScrollView for long lists** — use FlatList; ScrollView renders ALL items
2. ❌ **Inline styles in FlatList items** — create StyleSheet outside component
3. ❌ **Not using `useCallback` for FlatList renderItem** — causes re-renders
4. ❌ **Large images without resizing** — resize before display; full-res images consume RAM
5. ❌ **JavaScript animations** — use Reanimated for UI thread animations
6. ❌ **Not handling keyboard** — use `KeyboardAvoidingView` + `keyboardShouldPersistTaps`
7. ❌ **iOS/Android differences** — test on BOTH platforms, use Platform.OS checks
8. ❌ **Not handling deep links** — configure linking config for all routes
9. ❌ **Background fetch without setup** — iOS kills background tasks; use `react-native-background-fetch`
10. ❌ **Ignoring iOS notch** — use `SafeAreaView` from `react-native-safe-area-context`

## Performance Checklist
- [ ] FlatList with `getItemLayout` for fixed-height items
- [ ] `useMemo` / `useCallback` for expensive renders in lists
- [ ] Images resized to display size (not full resolution)
- [ ] Animations on native thread (Reanimated `useAnimatedStyle`)
- [ ] Bundle size check with `react-native-bundle-visualizer`
- [ ] Hermes engine enabled (default in 0.76)
- [ ] Profiling with Flipper Performance plugin

## Project Structure
```
src/
├── app/                    # App entry, navigation
│   ├── App.tsx
│   └── navigation/
│       ├── RootNavigator.tsx
│       └── TabNavigator.tsx
├── features/              # Feature-based modules
│   ├── auth/
│   │   ├── screens/
│   │   ├── components/
│   │   └── hooks/
│   └── orders/
├── components/            # Shared UI components
│   ├── Button.tsx
│   └── Card.tsx
├── hooks/                 # Shared hooks
├── services/              # API clients
├── stores/                # State management (Zustand)
├── theme/                 # Colors, typography, spacing
└── utils/                 # Helpers
```
