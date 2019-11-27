// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "Website",
    dependencies: [
        .package(url: "https://github.com/JohnSundell/Ink.git", .upToNextMajor(from: "0.1.1"))
    ],
    targets: [
        .target(name: "Website", dependencies: ["Ink"]),
        .testTarget(name: "WebsiteTests", dependencies: ["Website"])
    ]
)
