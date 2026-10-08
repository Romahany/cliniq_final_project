# Rider Delivery Flutter — Claude Development Rules

> Read and follow every rule before starting **any** task (feature, fix, refactor, chore, hot-fix, spike). "It's only a small change" never excuses skipping a rule.
> A task ends only when the matching `docs/*.md` files are updated (§24). Code that compiles + passes `flutter analyze` is not "done".
> Scope: Flutter codebase at `rider_delivery_flutter/` (Dart ≥ 3.10), Android + iOS. Legacy Android under `../BikerAndroid/` is **read-only** reference.

---

## 0. Pre-Task Checklist

1. Read this file in full.
2. Write a plan (files created/modified, approach, decisions) and **wait for approval** before writing code.
3. Check the theme/UI catalogue (`docs/04-theme-and-ui-components.md`) and `lib/core/theme/` before inventing any colour, type style, shape, button, input, toast, or sheet. Never add a new `Biker*` widget without confirming none covers the need.
4. Check the API reference (`docs/09-network-layer.md` + `docs/postman-collection.json`). If a required endpoint is missing, **stop and report exactly which** — no workarounds.
5. If modifying a feature, re-read its feature doc (`docs/13-feature-*.md` …).
6. Grep for existing `UseCase`s, `Mapper`s, widgets, utilities before reinventing.
7. **Always cross-reference the legacy app (`../BikerAndroid/`) before new code** — mandatory:
   - Pin both repos side-by-side. Legacy → branch `feature/picker-barcode-scan-validation` (verify `git -C ../BikerAndroid branch --show-current`). Flutter (this repo) → `main` (verify `git branch --show-current`).
   - For each screen/flow/Cubit/repo ported: open matching legacy + Flutter files in the same pass. Every action/state/network call/validation in the legacy must have a counterpart on the Flutter side. Missing on Flutter = the work; present on Flutter but gone from legacy = dead code/regression (flag it).
   - **Port logic & flow as-is; re-skin UI to the Flutter design system** (`lib/core/theme/`, `lib/core/common_ui/`, Almarai type, Iconsax icons). Behavioural parity, not visual parity.
   - UI tasks: read both legacy XML (`res/layout*/`, `menu/`, `drawable/`) and the driving Kotlin/Java — **only to extract information architecture** (fields, order, actions, states, copy keys, transitions). Do not reproduce legacy visuals.
   - Business logic: read the matching `Presenter`/`ViewModel`/`Repository`/`UseCase`/`Mapper`/`*Request`/`*Response`/DTO. Port behaviour + validation, not framework idioms.
   - **Do not transliterate Java/Kotlin to Dart** — re-architect to this file's rules (Cubit + sealed actions, `Resources<T>`/`ApiResult<T>`, `easy_localization`, `auto_route`, `injectable`). Legacy is read-only. List legacy paths read in the walkthrough.
8. State the plan and wait for approval on any destructive action (`flutter clean` on a busy build, `rm -rf`, keystore overwrite, force-push, schema migration, deleting generated files).

---

## 1. Component Catalogue

- Shared-UI catalogue: `lib/core/common_ui/`, documented in `docs/04-theme-and-ui-components.md`.
- Every new shared widget gets a row in `docs/04` before commit: class name, file path, full constructor signature (named params + defaults), one-line purpose.
- Check `docs/04` before building any UI primitive; extend/parameterise rather than duplicate. Update the entry when params change.
- Feature-specific widgets stay in `lib/features/<feature>/presentation/<screen>/widgets/` and are **not** catalogued — the catalogue is for cross-feature primitives.

---

## 2. Git Commits

- Commit after every completed, working unit. Format:

  ```
  <type>(<scope>): <short description>

  <body — what & why, if non-obvious>

  Co-Authored-By: Claude <noreply@anthropic.com>
  ```

