//
//  AXWindow.swift
//  AXDashboard
//
//  Created by Ashwin Paudel on 2024-12-27.
//

import AppKit
import Cocoa

class AXWindow: NSWindow, NSWindowDelegate {
    init() {
        super.init(
            contentRect: .zero,
            styleMask: [.fullSizeContentView, .resizable],
            backing: .buffered,
            defer: false
        )
        self.delegate = self
        self.isReleasedWhenClosed = false
        self.collectionBehavior = [
            .fullScreenPrimary, .fullScreenDisallowsTiling, .stationary,
        ]
        self.contentView = AXDashboardView()

        self.toggleFullScreen(nil)
    }

    func window(
        _ window: NSWindow,
        willUseFullScreenPresentationOptions proposedOptions: NSApplication
            .PresentationOptions = []
    ) -> NSApplication.PresentationOptions {
        [.fullScreen, .disableHideApplication, .hideDock, .hideMenuBar]
    }
}
