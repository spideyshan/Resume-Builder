import Foundation

// MARK: - Cover Letter Model

struct CoverLetter: Identifiable, Codable {
    var id = UUID()
    
    // Target Info
    var companyName: String = ""
    var jobTitle: String = ""
    var hiringManagerName: String = ""
    
    // Content
    var tone: CoverLetterTone = .formal
    var whyInterested: String = ""
    
    // Source
    var resumeId: UUID?
}

// MARK: - Tone

enum CoverLetterTone: String, CaseIterable, Codable, Identifiable {
    case formal = "Formal"
    case modern = "Modern"
    case creative = "Creative"
    
    var id: String { rawValue }
    
    var description: String {
        switch self {
        case .formal: return "Traditional business letter"
        case .modern: return "Clean and direct"
        case .creative: return "Expressive and bold"
        }
    }
    
    var greeting: String {
        switch self {
        case .formal: return "Dear"
        case .modern: return "Hello"
        case .creative: return "Hi"
        }
    }
    
    var signOff: String {
        switch self {
        case .formal: return "Sincerely"
        case .modern: return "Best regards"
        case .creative: return "Cheers"
        }
    }
}
