import SwiftUI

struct ResumeAnalysisView: View {
    
    let resume: Resume
    let feedback: [String]
    
    init(resume: Resume) {
        self.resume = resume
        self.feedback = ResumeAnalyzer.analyze(resume: resume)
    }
    
    var isComplete: Bool {
        feedback.count == 1 && feedback.first?.contains("strong") == true
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // Status
                VStack(spacing: 12) {
                    Image(systemName: isComplete ? "checkmark.circle" : "exclamationmark.circle")
                        .font(.system(size: 44, weight: .light))
                        .foregroundColor(isComplete ? .green : .orange)
                    
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
                    ResumePreviewView(resume: resume)
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
    }
}
