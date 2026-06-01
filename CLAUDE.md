# Spider Restaurant — AI Workspace Rules

Project Root: `C:\Users\Qeema\Documents\flutter\qeema_tech\spider-restaurant`

---

## Workspace Safety (Highest Priority)

1. NEVER use git worktrees, temporary mirrors, detached copies, sandbox clones, or `.claude/projects/` directories.
2. NEVER modify files outside the original project root.
3. ALL edits, deletions, refactors, file creations, and analysis must happen directly in the real source project.
4. Before ANY file modification:
   * print the current working directory
   * verify it matches the project root
5. If the current workspace is not the original project root:
   * STOP immediately
   * refuse to modify files
   * ask to reopen the correct workspace
6. After every task:
   * run `git status`
   * show modified/deleted files
   * confirm changes affected the original project only
7. Never silently switch environments or create hidden working copies.
8. All future refactors must persist directly to the real repository files.

---

## Architecture Rules

- Use **Clean Architecture** only (Data → Domain → Presentation)
- Follow **SOLID principles** at all times
- Use **Cubit/BLoC** for state management (flutter_bloc + Equatable)
- Use `dartz` Either<Failure, T> pattern for error handling in repositories and use cases
- Use `get_it` for dependency injection via the service locator
- Prefer **feature-first** folder structure (`lib/features/{feature}/data|domain|presentation`)
- Keep **UI separated from business logic** — never put business logic in widgets/pages
- Preserve existing architecture patterns when adding new code

## Code Quality Rules

- Never create **duplicate** layers, files, classes, or error systems
- Never duplicate models/entities — check for existing ones first
- **Reuse** existing widgets/components before creating new ones
- Always check for existing implementations before adding new files
- Delete unused/dead code after refactors
- Use **Equatable** for state and entity comparison
- Use **const constructors** whenever possible
- Keep imports clean and consistent (prefer `package:` style for internal imports)
- Use `easy_localization` for all user-facing strings — no hardcoded strings if localization exists
- Never break existing API contracts
- Do not modify generated files (`.g.dart`, `.freezed.dart`)
- Add clear comments only when necessary (don't comment the obvious)
- Keep naming consistent across layers (e.g., `XxxRepository` in domain, `XxxRepositoryImpl` in data)

## Code Size Rules

- **Maximum 200 lines** per screen/page/widget class
- **Maximum 300 lines** per file
- If a screen exceeds 200 lines, split it into smaller widgets/components
- Extract reusable sections into separate widgets
- Extract business logic out of UI files into Cubits/UseCases
- Avoid massive `build()` methods — prefer composition over large monolithic widgets

## Testing Rules

- Run `flutter analyze` after every major refactor
- Write unit tests for Cubits, UseCases, and Repositories
- Use `mocktail` or `mockito` for mocking dependencies
- Maintain test structure that mirrors the `lib/` feature structure

## Networking Rules

- Use the existing `ApiClient` Dio singleton for all HTTP calls
- Use `ApiConstants` for all endpoint paths — never hardcode URLs
- Use the existing interceptor chain (AuthInterceptor, LanguageInterceptor, LoggingInterceptor)
- Datasources throw exceptions → Repositories catch and convert to Either<Failure, T>

## State Management Rules

- Each feature has its own Cubit(s)
- States extend Equatable with proper `props`
- Use BlocConsumer (listener + builder) in pages
- Create Cubits via `BlocProvider(create: ...)` — never create in `initState()`
- Always check `isClosed` before emitting states after async operations
