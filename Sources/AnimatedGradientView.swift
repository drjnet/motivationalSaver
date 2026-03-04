// AnimatedGradientView.swift
// MotivationalScreensaver

import AppKit
import QuartzCore

final class AnimatedGradientView: NSView {

    private var baseLayer:  CAGradientLayer!
    private var orbLayer1:  CAGradientLayer!
    private var orbLayer2:  CAGradientLayer!
    private var shiftLayer: CAGradientLayer!

    private let palettes: [[[CGFloat]]] = [
        [[0.11, 0.00, 0.30, 1], [0.06, 0.04, 0.45, 1], [0.02, 0.04, 0.22, 1], [0.01, 0.01, 0.10, 1]],
        [[0.00, 0.28, 0.38, 1], [0.00, 0.18, 0.30, 1], [0.01, 0.08, 0.18, 1], [0.00, 0.04, 0.10, 1]],
        [[0.35, 0.04, 0.18, 1], [0.22, 0.02, 0.20, 1], [0.12, 0.01, 0.14, 1], [0.05, 0.00, 0.06, 1]],
        [[0.00, 0.26, 0.18, 1], [0.00, 0.16, 0.14, 1], [0.01, 0.09, 0.10, 1], [0.00, 0.04, 0.06, 1]],
        [[0.22, 0.06, 0.40, 1], [0.14, 0.04, 0.30, 1], [0.08, 0.02, 0.18, 1], [0.03, 0.01, 0.08, 1]],
        [[0.28, 0.12, 0.02, 1], [0.20, 0.08, 0.01, 1], [0.10, 0.04, 0.01, 1], [0.04, 0.02, 0.00, 1]],
    ]

    private var currentPaletteIndex = 0

    override init(frame: NSRect) { super.init(frame: frame); setup() }
    required init?(coder: NSCoder) { super.init(coder: coder); setup() }

    private func setup() {
        wantsLayer = true
        layer?.backgroundColor = NSColor.black.cgColor

        baseLayer = CAGradientLayer()
        baseLayer.type = .axial
        baseLayer.startPoint = CGPoint(x: 0, y: 1)
        baseLayer.endPoint   = CGPoint(x: 1, y: 0)
        baseLayer.locations  = [0, 0.55, 1]
        layer?.addSublayer(baseLayer)

        orbLayer1 = CAGradientLayer()
        orbLayer1.type       = .radial
        orbLayer1.startPoint = CGPoint(x: 0.72, y: 0.28)
        orbLayer1.endPoint   = CGPoint(x: 1.30, y: 1.20)
        orbLayer1.opacity    = 0.55
        layer?.addSublayer(orbLayer1)

        orbLayer2 = CAGradientLayer()
        orbLayer2.type       = .radial
        orbLayer2.startPoint = CGPoint(x: 0.28, y: 0.72)
        orbLayer2.endPoint   = CGPoint(x: -0.30, y: -0.20)
        orbLayer2.opacity    = 0.40
        layer?.addSublayer(orbLayer2)

        shiftLayer = CAGradientLayer()
        shiftLayer.type      = .axial
        shiftLayer.startPoint = CGPoint(x: 0, y: 0)
        shiftLayer.endPoint   = CGPoint(x: 1, y: 1)
        shiftLayer.opacity   = 0.18
        layer?.addSublayer(shiftLayer)

        applyPalette(currentPaletteIndex, animated: false)
    }

    override func layout() {
        super.layout()
        [baseLayer, orbLayer1, orbLayer2, shiftLayer].forEach { $0?.frame = bounds }
    }

    func startAnimating() { addDriftAnimations() }

    func stopAnimating() {
        [baseLayer, orbLayer1, orbLayer2, shiftLayer].forEach { $0?.removeAllAnimations() }
    }

    func nextColorScheme() {
        currentPaletteIndex = (currentPaletteIndex + 1) % palettes.count
        applyPalette(currentPaletteIndex, animated: true)
    }

    private func color(_ rgba: [CGFloat]) -> CGColor {
        NSColor(red: rgba[0], green: rgba[1], blue: rgba[2], alpha: rgba[3]).cgColor
    }

    private func applyPalette(_ index: Int, animated: Bool) {
        let p = palettes[index % palettes.count]

        CATransaction.begin()
        CATransaction.setAnimationDuration(animated ? 3.5 : 0)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeInEaseOut))

        baseLayer.colors = [color(p[0]), color(p[2]), color(p[3])]

        let orb1Bright = NSColor(red: p[1][0]*1.6, green: p[1][1]*1.6, blue: p[1][2]*1.6, alpha: 0.85).cgColor
        orbLayer1.colors = [orb1Bright, color([p[1][0], p[1][1], p[1][2], 0])]

        let orb2Bright = NSColor(red: p[0][0]*1.4, green: p[0][1]*1.4, blue: p[0][2]*1.4, alpha: 0.70).cgColor
        orbLayer2.colors = [orb2Bright, color([p[0][0], p[0][1], p[0][2], 0])]

        shiftLayer.colors = [color(p[1]), color(p[3])]

        CATransaction.commit()
    }

    private func addDriftAnimations() {
        func drift(from: CGPoint, to: CGPoint, duration: Double, key: String, layer: CAGradientLayer) {
            let anim            = CABasicAnimation(keyPath: key)
            anim.fromValue      = from
            anim.toValue        = to
            anim.duration       = duration
            anim.autoreverses   = true
            anim.repeatCount    = .infinity
            anim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            layer.add(anim, forKey: key)
        }

        drift(from: CGPoint(x: 0.00, y: 1.00), to: CGPoint(x: 0.15, y: 0.85),
              duration: 10, key: "startPoint", layer: baseLayer)
        drift(from: CGPoint(x: 1.00, y: 0.00), to: CGPoint(x: 0.85, y: 0.15),
              duration: 10, key: "endPoint",   layer: baseLayer)
        drift(from: CGPoint(x: 0.72, y: 0.28), to: CGPoint(x: 0.60, y: 0.40),
              duration: 14, key: "startPoint", layer: orbLayer1)
        drift(from: CGPoint(x: 0.28, y: 0.72), to: CGPoint(x: 0.40, y: 0.60),
              duration: 18, key: "startPoint", layer: orbLayer2)
    }
}
