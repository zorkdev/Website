import XCTest
@testable import Website

final class WebsiteTests: XCTestCase {
    override func setUp() {
        super.setUp()
        try? FileManager.default.removeItem(atPath: productsDirectory.path + "/head.html")
        try? FileManager.default.removeItem(atPath: productsDirectory.path + "/content.md")
    }

    func testGenerate_Success() throws {
        let head = "<html>%@</html>"
        let content = "Hello world!"

        FileManager.default.createFile(atPath: productsDirectory.path + "/head.html",
                                       contents: head.data(using: .utf8))
        FileManager.default.createFile(atPath: productsDirectory.path + "/content.md",
                                       contents: content.data(using: .utf8))

        XCTAssertEqual(try runApp(), "<html><p>Hello world!</p></html>\n")
    }

    func testGenerate_Failure() throws {
        XCTAssertEqual(try runApp(),
                       "The file “head.html” couldn’t be opened because there is no such file.\n")
    }

    func runApp() throws -> String? {
        guard #available(macOS 10.13, *) else { return nil }

        let fooBinary = productsDirectory.appendingPathComponent("Website")
        let process = Process()
        process.executableURL = fooBinary
        let pipe = Pipe()
        process.standardOutput = pipe
        try process.run()
        process.waitUntilExit()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)

        return output
    }

    var productsDirectory: URL {
      #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
      #else
        return Bundle.main.bundleURL
      #endif
    }

    static var allTests = [
        ("testGenerate_Success", testGenerate_Success),
        ("testGenerate_Failure", testGenerate_Failure)
    ]
}
