//
//  AXWidgetManager.swift
//  AXDashboard
//
//  Created by Baba Paudel on 2024-12-27.
//

import AXWidgetKit
import AppKit

class WidgetManager {
    static let shared = WidgetManager()
    var loadedWidgets: [String: AXWidgetView] = [:]

    func registerWidget(_ widget: AXWidgetView) {
        loadedWidgets[widget.name] = widget
    }

    func widget(withIdentifier identifier: String) -> AXWidgetView? {
        return loadedWidgets[identifier]
    }

    func loadBuiltinWidgets() {
        let widgets = [AXClock(), AXSticky()]

        for widget in widgets {
            self.loadedWidgets[widget.name] = widget
        }
    }

    func loadWidgetFromBundle() {
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

                guard
                    let principalClass = bundle.principalClass
                        as? AXWidgetView.Type
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

    private func loadWidget(at path: String) {
        guard let bundle = Bundle(path: path) else {
            print("Failed to load bundle at \(path)")
            return
        }

        guard let principalClass = bundle.principalClass as? AXWidgetView.Type
        else {
            print("Failed load principal class for \(path)")
            return
        }

        let widgetInstance = principalClass.init()

        // Optionally use `widgetInstance.name` or call other methods
        print("Loaded widget: \(widgetInstance.name)")
        self.loadedWidgets[widgetInstance.name] = widgetInstance
    }
}
