//
//  AXWidgetProtocol.swift
//  AXDashboard
//
//  Created by Ashwin Paudel on 2024-12-27.
//

import AppKit

// Enum for titlebar styles
public enum AXWidgetTitlebarStyle {
    case hidden
    case outsideView
}

open class AXWidgetView: NSView {
    // Titlebar style
    open var titlebarStyle: AXWidgetTitlebarStyle = .outsideView

    open var name: String {
        return "Draggable and Resizable AXView"
    }

    open var preferredSize: NSSize {
        return .init(width: 200, height: 400)
    }

    // Initializer with titlebar style
    required public init() {
        super.init(frame: .zero)

    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
