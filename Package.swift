// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "Website",
    platforms: [
        .macOS(.v10_13)
    ],
    dependencies: [
        .package(url: "https://github.com/JohnSundell/Splash.git", .upToNextMajor(from: "0.9.0")),
        .package(url: "https://github.com/JohnSundell/Ink.git", .upToNextMajor(from: "0.2.0")),
        .package(url: "https://github.com/JohnSundell/Plot.git", .upToNextMajor(from: "0.2.0")),
        .package(url: "https://github.com/realm/SwiftLint.git", .upToNextMajor(from: "0.38.0")),
        .package(url: "https://github.com/shibapm/Komondor.git", .upToNextMajor(from: "1.0.4"))
    ],
    targets: [
        .target(name: "Website", dependencies: ["WebsiteKit"]),
        .target(name: "WebsiteKit", dependencies: ["Splash", "Ink", "Plot"]),
        .testTarget(name: "WebsiteTests", dependencies: ["Website"])
    ]
)

#if canImport(PackageConfig)
import PackageConfig

let config = PackageConfiguration([
    "komondor": [
        "pre-push": [
            "sh integrate.sh"
        ]
    ]
]).write()
#endif
