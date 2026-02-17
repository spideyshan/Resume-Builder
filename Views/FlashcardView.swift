import SwiftUI

struct FlashcardView: View {
    let question: InterviewQuestion
    @State private var isFlipped = false
    @State private var rotation: Double = 0
    
    var body: some View {
        ZStack {
            // Back of Card (Answer)
            CardFace(title: "Answer", content: question.answer, context: question.context, color: .green)
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                .opacity(isFlipped ? 1 : 0)
            
            // Front of Card (Question)
            CardFace(title: "Question", content: question.question, context: question.context, color: .blue)
                .opacity(isFlipped ? 0 : 1)
        }
        .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: 1, z: 0))
        .onTapGesture {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8, blendDuration: 0)) {
                isFlipped.toggle()
                rotation += 180
            }
        }
    }
}

struct CardFace: View {
    let title: String
    let content: String
    let context: String?
    let color: Color
    
    var body: some View {
        VStack(spacing: 20) {
            Text(title.uppercased())
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(color)
                .padding(.top, 20)
            
            Spacer()
            
            Text(content)
                .font(.title3)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .foregroundColor(.primary)
            
            if let context = context {
                Text(context)
                    .font(.caption)
                    .italic()
                    .foregroundColor(.secondary)
                    .padding(.top, 10)
            }
            
            Spacer()
            
            Text(title == "Question" ? "Tap to flip" : "Tap to see question")
                .font(.caption2)
                .foregroundColor(.secondary)
                .padding(.bottom, 20)
        }
        .frame(width: 300, height: 400)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(20)
        .shadow(radius: 10)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(color.opacity(0.5), lineWidth: 1)
        )
    }
}
