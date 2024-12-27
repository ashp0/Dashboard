//
//  AXDashboardView.swift
//  AXDashboard
//
//  Created by Ashwin Paudel on 2024-12-27.
//

import AXWidgetKit
import AppKit

class AXDashboardView: NSView {
    let widgetManager = WidgetManager.shared

    init() {
        super.init(frame: .zero)

        widgetManager.loadBuiltinWidgets()

        for widget in widgetManager.loadedWidgets {
            let hostView = AXWidgetHostView(widget: widget.value)
            hostView.setFrameSize(widget.value.preferredSize)
            addSubview(hostView)
        }
    }

    override func viewDidUnhide() {
        //        timeWidget.widgetDidAppear()
    }

    override func viewDidHide() {
        //        timeWidget.widgetDidDisappear()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