- Types: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`, `build`. Scopes: `auth`, `orders`, `delivery`, `tracking`, `map`, `profile`, `notifications`, `network`, `di`, `routing`, `theme`, `l10n`, `ci`, `android`, `ios`.
- **Never commit:** secrets/signing files (`.env`, `key.properties`, `keystore.properties`, `google-services.json`, `GoogleService-Info.plist`, `*.jks/.p8/.p12`); build artefacts (`build/`, `.dart_tool/`, `.flutter-plugins*`, `ios/Pods/`, `ios/.symlinks/`, `ios/Flutter/Flutter.framework`, `ios/DerivedData/`, `android/.gradle/`, `android/app/release/`, `android/local.properties`, `*.iml`, `.idea/`); failing tests; stray `print`/`debugPrint`/`log` in release paths (use the logger, §15); commented-out code; generated files whose source changed without re-running `build_runner` (§25).
- Never `--no-verify`, `git push --force` on `main`/`development`/`release/*`, or `git reset --hard` without explicit user instruction.

---

## 3. Walkthrough History

- After every completed feature, fix, or significant refactor: create/update `docs/walkthroughs/YYYY-MM-DD_<slug>.md` and add a one-line entry to `docs/walkthroughs/README.md`.
- Contents: **Date**; **Summary** (one paragraph); **Files changed** (all created/modified; generated files only when their source changed); **API changes** (endpoints + whether Postman updated); **Widgets** (+ `docs/04` change); **DI** (new registrations/modules/scopes + regen); **Routing** (routes, deep links, guards); **Localization** (new keys in both `en.json` and `ar.json` + regenerated `locale_keys.g.dart`); **Analytics** (new `AppEvent`/properties); **Platform impact** (Dart vs iOS/Android native/channel); **Build config** (flavor, `--dart-define`, `Info.plist`, manifest, Gradle); **Code generation** (generators re-run); **Testing** (what + coverage); **Known limitations / follow-ups**.

---

## 4. Secrets & Environment

- All base URLs, API keys, credentials live in `.env.<flavor>` at repo root (`.env.dev/.staging/.prod`) — nowhere else. All `.env*` gitignored except `.env.example` (every key, no values).
- Load at start via `flutter_dotenv` (`lib/core/config/app_environment.dart`), expose through typed `AppEnvironment` — never `dotenv.env['KEY']` at call sites. Compile-time secrets via `--dart-define` from the flavor config (§26).
- Required keys: `GOOGLE_MAPS_API_KEY`, `PROD_BASE_URL`, `STAGING_BASE_URL`, `DEV_BASE_URL`, `FCM_SENDER_ID`, `MAPS_DIRECTIONS_API_KEY`, plus any logistics SDK keys.
- Firebase: Android `android/app/src/{dev,staging,prod}/google-services.json`; iOS `ios/Runner/Firebase/{Dev,Staging,Prod}/GoogleService-Info.plist` — both gitignored, wired per flavor via `lib/firebase/firebase_options_<flavor>.dart`. Never commit production `firebase_options.dart`.
- Android signing: `android/key.properties` + `.jks` (gitignored). iOS signing via Xcode/provisioning — never commit `*.mobileprovision`/`.p12`.
- `AppEnvironment.assertConfigured()` must throw and refuse to boot on a missing key — never silently fall back to empty strings.
- Maps keys via manifest placeholders (`${MAPS_API_KEY}` from Gradle `manifestPlaceholders`) and iOS `--dart-define` through `FlutterAppDelegate`. Never hard-coded.

---

## 5. Localisation (EN / AR)

- **Every** user-facing string is localised. Locales: `ar` (default, RTL) and `en` (LTR). Fresh install boots `ar`; choice persisted by `easy_localization` and mirrored into `SecureStorage` under `Storage.Key.appLanguage`. Root config: `fallbackLocale`/`startLocale` = `Locale('ar')`.
- Call `LocaleKeys.<scope>_<key>.tr(context: context)` (typed) or `'order.status.${status.name}'.tr(context: context)` (dynamic). **Always pass `context: context` from widget code** — bare `.tr()` freezes `const`/helper widgets on the first language. Helper methods that compute strings take `BuildContext` first and forward it.
  - Sanctioned bare-`.tr()` exceptions: validators in `lib/core/utils/validation.dart`; post-`await` toast strings; code with no `BuildContext` (Cubits, mappers, services).
  - Only literal-string exception: the two language-picker buttons (`"العربيه"`, `"English"`).
- Files: `assets/translations/en.json` + `ar.json`, keys by feature (`auth.*`, `orders.*`, `tracking.*`, `errors.*`, `common.*`). Typed catalogue generated to `lib/generated/locale_keys.g.dart` — never reference raw keys except dynamic ones.
- Adding a string: add to **both** JSONs in the same PR, then regen: `flutter pub run easy_localization:generate -S assets/translations -O lib/generated -o locale_keys.g.dart -f keys`. Commit the generated file.
- Parametrised strings use `args`/`namedArgs`; plurals use ICU `{count, plural, ...}`. Date/time formatting lives on `AppFormatters` (§6).
- **RTL-first:** use `EdgeInsetsDirectional` and `AlignmentDirectional` — never `EdgeInsets.only(left/right)` or `Alignment.centerLeft`. RTL bugs are release blockers. Active language mirrored to `SecureStorage` for non-widget code. When a Cubit caches mapped strings, subscribe to the language-change stream (§10/§19) and re-map.
- **Server i18n:** bilingual DTO fields come as `name_en`/`name_ar` etc.; mappers pick via active locale (`AppEnvironment.isArabic`), falling back to English when both missing.

---

## 6. Timestamps & Timezones

- Backend returns UTC ISO-8601. Parse as `DateTime.parse(value).toUtc()`. Render via `AppFormatters` (`lib/core/utils/app_formatters.dart`) using `intl` `DateFormat` with `context.locale.languageCode` (`dateLong`, `minutesAgo`, `hoursAgo`, `daysAgo`, `daysBefore`, `etaCountdown`). Never `DateTime.toString()` or raw `DateFormat` in widgets for display.
- Always send `dt.toUtc().toIso8601String()`; never a locally-formatted string.
- Countdown timers recompute from wall-clock each tick (`DateTime.now().difference(target)`), not by decrementing a counter. Drive ticks with `Stream.periodic` inside the Cubit, emitting a state per tick.

---

## 7. Security Checklist (run before every commit)

- [ ] No token/secret/credential in source or logs.
- [ ] `accessToken`/`refreshToken` never logged, never in query strings/`Uri`; only in `flutter_secure_storage` via the `SecureStorage` facade.
- [ ] All persistence via `SecureStorage` (sensitive) or `Preferences` (non-sensitive) — never raw `SharedPreferences`/`NSUserDefaults`/Keychain. Hive only for non-sensitive cache, opened via `HiveStorage`.
- [ ] Authed HTTP rides the main `Dio` (`lib/core/network/dio_module.dart`); `AuthInterceptor` attaches `Authorization: Bearer` — never attach manually except whitelisted paths.
- [ ] No PII logged (phone, name, address, password, OTP, token, rider GPS, plate). Don't bypass `AppLogger` redaction.
- [ ] No new `print`/`debugPrint` in release paths — use `AppLogger.d/i/w/e` (no-op in release).
- [ ] New SDK keys via `.env.<flavor>` → `AppEnvironment`/`manifestPlaceholders`/`--dart-define` — never hard-coded.
- [ ] Cleartext disallowed on release: `android:usesCleartextTraffic=false`; `network_security_config.xml` allows cleartext only for `*.local`/dev IPs in dev/staging; iOS `NSAppTransportSecurity` has no `NSAllowsArbitraryLoads=true` on release.
- [ ] TLS pinning in `dio_module.dart` unchanged unless explicitly tasked (self-signed bypass gated on `flavor != prod`).
- [ ] Maps/Firebase/FCM keys read from `AppEnvironment`, declared as placeholders/Info.plist.
- [ ] Deep-link URIs validated against `DeepLinkRoutes`; a new external URI needs manifest intent-filter + `assetlinks.json` + iOS `applinks:` in the same PR.
- [ ] Background-location perms (`ACCESS_BACKGROUND_LOCATION`, `NSLocationAlwaysAndWhenInUseUsageDescription`) added only with written justification (review-blockers).

---

## 8. Testing (≥ 70 % coverage)

- Every new `UseCase`, `Mapper`, `Repository`, `Cubit` has a test. Min 70 % line coverage (`lcov.info`); run `flutter test --coverage && genhtml coverage/lcov.info -o coverage/html`. Don't commit if coverage drops. CI fails the PR if coverage falls >1 % below the previous commit.

| Layer | Location | Tools |
| --- | --- | --- |
| Unit | `test/<feature>/...` | `flutter_test`, `mocktail`, `bloc_test` (works for Cubit) |
| Network | `test/<feature>/data/...` | `mocktail` over `Dio` (`MockAdapter`) |
| Widget | `test/<feature>/presentation/...` | `flutter_test` (`pumpWidget`) |
| Integration | `integration_test/` | `integration_test` + `dev` flavor |
| Manual | — | DevTools, real device |

- Mirror lib paths: `lib/.../get_active_run_usecase.dart` → `test/.../get_active_run_usecase_test.dart`. One unit per file. Names: `test('<action>_<expectation>')`, `blocTest('<action>_<expectation>')`.
- `bloc_test` for every Cubit (`act` → `expect(states)` → `verify`). Mocks built per-test in `setUp`, no shared mutable state, `reset` if reused. Register `registerFallbackValue` in `test/test_setup.dart`.
- Widget tests use `makeTestableWidget(child:)` from `test/utils/test_harness.dart` (real `EasyLocalization`, test `AutoRouter`, stubbed `GetIt`). Golden tests under `test/<feature>/golden/` (`goldenToolkit`/`alchemist`), regenerated only on macOS.
- Never `Future.delayed` to wait — use `pump`/`pumpAndSettle`/`bloc_test` `wait`. Shared builders in `test/utils/builders/`.

---

## 9. Clean Architecture (Cubit + BaseCubit)

Feature layout:

```
lib/features/<name>/
├── presentation/<screen>/view/{<screen>_cubit.dart, <screen>_states.dart, <screen>_page.dart}
│                       widgets/                 (screen-local)
│   widgets/                                     (feature-shared)
├── domain/{entities/, repository/, use_case/}
└── data/{datasource/{remote/, local/}, model/, mapper/, repository/}
```

Top-level: `main.dart` (+ `main_<flavor>.dart` entries), `app.dart`, `core/` (base, routing, storage, theme, l10n, network, utils, logger), `features/`, `network/` (Dio, interceptors, `ApiResult`, `Errors`, `Resources`), `di/`, `routing/`, `generated/`.

### 9.1 Limits
Dart file ≤ 400 lines; `build()` ≤ 100 (else extract sub-widgets like `_OrderHeader`); method ≤ 25 (else extract — each extracted logic fn gets its own test). Applies to every artefact.

### 9.2 Structure
Organise by **feature**, not file type (see `docs/01-project-overview.md` §3).

### 9.3 `BaseCubit<T, A, NE>`
Cubit (not Bloc) for every screen. Bloc's events are replaced by `doAction(A action)` switching on a sealed class; one-shot effects flow through `Stream<NE>`.

```dart
abstract class BaseCubit<T, A, NE> extends Cubit<T> {
  BaseCubit(super.initialState);
  Future<void> doAction(A action);
  final StreamController<NE> _navigationStream = StreamController.broadcast();
  Stream<NE> get navigation => _navigationStream.stream;
  void emitNavigation(NE e) => _navigationStream.add(e);
  @override
  Future<void> close() { _navigationStream.close(); return super.close(); }
}
```

- Every screen Cubit extends `BaseCubit<<Screen>States, <Screen>Action, <Screen>NavigationAction>`. No `Bloc`/`on<Event>`/transformers.
- `State` = plain class (no freezed/equatable) with named-default fields + hand-written `copyWith`. `Action`/`NavigationAction` = Dart 3 `sealed class`.
- Mutate only via `emit(state.copyWith(...))` (never reassign `state`, never mutate nested collections). One-shot effects only via `emitNavigation(...)` (never a "consumed" flag). Cubits have no `BuildContext` and never touch the router.

### 9.4 Page (View)
`StatefulWidget` that: resolves cubit via `getIt()`; subscribes to `cubit.navigation` in `initState`; wraps body in `BlocProvider.value(value: cubit, ...)`; uses `BlocBuilder`/`BlocSelector` only around state-dependent parts; dispatches via `cubit.doAction(...)` — **never** other cubit methods.

```dart
class _LoginPageState extends State<LoginPage> {
  final LoginCubit cubit = getIt();
  StreamSubscription<LoginNavigationAction>? _navSub;
  @override
  void initState() { super.initState(); _navSub = cubit.navigation.listen(_handleNavigation); }
  void _handleNavigation(LoginNavigationAction e) {
    switch (e) {
      case NavigateToRegisterScreen(): context.router.replace(const RegisterRoute());
      case NavigateToHomeScreen(): context.router.replaceAll([const HomeRoute()]);
      case ShowLoginErrorToast(:final errorMessage): getIt<Toaster>().showError(errorMessage);
    }
  }
  @override
  void dispose() { _navSub?.cancel(); super.dispose(); }
  @override
  Widget build(BuildContext context) => BlocProvider.value(value: cubit, child: /* ... */);
}
```

- Cancel the nav subscription in `dispose`. Pages hold no business logic. All navigation goes through `_handleNavigation`; toasts/sheets are `NavigationAction` cases (never called from the cubit). Prefer `BlocProvider.value` (cubit owned by `getIt`).

### 9.5 State / Action / NavigationAction (no freezed)

```dart
class LoginStates {
  final Resources<String> loginResource;
  LoginStates({this.loginResource = const Resources.initial()});
  LoginStates copyWith({Resources<String>? loginResource}) =>
      LoginStates(loginResource: loginResource ?? this.loginResource);
}
sealed class LoginAction {}
class NavigateToRegisterAction extends LoginAction {}
class LoginUserAction extends LoginAction { final String email, password; LoginUserAction(this.email, this.password); }
sealed class LoginNavigationAction {}
class NavigateToHomeScreen extends LoginNavigationAction {}
class ShowLoginErrorToast extends LoginNavigationAction { final String errorMessage; ShowLoginErrorToast(this.errorMessage); }
```

- **Forbidden:** `freezed`, `dartz`, `fpdart`, `Either`, `equatable` (PR adding them is a release blocker).
- State = `final` fields + named ctor + hand-written `copyWith` (`field ?? this.field`). If >~12 fields, compose sub-states (not freezed). Actions/NavigationActions always `sealed class` (exhaustive switch, no `default`). State never carries `Function`/`BuildContext`/`StreamController` and must be cheap to copy. Identity equality — always emit a new instance via `copyWith`.

### 9.6 Cubit template

```dart
@injectable
class LoginCubit extends BaseCubit<LoginStates, LoginAction, LoginNavigationAction> {
  final LoginUseCase loginUseCase;
  LoginCubit(this.loginUseCase) : super(LoginStates());
  @override
  Future<void> doAction(LoginAction action) async {
    switch (action) {
      case NavigateToRegisterAction(): emitNavigation(NavigateToRegisterScreen());
      case LoginUserAction(): await _login(action);
    }
  }
  Future<void> _login(LoginUserAction a) async {
    emit(state.copyWith(loginResource: const Resources.loading()));
    final res = await loginUseCase.call(a.email, a.password);
    switch (res) {
      case Success<String>():
        emit(state.copyWith(loginResource: Resources.success(data: res.data)));
        emitNavigation(NavigateToHomeScreen());
      case Failure<String>():
        emit(state.copyWith(loginResource: Resources.failure(exception: res.exception, message: res.message)));
        emitNavigation(ShowLoginErrorToast(res.message));
    }
  }
}
```

- Constructor injection (`@injectable` → new instance per resolve = fresh state per mount). `doAction` is a thin dispatcher delegating to one private async method per case. Handlers follow **emit loading → call use case → switch on `ApiResult` → emit success/failure → emit nav effect**. Cubits never `try/catch` HTTP exceptions (the data layer's `_safeCall` converts them) and never read/write storage directly.

### 9.7 UseCase
`class <Verb><Noun>UseCase { Future<ApiResult<T>> call(<Params>) }` — positional params for 1–2, else a typed `<Verb><Noun>Params` class. Returns `Future<ApiResult<T>>` (or `Stream<ApiResult<T>>` for streaming). May compose injected use cases (never instantiate). Exactly one public method `call`; helpers `_`-prefixed.

### 9.8 Async / Streams / BuildContext
All I/O behind a `Future`/`Stream` `ApiResult<T>` UseCase. No `async`/`await` in widgets except `Navigator.push().then(...)`. Long-running streams (location, FCM, connectivity) owned by singleton services in `lib/core/services/`, consumed via Cubits subscribing in `doAction(StartListeningAction())` and cancelling in `close()`. Never `setState` inside a builder. Never use `context` after `await` without `if (!context.mounted) return;` (`use_build_context_synchronously` stays on). Debounce by the cubit cancelling/relaunching a per-key `Timer`. Store all subscriptions in fields; cancel in `close()`/`dispose()`.

### 9.9 Naming

| Artefact | Convention | Example |
| --- | --- | --- |
| Widget | PascalCase, `Biker` prefix only when replacing a Material primitive | `BikerButton`, `LoginPage` |
| Cubit | `<Feature><Screen>Cubit` | `ActiveRunCubit` |
| State/Action/Nav | `<Feature>States`/`Action`/`NavigationAction` | `LoginStates` |
| Action subclass | `<Verb><Noun>Action` | `LoginUserAction` |
| Nav subclass | `<Verb><Noun>Screen` / `Show<Noun><Effect>` | `NavigateToHomeScreen`, `ShowLoginErrorToast` |
| UseCase | `<Verb><Noun>UseCase` | `GetActiveRunUseCase` |
| Repo interface / impl | `<Feature>Repository` / `…Impl` | `OrdersRepository`, `OrdersRepositoryImpl` |
| Mapper | `<Feature>Mapper` | `OrdersMapper` |
| Remote data source | `<Feature>RemoteDataSource` | `OrdersRemoteDataSource` |
| Request / Response DTO | `<Name>Request` / `<Name>Response` (or `Remote<Name>`) | `LoginRequest`, `TokenResponse` |

### 9.10 Lint
`analysis_options.yaml` extends `flutter_lints` + `very_good_analysis`. Never disable: `prefer_const_constructors`, `prefer_const_literals_to_create_immutables`, `avoid_print`, `avoid_dynamic_calls`, `use_build_context_synchronously`, `require_trailing_commas`, `prefer_single_quotes`, `unnecessary_lambdas`, `unnecessary_parenthesis`. Before every commit run `dart format --set-exit-if-changed .` and `flutter analyze` — both exit 0. No `// ignore:` without justification + a TODO/issue.

