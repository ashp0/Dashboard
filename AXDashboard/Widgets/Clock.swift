//
//  Clock.swift
//  AXDashboard
//
//  Created by Baba Paudel on 2024-12-27.
//

import AXWidgetKit
import AppKit

class AXClock: AXWidgetView {
    private var timeLabel: NSTextField!
    private var timer: Timer?

    override var preferredSize: NSSize {
        return .init(width: 500, height: 500)
    }

    override var name: String {
        "Clock"
    }

    required init() {
        super.init()

        setupTimeLabel()
        startUpdatingTime()

        wantsLayer = true
        self.layer?.backgroundColor = NSColor.systemMint.cgColor
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @MainActor required init(style: AXWidgetTitlebarStyle = .hidden) {
        fatalError("init(style:) has not been implemented")
    }

    private func setupTimeLabel() {
        // Create the label (NSTextField)
        timeLabel = NSTextField(labelWithString: "00:00:00")
        timeLabel.font = NSFont.systemFont(ofSize: 24)
        timeLabel.textColor = .white
        timeLabel.alignment = .center
        timeLabel.frame = CGRect(
            x: 0, y: self.bounds.height / 2 - 20, width: self.bounds.width,
            height: 40)

        // Make the label non-editable and remove background
        timeLabel.isEditable = false
        timeLabel.isBezeled = false
        timeLabel.drawsBackground = false

        // Add label to the view
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(timeLabel)

        NSLayoutConstraint.activate([
            timeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    private func startUpdatingTime() {
        // Update the time every second
        timer = Timer.scheduledTimer(
            timeInterval: 1.0, target: self, selector: #selector(updateTime),
            userInfo: nil, repeats: true)
    }

    @objc private func updateTime() {
        // Get the current time and format it
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss"
        let timeString = dateFormatter.string(from: Date())

        // Update the label text with the current time
        timeLabel.stringValue = timeString
    }

    deinit {
        // Invalidate the timer when the view is deallocated
        timer?.invalidate()
    }
}
