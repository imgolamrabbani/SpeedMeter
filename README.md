# SpeedMeter

A native macOS menu bar application that monitors network speed and tracks data usage in real-time.

![macOS](https://img.shields.io/badge/macOS-14.0+-blue)
![Swift](https://img.shields.io/badge/Swift-6.2-orange)
![License](https://img.shields.io/badge/License-MIT-green)

## Features

### 🚀 Real-Time Speed Monitoring
- **Live Speed Display**: Download and upload speeds shown directly in the menu bar
- **Automatic Updates**: Refreshes every second for accurate readings
- **Network Detection**: Automatically detects Wi-Fi, Ethernet, and other interfaces

### 📊 Data Usage Tracking
- **Daily Tracking**: Monitor today's data consumption
- **Weekly Statistics**: View your weekly usage (Monday-Sunday)
- **Monthly Reports**: Track data usage per month
- **Yearly Overview**: Annual data consumption stats
- **Persistent Storage**: All data is saved and survives app restarts

### 📈 Dashboard
- **Real-Time Graphs**: Visual representation of the last 60 seconds of network activity
- **Usage Statistics**: Detailed breakdown of download/upload data
- **Period Selection**: Toggle between different time periods
- **Data Management**: Reset individual period statistics

### ⚙️ Settings
- **Launch at Login**: Automatically start with macOS
- **Customization**: Adjust update intervals
- **Menu Bar Only**: Runs entirely in the menu bar (no dock icon)

## Installation

### Build from Source

1. **Clone or navigate to the project directory:**
   ```bash
   cd "/Users/mdgolamrabbani/My MacOS Apps/SpeedMeter"
   ```

2. **Build the project:**
   ```bash
   swift build -c release
   ```

3. **Run the application:**
   ```bash
   .build/release/SpeedMeter
   ```

### Create App Bundle (Optional)

To create a proper macOS app bundle:

```bash
# Build release version
swift build -c release

# Create app bundle structure
mkdir -p SpeedMeter.app/Contents/MacOS
mkdir -p SpeedMeter.app/Contents/Resources

# Copy executable
cp .build/release/SpeedMeter SpeedMeter.app/Contents/MacOS/

# Create Info.plist
cat > SpeedMeter.app/Contents/Info.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>SpeedMeter</string>
    <key>CFBundleIdentifier</key>
    <string>com.speedmeter.app</string>
    <key>CFBundleName</key>
    <string>SpeedMeter</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSMinimumSystemVersion</key>
    <string>14.0</string>
    <key>LSUIElement</key>
    <true/>
    <key>NSHumanReadableCopyright</key>
    <string>Copyright © 2025. All rights reserved.</string>
</dict>
</plist>
EOF

# Make executable
chmod +x SpeedMeter.app/Contents/MacOS/SpeedMeter

# Copy to Applications (optional)
# cp -r SpeedMeter.app /Applications/
```

## Usage

### First Launch

1. When you first run SpeedMeter, it will appear in your menu bar (top-right corner)
2. You'll see network speeds displayed as: `↓ X.X MB/s ↑ Y.Y MB/s`

### Menu Bar Interface

Click the menu bar item to see:
- **Network Statistics**: Current statistics header
- **Today**: Today's total data usage with download/upload breakdown
- **This Week**: Weekly cumulative data
- **This Month**: Monthly cumulative data
- **This Year**: Yearly cumulative data
- **Show Dashboard**: Opens detailed dashboard window
- **Settings**: Configure app preferences
- **Quit SpeedMeter**: Exit the application

### Dashboard Window

Access comprehensive statistics through the dashboard:

- **Current Speed Card**: Real-time download/upload speeds with connection status
- **Speed History Graph**: Live 60-second chart showing network activity
- **Usage Statistics**: Detailed breakdown by selected time period
- **Data Management**: Reset statistics for specific periods

### Settings

Configure SpeedMeter to your liking:

- **Launch at Login**: Enable automatic startup with macOS
- **Update Interval**: Adjust how often speeds are measured (0.5-5 seconds)

## Requirements

- **macOS**: 14.0 (Sonoma) or later
- **Apple Silicon**: M1/M2/M3/M4 Mac (native ARM64)
- **Swift**: 6.2+ (for building from source)

## How It Works

### Network Monitoring

SpeedMeter uses macOS system APIs to monitor network interfaces:
- **NWPathMonitor**: Detects network connectivity and interface types
- **sysctl**: Reads network interface statistics directly from the kernel
- **Real-time calculation**: Computes speed by measuring byte deltas over time

### Data Persistence

All usage data is stored using UserDefaults:
- Hourly snapshots are accumulated
- Automatic period rollovers (daily, weekly, monthly, yearly)
- Data survives app restarts and system reboots

### Privacy

SpeedMeter runs entirely locally on your Mac:
- No data is transmitted to external servers
- No telemetry or analytics
- All statistics remain on your device

## Architecture

```
SpeedMeter/
├── Services/
│   ├── NetworkMonitor.swift    # Real-time speed monitoring
│   ├── DataTracker.swift        # Usage persistence & aggregation
│   └── StartupManager.swift     # Launch at login functionality
├── Models/
│   └── NetworkStats.swift       # Data structures
├── Views/
│   ├── DashboardView.swift      # Main statistics window
│   └── SettingsView.swift       # Preferences panel
└── AppDelegate.swift            # Menu bar integration
```

## Troubleshooting

### App doesn't show in menu bar

- Check that LSUIElement is set to true in Info.plist
- Restart the app
- Check macOS privacy settings

### Speeds show 0 B/s

- Verify you have an active network connection
- Check that the app has necessary permissions
- Try disconnecting and reconnecting to your network

### Data not persisting

- Check UserDefaults access
- Verify app has write permissions to its container

## Development

### Project Structure

This is a Swift Package Manager project:
- No Xcode project file needed
- Build with `swift build`
- Can be opened in Xcode or any text editor

### Building for Release

```bash
swift build -c release --arch arm64
```

### Running Tests

```bash
swift test
```

## Contributing

Feel free to fork this project and submit pull requests for:
- Bug fixes
- New features
- Performance improvements
- Documentation enhancements

## License

MIT License - feel free to use this project however you'd like!

## Acknowledgments

Built with:
- SwiftUI for the user interface
- Combine for reactive programming
- Network framework for connectivity monitoring
- Charts framework for data visualization

---

**Made with ❤️ for macOS**
