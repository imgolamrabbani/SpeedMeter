import SwiftUI

@main
struct SpeedMeterApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        // Settings window (optional)
        Settings {
            SettingsView()
                .frame(width: 500, height: 400)
        }
    }
}
