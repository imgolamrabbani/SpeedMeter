# Quick Start Guide

## Build and Run SpeedMeter

### Option 1: Quick Build & Run
```bash
cd "/Users/mdgolamrabbani/My MacOS Apps/SpeedMeter"
./build.sh
```

The script will guide you through building and launching the app.

### Option 2: Manual Build
```bash
# Build release version
swift build -c release

# Run directly
.build/release/SpeedMeter
```

### Option 3: Install to Applications
```bash
# Build the app bundle first
./build.sh

# Then install
cp -r SpeedMeter.app /Applications/

# Launch from Applications
open /Applications/SpeedMeter.app
```

## What to Expect

1. **First Launch**: The app icon appears in your menu bar (top-right corner)
2. **Speed Display**: Shows as `↓ X.X MB/s ↑ Y.Y MB/s`
3. **Click the Icon**: Access detailed statistics and settings

## Key Features

### Menu Bar
- Real-time speed updates every second
- Click to see:
  - Today's usage
  - This week's total
  - This month's total
  - This year's total
  - Dashboard access
  - Settings

### Dashboard (Show Dashboard)
- Live speed graph (last 60 seconds)
- Detailed statistics by period
- Reset individual periods

### Settings
- **Launch at Login**: Auto-start with macOS
- **Update Interval**: Customize refresh rate
- Version information

## Tips

- **No Dock Icon**: The app runs entirely in the menu bar
- **Background Operation**: Continues monitoring even when dashboard is closed
- **Data Persistence**: All statistics saved automatically
- **Lightweight**: Uses < 2% CPU and < 50MB RAM

## Troubleshooting

### App doesn't show in menu bar
- Check top-right corner of screen
- Look for network speed text
- Try restarting the app

### Speeds show 0 B/s
- Ensure you have active network connection
- Try disconnecting/reconnecting to network
- Check Activity Monitor for network activity

### Launch at Login doesn't work
- Go to System Settings > General > Login Items
- Verify SpeedMeter is listed
- Toggle the setting in app

## Next Steps

1. Enable "Launch at Login" in Settings
2. Customize update interval if desired
3. Open Dashboard to see detailed graphs
4. Monitor your network usage over time!

Enjoy SpeedMeter! 🚀
