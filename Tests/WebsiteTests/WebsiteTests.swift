import XCTest

final class WebsiteTests: XCTestCase {
    var previousTemplate: Data?
    var previousContent: Data?

    let templatePath = "template.html"
    let contentPath = "content.md"

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
        previousTemplate = FileManager.default.contents(atPath: templatePath)
        previousContent = FileManager.default.contents(atPath: contentPath)

        [templatePath, contentPath].forEach {
            try? FileManager.default.removeItem(atPath: $0)
        }
    }

    override func tearDown() {
        super.tearDown()

        [(templatePath, previousTemplate), (contentPath, previousContent)].forEach {
            FileManager.default.createFile(atPath: $0.0, contents: $0.1)
        }
    }

    func testGenerate_Success() throws {
        let template = "<html>#(content)</html>".data(using: .utf8)
        let content = "Hello world!".data(using: .utf8)

        [(templatePath, template), (contentPath, content)].forEach {
            FileManager.default.createFile(atPath: $0.0, contents: $0.1)
        }

        XCTAssertEqual(try runApp(), "<html><p>Hello world!</p></html>\n")
        XCTAssertEqual(try String(contentsOfFile: "docs/index.html"), "<html><p>Hello world!</p></html>")
    }

    func testGenerate_Failure() throws {
        XCTAssertEqual(try runApp(), "The file “template.html” couldn’t be opened because there is no such file.\n")
    }

    func runApp() throws -> String? {
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
