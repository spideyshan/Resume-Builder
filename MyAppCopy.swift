import SwiftUI

@main
struct MyAppCopy: App {
    @StateObject private var resumeManager = ResumeManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(resumeManager)
        }
    }
}
