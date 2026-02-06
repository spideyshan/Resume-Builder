import SwiftUI

struct WelcomeView: View {
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            // Simple document icon
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.black)
                    .frame(width: 80, height: 100)
                
                VStack(alignment: .leading, spacing: 6) {
                    Rectangle()
                        .fill(Color.white)
                        .frame(width: 40, height: 4)
                    Rectangle()
                        .fill(Color.white.opacity(0.6))
                        .frame(width: 50, height: 3)
                    Rectangle()
                        .fill(Color.white.opacity(0.4))
                        .frame(width: 35, height: 3)
                    Spacer().frame(height: 8)
                    Rectangle()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 45, height: 3)
                    Rectangle()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 50, height: 3)
                    Rectangle()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 30, height: 3)
                }
            }
            .padding(.bottom, 40)
            
            // Title
            VStack(spacing: 6) {
                Text("Resume Builder")
                    .font(.system(size: 28, weight: .bold))
                
                Text("Create a professional resume in minutes")
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Start button
            NavigationLink {
                ResumeFormView()
            } label: {
                Text("Get Started")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.black)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .navigationBarHidden(true)
    }
}
