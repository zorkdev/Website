// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "Website",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(name: "Website", targets: ["Website"])
    ],
    dependencies: [
        .package(url: "https://github.com/JohnSundell/Publish.git", from: "0.9.0"),
        .package(url: "https://github.com/JohnSundell/SplashPublishPlugin", from: "0.2.0"),
        .package(url: "https://github.com/realm/SwiftLint.git", from: "0.54.0")
    ],
    targets: [
        .executableTarget(name: "Website", dependencies: ["Publish", "SplashPublishPlugin"])
    ]
)
