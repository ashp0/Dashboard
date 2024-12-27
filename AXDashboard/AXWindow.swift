//
//  AXWindow.swift
//  AXDashboard
//
//  Created by Ashwin Paudel on 2024-12-27.
//

import AppKit
import Cocoa

class AXWindow: NSWindow, NSWindowDelegate {
    lazy var desktopImageView: NSImageView = {
        let v = NSImageView()
        v.image = getDesktopWallpaper()

        visualEffectView.frame = v.bounds
        v.addSubview(visualEffectView)
        visualEffectView.autoresizingMask = [.height, .width]

        return v
    }()

    lazy var visualEffectView: NSVisualEffectView = {
        let v = NSVisualEffectView()
        v.material = .fullScreenUI
        v.blendingMode = .withinWindow
        v.state = .active

        return v
    }()

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
        self.toggleFullScreen(nil)

        self.contentView = desktopImageView

        let dashboard = AXDashboardView()
        dashboard.translatesAutoresizingMaskIntoConstraints = false
        visualEffectView.addSubview(dashboard)

        NSLayoutConstraint.activate([
            dashboard.topAnchor.constraint(equalTo: visualEffectView.topAnchor),
            dashboard.leftAnchor.constraint(
                equalTo: visualEffectView.leftAnchor),
            dashboard.bottomAnchor.constraint(
                equalTo: visualEffectView.bottomAnchor),
            dashboard.rightAnchor.constraint(
                equalTo: visualEffectView.rightAnchor),
        ])

    }

    func window(
        _ window: NSWindow,
        willUseFullScreenPresentationOptions proposedOptions: NSApplication
            .PresentationOptions = []
    ) -> NSApplication.PresentationOptions {
        [.fullScreen, .disableHideApplication, .hideDock, .hideMenuBar]
    }
}

func getDesktopWallpaper() -> NSImage? {
    let workspace = NSWorkspace.shared
    if let desktopURL = workspace.desktopImageURL(for: .main!) {
        return NSImage(contentsOf: desktopURL)
    }
    return nil
}
