//
//  AXWidgetHostView.swift
//  AXDashboard
//
//  Created by Baba Paudel on 2024-12-27.
//

import AXWidgetKit
import AppKit

class AXWidgetHostView: NSView {
    var widgetView: AXWidgetView
    var titlebarView: NSView? = nil

    private var isDragging = false
    private var isResizing = false
    private var initialMouseLocation: NSPoint = .zero
    private var initialFrame: NSRect = .zero

    init(widget: AXWidgetView) {
        self.widgetView = widget
        super.init(frame: .zero)

        if widget.titlebarStyle == .outsideView {
            createTitlebar()
        }

        widgetView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(widgetView)

        NSLayoutConstraint.activate([
            widgetView.topAnchor.constraint(
                equalTo: topAnchor,
                constant: (widget.titlebarStyle == .outsideView) ? 25 : 0),
            widgetView.bottomAnchor.constraint(equalTo: bottomAnchor),
            widgetView.leftAnchor.constraint(equalTo: leftAnchor),
            widgetView.rightAnchor.constraint(equalTo: rightAnchor),
        ])

        wantsLayer = true
        layer?.cornerRadius = 9.0

        // Add a shadow
        layer?.shadowColor = NSColor.textColor.cgColor  // Shadow color
        layer?.shadowOpacity = 1  // Opacity of the shadow
        layer?.shadowRadius = 5.0  // Blur radius of the shadow
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createTitlebar() {
        titlebarView = NSView()
        titlebarView?.wantsLayer = true
        titlebarView?.layer?.backgroundColor =
            NSColor.controlBackgroundColor.cgColor
        addSubview(titlebarView!)

        titlebarView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titlebarView!.topAnchor.constraint(equalTo: topAnchor),
            titlebarView!.leftAnchor.constraint(equalTo: leftAnchor),
            titlebarView!.rightAnchor.constraint(equalTo: rightAnchor),
            titlebarView!.heightAnchor.constraint(equalToConstant: 25),
        ])

        // Create the label
        let titleLabel = NSTextField(labelWithString: widgetView.name)
        titleLabel.font = NSFont.systemFont(ofSize: 14)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        // Add the label to the titlebar
        titlebarView?.addSubview(titleLabel)

        // Add constraints for the label
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(
                equalTo: titlebarView!.centerYAnchor),
            titleLabel.leftAnchor.constraint(
                equalTo: titlebarView!.leftAnchor, constant: 10),
        ])
    }

    // Mouse down: Detect drag or resize initiation
    open override func mouseDown(with event: NSEvent) {
        let clickLocation = convert(event.locationInWindow, from: nil)
        initialMouseLocation = event.locationInWindow
        initialFrame = self.frame

        // Adjust drag initiation based on titlebar style
        if widgetView.titlebarStyle == .outsideView,
            clickLocation.y > bounds.height - 25
        {
            isDragging = true
            isResizing = false
        } else if widgetView.titlebarStyle == .hidden
            && clickLocation.y > bounds.height - 25
        {
            isDragging = true
            isResizing = false
        } else if clickLocation.x > bounds.width - 10 || clickLocation.y < 10 {
            isDragging = false
            isResizing = true
        } else {
            isDragging = false
            isResizing = false
        }
    }

    // Mouse dragged: Perform dragging or resizing
    public override func mouseDragged(with event: NSEvent) {
        guard let superview = self.superview else { return }
        let currentLocation = event.locationInWindow

        if isDragging {
            // Handle dragging based on titlebar style
            let deltaX = currentLocation.x - initialMouseLocation.x
            let deltaY = currentLocation.y - initialMouseLocation.y

            let newOrigin = NSPoint(
                x: min(
                    max(0, initialFrame.origin.x + deltaX),
                    superview.bounds.width - frame.width),
                y: min(
                    max(0, initialFrame.origin.y + deltaY),
                    superview.bounds.height - frame.height)
            )

            self.frame.origin = newOrigin
        } else if isResizing {
            // Handle resizing
            let deltaX = currentLocation.x - initialMouseLocation.x
            let deltaY = currentLocation.y - initialMouseLocation.y

            let newWidth = max(50, initialFrame.size.width + deltaX)
            let newHeight = max(50, initialFrame.size.height - deltaY)

            self.frame = NSRect(
                x: initialFrame.origin.x,
                y: initialFrame.origin.y
                    + (initialFrame.size.height - newHeight),
                width: newWidth,
                height: newHeight
            )
        }
    }

    // Mouse up: Reset dragging and resizing states
    public override func mouseUp(with event: NSEvent) {
        isDragging = false
        isResizing = false
    }
}
