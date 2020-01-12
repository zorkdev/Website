// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "Website",
    products: [
        .executable(name: "Website", targets: ["Website"])
    ],
    dependencies: [
        .package(url: "https://github.com/JohnSundell/Publish.git", .upToNextMajor(from: "0.3.0")),
        .package(url: "https://github.com/JohnSundell/SplashPublishPlugin", .upToNextMajor(from: "0.1.0")),
        .package(url: "https://github.com/realm/SwiftLint.git", .upToNextMajor(from: "0.38.2"))
    ],
    targets: [
        .target(name: "Website", dependencies: ["Publish", "SplashPublishPlugin"])
    ]
)
