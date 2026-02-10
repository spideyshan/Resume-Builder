import SwiftUI

@main
struct MyAppCopy: App {
    @StateObject private var resumeManager = ResumeManager()
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(resumeManager)
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
