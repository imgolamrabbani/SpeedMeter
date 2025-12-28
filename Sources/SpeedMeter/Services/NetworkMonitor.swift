import Foundation
import Network
import Combine

/// Monitors network interfaces and calculates real-time download/upload speeds
@MainActor
class NetworkMonitor: ObservableObject {
    @Published var currentStats: NetworkStats = NetworkStats()
    @Published var isMonitoring: Bool = false
    
    private var pathMonitor: NWPathMonitor?
    private var monitorQueue = DispatchQueue(label: "com.speedmeter.network.monitor")
    
    // For speed calculation
    private var lastBytesReceived: UInt64 = 0
    private var lastBytesSent: UInt64 = 0
    private var lastUpdateTime: Date = Date()
    private var timer: Timer?
    
    // Callback for data tracking
    var onDataUpdate: ((Int64, Int64) -> Void)?
    
    init() {
        setupPathMonitor()
    }
    
    /// Set up network path monitor to detect connectivity changes
    private func setupPathMonitor() {
        pathMonitor = NWPathMonitor()
        
        pathMonitor?.pathUpdateHandler = { [weak self] path in
            Task { @MainActor [weak self] in
                guard let self = self else { return }
                self.currentStats.isConnected = path.status == .satisfied
                
                // Get active interface name
                if let interface = path.availableInterfaces.first {
                    switch interface.type {
                    case .wifi:
                        self.currentStats.interfaceName = "Wi-Fi"
                    case .wiredEthernet:
                        self.currentStats.interfaceName = "Ethernet"
                    case .cellular:
                        self.currentStats.interfaceName = "Cellular"
                    default:
                        self.currentStats.interfaceName = "Other"
                    }
                }
            }
        }
        
        pathMonitor?.start(queue: monitorQueue)
    }
    
    /// Start monitoring network speed
    func startMonitoring() {
        guard !isMonitoring else { return }
        
        isMonitoring = true
        
        // Initialize counters
        if let stats = getNetworkStats() {
            lastBytesReceived = stats.received
            lastBytesSent = stats.sent
            lastUpdateTime = Date()
        }
        
        // Update every second
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                await self?.updateSpeed()
            }
        }
        
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    /// Stop monitoring
    func stopMonitoring() {
        isMonitoring = false
        timer?.invalidate()
        timer = nil
    }
    
    /// Update speed calculation
    private func updateSpeed() async {
        guard let stats = getNetworkStats() else { return }
        
        let now = Date()
        let timeInterval = now.timeIntervalSince(lastUpdateTime)
        
        guard timeInterval > 0 else { return }
        
        // Calculate bytes transferred since last update
        let receivedDelta = stats.received > lastBytesReceived ? stats.received - lastBytesReceived : 0
        let sentDelta = stats.sent > lastBytesSent ? stats.sent - lastBytesSent : 0
        
        // Calculate speed (bytes per second)
        currentStats.downloadSpeed = Double(receivedDelta) / timeInterval
        currentStats.uploadSpeed = Double(sentDelta) / timeInterval
        
        // Notify data tracker
        if receivedDelta > 0 || sentDelta > 0 {
            onDataUpdate?(Int64(receivedDelta), Int64(sentDelta))
        }
        
        // Update for next iteration
        lastBytesReceived = stats.received
        lastBytesSent = stats.sent
        lastUpdateTime = now
    }
    
    /// Get network statistics from system
    private func getNetworkStats() -> (received: UInt64, sent: UInt64)? {
        // Use sysctl to get network interface statistics
        var mib: [Int32] = [CTL_NET, PF_ROUTE, 0, 0, NET_RT_IFLIST2, 0]
        var len: size_t = 0
        
        // Get required buffer size
        guard sysctl(&mib, 6, nil, &len, nil, 0) == 0 else {
            return nil
        }
        
        var buffer = [Int8](repeating: 0, count: len)
        
        // Get actual data
        guard sysctl(&mib, 6, &buffer, &len, nil, 0) == 0 else {
            return nil
        }
        
        var totalReceived: UInt64 = 0
        var totalSent: UInt64 = 0
        var offset = 0
        
        while offset < len {
            let ifm = buffer.withUnsafeBytes { ptr in
                ptr.load(fromByteOffset: offset, as: if_msghdr.self)
            }
            
            if ifm.ifm_type == RTM_IFINFO2 {
                let ifm2 = buffer.withUnsafeBytes { ptr in
                    ptr.load(fromByteOffset: offset, as: if_msghdr2.self)
                }
                
                // Accumulate all interface data (system will handle loopback filtering)
                let data = ifm2.ifm_data
                totalReceived += data.ifi_ibytes
                totalSent += data.ifi_obytes
            }
            
            offset += Int(ifm.ifm_msglen)
        }
        
        return (totalReceived, totalSent)
    }
}

// System framework imports for network statistics
import Darwin

// Network interface message structures (from Darwin framework)
private let RTM_IFINFO2: UInt8 = 0x12
private let NET_RT_IFLIST2: Int32 = 0x0006
