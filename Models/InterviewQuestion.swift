import Foundation

enum QuestionType: String, CaseIterable, Codable {
    case technical = "Technical"
    case behavioral = "Behavioral"
    case general = "General"
}

struct InterviewQuestion: Identifiable, Codable {
    var id: UUID = UUID()
    var question: String
    var answer: String // Or a hint/guide on how to answer
    var type: QuestionType
    var context: String? // e.g., "From your Swift skills", "Regarding Project X"
    var isFavorite: Bool = false
}
