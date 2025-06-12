//
//  timeApp.swift
//  time
//
//  Created by Arton on 2025/06/12.
//

import SwiftUI

@main
struct TimerApp: App {
    // NSWindowをフックするための変数
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

// AppDelegateを使ってNSWindowを取得・設定
class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        // ウィンドウを取得
        if let window = NSApplication.shared.windows.first {
            // リサイズ不可、最大化・最小化不可に設定
            window.styleMask.remove(.resizable)
            window.styleMask.remove(.miniaturizable)
            window.styleMask.remove(.closable) //
        }
    }
}
