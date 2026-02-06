import SwiftUI
import UIKit

struct ResumePreviewView: View {
    
    let resume: Resume
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        ScrollView {
            resumeContent
        }
        .background(Color.white)
        .environment(\.colorScheme, .light)
        .navigationTitle("Resume")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    printResume()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "printer")
                        Text("Print")
                            .font(.system(size: 14))
                    }
                }
            }
        }
    }
    
    var resumeContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            // ===== NAME =====
            Text(resume.fullName.isEmpty ? "Your Name" : resume.fullName.uppercased())
                .font(.system(size: 24, weight: .bold))
                .tracking(2)
                .padding(.bottom, 8)
            
            // ===== CONTACT INFO =====
            VStack(alignment: .leading, spacing: 4) {
                let contactItems = [
                    resume.email,
                    resume.fullPhone,
                    resume.location,
                    resume.linkedin,
                    resume.github
                ].filter { !$0.isEmpty }
                
                Text(contactItems.joined(separator: "  •  "))
                    .font(.system(size: 11))
                    .foregroundColor(.gray)
            }
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
        .foregroundColor(.black)
    }
    
    func printResume() {
        // Create the print content
        let printContent = ResumePrintView(resume: resume)
        
        // Create hosting controller
        let hostingController = UIHostingController(rootView: printContent)
        hostingController.view.frame = CGRect(x: 0, y: 0, width: 612, height: 792)
        hostingController.view.backgroundColor = .white
        
        // Add to a temporary window for rendering
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 612, height: 792))
        window.rootViewController = hostingController
        window.makeKeyAndVisible()
        hostingController.view.layoutIfNeeded()
        
        // Create PDF data
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 612, height: 792))
        let pdfData = pdfRenderer.pdfData { context in
            context.beginPage()
            hostingController.view.layer.render(in: context.cgContext)
        }
        
        // Create print info
        let printInfo = UIPrintInfo(dictionary: nil)
        printInfo.jobName = "\(resume.fullName.isEmpty ? "Resume" : resume.fullName)"
        printInfo.outputType = .general
        
        // Show print controller
        let printController = UIPrintInteractionController.shared
        printController.printInfo = printInfo
        printController.printingItem = pdfData
        
        printController.present(animated: true) { _, _, _ in }
    }
}

// MARK: - Resume Print View

struct ResumePrintView: View {
    let resume: Resume
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Name
            Text(resume.fullName.isEmpty ? "Your Name" : resume.fullName.uppercased())
                .font(.system(size: 24, weight: .bold))
                .tracking(2)
                .padding(.bottom, 6)
            
            // Contact
            let contactItems = [
                resume.email,
                resume.fullPhone,
                resume.location,
                resume.linkedin,
                resume.github
            ].filter { !$0.isEmpty }
            
            if !contactItems.isEmpty {
                Text(contactItems.joined(separator: "  •  "))
                    .font(.system(size: 10))
                    .foregroundColor(Color(white: 0.4))
                    .padding(.bottom, 16)
            }
            
            // Education
            if !resume.education.isEmpty {
                PrintSection(title: "EDUCATION") {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(resume.education) { edu in
                            VStack(alignment: .leading, spacing: 2) {
                                HStack {
                                    Text(edu.displayTitle)
                                        .font(.system(size: 12, weight: .semibold))
                                    Spacer()
                                    if !edu.formattedScore.isEmpty {
                                        Text(edu.formattedScore)
                                            .font(.system(size: 11))
                                            .foregroundColor(Color(white: 0.4))
                                    }
                                }
                                HStack {
                                    Text(edu.institution)
                                        .font(.system(size: 11))
                                        .foregroundColor(Color(white: 0.4))
                                    Spacer()
                                    if !edu.year.isEmpty {
                                        Text(edu.year)
                                            .font(.system(size: 11))
                                            .foregroundColor(Color(white: 0.4))
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            // Skills
            if !resume.skills.isEmpty {
                PrintSection(title: "SKILLS") {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(SkillCategory.allCases) { category in
                            if let skills = resume.skills[category], !skills.isEmpty {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(category.rawValue)
                                        .font(.system(size: 10, weight: .semibold))
                                        .foregroundColor(Color(white: 0.4))
                                    Text(skills.joined(separator: ", "))
                                        .font(.system(size: 11))
                                }
                            }
                        }
                    }
                }
            }
            
            // Experience
            if !resume.experience.isEmpty {
                PrintSection(title: "EXPERIENCE") {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(resume.experience) { exp in
                            VStack(alignment: .leading, spacing: 3) {
                                HStack {
                                    Text(exp.title)
                                        .font(.system(size: 12, weight: .semibold))
                                    Spacer()
                                    Text(exp.duration)
                                        .font(.system(size: 11))
                                        .foregroundColor(Color(white: 0.4))
                                }
                                if !exp.company.isEmpty {
                                    Text(exp.company)
                                        .font(.system(size: 11))
                                        .foregroundColor(Color(white: 0.4))
                                }
                                ForEach(exp.bullets, id: \.self) { bullet in
                                    HStack(alignment: .top, spacing: 5) {
                                        Text("•")
                                        Text(bullet)
                                    }
                                    .font(.system(size: 11))
                                }
                            }
                        }
                    }
                }
            }
            
            // Projects
            if !resume.projects.isEmpty {
                PrintSection(title: "PROJECTS") {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(resume.projects) { project in
                            VStack(alignment: .leading, spacing: 3) {
                                HStack {
                                    Text(project.name)
                                        .font(.system(size: 12, weight: .semibold))
                                    Spacer()
                                    if !project.tools.isEmpty {
                                        Text(project.tools)
                                            .font(.system(size: 10))
                                            .foregroundColor(Color(white: 0.4))
                                    }
                                }
                                ForEach(project.bullets, id: \.self) { bullet in
                                    HStack(alignment: .top, spacing: 5) {
                                        Text("•")
                                        Text(bullet)
                                    }
                                    .font(.system(size: 11))
                                }
                            }
                        }
                    }
                }
            }
            
            Spacer()
        }
        .padding(36)
        .frame(width: 612, height: 792, alignment: .topLeading)
        .background(Color.white)
        .foregroundColor(.black)
    }
}

struct PrintSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Text(title)
                    .font(.system(size: 11, weight: .bold))
                    .tracking(1)
                Rectangle()
                    .fill(Color.black)
                    .frame(height: 0.5)
            }
            content
        }
        .padding(.bottom, 14)
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

// MARK: - Education Item

struct EducationItem: View {
    let education: Education
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Text(education.displayTitle)
                    .font(.system(size: 13, weight: .semibold))
                
                Spacer()
                
                if !education.formattedScore.isEmpty {
                    Text(education.formattedScore)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.gray)
                }
            }
            
            HStack {
                Text(education.institution)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                
                Spacer()
                
                if !education.year.isEmpty {
                    Text(education.year)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
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
                .foregroundColor(.gray)
            
            Text(skills.joined(separator: ", "))
                .font(.system(size: 13))
                .lineSpacing(3)
        }
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
                    .foregroundColor(.gray)
            }
            
            if !experience.company.isEmpty {
                Text(experience.company)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
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
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                if !project.tools.isEmpty {
                    Text(project.tools)
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
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
