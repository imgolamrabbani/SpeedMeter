import Foundation
import ServiceManagement

/// Manages launch at login functionality
class StartupManager: ObservableObject {
    @Published var isEnabled: Bool = false
    
    private let userDefaults = UserDefaults.standard
    private let launchAtLoginKey = "launchAtLogin"
    
    init() {
        loadPreference()
    }
    
    /// Check if launch at login is currently enabled
    func checkStatus() -> Bool {
        if #available(macOS 13.0, *) {
            return SMAppService.mainApp.status == .enabled
        } else {
            return isEnabled
        }
    }
    
    /// Enable launch at login
    func enable() throws {
        if #available(macOS 13.0, *) {
            try SMAppService.mainApp.register()
        }
        
        isEnabled = true
        userDefaults.set(true, forKey: launchAtLoginKey)
    }
    
    /// Disable launch at login
    func disable() throws {
        if #available(macOS 13.0, *) {
            try SMAppService.mainApp.unregister()
        }
        
        isEnabled = false
        userDefaults.set(false, forKey: launchAtLoginKey)
    }
    
    /// Toggle launch at login
    func toggle() {
        do {
            if isEnabled {
                try disable()
            } else {
                try enable()
            }
        } catch {
            print("Failed to toggle launch at login: \(error)")
        }
    }
    
    /// Load saved preference
    private func loadPreference() {
        isEnabled = userDefaults.bool(forKey: launchAtLoginKey)
    }
}
