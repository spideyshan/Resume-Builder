import SwiftUI

struct InterviewPrepView: View {
    let resume: Resume
    @State private var questions: [InterviewQuestion] = []
    @State private var currentIndex = 0
    
    var body: some View {
        VStack {
            if questions.isEmpty {
                VStack {
                    ProgressView()
                    Text("Generating custom questions...")
                        .padding(.top)
                }
            } else {
                VStack(spacing: 30) {
                    // Progress Bar
                    ProgressView(value: Double(currentIndex + 1), total: Double(questions.count))
                        .padding(.horizontal)
                        .accentColor(.blue)
                    
                    Text("Question \(currentIndex + 1) of \(questions.count)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    // Card Stack
                    ZStack {
                        ForEach(questions.indices.reversed(), id: \.self) { index in
                            if index == currentIndex {
                                FlashcardView(question: questions[index])
                                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                                    .zIndex(1)
                            } else if index == currentIndex + 1 {
                                // Next Card Preview
                                FlashcardView(question: questions[index])
                                    .scaleEffect(0.9)
                                    .offset(x: 20, y: 0)
                                    .opacity(0.5)
                                    .zIndex(0)
                            }
                        }
                    }
                    .frame(height: 420)
                    
                    // Controls
                    HStack(spacing: 40) {
                        Button(action: {
                            withAnimation {
                                if currentIndex > 0 {
                                    currentIndex -= 1
                                }
                            }
                        }) {
                            Image(systemName: "arrow.left.circle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(currentIndex > 0 ? .blue : .gray)
                        }
                        .disabled(currentIndex == 0)
                        
                        Button(action: {
                            withAnimation {
                                if currentIndex < questions.count - 1 {
                                    currentIndex += 1
                                }
                            }
                        }) {
                            Image(systemName: "arrow.right.circle.fill")
                                .font(.system(size: 50))
                                .foregroundColor(currentIndex < questions.count - 1 ? .blue : .gray)
                        }
                        .disabled(currentIndex == questions.count - 1)
                    }
                    .padding(.top, 20)
                }
            }
        }
        .navigationTitle("Interview Prep")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadQuestions()
        }
    }
    
    private func loadQuestions() {
        // Simulate a slight delay for better UX (so user sees "Generating...") -> Optional but feels nice
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.questions = InterviewQuestionGenerator.generate(for: resume)
        }
    }
}
