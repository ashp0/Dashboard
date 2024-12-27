//
//  AppDelegate.swift
//  AXDashboard
//
//  Created by Ashwin Paudel on 2024-12-27.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    var window = AXWindow()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        window.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool
    {
        return true
    }

}
