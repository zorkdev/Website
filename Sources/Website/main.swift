import Foundation
import Files
import Ink
import Plot
import SplashPublishPlugin
import Publish

struct MyWebsite: Website {
    enum SectionID: String, WebsiteSectionID {
        case about
    }

    struct ItemMetadata: WebsiteItemMetadata {}

    let url = URL(string: "https://www.attilanemet.com")!
    let name = "Attila Nemet"
    let description = "I'm an iOS engineer based in London."
    let language: Language = .english
    let imagePath: Path? = nil
    let favicon: Favicon? = .init(path: "favicon.png")
}

extension Theme where Site == MyWebsite {
    static var custom: Self {
        Theme(htmlFactory: CustomHTMLFactory())
    }

    private struct CustomHTMLFactory: HTMLFactory {
        func makeIndexHTML(for index: Index, context: PublishingContext<MyWebsite>) throws -> HTML {
            HTML(
                .lang(context.site.language),
                .head(
                    .encoding(.utf8),
                    .title(context.site.name),
                    .description(context.site.description),
                    .meta(.name("color-scheme"), .content("light dark")),
                    .viewport(.accordingToDevice),
                    .stylesheet("styles.css"),
                    .unwrap(context.site.favicon) { .favicon($0) },
                    .link(.rel(.appleTouchIcon), .href("apple-touch-icon.png"), .type("image/png"))
                ),
                .body(
                    .contentBody(index.body)
                )
            )
        }

        func makeSectionHTML(for section: Section<MyWebsite>, context: PublishingContext<MyWebsite>) throws -> HTML {
            HTML()
        }
        func makeItemHTML(for item: Item<MyWebsite>, context: PublishingContext<MyWebsite>) throws -> HTML { HTML() }
        func makePageHTML(for page: Page, context: PublishingContext<MyWebsite>) throws -> HTML { HTML() }
        func makeTagListHTML(for page: TagListPage, context: PublishingContext<MyWebsite>) throws -> HTML? { nil }
        func makeTagDetailsHTML(for page: TagDetailsPage, context: PublishingContext<MyWebsite>) throws -> HTML? { nil }
    }
}

extension StringProtocol {
    func substring(start: Character, end: Character) -> SubSequence? {
        guard let lowerBound = firstIndex(of: start),
            let upperBound = lastIndex(of: end) else { return nil }
        let newLowerBound = self.index(lowerBound, offsetBy: 1)
        return self[newLowerBound..<upperBound]
    }
}

extension Plugin {
    static func darkModeImages() -> Self {
        Plugin(name: "Dark Mode Images") { context in
            context.markdownParser.addModifier(Modifier(target: .images) { input in
                guard let filename = input.markdown.substring(start: "(", end: "."),
                    let fileExtension = input.markdown.substring(start: ".", end: ")"),
                    let alt = input.markdown.substring(start: "[", end: "]") else { return input.html }

                return Node.picture(
                    .source(
                        .srcset("\(filename)-dark.\(fileExtension), \(filename)-dark-2x.\(fileExtension) 2x"),
                        .media("(prefers-color-scheme: dark)")
                    ),
                    .img(
                        .src("\(filename).\(fileExtension)"),
                        .alt(String(alt)),
                        .attribute(named: "srcset", value: "\(filename)-2x.\(fileExtension) 2x")
                    )
                ).render()
            })
        }
    }
}

try MyWebsite().publish(using: [
    .installPlugin(.splash(withClassPrefix: "")),
    .installPlugin(.darkModeImages()),
    .optional(.copyResources()),
    .addMarkdownFiles(),
    .generateHTML(withTheme: .custom)
])

let packageFolder = try File(path: #file).parent?.parent?.parent
try? packageFolder?.subfolder(named: "docs").delete()
try packageFolder?.subfolder(named: "Output").rename(to: "docs")
