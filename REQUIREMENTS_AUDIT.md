# Product Catalogue BRD implementation review

Reviewed on 2 November 2026 against the supplied Business Requirements Document and its four QR examples. “Implemented” describes source behavior; test evidence below distinguishes automated fixtures from physical device verification.

| Requirement | Implementation and evidence | Status |
| --- | --- | --- |
| Android and iOS apps | Flutter platform projects, Android camera declaration, iOS camera usage description, Keychain entitlements and CocoaPods configuration | Android build verification in progress; iOS build/device verification requires macOS |
| Login, wrong credentials, saved session, Logout | LoginViewModel, SessionService, secure token restoration; auth and widget tests | Implemented, automated tests pass |
| Secure token and Bearer header | flutter_secure_storage only; ApiService interceptor attaches Bearer token; no token/password logging or SQLite storage | Implemented; secure storage mocked in tests; real Keychain/Keystore restart check remains |
| Bottom tabs | Products, Favourites, Settings; navigation and widget tests | Implemented, automated tests pass |
| Product image, title, price, rating | ProductTile and ProductImage with loading/failure fallback | Implemented |
| Pagination in groups of 20 | API limit=20, skip=0/20/40, scroll loading and refresh offset reset | Implemented, logic and widget tests pass |
| Pull to refresh | RefreshIndicator on a scrollable product list, including empty state | Implemented |
| Debounced API search | 350 ms timer, cancellation of obsolete requests, paginated API results and offline matches | Implemented, debounce and search tests pass |
| Product detail | Image gallery, price, rating, optional brand, category, description, favourite button; downloaded details cached | Implemented; added full image gallery and image cache round-trip test |
| Missing brand | Null/missing brand becomes an empty string and its row is omitted | Implemented, logic test passes |
| Persistent favourites | SQLite saves full products and restores them; failed writes retain current state and Retry reattempts | Implemented, persistence and failure tests pass using a storage fixture |
| Product QR navigation | catalogue://product/{positive integer}; camera capture submits automatically and repeated frames do not push another route | Fixed; parsing, capture and navigation tests pass |
| Permission requested on Scan only | Camera widget is absent until Start camera; scanner page and manual entry never initialize a camera | Implemented, widget test verifies deferred mounting |
| Denied permission and settings | Localized explanation, Retry and Open settings; Android app details settings / iOS app settings via native channel; failure message if settings cannot open | Implemented, denial UI/channel unit test passes; real OS permission dialog remains a device check |
| Wrong codes | Unrelated URLs and malformed product links show “This QR code is not a product.”; no Search redirect | Fixed, parsing and widget tests pass |
| Type code instead | Visible button stops capture and focuses manual input; works without a camera | Implemented, manual entry widget tests pass |
| Offline products and banner | Last successful list, downloaded thumbnails, offline banner, Retry and cached product scan fallback | Implemented; cached restart and retry logic tests pass; airplane-mode OS check remains |
| Arabic language and full RTL | English/Arabic localization delegates and persisted locale; route-level and bottom navigation RTL tests; Settings language label now localized | Implemented, widget tests pass |
| Loading, empty, error, Retry | Login/session, products, search, details, favourites, settings persistence and camera errors have applicable states; product/image errors offer Retry | Implemented; automated coverage includes principal failure paths |
| At least three logic tests | Authentication, search, details, pagination, offline, favourites, parsing and product model tests | Implemented, exceeds minimum |
| README | Run instructions, structure, libraries/reasons, verification, improvements, bonus features, hours caveat | Updated; actual original development hours still need to be supplied |
| Git repository and full history | Existing commits preserved | Remote submission link and submission remain owner tasks |
| iOS and Android screenshots/video including Arabic and offline | Not yet recorded | Outstanding delivery requirement |
| Optional bonuses | Automated UI/widget tests and native scanner integration test | UI tests implemented; native integration verification in progress; no other bonuses claimed |

## Supplied QR acceptance cases

| Code in the supplied image/document | Expected behavior | Automated result |
| --- | --- | --- |
| `catalogue://product/3` | Open product 3 | Pass with deterministic API fixture |
| `catalogue://product/15` | Open product 15 | Pass with deterministic API fixture |
| `catalogue://product/9999` | “Product not found.” | Pass using an HTTP 404 fixture |
| `https://example.com` | “This QR code is not a product.” | Pass; remains on scanner |

The native integration test decodes the actual supplied PNG using mobile_scanner, then tests the four navigation cases on an Android device. Its API responses are deterministic fixtures; it does not establish availability of the live DummyJSON service. The real camera permission sheet and optical capture from a physical camera require a device test.

## Recorded verification results

- `flutter analyze`: no issues found.
- `flutter test --concurrency=1`: all 37 tests passed. Initial parallel reruns exceeded the host's Windows memory/paging limit; the completed serial run passed after releasing memory held by stopped Gradle processes.
- Separate live DummyJSON API checks: demo login succeeded, product IDs 3 and 15 returned their matching IDs, and product 9999 returned HTTP 404. The login token was neither printed nor saved by this check.
- Native QR-image integration run: in progress.
- Android production-entry debug build: pending the native integration run.
- iOS build, signed device checks and submission screenshots/video: outstanding.

## Verification commands

```sh
flutter gen-l10n
flutter analyze
flutter test --concurrency=1
flutter build apk --debug
```

```powershell
flutter test integration_test/scanner_device_test.dart -d emulator-5554
```

## Device acceptance checklist

1. Fresh install: sign in, open Scanner, confirm no camera prompt until Start camera. Deny access and check explanation, Open settings, Retry, and manual entry. Grant access in settings, return and tap Retry.
2. Point the physical camera at each supplied QR: products 3 and 15 open, 9999 shows Product not found, example.com shows the invalid-code message. Check back navigation and repeated detections.
3. Save a favourite, load at least two pages and open a product detail. Restart with airplane mode enabled. Verify saved session, cached products/details, cached thumbnails, favourites, offline banner and manual cached-product lookup. Reconnect and Retry.
4. Switch to Arabic, verify the entire tab layout, scanner and details mirror RTL, then restart to confirm the preference persists. Verify Logout clears secure session storage.
5. Repeat on a signed iOS build and capture Android/iOS screenshots or video including Arabic and offline mode. Configure production signing before distributing a release.
