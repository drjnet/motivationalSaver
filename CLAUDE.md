# Motivational Screensaver — Project Context

## Repo location
This project lives at `/Users/davejenkins/dev/repos/motivationalSaver`.

## Working rules
- **Always update `CHANGELOG.md`** whenever a significant feature, fix, or change is made. Add it under `## [Unreleased]` using Added / Fixed / Changed / Removed sub-sections as appropriate.
- Keep the project structure list and category count below in sync when new categories or files are added.

## What this is
A native macOS screensaver (`.saver` bundle) written in Swift that:
- Fetches live motivational quotes from quotable.io (no API key)
- Displays them over animated abstract gradient backgrounds
- Supports 5 categories: Success, Mindset, Health, Leadership, Trading & Investing
- Has a preferences panel (category toggles, rotation interval, and custom quotes text area)
- Falls back to 50 built-in quotes when offline (10 per category)
- Lets users enter their own quotes in the Settings panel ("My Quotes")

## Project structure
```
Sources/
  MotivationalScreensaverView.swift   # Main ScreenSaverView subclass
  AnimatedGradientView.swift          # CAGradientLayer animated backgrounds
  ConfigurationSheetController.swift  # Preferences panel
  QuoteService.swift                  # Fetches from quotable.io
  Models.swift                        # Quote / QuoteCategory types
Resources/
  Info.plist                          # NSPrincipalClass = MotivationalScreensaverView
  MotivationalScreensaver.entitlements
MotivationalScreensaver.xcodeproj/
  project.pbxproj
  xcshareddata/xcschemes/MotivationalScreensaver.xcscheme
.github/workflows/release.yml        # Auto-builds on git tag push
build.sh                              # Local build/install script
INSTALL.md                            # End-user install guide
CHANGELOG.md                          # Feature/fix history — keep updated
CLAUDE.md                             # This file — project context for Claude
```

## Known gotchas — read before touching these areas

### Options / preferences panel
- **Always create a fresh `ConfigurationSheetController`** inside `configureSheet` — never cache it. macOS Sonoma returns the sheet window via the property every time, so a stale cached controller causes the panel to silently fail to open.
- `done()` and `cancel()` must fall back to `window.close()` when `window.sheetParent` is nil (happens in preview mode).
- The controller is initialised with the view's `ssDefaults` instance so they share exactly one `UserDefaults` object.

### User defaults / `ssDefaults`
- `ssDefaults` **must be a stored `let` property**, not a computed property. A computed property creates a new `ScreenSaverDefaults` instance on every access, which can read stale in-memory values that haven't synced with what the controller just wrote. Storing it once at init time means the view and controller always work with the same object.
- Module name: `kBundleID = "com.motivational.screensaver"` — must match `CFBundleIdentifier` in Info.plist.

### Category filtering
- `selectedCategories()` reads from `ssDefaults`. If it returns `QuoteCategory.allCases`, check that `ssDefaults` is non-nil and that the controller is writing with matching keys (`"category_\(cat.rawValue)"`).
- quotable.io tags are OR-matched; always post-filter API results by `allowedTags` after fetching.
- After updating `quotes` in the `fetchQuotes` callback, call `showQuote(at: 0, animated: true)` so the display refreshes immediately rather than waiting for the next timer tick.

## Key technical details
- macOS 12+ target, Swift 5, no external dependencies
- `NSPrincipalClass` in Info.plist must match ObjC name: `MotivationalScreensaverView`
- `@objc(MotivationalScreensaverView)` annotation on main class
- Ad-hoc code signing (`codesign --sign -`) — no Apple Developer account needed
- GitHub Actions builds universal binary on `v*` tag push
- GitHub remote: git@github.com:drjnet/motivationalSaver.git

## Distribution workflow
1. `git tag v1.x.x && git push origin v1.x.x` triggers GitHub Actions
2. CI builds universal `.saver`, zips with `INSTALL.md`, attaches to GitHub Release
3. Friends download zip, double-click `.saver`, follow INSTALL.md
