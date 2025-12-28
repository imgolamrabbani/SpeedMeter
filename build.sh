#!/bin/bash

# SpeedMeter Build and Run Script

set -e

echo "🚀 Building SpeedMeter..."
swift build -c release

echo "✅ Build complete!"
echo ""
echo "📦 Creating app bundle..."

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

echo "✅ App bundle created: SpeedMeter.app"
echo ""
echo "🎯 To install to Applications folder:"
echo "   cp -r SpeedMeter.app /Applications/"
echo ""
echo "🏃 To run now:"
echo "   open SpeedMeter.app"
echo ""

# Ask if user wants to run
read -p "Would you like to launch SpeedMeter now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    open SpeedMeter.app
    echo "✅ SpeedMeter launched! Look for it in your menu bar (top-right)"
fi
