# Motivational Screensaver — Project Context

## Repo location
This project lives at `/Users/davejenkins/dev/repos/motivationalSaver`.

## What this is
A native macOS screensaver (`.saver` bundle) written in Swift that:
- Fetches live motivational quotes from quotable.io (no API key)
- Displays them over animated abstract gradient backgrounds
- Supports 4 categories: Success, Mindset, Health, Leadership
- Has a preferences panel (category toggles + rotation interval)
- Falls back to 15 built-in quotes when offline

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
```

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
