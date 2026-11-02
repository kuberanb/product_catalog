# Product catalog

Flutter catalog using DummyJSON, Provider, Dio and SQLite. Targets Android and iOS.

## Run

```sh
flutter pub get
flutter gen-l10n
flutter run
```

Demo login: `emilys` / `emilyspass`.

## Behaviour

- Products request `/products?limit=20&skip=0`, then skip 20, 40, etc. Scroll near the end to load another page; pull down to refresh.
- Each product shows a thumbnail, title, USD price, rating and favourite toggle. Favourites save complete product details independently of the current page.
- SQLite stores the latest successful list, downloaded thumbnails, favourites and language. Failed requests preserve visible data. The offline banner updates on requests, app resume and periodic connection checks.
- Settings supports English, Arabic (full RTL layout) and Hindi. Language persists across restarts.
- Login and refresh tokens use `flutter_secure_storage` only: Android Keystore-backed encryption and iOS Keychain. Android backup is disabled; all iOS build configurations reference the Keychain entitlement. Tokens and passwords are never logged or written to SQLite.
- Startup checks for a saved secure token, including offline. Session restoration does not parse JWT claims or make refresh requests. Logout clears both secure tokens.
- Loading indicators, empty states, image fallbacks and error Retry controls prevent blank content on failed requests.

## Verification

```sh
flutter analyze
flutter test
flutter build apk --debug
```

Tests cover page boundaries, refresh/retry, cached offline startup, favourite persistence and failed writes, token saving/restoration/logout, invalid credentials, Arabic layout direction and navigation.

On a device, load at least two pages and save a favourite, then enable airplane mode, close/reopen the app, and verify the cached list and offline banner. Cached thumbnails are available only after their download completed. Reconnect, pull to refresh, switch to Arabic in Settings, restart, and verify the mirrored navigation and saved language. Test Keychain persistence on a signed iOS build and Keystore persistence on Android.

Products has Search and Scanner actions. Search uses the product search API with 20-item pages and can match cached products offline. Product taps open a detail page with cached fallback. Scanner supports camera barcode/QR capture and manual input; product IDs, product URLs and saved barcodes open details, while other text opens Search. Camera errors provide Retry and manual entry.

All app color values live in lib/core/app_colors.dart.