---

## 10. Separation of Concerns

- Views → `cubit.doAction(...)` only (never repos/use cases/`Dio`). Cubits → UseCases only (never repos), switching on `ApiResult<T>`. UseCases → Repository interface only, returning `Future<ApiResult<T>>`. RepositoryImpl → `<feature>RemoteDataSource` + `Mapper`, wrapping calls in `_safeCall(...)`; may use `SecureStorage`/`Preferences`/`HiveStorage`.
- No feature imports another feature's use cases except via DI-injected constructor deps (document in both features' docs). Mappers do DTO↔entity only (no side effects beyond an injected `AppLocale`).
- `lib/core/` never imports `lib/features/`; `features/<X>` never imports `features/<Y>` (except via DI); `lib/di/` imports everything by design.

---

## 11. API Integration

- HTTP via feature `<Feature>RemoteDataSource` (Retrofit abstract → `*.g.dart`). Never call `Dio` directly from Cubit/Repo/UseCase; the single instance is `DioModule.client()`.
- Repository boundary returns `Future<ApiResult<T>>`; wrap Retrofit calls in `_safeCall(() async => dataSource.fetchX(...))` (converts `DioException`/`FormatException`/`TimeoutException` to `Failure` via `ErrorParser`). No raw `DioException` escapes the data layer.
- DTOs are `@JsonSerializable(fieldRename: FieldRename.snake)` plain classes (**no freezed**); `final`, nullable-default unless guaranteed; `@JsonKey(name:)` only when needed; hand-written `fromJson`/`toJson` around generated fns.
- Handle loading/success/error explicitly via `Resources<T>` in State (§11.2) — never an unindicated in-flight UI. Responses use `BaseApiResponse<T>` (paginated: `BaseApiResponse<PageContent<T>>`) unless external (Google Directions, logistics).
- New endpoint → same PR updates `docs/09-network-layer.md` §15 + `docs/postman-collection.json`. Never hard-code URLs (`AppEnvironment.baseUrl`); `@RestApi(baseUrl:)` stays empty (runtime `Dio` carries it).

