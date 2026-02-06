import SwiftUI

struct ResumePreviewView: View {
    
    let resume: Resume
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                
                // ===== NAME =====
                Text(resume.fullName.isEmpty ? "Your Name" : resume.fullName.uppercased())
                    .font(.system(size: 24, weight: .bold))
                    .tracking(2)
                    .padding(.bottom, 8)
                
                // ===== CONTACT INFO =====
                HStack(spacing: 0) {
                    let contactItems = [
                        resume.email,
                        resume.fullPhone,
                        resume.location,
                        resume.linkedin,
                        resume.github
                    ].filter { !$0.isEmpty }
                    
                    ForEach(Array(contactItems.enumerated()), id: \.offset) { index, item in
                        Text(item)
                            .font(.system(size: 12))
                        
                        if index < contactItems.count - 1 {
                            Text("  |  ")
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .foregroundColor(.primary)
                .padding(.bottom, 20)
                
                // ===== EDUCATION =====
                if !resume.education.isEmpty {
                    ResumeSection(title: "EDUCATION") {
                        VStack(alignment: .leading, spacing: 14) {
                            ForEach(resume.education) { edu in
                                EducationItem(education: edu)
                            }
                        }
                    }
                }
                
                // ===== SKILLS (Categorized) =====
                if !resume.skills.isEmpty {
                    ResumeSection(title: "SKILLS") {
                        VStack(alignment: .leading, spacing: 12) {
                            ForEach(SkillCategory.allCases) { category in
                                if let skills = resume.skills[category], !skills.isEmpty {
                                    SkillCategoryRow(category: category, skills: skills)
                                }
                            }
                        }
                    }
                }
                
                // ===== EXPERIENCE =====
                if !resume.experience.isEmpty {
                    ResumeSection(title: "EXPERIENCE") {
                        VStack(alignment: .leading, spacing: 16) {
                            ForEach(resume.experience) { exp in
                                ExperienceItem(experience: exp)
                            }
                        }
                    }
                }
                
                // ===== PROJECTS =====
                if !resume.projects.isEmpty {
                    ResumeSection(title: "PROJECTS") {
                        VStack(alignment: .leading, spacing: 16) {
                            ForEach(resume.projects) { project in
                                ProjectItem(project: project, openURL: openURL)
                            }
                        }
                    }
                }
            }
            .padding(24)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color.white)
        .navigationTitle("Resume")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Education Item (Updated)

struct EducationItem: View {
    let education: Education
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            // Title row
            HStack {
                Text(education.displayTitle)
                    .font(.system(size: 13, weight: .semibold))
                
                Spacer()
                
                if !education.formattedScore.isEmpty {
                    Text(education.formattedScore)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
            
            // Institution and Year
            HStack {
                Text(education.institution)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if !education.year.isEmpty {
                    Text(education.year)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

// MARK: - Skill Category Row

struct SkillCategoryRow: View {
    let category: SkillCategory
    let skills: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(category.rawValue)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.secondary)
            
            Text(skills.joined(separator: ", "))
                .font(.system(size: 13))
                .lineSpacing(3)
        }
    }
}

// MARK: - Resume Section

struct ResumeSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Text(title)
                    .font(.system(size: 13, weight: .bold))
                    .tracking(1.5)
                
                Rectangle()
                    .fill(Color.black)
                    .frame(height: 1)
            }
            .padding(.bottom, 4)
            
            content
        }
        .padding(.bottom, 16)
    }
}

// MARK: - Experience Item

struct ExperienceItem: View {
    let experience: Experience
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(experience.title)
                    .font(.system(size: 13, weight: .semibold))
                Spacer()
                Text(experience.duration)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            
            if !experience.company.isEmpty {
                Text(experience.company)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            
            if !experience.bullets.isEmpty {
                VStack(alignment: .leading, spacing: 3) {
                    ForEach(experience.bullets, id: \.self) { bullet in
                        HStack(alignment: .top, spacing: 8) {
                            Text("•")
                                .font(.system(size: 13))
                            Text(bullet)
                                .font(.system(size: 12))
                                .lineSpacing(2)
                        }
                    }
                }
                .padding(.top, 4)
            }
        }
    }
}

// MARK: - Project Item

struct ProjectItem: View {
    let project: Project
    let openURL: OpenURLAction
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 6) {
                if project.hasValidLink {
                    Button {
                        if let url = project.url {
                            openURL(url)
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Text(project.name)
                                .font(.system(size: 13, weight: .semibold))
                            Image(systemName: "arrow.up.right")
                                .font(.system(size: 9, weight: .semibold))
                        }
                        .foregroundColor(.blue)
                    }
                } else {
                    Text(project.name)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                if !project.tools.isEmpty {
                    Text(project.tools)
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }
            }
            
            if !project.bullets.isEmpty {
                VStack(alignment: .leading, spacing: 3) {
                    ForEach(project.bullets, id: \.self) { bullet in
                        HStack(alignment: .top, spacing: 8) {
                            Text("•")
                                .font(.system(size: 13))
                            Text(bullet)
                                .font(.system(size: 12))
                                .lineSpacing(2)
                        }
                    }
                }
                .padding(.top, 4)
            }
        }
    }
}
