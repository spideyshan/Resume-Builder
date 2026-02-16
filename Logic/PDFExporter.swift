import UIKit
import WebKit

class PDFExporter: NSObject, WKNavigationDelegate {
    
    static let shared = PDFExporter()
    
    private var webView: WKWebView?
    private var completion: ((URL?) -> Void)?
    
    func exportToPDF(html: String, completion: @escaping (URL?) -> Void) {
        self.completion = completion
        
        // Width matches Letter page; tall height lets content fully render
        let config = WKWebViewConfiguration()
        let pageFrame = CGRect(x: 0, y: 0, width: 612, height: 5000)
        self.webView = WKWebView(frame: pageFrame, configuration: config)
        self.webView?.navigationDelegate = self
        self.webView?.isHidden = true
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.addSubview(self.webView!)
        }
        
        self.webView?.loadHTMLString(html, baseURL: nil)
    }
    
    // MARK: - WKNavigationDelegate
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            self.createPDF()
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("WebView navigation failed: \(error.localizedDescription)")
        completion?(nil)
        cleanup()
    }
    
    private func createPDF() {
        guard let webView = webView else {
            completion?(nil)
            return
        }
        
        // Use UIPrintPageRenderer for proper multi-page A4/Letter pagination
        let renderer = UIPrintPageRenderer()
        let formatter = webView.viewPrintFormatter()
        renderer.addPrintFormatter(formatter, startingAtPageAt: 0)
        
        // Letter page size in points (8.5 x 11 inches)
        let pageSize = CGSize(width: 612, height: 792)
        let pageRect = CGRect(origin: .zero, size: pageSize)
        
        renderer.setValue(NSValue(cgRect: pageRect), forKey: "paperRect")
        renderer.setValue(NSValue(cgRect: pageRect), forKey: "printableRect")
        
        // Render all pages into PDF data
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, pageRect, nil)
        
        for i in 0..<renderer.numberOfPages {
            UIGraphicsBeginPDFPage()
            renderer.drawPage(at: i, in: UIGraphicsGetPDFContextBounds())
        }
        
        UIGraphicsEndPDFContext()
        
        // Save to temp file
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("Resume.pdf")
        do {
            if FileManager.default.fileExists(atPath: tempURL.path) {
                try FileManager.default.removeItem(at: tempURL)
            }
            try pdfData.write(to: tempURL, options: .atomic)
            self.completion?(tempURL)
        } catch {
            print("Failed to write PDF: \(error)")
            self.completion?(nil)
        }
        
        cleanup()
    }
    
    private func cleanup() {
        webView?.removeFromSuperview()
        webView = nil
        completion = nil
    }
}