### 11.1 `ApiResult<T>` (data-layer envelope)

```dart
sealed class ApiResult<T extends Object?> { const ApiResult(); }
class Success<T extends Object?> extends ApiResult<T> { final T? data; const Success(this.data); }
class Failure<T extends Object?> extends ApiResult<T> { final Errors? exception; final String message; const Failure({this.exception, required this.message}); }
// extension: onSuccess / onSuccessNotNull / onFailure
```

- Repos/UseCases return `Future<ApiResult<T>>` — never `Future<T>`, `Either`, or another result shape. Cubits handle via exhaustive `switch (response) { case Success<T>(): … case Failure<T>(): … }`. `onSuccess`/`onFailure` extensions are for terse logging/analytics, not the primary path. `Errors` (`lib/network/errors.dart`) is the parsed error hierarchy (§15).

### 11.2 `Resources<T>` (UI envelope)

```dart
enum Status { initial, loading, success, error }
class Resources<T> {
  final Status status; final T? data; final Errors? error; final String? message;
  const Resources._({required this.status, this.data, this.error, this.message});
  const Resources.initial() : this._(status: Status.initial);
  const Resources.loading({T? data}) : this._(status: Status.loading, data: data);
  const Resources.success({T? data}) : this._(status: Status.success, data: data);
  const Resources.failure({Errors? exception, String? message, T? data}) : this._(status: Status.error, error: exception, message: message, data: data);
  bool get isInitial => status == Status.initial;  bool get isLoading => status == Status.loading;
  bool get isSuccess => status == Status.success;   bool get isError => status == Status.error;
}
```

