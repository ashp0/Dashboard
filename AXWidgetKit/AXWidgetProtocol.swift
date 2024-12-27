//
//  AXWidgetProtocol.swift
//  AXDashboard
//
//  Created by Ashwin Paudel on 2024-12-27.
//

import AppKit

private protocol AXWidget: NSView {
    var name: String { get }

    func widgetDidAppear()
    func widgetDidDisappear()
}

open class AXView: NSView, AXWidget {
    private var isDragging = false
    private var isResizing = false
    private var initialMouseLocation: NSPoint = .zero
    private var initialFrame: NSRect = .zero

    open var name: String {
        return "Draggable and Resizable AXView"
    }

    // Implement required methods from AXWidget
    open func widgetDidAppear() {
        print("\(name) appeared")
    }

    open func widgetDidDisappear() {
        print("\(name) disappeared")
    }

    // Mouse down: Detect drag or resize initiation
    open override func mouseDown(with event: NSEvent) {
        let clickLocation = convert(event.locationInWindow, from: nil)
        initialMouseLocation = event.locationInWindow
        initialFrame = self.frame

        // Determine whether the user is dragging or resizing
        if clickLocation.y > bounds.height - 25 {
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
            // Handle dragging
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
