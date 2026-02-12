import Foundation

// MARK: - Resume Models

struct Resume: Identifiable, Codable, Equatable, Hashable {
    var id = UUID()
    var lastModified = Date()
    var title: String? // Optional title for the resume
    
    // Personal Info
    var firstName: String
    var lastName: String
    
    // Contact
    var email: String
    var countryCode: CountryCode
    var phone: String
    var location: String
    var linkedin: String
    var github: String
    var photoData: Data? // Profile photo data
    
    // Sections
    var education: [Education]
    var skills: [SkillCategory: [String]]
    var experience: [Experience]
    var projects: [Project]
    var certifications: [Certification]?
    
    var fullName: String {
        "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
    }
    
    var fullPhone: String {
        guard !phone.isEmpty else { return "" }
        return "\(countryCode.dialCode) \(phone)"
    }
    
    var linkedinURL: URL? {
        guard !linkedin.isEmpty else { return nil }
        let urlString = linkedin.hasPrefix("http") ? linkedin : "https://\(linkedin)"
        return URL(string: urlString)
    }
    
    var githubURL: URL? {
        guard !github.isEmpty else { return nil }
        let urlString = github.hasPrefix("http") ? github : "https://\(github)"
        return URL(string: urlString)
    }
}

// MARK: - Education

enum EducationType: String, CaseIterable, Hashable, Codable {
    case classX = "Class X (10th)"
    case classXII = "Class XII (12th)"
    case diploma = "Diploma"
    case degree = "Degree (B.Tech, BCA, etc.)"
    case postgraduate = "Post Graduate (M.Tech, MBA, etc.)"
    
    var schoolLabel: String {
        switch self {
        case .classX, .classXII: return "School Name"
        case .diploma, .degree, .postgraduate: return "College / University"
        }
    }
    
    var fieldLabel: String? {
        switch self {
        case .classX, .classXII: return nil // No field for school
        case .diploma, .degree, .postgraduate: return "Field of Study"
        }
    }
    
    var degreeLabel: String? {
        switch self {
        case .classX: return nil
        case .classXII: return nil
        case .diploma: return "Diploma Name"
        case .degree: return "Degree Name (e.g., B.Tech, BCA)"
        case .postgraduate: return "Degree Name (e.g., M.Tech, MBA)"
        }
    }
    
    var scoreLabel: String {
        switch self {
        case .classX, .classXII: return "Marks / Percentage"
        case .diploma, .degree, .postgraduate: return "CGPA"
        }
    }
    
    var scorePlaceholder: String {
        switch self {
        case .classX, .classXII: return "85% or 450/500"
        case .diploma, .degree, .postgraduate: return "8.5"
        }
    }
    
    var displayName: String {
        switch self {
        case .classX: return "Class X"
        case .classXII: return "Class XII"
        case .diploma: return "Diploma"
        case .degree: return "Degree"
        case .postgraduate: return "Post Graduate"
        }
    }
}

struct Education: Identifiable, Hashable, Codable {
    let id = UUID()
    var type: EducationType
    var institution: String
    var degree: String      // For college only
    var field: String       // For college only
    var year: String
    var score: String
    
    var formattedScore: String {
        guard !score.isEmpty else { return "" }
        switch type {
        case .classX, .classXII:
            // If it already has % or /, return as is
            if score.contains("%") || score.contains("/") {
                return score
            }
            return "\(score)%"
        case .diploma, .degree, .postgraduate:
            return "CGPA: \(score)"
        }
    }
    
    var displayTitle: String {
        switch type {
        case .classX:
            return "Class X"
        case .classXII:
            return "Class XII"
        case .diploma, .degree, .postgraduate:
            if !degree.isEmpty {
                if !field.isEmpty {
                    return "\(degree) in \(field)"
                }
                return degree
            }
            return type.displayName
        }
    }
}

// MARK: - Skill Category

