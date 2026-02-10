import SwiftUI

struct ResumeAnalysisView: View {
    
    let resume: Resume
    let feedback: [String]
    @Binding var path: NavigationPath
    
    init(resume: Resume, path: Binding<NavigationPath>) {
        self.resume = resume
        self._path = path
        self.feedback = ResumeAnalyzer.analyze(resume: resume)
    }
    
    var isComplete: Bool {
        feedback.count == 1 && feedback.first?.contains("strong") == true
    }
    
    var atsScore: Int {
        ResumeAnalyzer.calculateATSScore(resume: resume)
    }
    
    var scoreColor: Color {
        if atsScore >= 80 { return .green }
        else if atsScore >= 50 { return .orange }
        else { return .red }
    }
    
    @EnvironmentObject var resumeManager: ResumeManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // Status
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .stroke(lineWidth: 10)
                            .opacity(0.3)
                            .foregroundColor(scoreColor)
                        
                        Circle()
                            .trim(from: 0.0, to: CGFloat(atsScore) / 100.0)
                            .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                            .foregroundColor(scoreColor)
                            .rotationEffect(Angle(degrees: 270.0))
                            .animation(.linear, value: atsScore)

                        VStack {
                            Text("\(atsScore)")
                                .font(.system(size: 40, weight: .bold))
                            Text("ATS Score")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(width: 120, height: 120)
                    
                    Text(isComplete ? "Ready to go!" : "Review needed")
                        .font(.system(size: 20, weight: .semibold))
                    
                    Text(isComplete ? "Your resume looks complete" : "\(feedback.count) suggestion\(feedback.count == 1 ? "" : "s")")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                .padding(.top, 20)
                
                // Feedback list
                if !isComplete {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(Array(feedback.enumerated()), id: \.offset) { index, tip in
                            HStack(alignment: .top, spacing: 12) {
                                Text("•")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.orange)
                                
                                Text(tip)
                                    .font(.system(size: 14))
                                    .foregroundColor(.primary)
                                
                                Spacer()
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            
                            if index < feedback.count - 1 {
                                Divider()
                                    .padding(.leading, 36)
                            }
                        }
                    }
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                }
                
                // Preview Button
                NavigationLink {
                    ResumePreviewView(resume: resume, path: $path)
                } label: {
                    HStack {
                        Text("View Resume")
                            .font(.system(size: 17, weight: .semibold))
                        Spacer()
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(Color.black)
                    .cornerRadius(10)
                }
            }
            .padding(20)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Review")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            resumeManager.save(resume: resume)
        }
    }
}
