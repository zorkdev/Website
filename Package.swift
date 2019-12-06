// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "Website",
    platforms: [
        .macOS(.v10_13)
    ],
    dependencies: [
        .package(url: "https://github.com/JohnSundell/Ink.git", .upToNextMajor(from: "0.1.2")),
        .package(url: "https://github.com/JohnSundell/Plot.git", .upToNextMajor(from: "0.1.0")),
        .package(url: "https://github.com/realm/SwiftLint.git", .upToNextMajor(from: "0.38.0"))
    ],
    targets: [
        .target(name: "Website", dependencies: ["WebsiteKit"]),
        .target(name: "WebsiteKit", dependencies: ["Ink", "Plot"]),
        .testTarget(name: "WebsiteTests", dependencies: ["Website"])
    ]
)
