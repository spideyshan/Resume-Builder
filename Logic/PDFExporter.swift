import UIKit
import WebKit

class PDFExporter: NSObject, WKNavigationDelegate {
    
    static let shared = PDFExporter()
    
    private var webView: WKWebView?
    private var completion: ((URL?) -> Void)?
    
    func exportToPDF(html: String, completion: @escaping (URL?) -> Void) {
        self.completion = completion
        
        // Configure WebView
        let config = WKWebViewConfiguration()
        self.webView = WKWebView(frame: .zero, configuration: config)
        self.webView?.navigationDelegate = self
        self.webView?.isHidden = true
        
        // Add to key window to ensure rendering (sometimes needed for WebKit)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.addSubview(self.webView!)
        }
        
        // Load HTML
        let wrappedHTML = html
        self.webView?.loadHTMLString(wrappedHTML, baseURL: nil)
    }
    
    // MARK: - WKNavigationDelegate
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // Delay slightly to ensure rendering (fonts, layout) is stable
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
        
        let pdfConfig = WKPDFConfiguration()
        // Standard A4 / Letter approx points
        pdfConfig.rect = CGRect(x: 0, y: 0, width: 612, height: 792) 
        
        if #available(iOS 14.0, *) {
            webView.createPDF(configuration: pdfConfig) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let data):
                    let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("Resume.pdf")
                    do {
                        try data.write(to: tempURL)
                        self.completion?(tempURL)
                    } catch {
                        print("Failed to write PDF: \(error)")
                        self.completion?(nil)
                    }
                case .failure(let error):
                    print("Failed to create PDF: \(error)")
                    self.completion?(nil)
                }
                
                self.cleanup()
            }
        } else {
            // Fallback or error for older iOS (not expected here)
            print("iOS 14+ required for createPDF")
            completion?(nil)
            cleanup()
        }
    }
    
    private func cleanup() {
        webView?.removeFromSuperview()
        webView = nil
        completion = nil
    }
}
