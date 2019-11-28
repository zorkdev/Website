import Foundation
import Ink

private func read(filename: String) -> String {
    let content: String

    do {
        content = try String(contentsOfFile: filename)
    } catch {
        print(error.localizedDescription)
        exit(1)
    }

    return content
}

public func generate() {
    let template = read(filename: "template.html")
    let content = read(filename: "content.md")
    let contentHTML = MarkdownParser().html(from: content)
    let html = String(format: template, contentHTML)
    try? FileManager.default.createDirectory(atPath: "docs", withIntermediateDirectories: false)
    FileManager.default.createFile(atPath: "docs/index.html", contents: html.data(using: .utf8))
    print(html)
}