- Cubit emits `Resources<T>` into State (one field per async op), converting `ApiResult<T>` in switch arms. Default = `const Resources.initial()`. Never roll your own `Status`/`Resources`. Per-entry use `Map<String, Resources<T>>` (§13).

---

## 12. Loading — Shimmer

- All list/grid loading uses shimmer skeletons — never spinners/blank screens/progress bars. Circular indicators allowed only in a button (`isLoading: true` on `BikerButton`) or a single-call dialog.
- Shared primitives in `lib/core/common_ui/shimmer/`: `OrdersListShimmer({int count=6})`, `MapPlaceholderShimmer()`, `RowShimmer({double height, int count})`. Feature shimmers in `lib/features/<feature>/presentation/widgets/<screen>_shimmer.dart`, mirroring real content shape/dimensions.
- Driven by `state.<resource>.isLoading`; show on `Resources.loading()`, remove on success/failure — never a fixed delay. List errors use `DefaultErrorView(error:, onRetry:)` from `lib/core/common_ui/defaults/`.

---

## 13. Optimistic UI

- Mutating actions update the UI immediately (happy-path) **where safe**: 1) snapshot state, 2) apply optimistic `emit(copyWith)`, 3) send request, 4) on `Success` keep (optionally merge canonical fields), 5) on `Failure` roll back to snapshot + `emitNavigation(ShowErrorToast(...))`. Optimistic state lives in the Cubit; rollback is silent except the toast (no flash).
- **Do not** apply optimistic updates where a wrong state causes confusion/data loss — emit `Resources.loading()` instead and wait: accepting a run (`POST /runs/{id}/accept`), POD submit (`POST /orders/{id}/pod`), payments, account-state mutations (logout, deletion).
- Per-entry: `Map<String, Resources<T>>` keyed by id; copy the map in `copyWith` (don't mutate) and re-emit.

---

## 14. Token Management & Auth Interceptor

- Token expiry is never surfaced while a valid refresh token exists. All token logic lives in `AuthInterceptor` + `RefreshInterceptor` on the shared `Dio`; only `AuthRepositoryImpl` touches tokens otherwise.
- Flow: 1) `AuthInterceptor.onRequest` attaches `Bearer` (skips whitelist). 2) `RefreshInterceptor.onError` on 401/403 (not in `isExcludedFromRetry`) enters refresh. 3) A `Mutex` (`synchronized`) serialises refresh: re-read token (retry if changed), else call `authRefreshClient.refreshToken(...)` on a **separate `Dio`** with no `RefreshInterceptor`, persist, retry via `dio.fetch(err.requestOptions)`. 4) N concurrent 401s → at most one refresh. 5) On refresh failure emit `LoginRequired(forceLogout: true)` via `AuthEventBus` → `AppRouter` does `replaceAll([LoginRoute()])`.
- Tokens only in `SecureStorage`. Whitelist (no token): `/auth/login`, `/auth/refresh-token`, `/auth/forgot-password`, `/auth/otp/verify`, `/auth/otp/resend`, `/versions/check`. Exclude-from-retry adds `/auth/change-password`, `/auth/logout`, `/users` (coded in `isExcludedFromRetry`). FCM token (`Storage.Key.deviceToken`) ≠ `accessToken`; written by `FcmService`, sent via `UpdateFcmTokenUseCase` + on every `LoginRequest`.

---

## 15. Error Handling & Notifications

- Every error flows as `Errors` (sealed, `lib/network/errors.dart`) — never raw `Exception`/`DioException`/`Object`:

```dart
sealed class Errors { final String? message; const Errors({this.message}); }
class NetworkError extends Errors { const NetworkError({super.message}); }
class TimeoutError extends Errors { const TimeoutError({super.message}); }
class ParseError extends Errors { final Object? cause; const ParseError({super.message, this.cause}); }
class ServerError extends Errors { final int statusCode; final String? code; const ServerError({required this.statusCode, this.code, super.message}); }
class LoginRequired extends Errors { final bool forceLogout; const LoginRequired({this.forceLogout = false, super.message}); }
class JustMessage extends Errors { const JustMessage(String message) : super(message: message); }
class Unknown extends Errors { final Object? cause; const Unknown({super.message, this.cause}); }
```

