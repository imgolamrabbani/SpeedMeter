import SwiftUI

struct SettingsView: View {
    @StateObject private var startupManager = StartupManager()
    @AppStorage("updateInterval") private var updateInterval: Double = 1.0
    @AppStorage("showInMenuBar") private var showInMenuBar: Bool = true
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 8) {
                Image(systemName: "speedometer")
                    .font(.system(size: 48))
                    .foregroundStyle(.blue)
                
                Text("SpeedMeter")
                    .font(.title)
                    .fontWeight(.semibold)
                
                Text("Network Speed Monitor for macOS")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.top, 30)
            .padding(.bottom, 20)
            
            Divider()
            
            // Settings
            Form {
                Section {
                    Toggle("Launch at Login", isOn: Binding(
                        get: { startupManager.isEnabled },
                        set: { _ in startupManager.toggle() }
                    ))
                    .help("Automatically start SpeedMeter when you log in")
                    
                    Toggle("Show in Menu Bar", isOn: $showInMenuBar)
                        .help("Display network speeds in the menu bar")
                        .disabled(true) // Always enabled for menu bar app
                } header: {
                    Text("General")
                        .font(.headline)
                }
                
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Update Interval: \(updateInterval, specifier: "%.1f") second(s)")
                            .font(.subheadline)
                        
                        Slider(value: $updateInterval, in: 0.5...5.0, step: 0.5)
                            .help("How often to update speed measurements")
                    }
                } header: {
                    Text("Performance")
                        .font(.headline)
                }
                
                Section {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Version:")
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("1.0.0")
                        }
                        
                        HStack {
                            Text("Build:")
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("2025.1")
                        }
                        
                        Divider()
                        
                        Text("SpeedMeter monitors your network speed and tracks data usage across different time periods.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                } header: {
                    Text("About")
                        .font(.headline)
                }
            }
            .formStyle(.grouped)
            
            Spacer()
        }
        .frame(minWidth: 450, minHeight: 400)
    }
}
