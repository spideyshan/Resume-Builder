import SwiftUI

struct SplashScreenView: View {
    @State private var scale = 0.5
    @State private var rotation = -30.0
    @State private var opacity = 0.0 // Logo opacity
    @State private var textOpacity = 0.0
    
    // Custom binding to signal when animation completes
    var onAnimationComplete: () -> Void
    
    var body: some View {
        ZStack {
            // Background - Force system background
            Color(UIColor.systemBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                // Logo with Spring Animation
                Image(systemName: "doc.text.fill") 
                    .font(.system(size: 80))
                    .foregroundColor(.blue)
                    .scaleEffect(scale)
                    .rotationEffect(.degrees(rotation))
                    .opacity(opacity)
                
                // App Name
                Text("ResumeCraft")
                    .font(.title) 
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .opacity(textOpacity)
                
                // Subtle Tagline
                Text("Professional resumes in minutes")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .opacity(textOpacity)
            }
        }
        .task {
            // Force a slight delay to ensure view is mounted before animating
            try? await Task.sleep(nanoseconds: 100_000_000) // 0.1s
            
            // 1. Logo Spring Entrance
            withAnimation(.interpolatingSpring(stiffness: 120, damping: 12)) {
                scale = 1.0
                rotation = 0
                opacity = 1.0
            }
            
            // 2. Text Fade In (Delayed)
            withAnimation(.easeIn(duration: 0.8).delay(0.4)) {
                textOpacity = 1.0
            }
            
            // 3. Exit Callback
            try? await Task.sleep(nanoseconds: 2_000_000_000) // 2.0s
            onAnimationComplete()
        }
    }
}
