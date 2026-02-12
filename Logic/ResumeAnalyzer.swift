import Foundation

struct ResumeAnalyzer {
    
    static func analyze(resume: Resume) -> [String] {
        var feedback: [String] = []
        
        // --- Basic Checks ---
        
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
        
        if resume.linkedin.isEmpty && resume.github.isEmpty {
            feedback.append("Add a LinkedIn or GitHub profile to boost credibility.")
        }
        
        // Certifications check
        if let certs = resume.certifications, !certs.isEmpty {
           feedback.append("Good job adding certifications! They validate your expertise.")
        } else {
            feedback.append("Consider adding certifications to validate your skills.")
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
        
        // --- Smart Checks ---
        
        // Content quality check using NLTagger (via SmartTextAnalyzer)
        let allBullets = resume.experience.flatMap { $0.bullets } + resume.projects.flatMap { $0.bullets }
        
        if !allBullets.isEmpty {
            let averageTone = allBullets.reduce(0.0) { $0 + SmartTextAnalyzer.analyzeTone(text: $1) } / Double(allBullets.count)
            // Sentiment of 0.0 is neutral. Very negative might mean "bad" or just "impersonal".
            // High positive might be "excited". We want professional, which is usually slightly positive or neutral.
            // But let's check for *length* and *keywords* mainly.
            
            // Check for action verbs using SmartTextAnalyzer synonyms/keywords could be an extension, 
            // but for now let's stick to the specific list but maybe suggest better ones?
            // Actually, let's keep the existing action verb check but make it smarter later.
             let actionVerbs = ["developed", "designed", "built", "created", "implemented", "led", "managed", "improved", "achieved", "integrated", "deployed", "automated", "optimized", "analyzed"]
             
             let hasActionVerbs = allBullets.contains { bullet in
                 actionVerbs.contains { verb in
                     bullet.lowercased().hasPrefix(verb) || bullet.lowercased().contains(" \(verb)")
                 }
             }
             
             if !hasActionVerbs {
                  feedback.append("Start bullet points with strong action verbs (e.g., Developed, Managed).")
             }
        }
       
        // ATS Score feedback
        let score = calculateATSScore(resume: resume)
        if score < 50 {
            feedback.append("Your ATS Score is low (\(score)/100). Add more detailed descriptions and skills.")
        } else if score < 80 {
             feedback.append("Good start! boost your ATS score (\(score)/100) by adding more measurable results (numbers, %).")
        }
        
        if feedback.isEmpty {
            feedback.append("Your resume looks strong and well-structured! ATS Score: \(score)/100")
        }
        
        return feedback
    }
    
    static func calculateATSScore(resume: Resume) -> Int {
        var score = 0
        
        // 1. Contact Info (15 pts)
        if !resume.firstName.isEmpty && !resume.lastName.isEmpty { score += 3 }
        if !resume.email.isEmpty { score += 3 }
        if !resume.phone.isEmpty { score += 3 }
        if !resume.linkedin.isEmpty || !resume.github.isEmpty { score += 3 }
        if !resume.location.isEmpty { score += 3 }
        
        // 2. Education (10 pts)
        if !resume.education.isEmpty { score += 10 }
        
        // 3. Experience & Projects (15 pts)
        if !resume.experience.isEmpty { score += 10 }
        if !resume.projects.isEmpty { score += 5 }
        
        // 4. Skills (20 pts)
        let totalSkills = resume.skills.values.reduce(0) { $0 + $1.count }
        if totalSkills >= 5 { score += 20 }
        else if totalSkills >= 3 { score += 10 }
        else if totalSkills > 0 { score += 5 }
        
        // 5. Content Depth & ML Semantic Score (40 pts)
        let allBullets = resume.experience.flatMap { $0.bullets } + resume.projects.flatMap { $0.bullets }
        if !allBullets.isEmpty {
            let fullText = allBullets.joined(separator: " ")
            let semanticScore = SmartTextAnalyzer.calculateSemanticScore(text: fullText)
            
            // semanticScore is 0.0 to 1.0. 
            // We weigh this heavily now (40 points).
            let mlPoints = Int(semanticScore * 40.0)
            
            score += mlPoints
        }
        
        return min(100, score)
    }
}
