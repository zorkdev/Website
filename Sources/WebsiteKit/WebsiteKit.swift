import Foundation
import Ink
import Plot

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

private func template(content: String) -> HTML {
    HTML(
        .lang("en"),
        .head(
            .encoding(.utf8),
            .title("Attila Nemet"),
            .description("I'm an iOS engineer based in London."),
            .meta(.name("color-scheme"), .content("light dark")),
            .viewport(.accordingToDevice),
            .stylesheet("styles.css")
        ),
        .body(
            .raw(content)
        )
    )
}

public func generate() {
    let content = read(filename: "content.md")
    let contentHTML = MarkdownParser().html(from: content)
    let html = template(content: contentHTML).render()
    try? FileManager.default.createDirectory(atPath: "docs", withIntermediateDirectories: false)
    FileManager.default.createFile(atPath: "docs/index.html", contents: html.data(using: .utf8))
    print(html)
}
