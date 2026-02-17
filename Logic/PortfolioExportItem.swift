import SwiftUI
import UniformTypeIdentifiers

struct PortfolioExportItem: Transferable {
    let resume: Resume
    
    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(exportedContentType: .html) { item in
            let html = PortfolioGenerator.generateHTML(for: item.resume)
            let tempDir = FileManager.default.temporaryDirectory
            let fileName = "index.html"
            let fileURL = tempDir.appendingPathComponent(fileName)
            
            try html.write(to: fileURL, atomically: true, encoding: .utf8)
            
            return SentTransferredFile(fileURL)
        }
    }
}
