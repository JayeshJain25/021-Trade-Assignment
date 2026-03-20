# 021 Trade — Stock Watchlist

A Flutter app built for the assignment. It shows a stock watchlist where you can drag to reorder stocks and swipe/tap to delete them.

---

## What it does

- View a named watchlist of stocks
- Drag the ≡ handle to reorder any stock
- Tap button to remove a stock from the list

---

## Approach

The app uses **BLoC** for state management with a clean separation between layers:

- **Data layer** — `StockModel` is an immutable value object. `WatchlistRepository` holds an in-memory list seeded with sample stocks and exposes `getStocks()`, `reorder()`, and `remove()`.
- **BLoC layer** — Three events (`WatchlistLoaded`, `WatchlistStockReordered`, `WatchlistStockRemoved`) and four sealed states (`Initial`, `LoadInProgress`, `LoadSuccess`, `LoadFailure`). The BLoC never mutates state directly — it calls the repository and emits a fresh snapshot.
- **Presentation layer** — `WatchlistPage` sets up the `BlocProvider`. A `BlocBuilder` switches on the sealed state, so the compiler enforces every case is handled. The reorderable list uses `ReorderableListView` with custom drag handles and an elevation animation on the dragged item.

The repository is injected into the BLoC via its constructor so it's easy to swap with a mock in tests.

---

## Project structure

```
lib/
├── main.dart
├── core/theme/
│   ├── app_colors.dart     
│   └── app_theme.dart      
└── features/watchlist/
    ├── bloc/
    │   ├── watchlist_event.dart
    │   ├── watchlist_state.dart
    │   └── watchlist_bloc.dart
    ├── data/
    │   ├── models/stock_model.dart
    │   └── repositories/watchlist_repository.dart
    └── presentation/
        ├── pages/watchlist_page.dart
        └── widgets/
            ├── stock_list_item.dart
            ├── watchlist_header.dart
            └── bottom_action_buttons.dart
```

---

## Dependencies

| Package | Use |
|---|---|
| `flutter_bloc` | BLoC state management |
| `equatable` | Value equality for models and state classes |
| `google_fonts` | Inter font |
| `uuid` | Stable IDs for each stock (used as `ValueKey` during reorder) |

---

## Running the app

```bash
flutter pub get
flutter run
```
