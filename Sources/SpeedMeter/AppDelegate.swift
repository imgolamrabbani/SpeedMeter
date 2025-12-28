import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var networkMonitor: NetworkMonitor?
    var dataTracker: DataTracker?
    
    private var dashboardWindow: NSWindow?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create status bar item
        setupMenuBar()
        
        // Initialize services
        Task { @MainActor in
            networkMonitor = NetworkMonitor()
            dataTracker = DataTracker()
            
            // Connect network monitor to data tracker
            networkMonitor?.onDataUpdate = { [weak self] downloaded, uploaded in
                Task { @MainActor in
                    self?.dataTracker?.addUsage(downloaded: downloaded, uploaded: uploaded)
                }
            }
            
            // Start monitoring
            networkMonitor?.startMonitoring()
        }
        
        // Hide dock icon (run as menu bar only app)
        NSApp.setActivationPolicy(.accessory)
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        Task { @MainActor in
            networkMonitor?.stopMonitoring()
        }
    }
    
    private func setupMenuBar() {
        // Create status item in menu bar
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem?.button {
            button.title = "↓ 0 B/s ↑ 0 B/s"
            
            // Update title periodically
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                Task { @MainActor [weak self] in
                    self?.updateMenuBarTitle()
                }
            }
        }
        
        // Create menu
        setupMenu()
    }
    
    @MainActor
    private func updateMenuBarTitle() {
        guard let monitor = networkMonitor else { return }
        
        if let button = statusItem?.button {
            button.title = monitor.currentStats.menuBarString()
        }
    }
    
    private func setupMenu() {
        let menu = NSMenu()
        
        // Statistics section
        menu.addItem(NSMenuItem(title: "Network Statistics", action: nil, keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        
        // Today's usage
        let todayItem = NSMenuItem(title: "Loading...", action: nil, keyEquivalent: "")
        todayItem.tag = 1
        menu.addItem(todayItem)
        
        // This week
        let weekItem = NSMenuItem(title: "Loading...", action: nil, keyEquivalent: "")
        weekItem.tag = 2
        menu.addItem(weekItem)
        
        // This month
        let monthItem = NSMenuItem(title: "Loading...", action: nil, keyEquivalent: "")
        monthItem.tag = 3
        menu.addItem(monthItem)
        
        // This year
        let yearItem = NSMenuItem(title: "Loading...", action: nil, keyEquivalent: "")
        yearItem.tag = 4
        menu.addItem(yearItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Show Dashboard
        menu.addItem(withTitle: "Show Dashboard", action: #selector(showDashboard), keyEquivalent: "d")
        
        // Settings
        menu.addItem(withTitle: "Settings...", action: #selector(showSettings), keyEquivalent: ",")
        
        menu.addItem(NSMenuItem.separator())
        
        // Quit
        menu.addItem(withTitle: "Quit SpeedMeter", action: #selector(quitApp), keyEquivalent: "q")
        
        statusItem?.menu = menu
        
        // Update menu items periodically
        Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.updateMenuItems()
            }
        }
    }
    
    @MainActor
    private func updateMenuItems() {
        guard let menu = statusItem?.menu,
              let tracker = dataTracker else { return }
        
        // Update today
        if let item = menu.item(withTag: 1) {
            let usage = tracker.todayUsage
            let total = UsageStats.formatBytes(usage.totalBytes)
            let down = UsageStats.formatBytes(usage.totalDownloaded)
            let up = UsageStats.formatBytes(usage.totalUploaded)
            item.title = "Today: \(total) (↓\(down) ↑\(up))"
        }
        
        // Update week
        if let item = menu.item(withTag: 2) {
            let usage = tracker.weekUsage
            let total = UsageStats.formatBytes(usage.totalBytes)
            item.title = "This Week: \(total)"
        }
        
        // Update month
        if let item = menu.item(withTag: 3) {
            let usage = tracker.monthUsage
            let total = UsageStats.formatBytes(usage.totalBytes)
            item.title = "This Month: \(total)"
        }
        
        // Update year
        if let item = menu.item(withTag: 4) {
            let usage = tracker.yearUsage
            let total = UsageStats.formatBytes(usage.totalBytes)
            item.title = "This Year: \(total)"
        }
    }
    
    @MainActor
    @objc private func showDashboard() {
        if dashboardWindow == nil {
                // Create dashboard window
                let contentView = DashboardView(
                    networkMonitor: networkMonitor!,
                    dataTracker: dataTracker!
                )
                
                dashboardWindow = NSWindow(
                    contentRect: NSRect(x: 0, y: 0, width: 800, height: 600),
                    styleMask: [.titled, .closable, .miniaturizable, .resizable],
                    backing: .buffered,
                    defer: false
                )
                
                dashboardWindow?.title = "SpeedMeter Dashboard"
                dashboardWindow?.contentView = NSHostingView(rootView: contentView)
                dashboardWindow?.center()
                dashboardWindow?.setFrameAutosaveName("DashboardWindow")
        }
        
        dashboardWindow?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @MainActor
    @objc private func showSettings() {
        NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @MainActor
    @objc private func quitApp() {
        NSApp.terminate(nil)
    }
}
