import XCTest

final class WebsiteTests: XCTestCase {
    private var previousContent: Data?
    private let contentPath = "content.md"

    private var productsDirectory: URL {
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
        previousContent = FileManager.default.contents(atPath: contentPath)
        try? FileManager.default.removeItem(atPath: contentPath)
    }

    override func tearDown() {
        super.tearDown()
        FileManager.default.createFile(atPath: contentPath, contents: previousContent)
    }

    func testGenerate_Success() throws {
        let content =
            """
            Hello world!
            ```
            struct Model: Codable {
                let value: String
            }
            ```
            """.data(using: .utf8)
        FileManager.default.createFile(atPath: contentPath, contents: content)

        // swiftlint:disable:next line_length
        let expectedHTML = "<!DOCTYPE html><html lang=\"en\"><head><meta charset=\"UTF-8\"/><title>Attila Nemet</title><meta name=\"twitter:title\" content=\"Attila Nemet\"/><meta name=\"og:title\" content=\"Attila Nemet\"/><meta name=\"description\" content=\"I\'m an iOS engineer based in London.\"/><meta name=\"twitter:description\" content=\"I\'m an iOS engineer based in London.\"/><meta name=\"og:description\" content=\"I\'m an iOS engineer based in London.\"/><meta name=\"color-scheme\" content=\"light dark\"/><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\"/><link rel=\"stylesheet\" href=\"styles.css\" type=\"text/css\"/></head><body><p>Hello world!</p><pre class=\"splash\"><code><span class=\"keyword\">struct</span> Model: <span class=\"type\">Codable</span> {\n    <span class=\"keyword\">let</span> value: <span class=\"type\">String</span>\n}</code></pre></body></html>"

        XCTAssertEqual(try runApp(), expectedHTML + "\n")
        XCTAssertEqual(try String(contentsOfFile: "docs/index.html"), expectedHTML)
    }

    func testGenerate_Failure() throws {
        #if os(Linux)
        XCTAssertEqual(try runApp(), "The operation could not be completed. No such file or directory\n")
        #else
        XCTAssertEqual(try runApp(), "The file “content.md” couldn’t be opened because there is no such file.\n")
        #endif
    }

    private func runApp() throws -> String? {
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
