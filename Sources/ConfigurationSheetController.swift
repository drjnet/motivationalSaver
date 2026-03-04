// ConfigurationSheetController.swift
// MotivationalScreensaver

import AppKit
import ScreenSaver

final class ConfigurationSheetController: NSObject {

    let window: NSWindow
    private let defaults: UserDefaults?
    private var categoryBoxes: [QuoteCategory: NSButton] = [:]
    private var intervalSlider: NSSlider!
    private var intervalValueLabel: NSTextField!

    init(defaults: UserDefaults?) {
        self.defaults = defaults
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 400, height: 370),
            styleMask:   [.titled],
            backing:     .buffered,
            defer:       false
        )
        window.title = "Motivational Screensaver — Options"
        super.init()
        buildUI()
        loadSettings()
    }

    private func buildUI() {
        guard let cv = window.contentView else { return }
        var y: CGFloat = 330

        addLabel("Settings", to: cv, frame: NSRect(x: 20, y: y, width: 360, height: 28),
                 fontSize: 17, bold: true)
        y -= 42

        addLabel("Quote Categories", to: cv, frame: NSRect(x: 20, y: y, width: 360, height: 20),
                 fontSize: 12, bold: true, colour: .secondaryLabelColor)
        y -= 6

        let sep1 = NSBox(frame: NSRect(x: 20, y: y, width: 360, height: 1))
        sep1.boxType = .separator
        cv.addSubview(sep1)
        y -= 28

        for cat in QuoteCategory.allCases {
            let cb = NSButton(checkboxWithTitle: "  \(cat.displayName)",
                              target: self, action: #selector(categoryToggled(_:)))
            cb.frame = NSRect(x: 30, y: y, width: 340, height: 24)
            cb.font  = NSFont.systemFont(ofSize: 13)
            cv.addSubview(cb)
            categoryBoxes[cat] = cb
            y -= 30
        }

        y -= 10

        addLabel("Quote Rotation Interval", to: cv,
                 frame: NSRect(x: 20, y: y, width: 220, height: 20),
                 fontSize: 12, bold: true, colour: .secondaryLabelColor)
        intervalValueLabel = addLabel("20 s", to: cv,
                                       frame: NSRect(x: 300, y: y, width: 80, height: 20),
                                       fontSize: 12, bold: false)
        intervalValueLabel.alignment = .right
        y -= 6

        let sep2 = NSBox(frame: NSRect(x: 20, y: y, width: 360, height: 1))
        sep2.boxType = .separator
        cv.addSubview(sep2)
        y -= 30

        intervalSlider = NSSlider(value: 20, minValue: 5, maxValue: 60,
                                   target: self, action: #selector(sliderMoved(_:)))
        intervalSlider.frame        = NSRect(x: 28, y: y, width: 344, height: 24)
        intervalSlider.isContinuous = true
        cv.addSubview(intervalSlider)
        y -= 12

        addLabel("5 s",  to: cv, frame: NSRect(x: 28,  y: y, width: 40, height: 16),
                 fontSize: 10, bold: false, colour: .tertiaryLabelColor)
        addLabel("60 s", to: cv, frame: NSRect(x: 356, y: y, width: 40, height: 16),
                 fontSize: 10, bold: false, colour: .tertiaryLabelColor).alignment = .right

        let doneBtn = NSButton(title: "Done", target: self, action: #selector(done(_:)))
        doneBtn.bezelStyle    = .rounded
        doneBtn.keyEquivalent = "\r"
        doneBtn.frame         = NSRect(x: 290, y: 14, width: 90, height: 30)
        cv.addSubview(doneBtn)

        let cancelBtn = NSButton(title: "Cancel", target: self, action: #selector(cancel(_:)))
        cancelBtn.bezelStyle = .rounded
        cancelBtn.frame      = NSRect(x: 190, y: 14, width: 90, height: 30)
        cv.addSubview(cancelBtn)
    }

    @discardableResult
    private func addLabel(_ text: String, to view: NSView, frame: NSRect,
                           fontSize: CGFloat, bold: Bool,
                           colour: NSColor = .labelColor) -> NSTextField {
        let lbl = NSTextField(labelWithString: text)
        lbl.frame     = frame
        lbl.font      = bold ? NSFont.boldSystemFont(ofSize: fontSize)
                              : NSFont.systemFont(ofSize: fontSize)
        lbl.textColor = colour
        view.addSubview(lbl)
        return lbl
    }

    private func loadSettings() {
        for (cat, box) in categoryBoxes {
            let key = "category_\(cat.rawValue)"
            let on  = defaults?.object(forKey: key) == nil ? true : (defaults?.bool(forKey: key) ?? true)
            box.state = on ? .on : .off
        }
        let iv = defaults?.double(forKey: "quoteInterval") ?? 20.0
        intervalSlider.doubleValue = iv
        updateIntervalLabel(iv)
    }

    private func saveSettings() {
        for (cat, box) in categoryBoxes {
            defaults?.set(box.state == .on, forKey: "category_\(cat.rawValue)")
        }
        defaults?.set(intervalSlider.doubleValue, forKey: "quoteInterval")
        defaults?.synchronize()
    }

    private func updateIntervalLabel(_ v: Double) {
        intervalValueLabel?.stringValue = "\(Int(v)) s"
    }

    @objc private func categoryToggled(_ sender: NSButton) {
        let anyOn = categoryBoxes.values.contains { $0.state == .on }
        if !anyOn { sender.state = .on }
    }

    @objc private func sliderMoved(_ sender: NSSlider) { updateIntervalLabel(sender.doubleValue) }

    @objc private func done(_ sender: NSButton) {
        saveSettings()
        if let parent = window.sheetParent {
            parent.endSheet(window, returnCode: .OK)
        } else {
            window.close()
        }
    }

    @objc private func cancel(_ sender: NSButton) {
        if let parent = window.sheetParent {
            parent.endSheet(window, returnCode: .cancel)
        } else {
            window.close()
        }
    }
}
