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
- Settings supports English and Arabic (full RTL layout), plus System, Light and Dark appearance. Language and appearance persist across restarts.
- Login and refresh tokens use `flutter_secure_storage` only: Android Keystore-backed encryption and iOS Keychain. Android backup is disabled; all iOS build configurations reference the Keychain entitlement. Tokens and passwords are never logged or written to SQLite.
- Startup checks for a saved secure token, including offline. Session restoration does not parse JWT claims or make refresh requests. Logout clears both secure tokens.
- Loading indicators, empty states, image fallbacks and error Retry controls prevent blank content on failed requests.

## Verification

```sh
flutter analyze
flutter test --concurrency=1
flutter build apk --debug
```

Tests cover page boundaries, refresh/retry, cached offline startup, favourite persistence and failed writes, token saving/restoration/logout, invalid credentials, Arabic layout direction and navigation.

On a device, load at least two pages and save a favourite, then enable airplane mode, close/reopen the app, and verify the cached list and offline banner. Cached thumbnails are available only after their download completed. Reconnect, pull to refresh, switch to Arabic in Settings, restart, and verify the mirrored navigation and saved language. Test Keychain persistence on a signed iOS build and Keystore persistence on Android.

Products has Search and Scanner actions. Search waits 350 ms after typing and uses the product search API with 20-item pages; cached products remain searchable offline. Product taps open a detail page with cached fallback and a swipeable image gallery.

Scanner opens `catalogue://product/3` and `catalogue://product/15` automatically after camera capture. Camera access starts only after tapping Start camera; opening the scanner or using Type code instead does not request permission. Denied permission shows an explanation, Open settings and Retry. Return from settings and tap Retry. Invalid codes show `This QR code is not a product.` and a missing product (such as `catalogue://product/9999`) shows `Product not found.` with Retry. Numeric IDs and already cached barcodes/SKUs also work. Unrelated URLs stay on the scanner with an error.

## Native scanner integration test

The supplied QR image is retained at `integration_test/fixtures/test_qr_codes.png` and declared as a small Flutter asset for repeatable device testing. The integration test uses the native scanner to decode all four QR codes, then exercises their manual-entry navigation on Android with a deterministic API fixture.

```powershell
flutter test integration_test/scanner_device_test.dart -d emulator-5554
```

Replace the device ID with one from `flutter devices`. Camera permission dialogs and live physical-camera capture should also be checked on real Android and iOS devices. Native photo decoding is unavailable in the iOS simulator; manual entry works there.

## Structure and libraries

- `lib/core`: API client, secure session, SQLite cache, language, errors and theme.
- `lib/features`: each screen has a view and a Provider ChangeNotifier view model; products also defines the shared product model.
- `lib/l10n`: English/Arabic ARB sources and generated localization classes.
- `test`: logic and widget tests with in-memory API/storage fixtures.
- `integration_test`: native scanner decoding and Android navigation checks.
- `android` / `ios`: native configuration and a small platform channel to open app settings.

Provider keeps presentation state separate from widgets. Dio handles HTTP and search cancellation. SQLite (`sqflite`) persists public product data, images and favourites. `flutter_secure_storage` stores credentials in platform secure storage. `mobile_scanner` supplies native QR decoding and camera lifecycle handling. Flutter localization/intl provides translations and RTL direction. `integration_test` runs the native plugin tests on a device.

## Assignment review and remaining delivery work

See [REQUIREMENTS_AUDIT.md](REQUIREMENTS_AUDIT.md) for the full BRD checklist, verification evidence and platform limits. Improvements would include a repository layer instead of shared service state, cancellation for detail requests, broader accessibility checks and signed release builds. Android release signing currently uses the template debug key and must be configured before distribution.

Bonuses: automated UI/integration tests and dark mode. Keep existing Git history, provide the remote repository link, and record Android/iOS screenshots or video including Arabic and offline mode before sending the assignment.

All app color values live in lib/core/app_colors.dart.

