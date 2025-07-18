# Detailed Code Review of `/lib`

## 1. Logic and Correctness Issues

### 1.1 Task sorting and rendering (`screens/home_screen.dart`)
- `ListView.builder` sets `itemCount: tasks.length` but pulls data from `sortedTasks[index]`. If filtering is added later the counts can diverge. Use `itemCount: sortedTasks.length`.

### 1.2 `TaskBloc.toggleTaskStatus`
- `task.copyWith(completed: event.completed ?? false)` forces `completed` to `false` when the event value is `null`. Prefer `completed: event.completed ?? task.completed` or make the event field non nullable.

### 1.3 DTO and JSON key mismatch (`models/task.dart`)
- `toMap()` produces camelCase keys `createdAt` and `dueDate` but the backend expects `created_at` and `due_date`. Align the keys or introduce a dedicated `toJson`.

### 1.4 Hard coded empty token path
- `AddTaskScreen._addTask` sends `''` as the token when the user is unauthenticated which leads to a 401. Redirect to login or surface a clear auth error instead.

### 1.5 Race condition on startup
- `AuthBloc` may emit `AuthAuthenticated` before `TaskBloc` is created. The initial `LoadTasks` event can be lost. Create `TaskBloc` earlier or let `TaskBloc` subscribe to `AuthBloc`.

---

## 2. Cross Platform and Runtime Exceptions

### 2.1 Localhost URLs
- On devices the loopback address differs. Use `10.0.2.2` on Android emulators, keep `127.0.0.1` for iOS simulators, or inject the base URL per build flavor.

### 2.2 `flutter_secure_storage` availability
- Not supported on Linux, Windows, or Web by default. Provide a fallback such as `shared_preferences` or wrap calls with a platform check.

### 2.3 Date parsing and time zones
- Parsing an ISO-8601 string without a zone then calling `toLocal()` can move the date. Store dates as UTC and format on display.

---

## 3. Flexibility and Extensibility

### 3.1 Repository layer
- The current flow is UI -> Bloc -> Service. Introduce a `TodoRepository` that manages caching, offline mode, and multiple data sources so new features land in one place.

### 3.2 Dependency injection
- Services are created ad hoc. Use `RepositoryProvider`, `get_it`, or Riverpod so that tests can inject mocks and the base URL can be swapped easily.

### 3.3 Validation
- No client-side validation for empty titles, priority range, or date format. A `FormCubit` with `formz` makes it straightforward to add rules.

### 3.4 Shared enum and constants
- `TaskSortType` lives inside `HomeScreen`. Move it to `models/` so other views can reuse it and the sort preference can be persisted.

---

## 4. DRY and Design-Pattern Adherence

### 4.1 Duplicate token retrieval
- Widgets repeatedly call `AuthStorage.getToken()`. Since `AuthAuthenticated` already holds the token, Blocs and widgets can read it from `context.read<AuthBloc>().state`.

### 4.2 API boilerplate
- Every request repeats headers and error handling. Extract a small helper like `_authorizedRequest()` or switch to `dio` with an auth interceptor.

### 4.3 Bloc event growth
- A single Bloc file with many events will scale poorly. Use the `equatable` package and split responsibilities (pagination, optimistic updates) into smaller Blocs or Cubits.

---

## 5. Unwanted Complexity and Simplifications

### 5.1 `AddTask` event signature
- Seven parameters are hard to maintain. Pass a `TaskDraft` DTO or use a single object parameter with named fields.

### 5.2 Date input UX
- Free-text `YYYY-MM-DD` input is error-prone. Use `showDatePicker` and keep text controllers in a `StatefulWidget` so they can be disposed.

### 5.3 State immutability
- `Task.completed` is mutable. Make all model fields `final` and create a new `Task` on every state change to keep unidirectional data flow intact.

---

## 6. Platform Best Practice Checklist

| Area | Status |
| --- | --- |
| Bloc pattern | ✅ good |
| Localisation | ❌ none. Add the `intl` package |
| Light/dark theme | ⚠ only seed color. Add `ThemeMode.system` |
| Accessibility labels | ❌ none on checkboxes or buttons |
| Responsive layout | ❌ no `LayoutBuilder` or breakpoints |
| Null-safety | ✅ enabled |
| Tests | ❌ only the template widget test |

---

## 7. Quick-win Recommendations
1. Make the API base URL injectable.
2. Add a `RepositoryProvider` and repository classes.
3. Refactor `Task` to be fully immutable and fix the JSON keys.
4. Stop fetching the token in widgets; use the value already stored in `AuthBloc`.
5. Add form validation and a date picker to `AddTaskScreen`.
6. Write at least one golden widget test (`TaskTile`) and a bloc unit test (`TaskBloc` handling `ToggleTaskStatus`).
7. Switch to `dio` or `chopper` to remove repetitive HTTP code.

Overall the intern demonstrates a solid grasp of Flutter and Bloc fundamentals. Addressing the points above will move the codebase from "works on my machine" toward production readiness. 
