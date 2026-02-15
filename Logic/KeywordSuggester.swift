import Foundation

struct KeywordGroup: Identifiable {
    let id = UUID()
    let title: String
    let keywords: [String]
    let description: String
}

struct KeywordSuggester {
    
    static func suggestKeywords(resume: Resume) -> [KeywordGroup] {
        var suggestions: [KeywordGroup] = []
        
        // 1. Identify Primary Category
        let primaryCategory = identifyPrimaryCategory(resume: resume)
        
        // 2. Suggest missing skills for that category
        if let category = primaryCategory {
            let existingSkills = Set(resume.skills[category] ?? [])
            let allSkills = Set(category.predefinedSkills)
            let missingSkills = allSkills.subtracting(existingSkills).sorted()
            
            // Suggest top 5 missing skills if there are any
            if !missingSkills.isEmpty {
                suggestions.append(KeywordGroup(
                    title: "Recommended Skills for \(category.rawValue)",
                    keywords: Array(missingSkills.prefix(8)),
                    description: "Consider adding these standard skills for your role."
                ))
            }
        }
        
        // 3. Check for Power Words (Action Verbs)
        let allBullets = resume.experience.flatMap { $0.bullets } + resume.projects.flatMap { $0.bullets }
        let usedWords = Set(allBullets.flatMap { $0.lowercased().split(separator: " ").map(String.init) })
        
        let powerWords = [
            "achieved", "improved", "managed", "created", "resolved", "launched", "negotiated", "organized", "led", "developed"
        ]
        
        let missingPowerWords = powerWords.filter { !usedWords.contains($0) }
        
        if !missingPowerWords.isEmpty {
            suggestions.append(KeywordGroup(
                title: "Power Words",
                keywords: Array(missingPowerWords.prefix(6)),
                description: "Use these strong action verbs in your bullet points."
            ))
        }
        
        return suggestions
    }
    
    private static func identifyPrimaryCategory(resume: Resume) -> SkillCategory? {
        // Find the category with the most skills
        return resume.skills.max { a, b in a.value.count < b.value.count }?.key
    }
}
