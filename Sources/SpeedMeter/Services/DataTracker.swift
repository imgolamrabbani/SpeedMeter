import Foundation

/// Tracks and persists network usage data across different time periods
@MainActor
class DataTracker: ObservableObject {
    @Published var todayUsage: UsageStats = UsageStats()
    @Published var weekUsage: UsageStats = UsageStats()
    @Published var monthUsage: UsageStats = UsageStats()
    @Published var yearUsage: UsageStats = UsageStats()
    @Published var allTimeUsage: UsageStats = UsageStats()
    
    private let userDefaults = UserDefaults.standard
    private let calendar = Calendar.current
    
    // Keys for UserDefaults
    private let todayKey = "usage.today"
    private let weekKey = "usage.week"
    private let monthKey = "usage.month"
    private let yearKey = "usage.year"
    private let allTimeKey = "usage.alltime"
    private let lastUpdateKey = "usage.lastUpdate"
    
    init() {
        loadData()
        checkPeriodRollovers()
    }
    
    /// Add new data usage
    func addUsage(downloaded: Int64, uploaded: Int64) {
        let now = Date()
        
        // Check if we need to rollover periods
        checkPeriodRollovers()
        
        // Update all periods
        todayUsage.totalDownloaded += downloaded
        todayUsage.totalUploaded += uploaded
        todayUsage.endDate = now
        
        weekUsage.totalDownloaded += downloaded
        weekUsage.totalUploaded += uploaded
        weekUsage.endDate = now
        
        monthUsage.totalDownloaded += downloaded
        monthUsage.totalUploaded += uploaded
        monthUsage.endDate = now
        
        yearUsage.totalDownloaded += downloaded
        yearUsage.totalUploaded += uploaded
        yearUsage.endDate = now
        
        allTimeUsage.totalDownloaded += downloaded
        allTimeUsage.totalUploaded += uploaded
        allTimeUsage.endDate = now
        
        // Save to disk
        saveData()
    }
    
    /// Get usage for specific period
    func getUsage(for period: TimePeriod) -> UsageStats {
        switch period {
        case .today:
            return todayUsage
        case .thisWeek:
            return weekUsage
        case .thisMonth:
            return monthUsage
        case .thisYear:
            return yearUsage
        case .allTime:
            return allTimeUsage
        }
    }
    
    /// Reset usage for specific period
    func resetUsage(for period: TimePeriod) {
        let now = Date()
        
        switch period {
        case .today:
            todayUsage = UsageStats(startDate: now, endDate: now)
        case .thisWeek:
            weekUsage = UsageStats(startDate: startOfWeek(), endDate: now)
        case .thisMonth:
            monthUsage = UsageStats(startDate: startOfMonth(), endDate: now)
        case .thisYear:
            yearUsage = UsageStats(startDate: startOfYear(), endDate: now)
        case .allTime:
            allTimeUsage = UsageStats(startDate: now, endDate: now)
        }
        
        saveData()
    }
    
    /// Check if periods need to be rolled over (reset)
    private func checkPeriodRollovers() {
        let now = Date()
        
        // Check if it's a new day
        if !calendar.isDate(todayUsage.startDate, inSameDayAs: now) {
            todayUsage = UsageStats(startDate: calendar.startOfDay(for: now), endDate: now)
        }
        
        // Check if it's a new week (weeks start on Monday)
        let currentWeekStart = startOfWeek()
        if todayUsage.startDate < currentWeekStart {
            weekUsage = UsageStats(startDate: currentWeekStart, endDate: now)
        }
        
        // Check if it's a new month
        let currentMonthStart = startOfMonth()
        if todayUsage.startDate < currentMonthStart {
            monthUsage = UsageStats(startDate: currentMonthStart, endDate: now)
        }
        
        // Check if it's a new year
        let currentYearStart = startOfYear()
        if todayUsage.startDate < currentYearStart {
            yearUsage = UsageStats(startDate: currentYearStart, endDate: now)
        }
    }
    
    /// Get start of current week (Monday)
    private func startOfWeek() -> Date {
        let now = Date()
        var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)
        components.weekday = 2 // Monday
        return calendar.date(from: components) ?? now
    }
    
    /// Get start of current month
    private func startOfMonth() -> Date {
        let now = Date()
        let components = calendar.dateComponents([.year, .month], from: now)
        return calendar.date(from: components) ?? now
    }
    
    /// Get start of current year
    private func startOfYear() -> Date {
        let now = Date()
        let components = calendar.dateComponents([.year], from: now)
        return calendar.date(from: components) ?? now
    }
    
    /// Save data to UserDefaults
    private func saveData() {
        // Save each period
        saveUsageStat(todayUsage, key: todayKey)
        saveUsageStat(weekUsage, key: weekKey)
        saveUsageStat(monthUsage, key: monthKey)
        saveUsageStat(yearUsage, key: yearKey)
        saveUsageStat(allTimeUsage, key: allTimeKey)
        
        userDefaults.set(Date(), forKey: lastUpdateKey)
    }
    
    /// Load data from UserDefaults
    private func loadData() {
        let now = Date()
        
        todayUsage = loadUsageStat(key: todayKey) ?? UsageStats(startDate: calendar.startOfDay(for: now), endDate: now)
        weekUsage = loadUsageStat(key: weekKey) ?? UsageStats(startDate: startOfWeek(), endDate: now)
        monthUsage = loadUsageStat(key: monthKey) ?? UsageStats(startDate: startOfMonth(), endDate: now)
        yearUsage = loadUsageStat(key: yearKey) ?? UsageStats(startDate: startOfYear(), endDate: now)
        allTimeUsage = loadUsageStat(key: allTimeKey) ?? UsageStats(startDate: now, endDate: now)
    }
    
    /// Helper to save UsageStats
    private func saveUsageStat(_ stat: UsageStats, key: String) {
        let data: [String: Any] = [
            "downloaded": stat.totalDownloaded,
            "uploaded": stat.totalUploaded,
            "startDate": stat.startDate,
            "endDate": stat.endDate
        ]
        userDefaults.set(data, forKey: key)
    }
    
    /// Helper to load UsageStats
    private func loadUsageStat(key: String) -> UsageStats? {
        guard let data = userDefaults.dictionary(forKey: key) else { return nil }
        
        guard let downloaded = data["downloaded"] as? Int64,
              let uploaded = data["uploaded"] as? Int64,
              let startDate = data["startDate"] as? Date,
              let endDate = data["endDate"] as? Date else {
            return nil
        }
        
        return UsageStats(
            totalDownloaded: downloaded,
            totalUploaded: uploaded,
            startDate: startDate,
            endDate: endDate
        )
    }
}