enum SkillCategory: String, CaseIterable, Hashable, Identifiable, Codable {
    case frontend = "Frontend"
    case backend = "Backend"
    case database = "Database"
    case mobile = "Mobile"
    case devops = "DevOps"
    case tools = "Tools"
    case languages = "Languages"
    case softSkills = "Soft Skills"
    case other = "Other"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .frontend: return "globe"
        case .backend: return "server.rack"
        case .database: return "cylinder"
        case .mobile: return "iphone"
        case .devops: return "cloud"
        case .tools: return "wrench.and.screwdriver"
        case .languages: return "chevron.left.forwardslash.chevron.right"
        case .softSkills: return "person.2"
        case .other: return "ellipsis"
        }
    }
    
    var predefinedSkills: [String] {
        switch self {
        case .frontend:
            return ["React", "Angular", "Vue.js", "Next.js", "TypeScript", "JavaScript", "HTML", "CSS", "Tailwind CSS", "Bootstrap", "SASS", "jQuery", "Redux", "Svelte"]
        case .backend:
            return ["Node.js", "Python", "Java", "Go", "Ruby", "PHP", "C#", ".NET", "Express.js", "Django", "Flask", "Spring Boot", "FastAPI", "Laravel"]
        case .database:
            return ["MySQL", "PostgreSQL", "MongoDB", "Redis", "SQLite", "Oracle", "Firebase", "Supabase", "DynamoDB", "Elasticsearch", "Cassandra"]
        case .mobile:
            return ["Swift", "SwiftUI", "UIKit", "Kotlin", "React Native", "Flutter", "Dart", "Objective-C", "Xcode", "Android Studio", "Jetpack Compose"]
        case .devops:
            return ["Docker", "Kubernetes", "AWS", "Azure", "GCP", "Jenkins", "GitHub Actions", "CircleCI", "Terraform", "Ansible", "Linux", "Nginx"]
        case .tools:
            return ["Git", "GitHub", "GitLab", "Jira", "Figma", "VS Code", "Postman", "Notion", "Slack", "Trello", "Confluence"]
        case .languages:
            return ["Python", "JavaScript", "TypeScript", "Java", "C++", "C", "Go", "Rust", "Swift", "Kotlin", "Ruby", "PHP", "R", "MATLAB"]
        case .softSkills:
            return ["Communication", "Leadership", "Teamwork", "Problem Solving", "Time Management", "Critical Thinking", "Adaptability", "Creativity"]
        case .other:
            return []
        }
    }
}

// MARK: - Experience

struct Experience: Identifiable, Hashable, Codable {
    let id = UUID()
    var title: String
    var company: String
    var duration: String
    var bullets: [String]
}

// MARK: - Project

struct Project: Identifiable, Hashable, Codable {
    let id = UUID()
    var name: String
    var link: String
    var tools: String
    var bullets: [String]
    
    var hasValidLink: Bool {
        guard !link.isEmpty else { return false }
        let urlString = link.hasPrefix("http") ? link : "https://\(link)"
        return URL(string: urlString) != nil
    }
    
    var url: URL? {
        guard hasValidLink else { return nil }
        let urlString = link.hasPrefix("http") ? link : "https://\(link)"
        return URL(string: urlString)
    }
}

// MARK: - Country Code

struct CountryCode: Hashable, Identifiable, Codable {
    let id = UUID()
    let name: String
    let code: String
    let dialCode: String
    
    var flag: String {
        let base: UInt32 = 127397
        var flag = ""
        for scalar in code.uppercased().unicodeScalars {
            if let unicode = UnicodeScalar(base + scalar.value) {
                flag.append(String(unicode))
            }
        }
        return flag
    }
    
    var displayText: String {
        "\(flag) \(dialCode)"
    }
    
