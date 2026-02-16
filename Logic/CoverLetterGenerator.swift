import Foundation

struct CoverLetterGenerator {
    
    /// Generates the full cover letter body text from resume data and user inputs.
    static func generate(resume: Resume, coverLetter: CoverLetter) -> String {
        let tone = coverLetter.tone
        let fullName = resume.fullName
        let company = coverLetter.companyName.isEmpty ? "[Company]" : coverLetter.companyName
        let role = coverLetter.jobTitle.isEmpty ? "[Position]" : coverLetter.jobTitle
        let manager = coverLetter.hiringManagerName
        
        var paragraphs: [String] = []
        
        // 1. Opening paragraph
        paragraphs.append(openingParagraph(tone: tone, name: fullName, company: company, role: role, customReason: coverLetter.whyInterested))
        
        // 2. Skills paragraph
        let skillsPara = skillsParagraph(resume: resume, role: role, tone: tone)
        if !skillsPara.isEmpty {
            paragraphs.append(skillsPara)
        }
        
        // 3. Experience paragraph
        let expPara = experienceParagraph(resume: resume, tone: tone)
        if !expPara.isEmpty {
            paragraphs.append(expPara)
        }
        
        // 4. Projects paragraph
        let projPara = projectsParagraph(resume: resume, tone: tone)
        if !projPara.isEmpty {
            paragraphs.append(projPara)
        }
        
        // 5. Closing paragraph
        paragraphs.append(closingParagraph(tone: tone, company: company, role: role))
        
        // Assemble
        let greeting = greetingLine(tone: tone, managerName: manager)
        let body = paragraphs.joined(separator: "\n\n")
        let signOff = "\(tone.signOff),\n\(fullName)"
        
        return "\(greeting)\n\n\(body)\n\n\(signOff)"
    }
    
    // MARK: - Greeting
    
    private static func greetingLine(tone: CoverLetterTone, managerName: String) -> String {
        if !managerName.isEmpty {
            return "\(tone.greeting) \(managerName),"
        }
        switch tone {
        case .formal:
            return "Dear Hiring Manager,"
        case .modern:
            return "Hello Hiring Team,"
        case .creative:
            return "Hi there,"
        }
    }
    
    // MARK: - Opening
    
    private static func openingParagraph(tone: CoverLetterTone, name: String, company: String, role: String, customReason: String) -> String {
        let customInsert = customReason.isEmpty ? "" : " \(customReason.trimmingCharacters(in: .whitespacesAndNewlines))"
        
        switch tone {
        case .formal:
            return "I am writing to express my strong interest in the \(role) position at \(company). With a background in software development and a passion for building impactful solutions, I believe I would be a valuable addition to your team.\(customInsert)"
        case .modern:
            return "I'm excited to apply for the \(role) role at \(company). I've been following your work and I'm eager to contribute my skills to your team.\(customInsert)"
        case .creative:
            return "The \(role) role at \(company) caught my eye — and I knew I had to reach out. I love building things that make a difference, and your team seems like the perfect place to do that.\(customInsert)"
        }
    }
    
    // MARK: - Skills
    
    private static func skillsParagraph(resume: Resume, role: String, tone: CoverLetterTone) -> String {
        // Collect all skills into a flat list
        var allSkills: [String] = []
        for category in SkillCategory.allCases {
            if let skills = resume.skills[category], !skills.isEmpty {
                allSkills.append(contentsOf: skills.prefix(3)) // Top 3 per category
            }
        }
        
        guard !allSkills.isEmpty else { return "" }
        
        // Take top 6 skills for the letter
        let topSkills = Array(allSkills.prefix(6))
        let skillList = topSkills.joined(separator: ", ")
        
        switch tone {
        case .formal:
            return "My technical proficiency includes \(skillList), among other competencies. These skills enable me to contribute effectively to complex projects and deliver high-quality results in the \(role) capacity."
        case .modern:
            return "I bring hands-on experience with \(skillList). I'm comfortable working across the stack and always eager to learn new technologies that help the team move faster."
        case .creative:
            return "My toolkit includes \(skillList) — and I'm always adding more. I believe the best engineers are perpetual learners, and I thrive in environments where innovation is valued."
        }
    }
    
    // MARK: - Experience
    
    private static func experienceParagraph(resume: Resume, tone: CoverLetterTone) -> String {
        guard let latestExp = resume.experience.first else { return "" }
        
        let title = latestExp.title
        let company = latestExp.company
        let bullets = latestExp.bullets.filter { !$0.isEmpty }
        let achievement = bullets.first ?? ""
        
        switch tone {
        case .formal:
            var para = "In my most recent role as \(title) at \(company), I gained significant experience in delivering impactful solutions."
            if !achievement.isEmpty {
                para += " Notably, \(achievement.lowercasedFirst())"
            }
            return para
        case .modern:
            var para = "Most recently, I worked as \(title) at \(company), where I sharpened my ability to ship quality work under real-world constraints."
            if !achievement.isEmpty {
                para += " One highlight: \(achievement.lowercasedFirst())"
            }
            return para
        case .creative:
            var para = "At \(company), I served as \(title) and had the chance to make a real impact."
            if !achievement.isEmpty {
                para += " \(achievement)"
            }
            return para
        }
    }
    
    // MARK: - Projects
    
    private static func projectsParagraph(resume: Resume, tone: CoverLetterTone) -> String {
        guard let project = resume.projects.first else { return "" }
        
        let name = project.name
        let tools = project.tools
        let desc = project.bullets.first(where: { !$0.isEmpty }) ?? ""
        
        switch tone {
        case .formal:
            var para = "I also developed \(name)"
            if !tools.isEmpty { para += " using \(tools)" }
            if !desc.isEmpty { para += ", which \(desc.lowercasedFirst())" }
            para += "."
            return para
        case .modern:
            var para = "On the project side, I built \(name)"
            if !tools.isEmpty { para += " with \(tools)" }
            if !desc.isEmpty { para += " — \(desc.lowercasedFirst())" }
            para += "."
            return para
        case .creative:
            var para = "One project I'm particularly proud of is \(name)"
            if !tools.isEmpty { para += " (built with \(tools))" }
            if !desc.isEmpty { para += ". \(desc)" }
            return para
        }
    }
    
    // MARK: - Closing
    
    private static func closingParagraph(tone: CoverLetterTone, company: String, role: String) -> String {
        switch tone {
        case .formal:
            return "I am confident that my skills and experience align well with the requirements of the \(role) position at \(company). I would welcome the opportunity to discuss how I can contribute to your team's success. Thank you for considering my application."
        case .modern:
            return "I'd love to chat about how I can contribute to \(company) as your next \(role). I'm available for an interview at your convenience — looking forward to hearing from you!"
        case .creative:
            return "I'd be thrilled to bring my energy and expertise to \(company). Let's connect — I'm confident we'd make a great team. Thanks for reading!"
        }
    }
}

// MARK: - String Extension

private extension String {
    func lowercasedFirst() -> String {
        guard let first = self.first else { return self }
        return first.lowercased() + self.dropFirst()
    }
}
