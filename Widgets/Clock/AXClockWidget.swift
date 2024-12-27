//
//  AXClockWidget.swift
//  AXDashboard
//
//  Created by Ashwin Paudel on 2024-12-27.
//

import AXWidgetKit
import AppKit
import SwiftUI

class AXClockWidget: AXView {
    let clockFaceColor = NSColor.systemGray.withAlphaComponent(0.2)
    let clockHandColor = NSColor.systemBlue
    let textColor = NSColor.labelColor
    let timerInterval: TimeInterval = 1.0

    var timer: Timer?

    public override var name: String {
        "Clock Widget"
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        startTimer()

        wantsLayer = true
        if let layer {
            layer.borderColor = NSColor.black.cgColor
            layer.borderWidth = 1.0
            layer.shadowColor = NSColor.black.cgColor
            layer.shadowOpacity = 0.5
            layer.shadowRadius = 5.0
            layer.shadowOffset = CGSize(width: 0, height: -3)
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        startTimer()
    }

    deinit {
        //timer?.invalidate()
    }

    func startTimer() {
        timer = Timer.scheduledTimer(
            timeInterval: timerInterval, target: self,
            selector: #selector(updateClock), userInfo: nil, repeats: true)
    }

    @objc func updateClock() {
        needsDisplay = true
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        drawClockFace()
        drawClockHands()
        drawDigitalTime()
    }

    func drawClockFace() {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2 - 20
        let path = NSBezierPath(
            ovalIn: NSRect(
                x: center.x - radius, y: center.y - radius, width: 2 * radius,
                height: 2 * radius))
        clockFaceColor.setFill()
        path.fill()

        let context = NSGraphicsContext.current?.cgContext
        context?.saveGState()
        context?.translateBy(x: center.x, y: center.y)

        for i in 0..<12 {
            let angle = CGFloat(i) * .pi / 6
            let numberPosition = CGPoint(
                x: cos(angle) * radius * 0.85, y: sin(angle) * radius * 0.85)
            let numberString = NSAttributedString(
                string: "\(i == 0 ? 12 : i)",
                attributes: [
                    .font: NSFont.systemFont(ofSize: 14),
                    .foregroundColor: textColor,
                ])
            numberString.draw(
                at: CGPoint(x: numberPosition.x - 8, y: numberPosition.y - 8))
        }
        context?.restoreGState()
    }

    func drawClockHands() {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2 - 20
        let now = Date()
        let calendar = Calendar.current

        let seconds = CGFloat(calendar.component(.second, from: now))
        let minutes = CGFloat(calendar.component(.minute, from: now))
        let hours = CGFloat(calendar.component(.hour, from: now) % 12)

        let secondAngle = seconds * .pi / 30
        let minuteAngle = minutes * .pi / 30 + secondAngle / 60
        let hourAngle = hours * .pi / 6 + minuteAngle / 12

        // Hour hand
        drawHand(
            center: center, angle: hourAngle, length: radius * 0.5, thickness: 6
        )
        // Minute hand
        drawHand(
            center: center, angle: minuteAngle, length: radius * 0.75,
            thickness: 4)
        // Second hand
        drawHand(
            center: center, angle: secondAngle, length: radius * 0.9,
            thickness: 2, color: .red)
    }

    func drawHand(
        center: CGPoint, angle: CGFloat, length: CGFloat, thickness: CGFloat,
        color: NSColor? = nil
    ) {
        let endPoint = CGPoint(
            x: center.x + cos(angle - .pi / 2) * length,
            y: center.y + sin(angle - .pi / 2) * length)
        let path = NSBezierPath()
        path.lineWidth = thickness
        path.move(to: center)
        path.line(to: endPoint)
        (color ?? clockHandColor).setStroke()
        path.stroke()
    }

    func drawDigitalTime() {
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        let timeString = formatter.string(from: now)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.monospacedSystemFont(ofSize: 18, weight: .regular),
            .foregroundColor: textColor,
        ]
        let attributedString = NSAttributedString(
            string: timeString, attributes: attributes)
        let size = attributedString.size()
        let rect = CGRect(
            x: bounds.midX - size.width / 2, y: bounds.minY + 10,
            width: size.width, height: size.height)
        attributedString.draw(in: rect)
    }
}

//    public var name: String {
//        return "Sample Widget"
//    }
//
//    public func widgetDidAppear() {
//        print("\(name) appeared")
//    }
//
//    public func widgetDidDisappear() {
//        print("\(name) disappeared")
//    }
//
//    public override init(frame frameRect: NSRect) {
//        super.init(frame: frameRect)
//
//        let label = NSTextField(labelWithString: "Hello from SampleWidget!")
//        label.alignment = .center
//        label.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(label)
//
//        NSLayoutConstraint.activate([
//            label.centerXAnchor.constraint(equalTo: centerXAnchor),
//            label.centerYAnchor.constraint(equalTo: centerYAnchor)
//        ])
//
//        wantsLayer = true
//        layer?.backgroundColor = .black
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

//class AXClockWidget: NSView, @preconcurrency AXWidget {
//    var name: String = "Clock"
//
//    private var isDragging = false
//    private var isResizing = false
//    private var initialMouseLocation: NSPoint = .zero
//    private var initialFrame: NSRect = .zero
//
//    func widgetDidAppear() {
//        // Start Timer
//    }
//
//    func widgetDidDisappear() {
//        // Save current date and stop timer.
//    }
//
//    let timeLabel: NSTextField = {
//        let label = NSTextField(labelWithString: "00:00:00")
//        label.font = .systemFont(ofSize: 12, weight: .semibold)
//        label.textColor = .white
//        return label
//    }()
//
//    init() {
//        super.init(frame: .zero)
//
//        timeLabel.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(timeLabel)
//        timeLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        timeLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//
//        wantsLayer = true
//        self.layer?.backgroundColor = NSColor.black.cgColor
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func mouseDown(with event: NSEvent) {
//        let clickLocation = convert(event.locationInWindow, from: nil)
//        initialMouseLocation = event.locationInWindow
//        initialFrame = self.frame
//
//        // Determine whether the user is dragging or resizing
//        if clickLocation.y > bounds.height - 25 {
//            isDragging = true
//            isResizing = false
//        } else if clickLocation.x > bounds.width - 10 || clickLocation.y < 10 {
//            isDragging = false
//            isResizing = true
//        } else {
//            isDragging = false
//            isResizing = false
//        }
//    }
//
//    override func mouseDragged(with event: NSEvent) {
//        guard let superview = self.superview else { return }
//        let currentLocation = event.locationInWindow
//
//        if isDragging {
//            // Handle dragging
//            let deltaX = currentLocation.x - initialMouseLocation.x
//            let deltaY = currentLocation.y - initialMouseLocation.y
//
//            let newOrigin = NSPoint(
//                x: min(max(0, initialFrame.origin.x + deltaX), superview.bounds.width - frame.width),
//                y: min(max(0, initialFrame.origin.y + deltaY), superview.bounds.height - frame.height)
//            )
//
//            self.frame.origin = newOrigin
//        } else if isResizing {
//            // Handle resizing
//            let deltaX = currentLocation.x - initialMouseLocation.x
//            let deltaY = currentLocation.y - initialMouseLocation.y
//
//            let newWidth = max(50, initialFrame.size.width + deltaX)
//            let newHeight = max(50, initialFrame.size.height - deltaY)
//
//            self.frame = NSRect(
//                x: initialFrame.origin.x,
//                y: initialFrame.origin.y + (initialFrame.size.height - newHeight),
//                width: newWidth,
//                height: newHeight
//            )
//        }
//    }
//
//    override func mouseUp(with event: NSEvent) {
//        // Reset dragging and resizing states
//        isDragging = false
//        isResizing = false
//    }
//}
