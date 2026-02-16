import SwiftUI
import WebKit

struct CoverLetterPreviewView: View {
    let resume: Resume
    let coverLetter: CoverLetter
    @Binding var path: NavigationPath
    
    @EnvironmentObject var resumeManager: ResumeManager
    @State private var showShareSheet = false
    @State private var generatedFileUrl: URL?
    @State private var isGeneratingExport = false
    @State private var showCopied = false
    
    var body: some View {
        ZStack {
            CoverLetterWebView(html: generatedHTML)
                .edgesIgnoringSafeArea(.bottom)
            
            if isGeneratingExport {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: 12) {
                    ProgressView()
                        .scaleEffect(1.2)
                    Text("Generating PDF…")
                        .font(.caption)
                        .foregroundColor(.white)
                }
                .padding(24)
                .background(.ultraThinMaterial)
                .cornerRadius(12)
            }
        }
        .navigationTitle("Preview")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 16) {
                    if isGeneratingExport {
                        ProgressView()
                            .scaleEffect(0.7)
                    } else {
                        // Copy button
                        Button {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateStyle = .long
                            let dateStr = dateFormatter.string(from: Date())
                            let text = CoverLetterGenerator.generate(resume: resume, coverLetter: coverLetter)
                            UIPasteboard.general.string = "\(dateStr)\n\n\(text)"
                            showCopied = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                showCopied = false
                            }
                        } label: {
                            Image(systemName: showCopied ? "checkmark" : "doc.on.doc")
                                .foregroundColor(showCopied ? .green : .accentColor)
                        }
                        
                        // Export button
                        Button {
                            exportAsPDF()
                        } label: {
                            Image(systemName: "square.and.arrow.up")
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showShareSheet) {
            if let url = generatedFileUrl {
                ShareSheet(items: [url])
            }
        }
    }
    
    var generatedHTML: String {
        CoverLetterHTMLGenerator.generateHTML(resume: resume, coverLetter: coverLetter)
    }
    
    @MainActor
    func exportAsPDF() {
        isGeneratingExport = true
        let html = generatedHTML
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            PDFExporter.shared.exportToPDF(html: html) { pdfUrl in
                if let url = pdfUrl {
                    let baseName = coverLetter.companyName.isEmpty ? "Cover_Letter" : "Cover_Letter_\(coverLetter.companyName)"
                    var safeName = baseName.components(separatedBy: CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "_- ")).inverted).joined(separator: "_")
                    if safeName.isEmpty { safeName = "Cover_Letter" }
                    let filename = "\(safeName).pdf"
                    let targetURL = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
                    
                    do {
                        if FileManager.default.fileExists(atPath: targetURL.path) {
                            try FileManager.default.removeItem(at: targetURL)
                        }
                        try FileManager.default.moveItem(at: url, to: targetURL)
                        self.generatedFileUrl = targetURL
                        self.showShareSheet = true
                    } catch {
                        self.generatedFileUrl = url
                        self.showShareSheet = true
                    }
                }
                self.isGeneratingExport = false
            }
        }
    }
}

// MARK: - WebView Wrapper

struct CoverLetterWebView: UIViewRepresentable {
    let html: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.isOpaque = false
        webView.backgroundColor = .white
        webView.scrollView.backgroundColor = .white
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        webView.loadHTMLString(html, baseURL: nil)
    }
}
