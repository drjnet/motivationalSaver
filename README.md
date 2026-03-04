# Motivational Screensaver

A native macOS screensaver that displays rotating motivational quotes over animated abstract gradient backgrounds.

![macOS 12+](https://img.shields.io/badge/macOS-12%2B-blue)
![Swift 5](https://img.shields.io/badge/Swift-5-orange)
![License: MIT](https://img.shields.io/badge/License-MIT-green)

---

## Features

- **Live quotes** fetched from [quotable.io](https://api.quotable.io) — no API key needed
- **Offline fallback** — 50 built-in quotes across all categories if there's no internet
- **5 categories** — Success & Achievement, Mindset & Resilience, Health & Wellness, Leadership & Business, Trading & Investing (toggle any combination)
- **Animated gradients** — fluid dark colour palettes that drift and shift
- **Configurable rotation** — 5 to 60 seconds per quote
- **macOS native** — pure Swift, no dependencies, < 500 KB

---

## Install (for users)

Download the latest `.zip` from the [Releases](../../releases/latest) page and follow [INSTALL.md](INSTALL.md).

---

## Build from source

### Requirements

- macOS 12+
- Xcode 15+

### Steps

```bash
git clone https://github.com/drjnet/motivationalSaver.git
cd motivationalSaver

# Build for current machine (for testing)
./build.sh

# Build universal binary + zip for distribution
./build.sh --universal

# Build and install directly to ~/Library/Screen Savers/
./build.sh --install
```

Or open `MotivationalScreensaver.xcodeproj` in Xcode and press **⌘B**.

---

## Release a new version

Push a version tag and GitHub Actions will build a universal `.saver`, zip it with `INSTALL.md`, and attach it to a new GitHub Release automatically:

```bash
git tag v1.0.0
git push origin v1.0.0
```

---

## Project structure

```
motivationalSaver/
├── Sources/
│   ├── MotivationalScreensaverView.swift   # Main ScreenSaverView subclass
│   ├── AnimatedGradientView.swift          # Animated CAGradientLayer backgrounds
│   ├── ConfigurationSheetController.swift  # Preferences panel
│   ├── QuoteService.swift                  # Fetches quotes from quotable.io
│   └── Models.swift                        # Quote / QuoteCategory types
├── Resources/
│   ├── Info.plist
│   ├── MotivationalScreensaver.entitlements
│   └── thumbnail.png                        # Screensaver preview image
├── assets/
│   └── thumb1.png                           # Source image for thumbnail
├── MotivationalScreensaver.xcodeproj/
├── .github/workflows/release.yml          # CI/CD: auto-build on git tag
├── build.sh                                # Local build helper
└── INSTALL.md                              # End-user install guide
```

---

## License

MIT — do whatever you like with it.
