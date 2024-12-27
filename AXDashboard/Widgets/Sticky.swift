//
//  Sticky.swift
//  AXDashboard
//
//  Created by Baba Paudel on 2024-12-27.
//

import AXWidgetKit
import AppKit

class AXSticky: AXWidgetView {
    // Define the size of the sticky note
    override var preferredSize: NSSize {
        return .init(width: 500, height: 500)
    }

    // The title of the sticky note (used in the title bar)
    override var name: String {
        return "Sticky"
    }

    // Initialize the sticky note widget
    required init() {
        super.init()

        // Set the background color and make the widget layerable
        wantsLayer = true
        self.layer?.backgroundColor = NSColor.systemYellow.cgColor

        // Add a text view for the sticky note content
        createTextView()
    }

    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @MainActor required init(style: AXWidgetTitlebarStyle = .hidden) {
        fatalError("init(style:) has not been implemented")
    }

    // Create a text view inside the sticky note for the user to type notes
    private func createTextView() {
        let textView = NSTextView()
        textView.string = "Hello"
        textView.font = NSFont.systemFont(ofSize: 14)
        textView.textContainerInset = NSSize(width: 10, height: 10)  // Add some padding inside the text view
        textView.translatesAutoresizingMaskIntoConstraints = false

        // Add the text view to the widget's view
        addSubview(textView)

        NSLayoutConstraint.activate([
            textView.centerXAnchor.constraint(equalTo: centerXAnchor),
            textView.centerYAnchor.constraint(equalTo: centerYAnchor),
            textView.widthAnchor.constraint(equalToConstant: 100),
            textView.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
}