    static let all: [CountryCode] = [
        CountryCode(name: "United States", code: "US", dialCode: "+1"),
        CountryCode(name: "United Kingdom", code: "GB", dialCode: "+44"),
        CountryCode(name: "India", code: "IN", dialCode: "+91"),
        CountryCode(name: "Canada", code: "CA", dialCode: "+1"),
        CountryCode(name: "Australia", code: "AU", dialCode: "+61"),
        CountryCode(name: "Germany", code: "DE", dialCode: "+49"),
        CountryCode(name: "France", code: "FR", dialCode: "+33"),
        CountryCode(name: "Japan", code: "JP", dialCode: "+81"),
        CountryCode(name: "China", code: "CN", dialCode: "+86"),
        CountryCode(name: "Brazil", code: "BR", dialCode: "+55"),
        CountryCode(name: "Mexico", code: "MX", dialCode: "+52"),
        CountryCode(name: "South Korea", code: "KR", dialCode: "+82"),
        CountryCode(name: "Italy", code: "IT", dialCode: "+39"),
        CountryCode(name: "Spain", code: "ES", dialCode: "+34"),
        CountryCode(name: "Netherlands", code: "NL", dialCode: "+31"),
        CountryCode(name: "Russia", code: "RU", dialCode: "+7"),
        CountryCode(name: "Singapore", code: "SG", dialCode: "+65"),
        CountryCode(name: "UAE", code: "AE", dialCode: "+971"),
        CountryCode(name: "Saudi Arabia", code: "SA", dialCode: "+966"),
        CountryCode(name: "South Africa", code: "ZA", dialCode: "+27"),
        CountryCode(name: "New Zealand", code: "NZ", dialCode: "+64"),
        CountryCode(name: "Ireland", code: "IE", dialCode: "+353"),
        CountryCode(name: "Sweden", code: "SE", dialCode: "+46"),
        CountryCode(name: "Switzerland", code: "CH", dialCode: "+41"),
        CountryCode(name: "Norway", code: "NO", dialCode: "+47"),
        CountryCode(name: "Denmark", code: "DK", dialCode: "+45"),
        CountryCode(name: "Finland", code: "FI", dialCode: "+358"),
        CountryCode(name: "Poland", code: "PL", dialCode: "+48"),
        CountryCode(name: "Belgium", code: "BE", dialCode: "+32"),
        CountryCode(name: "Austria", code: "AT", dialCode: "+43"),
        CountryCode(name: "Portugal", code: "PT", dialCode: "+351"),
        CountryCode(name: "Greece", code: "GR", dialCode: "+30"),
        CountryCode(name: "Israel", code: "IL", dialCode: "+972"),
        CountryCode(name: "Turkey", code: "TR", dialCode: "+90"),
        CountryCode(name: "Thailand", code: "TH", dialCode: "+66"),
        CountryCode(name: "Malaysia", code: "MY", dialCode: "+60"),
        CountryCode(name: "Indonesia", code: "ID", dialCode: "+62"),
        CountryCode(name: "Philippines", code: "PH", dialCode: "+63"),
        CountryCode(name: "Vietnam", code: "VN", dialCode: "+84"),
        CountryCode(name: "Pakistan", code: "PK", dialCode: "+92"),
        CountryCode(name: "Bangladesh", code: "BD", dialCode: "+880"),
        CountryCode(name: "Sri Lanka", code: "LK", dialCode: "+94"),
        CountryCode(name: "Nepal", code: "NP", dialCode: "+977"),
        CountryCode(name: "Egypt", code: "EG", dialCode: "+20"),
        CountryCode(name: "Nigeria", code: "NG", dialCode: "+234"),
        CountryCode(name: "Kenya", code: "KE", dialCode: "+254"),
        CountryCode(name: "Argentina", code: "AR", dialCode: "+54"),
        CountryCode(name: "Chile", code: "CL", dialCode: "+56"),
        CountryCode(name: "Colombia", code: "CO", dialCode: "+57"),
        CountryCode(name: "Peru", code: "PE", dialCode: "+51"),
    ]
    
    static let defaultCode = CountryCode(name: "India", code: "IN", dialCode: "+91")
}

// MARK: - Certification

struct Certification: Identifiable, Hashable, Codable {
    let id = UUID()
    var name: String
    var issuer: String
    var issueDate: String  // e.g., "Jan 2023"
    var expiryDate: String // e.g., "Jan 2026" or "No Expiry"
    var link: String?      // Optional link to certificate
    
    var hasValidLink: Bool {
        guard let link = link, !link.isEmpty else { return false }
        let urlString = link.hasPrefix("http") ? link : "https://\(link)"
        return URL(string: urlString) != nil
    }
    
    var url: URL? {
        guard hasValidLink, let link = link else { return nil }
        let urlString = link.hasPrefix("http") ? link : "https://\(link)"
        return URL(string: urlString)
    }
}
