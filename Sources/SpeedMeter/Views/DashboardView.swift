import SwiftUI
import Charts

struct DashboardView: View {
    @ObservedObject var networkMonitor: NetworkMonitor
    @ObservedObject var dataTracker: DataTracker
    
    @State private var speedHistory: [SpeedDataPoint] = []
    @State private var selectedPeriod: TimePeriod = .today
    
    private let maxHistoryPoints = 60 // Last 60 seconds
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Current Speed Card
                currentSpeedCard
                
                // Speed Graph
                speedGraphCard
                
                // Usage Statistics
                usageStatisticsCard
                
                // Actions
                actionsCard
            }
            .padding()
        }
        .frame(minWidth: 700, minHeight: 500)
        .onAppear {
            startSpeedHistoryTracking()
        }
    }
    
    // MARK: - Current Speed Card
    
    private var currentSpeedCard: some View {
        VStack(spacing: 16) {
            Text("Current Network Speed")
                .font(.title2)
                .fontWeight(.semibold)
            
            HStack(spacing: 40) {
                speedIndicator(
                    title: "Download",
                    speed: networkMonitor.currentStats.downloadSpeed,
                    icon: "arrow.down.circle.fill",
                    color: .blue
                )
                
                Divider()
                    .frame(height: 60)
                
                speedIndicator(
                    title: "Upload",
                    speed: networkMonitor.currentStats.uploadSpeed,
                    icon: "arrow.up.circle.fill",
                    color: .green
                )
            }
            
            // Connection Status
            HStack {
                Circle()
                    .fill(networkMonitor.currentStats.isConnected ? Color.green : Color.red)
                    .frame(width: 8, height: 8)
                
                Text(networkMonitor.currentStats.isConnected ? "Connected via \(networkMonitor.currentStats.interfaceName)" : "Disconnected")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
    }
    
    private func speedIndicator(title: String, speed: Double, icon: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundStyle(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(NetworkStats.formatBytes(speed))
                .font(.title)
                .fontWeight(.bold)
                .monospacedDigit()
        }
        .frame(width: 150)
    }
    
    // MARK: - Speed Graph Card
    
    private var speedGraphCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Speed History (Last 60s)")
                .font(.headline)
            
            if #available(macOS 13.0, *), !speedHistory.isEmpty {
                Chart(speedHistory) { point in
                    LineMark(
                        x: .value("Time", point.timestamp),
                        y: .value("Download", point.downloadSpeed / 1_048_576) // Convert to MB/s
                    )
                    .foregroundStyle(.blue)
                    .interpolationMethod(.catmullRom)
                    
                    LineMark(
                        x: .value("Time", point.timestamp),
                        y: .value("Upload", point.uploadSpeed / 1_048_576) // Convert to MB/s
                    )
                    .foregroundStyle(.green)
                    .interpolationMethod(.catmullRom)
                }
                .chartYAxis {
                    AxisMarks(position: .leading) { value in
                        AxisValueLabel {
                            if let speed = value.as(Double.self) {
                                Text("\(speed, specifier: "%.1f") MB/s")
                            }
                        }
                    }
                }
                .chartXAxis {
                    AxisMarks { _ in
                        AxisValueLabel(format: .dateTime.second())
                    }
                }
                .frame(height: 200)
            } else {
                Text("Collecting data...")
                    .foregroundColor(.secondary)
                    .frame(height: 200)
            }
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
    }
    
    // MARK: - Usage Statistics Card
    
    private var usageStatisticsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Data Usage")
                .font(.headline)
            
            Picker("Period", selection: $selectedPeriod) {
                ForEach(TimePeriod.allCases, id: \.self) { period in
                    Text(period.rawValue).tag(period)
                }
            }
            .pickerStyle(.segmented)
            
            let usage = dataTracker.getUsage(for: selectedPeriod)
            
            VStack(spacing: 16) {
                usageRow(title: "Total", value: UsageStats.formatBytes(usage.totalBytes))
                usageRow(title: "Downloaded", value: UsageStats.formatBytes(usage.totalDownloaded), icon: "arrow.down.circle")
                usageRow(title: "Uploaded", value: UsageStats.formatBytes(usage.totalUploaded), icon: "arrow.up.circle")
                
                Divider()
                
                HStack {
                    Text("Period: \(formatDateRange(usage.startDate, usage.endDate))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
            }
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
    }
    
    private func usageRow(title: String, value: String, icon: String? = nil) -> some View {
        HStack {
            if let icon = icon {
                Image(systemName: icon)
                    .foregroundColor(.secondary)
            }
            
            Text(title)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .fontWeight(.semibold)
                .monospacedDigit()
        }
    }
    
    // MARK: - Actions Card
    
    private var actionsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Actions")
                .font(.headline)
            
            HStack(spacing: 12) {
                Button(action: {
                    if let period = selectedPeriod as TimePeriod? {
                        resetUsage(for: period)
                    }
                }) {
                    Label("Reset Period", systemImage: "trash")
                }
                .buttonStyle(.bordered)
                
                Spacer()
            }
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(12)
    }
    
    // MARK: - Helper Functions
    
    private func startSpeedHistoryTracking() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak networkMonitor] _ in
            Task { @MainActor in
                guard let monitor = networkMonitor else { return }
                let point = SpeedDataPoint(
                    timestamp: Date(),
                    downloadSpeed: monitor.currentStats.downloadSpeed,
                    uploadSpeed: monitor.currentStats.uploadSpeed
                )
                
                speedHistory.append(point)
                
                // Keep only last 60 points
                if speedHistory.count > maxHistoryPoints {
                    speedHistory.removeFirst()
                }
            }
        }
    }
    
    private func formatDateRange(_ start: Date, _ end: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        
        if Calendar.current.isDate(start, inSameDayAs: end) {
            return formatter.string(from: start)
        } else {
            return "\(formatter.string(from: start)) - \(formatter.string(from: end))"
        }
    }
    
    private func resetUsage(for period: TimePeriod) {
        let alert = NSAlert()
        alert.messageText = "Reset \(period.rawValue) Usage?"
        alert.informativeText = "This will permanently delete all usage data for this period. This action cannot be undone."
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Reset")
        alert.addButton(withTitle: "Cancel")
        
        if alert.runModal() == .alertFirstButtonReturn {
            dataTracker.resetUsage(for: period)
        }
    }
}

// MARK: - Speed Data Point

struct SpeedDataPoint: Identifiable {
    let id = UUID()
    let timestamp: Date
    let downloadSpeed: Double
    let uploadSpeed: Double
}
