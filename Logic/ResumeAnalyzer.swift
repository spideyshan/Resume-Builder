import Foundation

struct ResumeAnalyzer {
    
    static func analyze(resume: Resume) -> [String] {
        var feedback: [String] = []
        
        // Name check
        if resume.firstName.isEmpty || resume.lastName.isEmpty {
            feedback.append("Add your full name (first and last).")
        }
        
        // Contact check
        if resume.email.isEmpty {
            feedback.append("Add your email address.")
        }
        
        if resume.phone.isEmpty {
            feedback.append("Add your phone number.")
        }
        
        // Education check
        if resume.education.isEmpty {
            feedback.append("Add at least one education entry.")
        } else {
            let incompleteEdu = resume.education.filter { $0.institution.isEmpty || $0.degree.isEmpty }
            if !incompleteEdu.isEmpty {
                feedback.append("Complete all education entries with institution and degree.")
            }
        }
        
        // Skills check
        let totalSkills = resume.skills.values.reduce(0) { $0 + $1.count }
        if totalSkills < 3 {
            feedback.append("Add at least 3 skills.")
        }
        
        // Experience check
        if resume.experience.isEmpty && resume.projects.isEmpty {
            feedback.append("Add at least one experience or project.")
        }
        
        // Experience bullets check
        let expWithoutBullets = resume.experience.filter { $0.bullets.isEmpty }
        if !expWithoutBullets.isEmpty {
            feedback.append("Add bullet points to describe your experience.")
        }
        
        // Project bullets check
        let projWithoutBullets = resume.projects.filter { $0.bullets.isEmpty }
        if !projWithoutBullets.isEmpty {
            feedback.append("Add bullet points to describe your projects.")
        }
        
        // Action verbs check
        let actionVerbs = ["developed", "designed", "built", "created", "implemented", "led", "managed", "improved", "achieved", "integrated", "deployed", "automated", "optimized", "analyzed"]
        
        let allBullets = resume.experience.flatMap { $0.bullets } + resume.projects.flatMap { $0.bullets }
        let hasActionVerbs = allBullets.contains { bullet in
            actionVerbs.contains { verb in
                bullet.lowercased().hasPrefix(verb) || bullet.lowercased().contains(" \(verb)")
            }
        }
        
        if !allBullets.isEmpty && !hasActionVerbs {
            feedback.append("Start bullet points with action verbs (Developed, Built, Led...)")
        }
        
        if feedback.isEmpty {
            feedback.append("Your resume looks strong and well-structured!")
        }
        
        return feedback
    }
}
