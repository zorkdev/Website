import Foundation
import Splash
import Ink
import Plot

private extension StringProtocol {
    func substring(start: Character, end: Character) -> SubSequence? {
        guard let lowerBound = firstIndex(of: start),
            let upperBound = lastIndex(of: end) else { return nil }
        let newLowerBound = self.index(lowerBound, offsetBy: 1)
        return self[newLowerBound..<upperBound]
    }
}

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

private let codeBlocksModifier = Modifier(target: .codeBlocks) {
    MarkdownDecorator().decorate(String($0.markdown))
}

private let imagesModifier = Modifier(target: .images) { input in
    guard let filename = input.markdown.substring(start: "(", end: "."),
        let fileExtension = input.markdown.substring(start: ".", end: ")") else { return input.html }
    return
        """
        <picture><source srcset="\(filename)-dark.\(fileExtension)" media="(prefers-color-scheme: dark)">\(input.html)</picture>
        """
}

public func generate() {
    let content = read(filename: "content.md")
    let contentHTML = MarkdownParser(modifiers: [codeBlocksModifier, imagesModifier]).html(from: content)
    let html = template(content: contentHTML).render()
    try? FileManager.default.createDirectory(atPath: "docs", withIntermediateDirectories: false)
    FileManager.default.createFile(atPath: "docs/index.html", contents: html.data(using: .utf8))
    print(html)
}
