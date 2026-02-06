import SwiftUI

// MARK: - Resume Templates

enum ResumeTemplate: String, CaseIterable, Identifiable {
    case classic = "Classic"
    case simple = "Simple" 
    case modern = "Modern"
    
    var id: String { rawValue }
    
    var description: String {
        switch self {
        case .classic: return "Professional with timeline dots"
        case .simple: return "Clean and minimal"
        case .modern: return "Two-column modern layout"
        }
    }
    
    var icon: String {
        switch self {
        case .classic: return "doc.text"
        case .simple: return "doc.plaintext"
        case .modern: return "rectangle.split.2x1"
        }
    }
    
    var accentColor: Color {
        switch self {
        case .classic: return .black
        case .simple: return .black
        case .modern: return Color(red: 0.7, green: 0.85, blue: 0.85)
        }
    }
}