- `_safeCall` (`lib/network/safe_call.dart`) catches `DioException`/`FormatException`/`TimeoutException`/`Object` → `Failure(exception, message)` via `ErrorParser.parse`. Feature code never `try/catch`es HTTP.
- User feedback via `Toaster` (`getIt<Toaster>().showSuccess/showError/showWarning`, mounts via global `ScaffoldMessengerKey`; may use `cherry_toast` under the hood) or `BottomSheetHost` (`bottomSheetHost.show(dismissible:, builder:)`). Never call `showModalBottomSheet`/`ScaffoldMessenger` directly.
- Auth-critical reactions (login required, address required, location denied, force-logout) centralised in `handleUiEffect(effect, router, toaster)` — every `_handleNavigation` delegates for catch-all cases. Raw server messages surface only via `JustMessage`. Toasts auto-dismiss (short ≈ 3500 ms, long ≈ 6500 ms); non-dismissable → bottom sheet `dismissible: false`.
- Logging: only `AppLogger.d/i/w/e` (wraps `logger`, gated on `kDebugMode`). Unhandled errors (`FlutterError.onError`, `PlatformDispatcher.onError`) → `FirebaseCrashlytics.recordError`, never `print`.

---

## 16. Auth-Gated UI

- No role-based UI — features are **auth-gated** (run feed, pickup, delivery, profile, earnings require sign-in; login, forgot-password, version check, splash do not).
- Auth state in `@lazySingleton AuthSession`; check `authSession.isAuthenticated` (never `user != null`). Gated routes protected by `AuthGuard` (`lib/routing/app_router.dart`) redirecting to `LoginRoute(returnPath:)`. Force-logout only from the network layer via `LoginRequired(forceLogout: true)` → `replaceAll([LoginRoute()])` (never push).
- Logout/deletion wipe local state unconditionally (even if network fails): delete `accessToken`/`refreshToken`/`user`, `authSession.signOut()`, `HiveStorage.clearUserScope()`, `DI.resetUserScope()`. `AuthSession` rehydrated from `SecureStorage` at launch before `runApp()`.

---

## 17. Form State (Cubit + Validators)

Pick one pattern per screen:

- **Pattern A — `Form` + `TextFormField` + `validator`** (short forms): `GlobalKey<FormState>` + controllers in the View; `validator: Validators.validateEmail`; submit `if (formKey.currentState!.validate()) cubit.doAction(...)`. State carries a `Resources<T>` for the outcome; button `isLoading` from its status. Field errors stay in the field (no `<field>Error` in State).
- **Pattern B — fully Cubit-controlled** (cross-field deps, server hints): State holds `<field>: String` + `<field>Error: String?` + `bool get isValid`; View dispatches `<Field>Changed(value)`; Cubit re-runs validators and emits.

Shared: validation centralised in `lib/core/utils/validation.dart` (`Validation.validatePhone` Egyptian `^01[0125][0-9]{8}$`, `validatePassword` ≥8 chars + special, `validateName` Latin+Arabic 3–15, `validateEmail`, `validatePlate`, `validateLicenseNumber`, …), each returning `String?` already `.tr()`-ed. Never scatter regex — add a method. Input filtering via `inputFormatters`. Buttons use `isEnabled: !isLoading` + `isLoading:`. Reset via explicit `ResetFormAction` after success. Multi-step forms use separate routes + typed `auto_route` params. No `reactive_forms`.

---

## 18. Performance

- **Lazy DI:** everything via `injectable`/`get_it`, resolved on demand. `@injectable` = new per resolve (screen Cubits); `@lazySingleton` = repos/data sources/services/shared Cubits; `@singleton` = boot-time (`AppLogger`, `AppEnvironment`); `@factoryMethod`/env-scoped for flavor bindings. Run `build_runner build --delete-conflicting-outputs` after DI changes; never edit `injection.config.dart`.
- **Large lists:** >~30 items use `.builder`/`SliverList`/`SliverGrid` with stable `ValueKey(item.id)` (never index keys). Pagination via `ScrollController` triggering `LoadMoreAction`; State owns `hasReachedEnd`/`isLoadingMore`. No `infinite_scroll_pagination` without team agreement.
- **Recomposition:** `BlocSelector` for slices of frequently-rebuilt trees. Always emit new instances via `copyWith`. Use `const` aggressively. Hoist callbacks to fields when the parent rebuilds often.
- **Bundle:** check APK/IPA impact before adding a package (`flutter build apk --analyze-size --target-platform=android-arm64`); `import … show Bar;`; audit `flutter pub deps`. Icons/splash via `flutter_launcher_icons` + `flutter_native_splash` per flavor.
- **Images:** network images via `BikerNetworkImage` (wraps `cached_network_image`) — never `Image.network` directly. Assets in `assets/images/` + `assets/icons/` (SVG via `flutter_svg`), accessed via `Assets.images.xxx.path` (`flutter_gen`). Prefer SVG; PNGs in 1x/2x/3x.

---

## 19. State Management Boundaries

| State type | Lives in |
| --- | --- |
| UI-only (expanded, tab, scroll) | `StatefulWidget` field |
| Single-screen async data | Cubit State with `Resources<T>` |
| Cross-feature shared (active run, location stream, online status, FCM) | `@lazySingleton` Cubit at `core` scope |
| Server cache (order detail, polylines) | Singleton repo with in-memory fields (optionally Hive) |
| Cross-feature signals (language change, online toggle, FCM push, foreground) | `AppEventBus` (`StreamController.broadcast`, `@lazySingleton`) |
| Auth/session | `AuthSession` (`@lazySingleton`, `SecureStorage`-backed) |
| Transient cross-screen payloads | `auto_route` typed params or a per-flow Cubit |
| Route-serialisable args | `auto_route` `@PathParam`/`@QueryParam` wrapper |

- Never lift state higher than needed. Shared singletons (`ActiveRunCubit`, `LocationCubit`, `AuthSession`, `AppConfigCubit`) stay singletons — don't re-register `@injectable`. `AppEventBus` carries signals not state, fire-and-forget (no replay) — subscribers re-fetch on re-activation. Global writes (`AuthSession.signIn`, `SecureStorage.put*`) only in repos + `AppConfigCubit`.

---

## 20. Accessibility

