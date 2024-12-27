//
//  AXDashboardView.swift
//  AXDashboard
//
//  Created by Ashwin Paudel on 2024-12-27.
//

import AXWidgetKit
import AppKit

class AXDashboardView: NSView {
    //let timeWidget = AXTimeWidget()
    let widgetManager = WidgetManager.shared

    init() {
        super.init(frame: .zero)

        wantsLayer = true
        self.layer?.backgroundColor = .black

        widgetManager.loadBundledWidgets()

        for widget in widgetManager.loadedWidgets {
            widget.value.setFrameOrigin(NSPoint(x: 100, y: 100))
            widget.value.setFrameSize(NSSize(width: 100, height: 100))
            addSubview(widget.value)
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

public class WidgetManager {
    public static let shared = WidgetManager()
    var loadedWidgets: [String: AXView] = [:]

    public func registerWidget(_ widget: AXView) {
        loadedWidgets[widget.name] = widget
    }

    public func widget(withIdentifier identifier: String) -> AXView? {
        return loadedWidgets[identifier]
    }

    public func loadBundledWidgets() {
        guard let widgetsPath = Bundle.main.builtInPlugInsPath else { return }
        let fileManager = FileManager.default

        do {
            let bundlePaths = try fileManager.contentsOfDirectory(
                atPath: widgetsPath
            )
            .filter { $0.hasSuffix(".axwidget") }

            for bundleName in bundlePaths {
                let bundlePath = (widgetsPath as NSString)
                    .appendingPathComponent(bundleName)

                guard let bundle = Bundle(path: bundlePath) else {
                    print("Failed to load bundle at \(bundlePath)")
                    continue
                }

                print(bundle.principalClass)

                guard let principalClass = bundle.principalClass as? AXView.Type
                else {
                    print("Failed load principal class for \(bundlePath)")
                    continue
                }

                let widgetInstance = principalClass.init()

                // Optionally use `widgetInstance.name` or call other methods
                print("Loaded widget: \(widgetInstance.name)")
                self.loadedWidgets[widgetInstance.name] = widgetInstance
            }
        } catch {
            print("Error loading widgets: \(error)")
        }
    }
}
