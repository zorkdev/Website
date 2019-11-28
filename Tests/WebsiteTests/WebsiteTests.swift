import XCTest

final class WebsiteTests: XCTestCase {
    static var allTests = [
        ("testGenerate_Success", testGenerate_Success),
        ("testGenerate_Failure", testGenerate_Failure)
    ]

    var currentDir: String { FileManager.default.currentDirectoryPath }

    var productsDirectory: URL {
      #if os(macOS)
        guard let bundle = Bundle.allBundles.first(where: { $0.bundlePath.hasSuffix(".xctest") }) else {
            preconditionFailure("Couldn't find the products directory.")
        }
        return bundle.bundleURL.deletingLastPathComponent()
      #else
        return Bundle.main.bundleURL
      #endif
    }

    override func setUp() {
        super.setUp()
        try? FileManager.default.removeItem(atPath: currentDir + "/template.html")
        try? FileManager.default.removeItem(atPath: currentDir + "/content.md")
    }

    func testGenerate_Success() throws {
        let head = "<html>%@</html>"
        let content = "Hello world!"

        FileManager.default.createFile(atPath: currentDir + "/template.html",
                                       contents: head.data(using: .utf8))
        FileManager.default.createFile(atPath: currentDir + "/content.md",
                                       contents: content.data(using: .utf8))

        XCTAssertEqual(try runApp(), "<html><p>Hello world!</p></html>\n")
    }

    func testGenerate_Failure() throws {
        XCTAssertEqual(try runApp(),
                       "The file “template.html” couldn’t be opened because there is no such file.\n")
    }

    func runApp() throws -> String? {
        guard #available(macOS 10.13, *) else {
            XCTFail("Can't run tests below macOS 10.13.")
            return nil
        }

        let binary = productsDirectory.appendingPathComponent("Website")
        let process = Process()
        process.executableURL = binary
        let pipe = Pipe()
        process.standardOutput = pipe
        try process.run()
        process.waitUntilExit()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)

        return output
    }
}
