# SpeedMeter

A native macOS menu bar application that monitors network speed and tracks data usage in real-time.

![macOS](https://img.shields.io/badge/macOS-14.0+-blue)
![Swift](https://img.shields.io/badge/Swift-6.2-orange)
![License](https://img.shields.io/badge/License-MIT-green)

## 📥 Download & Installation

### Quick Install (Recommended)

1. **Download the latest release:**
   - Go to [Releases](../../releases)
   - Download `SpeedMeter-1.0.0.dmg`

2. **Install the app:**
   - Open the downloaded DMG file
   - Drag **SpeedMeter.app** to the **Applications** folder
   - Eject the DMG

3. **Launch SpeedMeter:**
   - Open SpeedMeter from your Applications folder
   - The app will appear in your menu bar (top-right corner)

> **First Launch Note:** macOS may show a security warning because the app is not notarized. See [Security & Privacy](#security--privacy) below.

### Alternative: Direct App Download

If you prefer not to use a DMG:
- Download `SpeedMeter.app.zip` from [Releases](../../releases)
- Unzip and move to Applications folder
- Launch from Applications

### Security & Privacy

**If macOS blocks the app on first launch:**

1. **Option 1: System Settings (Recommended)**
   - Go to **System Settings** → **Privacy & Security**
   - Scroll down to find SpeedMeter in the security section
   - Click **"Open Anyway"**

2. **Option 2: Right-click Method**
   - Right-click **SpeedMeter.app** in Applications
   - Select **"Open"**
   - Click **"Open"** in the warning dialog

3. **Option 3: Terminal Command**
   ```bash
   xattr -d com.apple.quarantine /Applications/SpeedMeter.app
   ```

**Why this happens:** The app is not code-signed or notarized with an Apple Developer account. It's completely safe and open source - you can review all the code in this repository.

### System Requirements

- **macOS**: 14.0 (Sonoma) or later
- **Hardware**: Apple Silicon Mac (M1/M2/M3/M4)
- **Network**: Active internet connection

---

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

## Installation for Developers

> **Note:** If you just want to use the app, see [Download & Installation](#-download--installation) above.

This section is for developers who want to build from source.

### Quick Build

```bash
# Clone the repository
git clone https://github.com/imgolamrabbani/SpeedMeter.git
cd SpeedMeter

# Build and run
./build-release.sh

# Or build manually
swift build -c release
.build/release/SpeedMeter
```

### Create Release Build

Use the provided build script to create a production app bundle with icon:

```bash
./build-release.sh
```

This will:
- Build the release binary (ARM64)
- Create proper app bundle structure
- Convert icon to .icns format
- Generate Info.plist
- Create `SpeedMeter.app` ready for distribution

### Create DMG Installer

```bash
./create-dmg.sh
```

Creates `SpeedMeter-1.0.0.dmg` for distribution.

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

---

## Troubleshooting

### App won't open / Security warning

See the detailed [Security & Privacy](#security--privacy) section above for multiple solutions.

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
