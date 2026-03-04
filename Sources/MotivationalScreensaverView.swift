// MotivationalScreensaverView.swift
// MotivationalScreensaver

import ScreenSaver

private let kBundleID = "com.motivational.screensaver"

@objc(MotivationalScreensaverView)
public class MotivationalScreensaverView: ScreenSaverView {

    private var gradientView:    AnimatedGradientView!
    private var cardView:        NSView!
    private var categoryLabel:   NSTextField!
    private var dividerLine:     NSView!
    private var quoteLabel:      NSTextField!
    private var authorLabel:     NSTextField!

    private var quotes:           [Quote] = []
    private var currentIndex:     Int     = 0
    private var rotationTimer:    Timer?
    private var configController: ConfigurationSheetController?

    private var ssDefaults: UserDefaults? {
        ScreenSaverDefaults(forModuleWithName: kBundleID)
    }

    public override init?(frame: NSRect, isPreview: Bool) {
        super.init(frame: frame, isPreview: isPreview)
        buildUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        buildUI()
    }

    private func buildUI() {
        wantsLayer = true
        animationTimeInterval = 1.0 / 30.0

        gradientView = AnimatedGradientView(frame: bounds)
        gradientView.autoresizingMask = [.width, .height]
        addSubview(gradientView)

        cardView = NSView(frame: .zero)
        cardView.wantsLayer = true
        cardView.layer?.backgroundColor = NSColor.white.withAlphaComponent(0.07).cgColor
        cardView.layer?.cornerRadius    = 20
        cardView.layer?.borderWidth     = 0.5
        cardView.layer?.borderColor     = NSColor.white.withAlphaComponent(0.18).cgColor
        addSubview(cardView)

        categoryLabel = buildTextField(weight: .bold,    alpha: 0.80)
        dividerLine   = NSView(frame: .zero)
        dividerLine.wantsLayer = true
        dividerLine.layer?.backgroundColor = NSColor.white.withAlphaComponent(0.35).cgColor
        quoteLabel    = buildTextField(weight: .light,   alpha: 1.0)
        quoteLabel.maximumNumberOfLines = 0
        quoteLabel.lineBreakMode        = .byWordWrapping
        authorLabel   = buildTextField(weight: .regular, alpha: 0.70)

        [categoryLabel, dividerLine, quoteLabel, authorLabel].forEach { addSubview($0) }

        quotes = Quote.fallbackQuotes.shuffled()
        fetchQuotes()
    }

    private func buildTextField(weight: NSFont.Weight, alpha: CGFloat) -> NSTextField {
        let f = NSTextField()
        f.isEditable      = false
        f.isBezeled       = false
        f.drawsBackground = false
        f.textColor       = NSColor.white.withAlphaComponent(alpha)
        f.alignment       = .center
        f.alphaValue      = 0
        f.font            = NSFont.systemFont(ofSize: 14, weight: weight)
        let shadow = NSShadow()
        shadow.shadowColor      = NSColor.black.withAlphaComponent(0.40)
        shadow.shadowBlurRadius = 8
        shadow.shadowOffset     = NSSize(width: 0, height: -1)
        f.shadow = shadow
        return f
    }

    public override func layout() {
        super.layout()
        relayout()
    }

    private func relayout() {
        let W = bounds.width, H = bounds.height
        let scale    = min(W, H) / 1080.0
        let quotePt  = clamp(34 * scale, lo: 10, hi: 54)
        let authorPt = clamp(22 * scale, lo:  8, hi: 34)
        let catPt    = clamp(13 * scale, lo:  6, hi: 20)
        let hPad     = W * 0.12
        let contentW = W - hPad * 2
        let lineH: CGFloat = max(1, 1.5 * scale)

        quoteLabel.font    = NSFont(name: "Georgia-Italic", size: quotePt)
            ?? NSFont.systemFont(ofSize: quotePt, weight: .light)
        authorLabel.font   = NSFont.systemFont(ofSize: authorPt, weight: .regular)
        categoryLabel.font = NSFont.systemFont(ofSize: catPt,    weight: .bold)

        let quoteStr = quoteLabel.stringValue.isEmpty ? "\u{201C}Quote\u{201D}" : quoteLabel.stringValue
        let quoteH   = textHeight(quoteStr, font: quoteLabel.font!, width: contentW * 0.85) + quotePt * 0.5

        let blockH = quoteH + authorPt * 3 + catPt * 2.5 + lineH + 28 * scale
        let blockY = (H - blockH) / 2

        let qY = blockY + authorPt * 3 + 14 * scale
        quoteLabel.frame = NSRect(x: hPad * 0.7, y: qY, width: contentW * 1.05, height: quoteH)

        let lineW = clamp(60 * scale, lo: 24, hi: 90)
        let lineY = qY + quoteH + 14 * scale
        dividerLine.frame = NSRect(x: (W - lineW) / 2, y: lineY, width: lineW, height: lineH)

        let catH = catPt * 2.5
        let catY = lineY + lineH + 8 * scale
        categoryLabel.frame = NSRect(x: hPad, y: catY, width: contentW, height: catH)

        let authH = authorPt * 2.5
        let authY = qY - authH - 10 * scale
        authorLabel.frame = NSRect(x: hPad, y: authY, width: contentW, height: authH)

        let cardPad = 32 * scale
        cardView.frame = NSRect(
            x: hPad - cardPad,
            y: authY - cardPad,
            width: contentW + cardPad * 2,
            height: catY + catH - authY + cardPad * 2
        )
    }

