import SwiftUI

struct WelcomeView: View {
    @State private var isBreathing = false
    
    var body: some View {
        ZStack {
            // Central Content (Icon + Title) - Strictly Centered
            VStack(spacing: 24) {
                // Simple document icon with breathing animation
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.primary) // Adapts to Dark Mode
                        .frame(width: 80, height: 100)
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Rectangle()
                            .fill(Color(.systemBackground)) // Adapts to Dark Mode
                            .frame(width: 40, height: 4)
                        Rectangle()
                            .fill(Color(.systemBackground).opacity(0.6))
                            .frame(width: 50, height: 3)
                        Rectangle()
                            .fill(Color(.systemBackground).opacity(0.4))
                            .frame(width: 35, height: 3)
                        Spacer().frame(height: 8)
                        Rectangle()
                            .fill(Color(.systemBackground).opacity(0.3))
                            .frame(width: 45, height: 3)
                        Rectangle()
                            .fill(Color(.systemBackground).opacity(0.3))
                            .frame(width: 50, height: 3)
                        Rectangle()
                            .fill(Color(.systemBackground).opacity(0.3))
                            .frame(width: 30, height: 3)
                    }
                }
                .scaleEffect(isBreathing ? 1.03 : 1.0)
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isBreathing)
                .onAppear {
                    isBreathing = true
                }
                
                // Title Group
                VStack(spacing: 8) {
                    Text("Resume Builder")
                        .font(.custom("Times New Roman", size: 32).weight(.bold))
                    
                    Text("Create a professional resume in minutes")
                        .font(.system(size: 15))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Occupies full space to center content
            
            // Bottom Button - Anchored to bottom
            VStack {
                Spacer()
                
                NavigationLink {
                    ResumeFormView()
                } label: {
                    Text("Get Started")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(Color(.systemBackground))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.primary)
                        .cornerRadius(10)
                }
                .simultaneousGesture(TapGesture().onEnded {
                    let generator = UIImpactFeedbackGenerator(style: .heavy)
                    generator.impactOccurred()
                })
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .navigationBarHidden(true)
    }
}
