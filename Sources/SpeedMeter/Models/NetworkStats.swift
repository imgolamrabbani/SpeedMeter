import Foundation

/// Represents current network statistics
struct NetworkStats {
    var downloadSpeed: Double // bytes per second
    var uploadSpeed: Double    // bytes per second
    var isConnected: Bool
    var interfaceName: String
    
    init(
        downloadSpeed: Double = 0,
        uploadSpeed: Double = 0,
        isConnected: Bool = false,
        interfaceName: String = "Unknown"
    ) {
        self.downloadSpeed = downloadSpeed
        self.uploadSpeed = uploadSpeed
        self.isConnected = isConnected
        self.interfaceName = interfaceName
    }
    
    /// Format bytes to human readable string
    static func formatBytes(_ bytes: Double) -> String {
        let units = ["B/s", "KB/s", "MB/s", "GB/s"]
        var value = bytes
        var unitIndex = 0
        
        while value >= 1024 && unitIndex < units.count - 1 {
            value /= 1024
            unitIndex += 1
        }
        
        return String(format: "%.1f %@", value, units[unitIndex])
    }
    
    /// Format speed for menu bar display
    func menuBarString() -> String {
        let down = Self.formatBytes(downloadSpeed)
        let up = Self.formatBytes(uploadSpeed)
        return "↓ \(down) ↑ \(up)"
    }
}

/// Represents accumulated usage data
struct UsageStats {
    var totalDownloaded: Int64 // bytes
    var totalUploaded: Int64   // bytes
    var startDate: Date
    var endDate: Date
    
    init(
        totalDownloaded: Int64 = 0,
        totalUploaded: Int64 = 0,
        startDate: Date = Date(),
        endDate: Date = Date()
    ) {
        self.totalDownloaded = totalDownloaded
        self.totalUploaded = totalUploaded
        self.startDate = startDate
        self.endDate = endDate
    }
    
    var totalBytes: Int64 {
        totalDownloaded + totalUploaded
    }
    
    /// Format bytes to human readable string
    static func formatBytes(_ bytes: Int64) -> String {
        let units = ["B", "KB", "MB", "GB", "TB"]
        var value = Double(bytes)
        var unitIndex = 0
        
        while value >= 1024 && unitIndex < units.count - 1 {
            value /= 1024
            unitIndex += 1
        }
        
        return String(format: "%.2f %@", value, units[unitIndex])
    }
}

/// Time period for data aggregation
enum TimePeriod: String, CaseIterable {
    case today = "Today"
    case thisWeek = "This Week"
    case thisMonth = "This Month"
    case thisYear = "This Year"
    case allTime = "All Time"
}
