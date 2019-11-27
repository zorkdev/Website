import Foundation
import Ink

func read(filename: String) -> String {
    let path = FileManager.default.currentDirectoryPath + "/" + filename

    do {
        return try String(contentsOfFile: path)
    } catch {
        print(error.localizedDescription)
        exit(1)
    }
}

let head = read(filename: "head.html")
let content = read(filename: "content.md")
let contentHTML = MarkdownParser().html(from: content)
let html = String(format: head, contentHTML)
FileManager.default.createFile(atPath: "index.html", contents: html.data(using: .utf8))
print(html)