- Icons inside `IconButton` with `tooltip` (semantic label) or under `Semantics(label:)`. All inputs labelled (`BikerTextField` enforces `label`/`hint`). Dialogs/sheets trap focus via `Navigator` — no custom frameworks. Touch targets ≥ 48 dp (`BikerButton` enforces; wrap raw `GestureDetector`/`InkWell` in `ConstrainedBox(minHeight/minWidth: 48)`).
- Contrast meets WCAG AA (4.5:1 / 3:1) per `lib/core/theme/app_colors.dart` — no custom colours outside the palette. RTL: `EdgeInsetsDirectional`/`AlignmentDirectional` only. `CustomPaint` reads `Directionality.of(context)` and flips geometry. Don't hard-code `fontSize` outside `app_typography.dart`; use `Theme.of(context).textTheme.*`; honour `MediaQuery.textScalerOf`.

---

## 21. HTTP Caching & Deduplication

- **Cache** data that's frequently read, rarely mutated, shared (active-run snapshot, vehicle profile, rider profile, static config) in a `@lazySingleton` repo property (`Map`/`rxdart BehaviorSubject`). Persistent caches via Hive opened by `HiveStorage`. Clear explicitly after mutation (don't rely on TTL for transactional data). No global `dio_cache_interceptor`.
- **Don't cache** paginated/filtered lists, data being edited, or `POST`/`PATCH`/`DELETE` responses.
- **Dedup:** if a GET fires concurrently, wrap the repo method with a pending-request guard (`Mutex` + cached `Future`). No global Dio plugin.

---

## 22. Dead Code & Module Boundaries

