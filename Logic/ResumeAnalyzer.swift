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
        
        // 1. Contact Info (20 pts)
        if !resume.firstName.isEmpty && !resume.lastName.isEmpty { score += 5 }
        if !resume.email.isEmpty { score += 5 }
        if !resume.phone.isEmpty { score += 5 }
        if !resume.linkedin.isEmpty || !resume.github.isEmpty { score += 5 }
        
        // 2. Education (15 pts)
        if !resume.education.isEmpty { score += 15 }
        
        // 3. Experience & Projects (30 pts)
        if !resume.experience.isEmpty { score += 15 }
        if !resume.projects.isEmpty { score += 15 }
        
        // 4. Skills (20 pts)
        let totalSkills = resume.skills.values.reduce(0) { $0 + $1.count }
        if totalSkills >= 5 { score += 20 }
        else if totalSkills >= 3 { score += 10 }
        else if totalSkills > 0 { score += 5 }
        
        // 5. Content Depth (15 pts) -> Refactored to include Semantic ML Score
        // Check average bullet length. Short bullets are bad for ATS.
        let allBullets = resume.experience.flatMap { $0.bullets } + resume.projects.flatMap { $0.bullets }
        if !allBullets.isEmpty {
            let avgLength = allBullets.reduce(0) { $0 + $1.count } / allBullets.count
            
            // Length Score (Max 10)
            let lengthScore: Int
            if avgLength > 100 { lengthScore = 10 }
            else if avgLength > 50 { lengthScore = 5 }
            else { lengthScore = 2 }
            
            // Semantic ML Score (Max 15)
            // Combine all bullets into one text block for analysis
            let fullText = allBullets.joined(separator: " ")
            let semanticScore = SmartTextAnalyzer.calculateSemanticScore(text: fullText)
            
            // semanticScore is 0.0 to 1.0
            let mlPoints = Int(semanticScore * 15.0)
            
            score += lengthScore + mlPoints
        }
        
        return min(100, score)
    }
}
