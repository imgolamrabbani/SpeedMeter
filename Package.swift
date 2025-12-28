// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SpeedMeter",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(
            name: "SpeedMeter",
            targets: ["SpeedMeter"]
        )
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "SpeedMeter",
            dependencies: [],
            path: "Sources/SpeedMeter",
            resources: [
                .process("Resources")
            ],
            swiftSettings: [
                .enableUpcomingFeature("BareSlashRegexLiterals")
            ]
        )
    ]
)
