# Changelog

All notable changes to Motivational Screensaver are documented here.
Format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

---

## [Unreleased]

### Added
- **My Quotes** — new text area in the Settings panel lets you type your own quotes, one per line. Optional author attribution using `— Author Name` at the end of a line. Custom quotes are stored locally and mixed into the rotation alongside built-in and live quotes.

### Fixed
- **Category selection had no effect** — `ssDefaults` was a computed property, creating a new `ScreenSaverDefaults` instance on every read. The view was reading from an instance that hadn't received the controller's writes. Fixed by making `ssDefaults` a stored `let` property so the view and controller share a single object.
- **Display not refreshing after API fetch** — when live quotes returned from quotable.io, the `quotes` array was updated but `showQuote` was never called. The screen stayed on the old quote until the timer fired. Now calls `showQuote(at: 0, animated: true)` immediately after updating the pool.

---

## [1.1.0] — 2026-02-xx

### Added
- **Trading & Investing category** — 10 built-in quotes (Warren Buffett, Benjamin Graham, Peter Lynch, George Soros, etc.) fetched from quotable.io using the `money` tag.
- **Expanded offline fallbacks** — increased from ~15 to 50 built-in quotes (10 per category) so the screensaver stays rich without internet.

### Fixed
- **Wrong category quotes showing** — categories like LOVE appeared even when not selected because `tags.first` was used blindly. Now scans all tags in priority order to find the best match.
- **Category filter not applied immediately** — switching categories in Settings had no effect until the screensaver restarted. Fixed using `NotificationCenter`; the quote pool refreshes the moment you click Done.
- **API quotes ignoring category filter** — quotable.io returns quotes with multiple tags; the fetched results are now filtered to only those matching your selected categories.
- **Settings panel not opening on macOS Sonoma** — caused by caching a stale `ConfigurationSheetController`. Now always creates a fresh controller when the panel is requested.
- **Done / Cancel buttons unresponsive** — `window.sheetParent` can be nil in preview mode; added `window.close()` fallback so buttons always work.

---

## [1.0.0] — 2026-01-xx

### Added
- Initial release.
- Live quotes from [quotable.io](https://api.quotable.io) — no API key needed.
- 4 categories: Success & Achievement, Mindset & Resilience, Health & Wellness, Leadership & Business.
- Animated dark gradient backgrounds with smooth colour transitions.
- Settings panel: category toggles and quote rotation interval (5–60 s).
- Offline fallback quotes (15 built-in).
- Universal binary build (Apple Silicon + Intel) via GitHub Actions on `v*` tag push.
- Ad-hoc code signing — no Apple Developer account required.
