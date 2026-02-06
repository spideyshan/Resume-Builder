import SwiftUI

struct WelcomeView: View {
    @State private var isBreathing = false
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            // Central Content (Icon + Title)
            VStack(spacing: 24) {
                // Simple document icon
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.primary)
                        .frame(width: 80, height: 100)
                        .shadow(radius: 5) // Added shadow for better visibility
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Rectangle()
                            .fill(Color(.systemBackground))
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
                // Animation removed to prevent "moving" issues
                
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
            
            Spacer()
            
            // Allow space for the button at the bottom
            Spacer().frame(height: 20)
            
            // Start button
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
                generator.prepare()
                generator.impactOccurred()
            })
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .navigationBarHidden(true)
    }
}
