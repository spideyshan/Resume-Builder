import SwiftUI

struct ContentView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var showSplash = true
    
    var body: some View {
        ZStack {
            if showSplash {
                SplashScreenView {
                    withAnimation {
                        showSplash = false
                    }
                }
            } else {
                if hasSeenOnboarding {
                    WelcomeView()
                } else {
                    OnboardingView()
                }
            }
        }
    }
}