- `dart format --set-exit-if-changed .` + `flutter analyze` before commit. Remove unused imports/symbols on sight (don't comment out). `analysis_options.yaml` **errors** on `unused_import`/`unused_element`/`unused_field`/`unused_local_variable`.
- Boundaries: `features/<X>` never imports `features/<Y>` directly — communicate via `lib/core/` services (`AuthSession`, `AppConfigCubit`, `AppEventBus`, `BottomSheetHost`, `Toaster`, `AppRouter`, storage facades) or DI-injected use cases (documented). `lib/core/` never imports features. `lib/network`/`lib/data` depend on `core` only. `lib/di` depends on everything.
- **Sanctioned stack:** `flutter_bloc` (Cubit only), `injectable`+`get_it`, `auto_route`; `dio`, `retrofit`, `json_serializable`; `easy_localization`(+generator); `flutter_secure_storage`, `shared_preferences`, `hive`; `cached_network_image`, `flutter_svg`, `cherry_toast` (under `Toaster`), `flutter_screenutil` (discuss first), `shimmer`; `intl`, `synchronized`; `flutter_test`, `mocktail`, `bloc_test`.
- **Forbidden (release blocker):** `freezed`, `dartz`/`fpdart`/any `Either`, `equatable`, `bloc_concurrency`, `reactive_forms`. Delete unreferenced code (don't comment out). Every PR passes `flutter build apk --debug` + `flutter build ios --debug --no-codesign` with no unused-module warnings.

---

## 23. Check Before Building

1. Read `docs/01-project-overview.md`. 2. **Grep `../BikerAndroid/`** (on `feature/picker-barcode-scan-validation`) for the matching screen/feature/class — extract IA & flow (UI) or behaviour & validation (logic), porting behaviour only. 3. Read the feature doc if in a feature. 4. Read the relevant infra doc (02 Base, 03 Routing, 04 Theme, 05 L10n, 06 Analytics, 07 FCM, 08 DI, 09 Network + Postman, 10 Event Bus). 5. Read 11/12 for platform code. 6. Confirm the endpoint exists in `postman-collection.json` (else stop & report). 7. Grep for existing `UseCase`/`Mapper`/`Cubit`/widget. 8. Extend/reuse if it exists (document why). 9. Create new only if extension would break things (flag the trade-off).

---

## 24. Post-Task Documentation Updates

**Every task ends with a docs update** — "code works"/"tests pass" ≠ "done". For each bullet that applies, update the matching doc in the same PR:

1. **Feature docs (`docs/13-feature-*.md`):** touched a feature's Cubit/UseCase/Repo/Mapper/State/Action/widget/sheet → update the relevant sub-section; route added/removed → Screen inventory; cross-feature dep → Integration table in **both** docs; new key → §Localisation.
2. **Infra docs (02–10):** touched `core/base/`, routing, theme/UI, l10n, analytics, FCM, DI, network, or event bus → update that doc's relevant + Golden Rules section. New `Errors` subclass → `docs/02` §5 + `docs/09` §12. Changed `BaseCubit`/`ApiResult`/`Resources` → `docs/02` + network section.
3. **Catalogue (`docs/04`):** new/modified shared widget → add/update entry with full ctor signature; new asset/font/animation → §4/§3.10.
4. **Network (`docs/09` + Postman):** endpoint added/changed/removed → update **both** (§15 table + Postman, keeping `{{baseUrl}}`/`{{accessToken}}` vars); DTO shape → §11/§13.1 + Postman body; error-parser change → §12.
5. **Analytics (`docs/06`):** new `AppEvent` → §7 catalogue + mapper; new user-property/id → §10.
6. **Routing (`docs/03`):** new route → §2; new deep link → §7 (+ manifest + entitlement + `assetlinks.json`); new typed param → §4.2.
7. **DI (`docs/08`):** new module → §4; new binding → relevant §4.*; new `@Named` → §7.5. Always re-run `build_runner build --delete-conflicting-outputs` and commit `injection.config.dart`.
8. **Native (`docs/11`/`docs/12`):** new channel → channels section both docs; new manifest/Info.plist/entitlement/Podfile → matching section; new variant/xcconfig/flavour → Build Configurations + flavor doc.
9. **Index (`docs/README.md`):** new/renamed doc → update TOC + hunt stale cross-refs with `grep -rn`.
10. **Walkthrough (`docs/walkthroughs/`):** required for every non-trivial task (§3) + update its README.

Cross-cutting: update Golden Rules when a rule becomes true/false/gains an exception; add to Gaps when introducing a known limitation; remove from Gaps when closing one; fix any code↔docs drift you notice (drive-by fixes encouraged).

Verify before commit:

```bash
grep -rn "<renamed-symbol-or-obsolete-term>" docs/   # no stale references
git status docs/                                      # expect changes matching the task
git diff docs/
```

If `git status docs/` shows no changes after a code change, stop and ask whether a docs update was really not needed (default: it was).

---

## 25. Code Generation Hygiene (`build_runner`)

Generated files are **committed** (fresh checkouts compile without running `build_runner`; reviewers see generated diffs).

| Source | Output | Purpose |
| --- | --- | --- |
| `@JsonSerializable` | `*.g.dart` | DTO `fromJson`/`toJson` |
| `@RestApi` | `*.g.dart` | Retrofit clients |
| `@injectable`/`@module` | `injection.config.dart` | DI graph |
| `@AutoRouterConfig` | `app_router.gr.dart` | Routing |
| `easy_localization_generator` | `lib/generated/locale_keys.g.dart` | Translation keys |
| `flutter_gen` | `lib/generated/assets.gen.dart` | Asset accessors |

`freezed` is not in the toolchain. Rules: never hand-edit generated files. After source-annotation changes run `build_runner build --delete-conflicting-outputs`; after translation changes run the `easy_localization:generate` command (both source + regen in the same commit); after route changes regenerate `app_router.gr.dart`. Every PR changing a source annotation commits the regenerated file (else fails review). `.dart_tool/build/` stays gitignored. Split enormous regen diffs (e.g. major-version bumps) into a chore commit.

---

## 26. Build Flavors

Three flavors — **dev / staging / prod** — each with its own app id, base URL, Firebase project, signing.

```
android/app/src/{dev,staging,prod,main}/   (app_name "Biker Dev" / "Biker Staging" / "Biker")
ios/Runner/Firebase/{Dev,Staging,Prod}/GoogleService-Info.plist
ios/Flutter/{Dev,Staging,Prod}.xcconfig
lib/{main.dart (never run directly), main_dev.dart, main_staging.dart, main_prod.dart}
```

- Single source of truth: `flavorizr.yaml` (run `flutter pub run flutter_flavorizr`, commit result — don't hand-edit generated Gradle/Xcode). Each `main_<flavor>.dart` calls `bootstrap(flavor:)` → loads `.env.<flavor>`, `Firebase.initializeApp(firebaseOptionsFor(flavor))`, `configureDependencies(env:)`, `runApp(BikerApp())`.
- Run: `flutter run --flavor dev -t lib/main_dev.dart` (etc.). Add IDE launch configs per flavor.
- App ids: `com.example.riderdelivery.dev`, `com.example.riderdelivery.staging`, `com.example.riderdelivery` (same iOS bundle ids). `--dart-define` is for ad-hoc compile-time overrides, not flavoring.
- Touching `flavorizr.yaml` → regenerate, run all three flavors, document in `docs/01` §9. A new flavor needs: yaml update + regen, `main_<x>.dart`, `.env.<x>`, Firebase configs, walkthrough, `docs/01` §9.

---

## 27. Platform Channels & Native Interop

For capabilities not pure-Dart (foreground service, CarPlay/Android Auto, custom location, scanner/logistics SDKs) use `MethodChannel`/`EventChannel`.

```
lib/core/platform/{biker_platform.dart (abstract), biker_platform_method_channel.dart}
android/app/src/main/kotlin/com/example/riderdelivery/platform/BikerMethodChannelHandler.kt
ios/Runner/Platform/BikerMethodChannelHandler.swift
```

- Dart side = abstract `BikerPlatform` + default method-channel impl (tests inject a fake). Channels namespaced `com.example.riderdelivery/<feature>` (e.g. `/foreground_location`, `/scanner`) — name as a `const` in the abstract class, never inline. Method names = camelCase `const`s on both sides.
- Args = plain `@JsonSerializable` classes → `Map<String, dynamic>` (no freezed, no arbitrary `Object`). Errors flow as `PlatformException` → caught and converted to a `PlatformError` subclass of `Errors`, surfaced via `Future<ApiResult<T>>`. One channel per feature.
- Foreground/background: Android services declare `android:foregroundServiceType` (`location`/`dataSync`); iOS background modes in `Info.plist` only with justification (review flags). Legacy `../BikerAndroid/` is the reference — port behaviour, rewrite in idiomatic modern Kotlin/Swift. Test `BikerPlatform` via `MockBikerPlatform` (`dependency_overrides`); native tested manually.

---

## Quick Reference — Mandatory Actions Per Task

All task types require **Plan & Approval**, a **Commit**, a **Walkthrough**, and a **Docs Update**. The table covers the conditional extras.

| Task | Theme+a11y | API | Catalogue | Shimmer | Optimistic | Codegen | Tests |
| --- | --- | --- | --- | --- | --- | --- | --- |
| New feature/screen | ✅ | ✅ | ✅ Update | ✅ | if mutating | DI+routes | ≥70 % |
| New widget | ✅ | if used | ✅ Add | if fetching | if mutating | — | ≥70 % |
| Modified widget | ✅ | if changed | ✅ Update | if fetching | if mutating | — | ≥70 % |
| New UseCase/Mapper | — | if new endpoint | — | — | — | injectable | ≥70 % |
| New form | ✅ | ✅ | ✅ Add | if fetching | ✅ | — | ≥70 % |
| New endpoint | — | ✅ Postman | — | — | — | Retrofit+JSON | Integration |
| New analytics event | — | — | — | — | — | — | ✅ |
| New route/deep link | — | — | — | — | — | auto_route | ✅ |
| New DI binding/module | — | — | — | — | — | injectable | ✅ |
| New storage key | — | — | — | — | — | — | ✅ |
| New bus event | — | — | — | — | — | — | ✅ |
| New translation key | — | — | — | — | — | easy_loc | — |
| New platform channel | — | — | — | — | — | — | ✅ Mock |
| New flavor | — | — | — | — | — | flavorizr | All flavors |
| Bug fix | if UI | if API | if changed | if affected | if affected | if source ann. | Regression |
| Refactor | if UI | if API surface | if changed | if affected | if affected | if source ann. | ≥70 % |
| New shared utility | — | — | — | — | — | — | ≥70 % |
| Native Android/iOS | if UI | — | if affected | — | — | — | ✅ |
| Secret/env change | — | — | — | — | — | — | — |
| Question → change | if UI | if API | if changed | if affected | if affected | if source ann. | if code changed |

Auth Interceptor / Auth Gate / Notifications / Caching apply per the relevant section whenever the task touches authed requests, gated routes, user feedback, or read-heavy data respectively.