    public override func startAnimation() {
        super.startAnimation()
        gradientView.startAnimating()

        let interval = (ssDefaults?.double(forKey: "quoteInterval") ?? 0) > 0
            ? ssDefaults!.double(forKey: "quoteInterval") : 20.0

        showQuote(at: currentIndex, animated: false)

        rotationTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            self?.advance()
        }
    }

    public override func stopAnimation() {
        rotationTimer?.invalidate()
        rotationTimer = nil
        gradientView.stopAnimating()
        super.stopAnimation()
    }

    public override func animateOneFrame() {}

    private func advance() {
        currentIndex = (currentIndex + 1) % max(quotes.count, 1)
        showQuote(at: currentIndex, animated: true)
        gradientView.nextColorScheme()
    }

    private func showQuote(at index: Int, animated: Bool) {
        guard !quotes.isEmpty else { return }
        let q = quotes[index % quotes.count]

        let apply: () -> Void = { [weak self] in
            guard let self = self else { return }
            self.quoteLabel.stringValue    = "\u{201C}\(q.content)\u{201D}"
            self.authorLabel.stringValue   = "\u{2014} \(q.author)"
            self.categoryLabel.stringValue = q.categoryDisplayName
            self.relayout()
        }

        if animated {
            let views: [NSView] = [quoteLabel, authorLabel, categoryLabel, dividerLine, cardView]
            NSAnimationContext.runAnimationGroup({ ctx in
                ctx.duration = 1.2
                ctx.timingFunction = CAMediaTimingFunction(name: .easeIn)
                views.forEach { $0.animator().alphaValue = 0 }
            }) { [weak self] in
                apply()
                NSAnimationContext.runAnimationGroup { ctx in
                    ctx.duration = 1.6
                    ctx.timingFunction = CAMediaTimingFunction(name: .easeOut)
                    self?.quoteLabel.animator().alphaValue    = 1.0
                    self?.authorLabel.animator().alphaValue   = 0.70
                    self?.categoryLabel.animator().alphaValue = 0.80
                    self?.dividerLine.animator().alphaValue   = 0.35
                    self?.cardView.animator().alphaValue      = 1.0
                }
            }
        } else {
            apply()
            quoteLabel.alphaValue    = 1.0
            authorLabel.alphaValue   = 0.70
            categoryLabel.alphaValue = 0.80
            dividerLine.alphaValue   = 0.35
            cardView.alphaValue      = 1.0
        }
    }

    private func fetchQuotes() {
        let cats = selectedCategories()
        QuoteService.shared.fetchQuotes(for: cats) { [weak self] fetched in
            guard let self = self, !fetched.isEmpty else { return }
            self.quotes       = fetched.shuffled()
            self.currentIndex = 0
        }
    }

    private func selectedCategories() -> [QuoteCategory] {
        guard let d = ssDefaults else { return QuoteCategory.allCases }
        let selected = QuoteCategory.allCases.filter { cat in
            let key = "category_\(cat.rawValue)"
            return d.object(forKey: key) == nil ? true : d.bool(forKey: key)
        }
        return selected.isEmpty ? QuoteCategory.allCases : selected
    }

    public override var hasConfigureSheet: Bool { true }

    public override var configureSheet: NSWindow? {
        // Always create a fresh controller — never return a stale cached window.
        let controller = ConfigurationSheetController(defaults: ssDefaults)
        configController = controller   // keep strong reference alive
        return controller.window
    }

    private func clamp(_ value: CGFloat, lo: CGFloat, hi: CGFloat) -> CGFloat {
        Swift.max(lo, Swift.min(hi, value))
    }

    private func textHeight(_ text: String, font: NSFont, width: CGFloat) -> CGFloat {
        let attrs: [NSAttributedString.Key: Any] = [.font: font]
        let rect = (text as NSString).boundingRect(
            with: NSSize(width: width, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: attrs
        )
        return ceil(rect.height)
    }
}
