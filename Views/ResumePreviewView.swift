import SwiftUI
import UIKit

struct ResumePreviewView: View {
    
    let resume: Resume
    @Environment(\.openURL) private var openURL
    @State private var selectedTemplate: ResumeTemplate = .classic
    @State private var showTemplateSelector = false
    
    var body: some View {
        ScrollView {
            Group {
                switch selectedTemplate {
                case .classic:
                    ClassicTemplateView(resume: resume, openURL: openURL)
                case .simple:
                    SimpleTemplateView(resume: resume, openURL: openURL)
                case .modern:
                    ModernTemplateView(resume: resume, openURL: openURL)
                }
            }
        }
        .background(Color.white)
        .environment(\.colorScheme, .light)
        .navigationTitle("Resume")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    showTemplateSelector = true
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "rectangle.3.group")
                        Text("Template")
                            .font(.system(size: 14))
                    }
                }
            }
            
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
        .sheet(isPresented: $showTemplateSelector) {
            TemplateSelectionView(selectedTemplate: $selectedTemplate)
        }
    }
    
    func printResume() {
        let printContent: AnyView
        switch selectedTemplate {
        case .classic:
            printContent = AnyView(ClassicPrintView(resume: resume))
        case .simple:
            printContent = AnyView(SimplePrintView(resume: resume))
        case .modern:
            printContent = AnyView(ModernPrintView(resume: resume))
        }
        
        let hostingController = UIHostingController(rootView: printContent)
        hostingController.view.frame = CGRect(x: 0, y: 0, width: 612, height: 792)
        hostingController.view.backgroundColor = .white
        
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 612, height: 792))
        window.rootViewController = hostingController
        window.makeKeyAndVisible()
        hostingController.view.layoutIfNeeded()
        
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 612, height: 792))
        let pdfData = pdfRenderer.pdfData { context in
            context.beginPage()
            hostingController.view.layer.render(in: context.cgContext)
        }
        
        let printInfo = UIPrintInfo(dictionary: nil)
        printInfo.jobName = "\(resume.fullName.isEmpty ? "Resume" : resume.fullName)"
        printInfo.outputType = .general
        
        let printController = UIPrintInteractionController.shared
        printController.printInfo = printInfo
        printController.printingItem = pdfData
        
        printController.present(animated: true) { _, _, _ in }
    }
}

// MARK: - Classic Template

struct ClassicTemplateView: View {
    let resume: Resume
    let openURL: OpenURLAction
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            Text(resume.fullName.isEmpty ? "YOUR NAME" : resume.fullName.uppercased())
                .font(.system(size: 26, weight: .bold))
                .tracking(2)
                .padding(.bottom, 6)
            
            // Contact row
            ClassicContactRow(resume: resume, openURL: openURL)
                .padding(.bottom, 20)
            
            // Education
            if !resume.education.isEmpty {
                ClassicSection(title: "EDUCATION") {
                    ForEach(resume.education) { edu in
                        ClassicTimelineItem(
                            leftTop: edu.year,
                            leftBottom: "",
                            title: edu.displayTitle,
                            subtitle: edu.institution,
                            detail: edu.formattedScore
                        )
                    }
                }
            }
            
            // Experience
            if !resume.experience.isEmpty {
                ClassicSection(title: "EXPERIENCE") {
                    ForEach(resume.experience) { exp in
                        ClassicTimelineItem(
                            leftTop: exp.duration,
                            leftBottom: exp.company,
                            title: exp.title,
                            subtitle: exp.company,
                            detail: nil,
                            bullets: exp.bullets
                        )
                    }
                }
            }
            
            // Projects
            if !resume.projects.isEmpty {
                ClassicSection(title: "PROJECTS") {
                    ForEach(resume.projects) { project in
                        ClassicTimelineItem(
                            leftTop: "",
                            leftBottom: project.tools,
                            title: project.name,
                            subtitle: project.tools,
                            detail: nil,
                            bullets: project.bullets
                        )
                    }
                }
            }
            
            // Skills
            if !resume.skills.isEmpty {
                ClassicSection(title: "TECHNICAL SKILLS") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(SkillCategory.allCases) { category in
                                if let skills = resume.skills[category], !skills.isEmpty {
                                    ForEach(skills, id: \.self) { skill in
                                        Text(skill)
                                            .font(.system(size: 12))
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(Color(.systemGray6))
                                            .cornerRadius(4)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundColor(.black)
    }
}

struct ClassicContactRow: View {
    let resume: Resume
    let openURL: OpenURLAction
    
    var body: some View {
        HStack(spacing: 16) {
            if !resume.phone.isEmpty {
                HStack(spacing: 4) {
                    Image(systemName: "phone.fill")
                        .font(.system(size: 10))
                    Text(resume.fullPhone)
                        .font(.system(size: 11))
                }
            }
            
            if !resume.email.isEmpty {
                HStack(spacing: 4) {
                    Image(systemName: "envelope.fill")
                        .font(.system(size: 10))
                    Text(resume.email)
                        .font(.system(size: 11))
                }
            }
            
            if !resume.linkedin.isEmpty {
                Button {
                    let urlString = resume.linkedin.hasPrefix("http") ? resume.linkedin : "https://\(resume.linkedin)"
                    if let url = URL(string: urlString) { openURL(url) }
                } label: {
                    Text("LinkedIn")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.blue)
                }
            }
            
            if !resume.github.isEmpty {
                Button {
                    let urlString = resume.github.hasPrefix("http") ? resume.github : "https://\(resume.github)"
                    if let url = URL(string: urlString) { openURL(url) }
                } label: {
                    Text("GitHub")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.blue)
                }
            }
            
            if !resume.location.isEmpty {
                HStack(spacing: 4) {
                    Image(systemName: "location.fill")
                        .font(.system(size: 10))
                    Text(resume.location)
                        .font(.system(size: 11))
                }
            }
        }
        .foregroundColor(.gray)
    }
}

struct ClassicSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Text(title)
                    .font(.system(size: 14, weight: .bold))
                    .tracking(1.5)
                Rectangle()
                    .fill(Color.black)
                    .frame(height: 1)
            }
            
            content
        }
        .padding(.bottom, 20)
    }
}

struct ClassicTimelineItem: View {
    let leftTop: String
    let leftBottom: String
    let title: String
    let subtitle: String
    var detail: String? = nil
    var bullets: [String] = []
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Left column with date
            VStack(alignment: .leading, spacing: 2) {
                Text(leftTop)
                    .font(.system(size: 11))
                    .foregroundColor(.gray)
            }
            .frame(width: 90, alignment: .leading)
            
            // Timeline dot
            Circle()
                .fill(Color.black)
                .frame(width: 8, height: 8)
                .padding(.top, 4)
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                
                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundColor(.blue)
                
                if let detail = detail, !detail.isEmpty {
                    Text(detail)
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                }
                
                if !bullets.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(bullets, id: \.self) { bullet in
                            HStack(alignment: .top, spacing: 6) {
                                Text("•")
                                Text(bullet)
                            }
                            .font(.system(size: 12))
                        }
                    }
                    .padding(.top, 4)
                }
            }
            
            Spacer()
        }
        .padding(.bottom, 12)
    }
}

// MARK: - Simple Template

struct SimpleTemplateView: View {
    let resume: Resume
    let openURL: OpenURLAction
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            Text(resume.fullName.isEmpty ? "Your Name" : resume.fullName)
                .font(.system(size: 28, weight: .bold))
                .padding(.bottom, 4)
            
            // Contact line
            SimpleContactLine(resume: resume, openURL: openURL)
                .padding(.bottom, 16)
            
            // Skills
            if !resume.skills.isEmpty {
                SimpleSectionHeader(title: "Top Skills")
                
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(SkillCategory.allCases) { category in
                        if let skills = resume.skills[category], !skills.isEmpty {
                            HStack(alignment: .top, spacing: 8) {
                                Text("•")
                                    .font(.system(size: 13, weight: .bold))
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(category.rawValue)
                                        .font(.system(size: 13, weight: .semibold))
                                    Text(skills.joined(separator: ", "))
                                        .font(.system(size: 12))
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 16)
            }
            
            // Experience
            if !resume.experience.isEmpty {
                SimpleSectionHeader(title: "Work Experience")
                
                ForEach(resume.experience) { exp in
                    SimpleExperienceItem(experience: exp)
                }
            }
            
            // Education
            if !resume.education.isEmpty {
                SimpleSectionHeader(title: "Education")
                
                ForEach(resume.education) { edu in
                    HStack {
                        Text("\(edu.displayTitle), \(edu.year), \(edu.institution)")
                            .font(.system(size: 12))
                        Spacer()
                        Text(edu.formattedScore)
                            .font(.system(size: 11))
                            .foregroundColor(.gray)
                    }
                    .padding(.bottom, 8)
                }
            }
            
            // Projects
            if !resume.projects.isEmpty {
                SimpleSectionHeader(title: "Projects")
                
                ForEach(resume.projects) { project in
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(project.name)
                                .font(.system(size: 13, weight: .semibold))
                            Spacer()
                            Text(project.tools)
                                .font(.system(size: 11))
                                .foregroundColor(.gray)
                        }
                        
                        ForEach(project.bullets, id: \.self) { bullet in
                            Text("• \(bullet)")
                                .font(.system(size: 12))
                        }
                    }
                    .padding(.bottom, 12)
                }
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .foregroundColor(.black)
    }
}

struct SimpleContactLine: View {
    let resume: Resume
    let openURL: OpenURLAction
    
    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 0) {
                let items = [resume.location, resume.fullPhone].filter { !$0.isEmpty }
                ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                    Text(item)
                    if index < items.count - 1 {
                        Text(" • ")
                    }
                }
            }
            .font(.system(size: 11))
            .foregroundColor(.gray)
            
            HStack(spacing: 0) {
                if !resume.email.isEmpty {
                    Text(resume.email)
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                }
                
                if !resume.linkedin.isEmpty {
                    Text(" • ")
                        .foregroundColor(.gray)
                    Button {
                        let urlString = resume.linkedin.hasPrefix("http") ? resume.linkedin : "https://\(resume.linkedin)"
                        if let url = URL(string: urlString) { openURL(url) }
                    } label: {
                        Text("LinkedIn")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.blue)
                    }
                }
                
                if !resume.github.isEmpty {
                    Text(" • ")
                        .foregroundColor(.gray)
                    Button {
                        let urlString = resume.github.hasPrefix("http") ? resume.github : "https://\(resume.github)"
                        if let url = URL(string: urlString) { openURL(url) }
                    } label: {
                        Text("GitHub")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.blue)
                    }
                }
            }
            .font(.system(size: 11))
        }
    }
}

struct SimpleSectionHeader: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.system(size: 16, weight: .bold))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
    }
}

struct SimpleExperienceItem: View {
    let experience: Experience
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(experience.company)
                        .font(.system(size: 13, weight: .semibold))
                    Text(experience.title)
                        .font(.system(size: 12))
                        .italic()
                }
                Spacer()
                Text(experience.duration)
                    .font(.system(size: 11))
                    .foregroundColor(.gray)
            }
            
            ForEach(experience.bullets, id: \.self) { bullet in
                Text(bullet)
                    .font(.system(size: 12))
                    .padding(.top, 2)
            }
        }
        .padding(.bottom, 14)
    }
}

// MARK: - Modern Template

struct ModernTemplateView: View {
    let resume: Resume
    let openURL: OpenURLAction
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            // Left sidebar
            VStack(alignment: .leading, spacing: 16) {
                // Name
                VStack(alignment: .leading, spacing: 0) {
                    let names = resume.fullName.isEmpty ? ["Your", "Name"] : resume.fullName.split(separator: " ").map(String.init)
                    ForEach(names, id: \.self) { name in
                        Text(name)
                            .font(.system(size: 28, weight: .light))
                    }
                }
                
                // Contact
                VStack(alignment: .leading, spacing: 8) {
                    if !resume.email.isEmpty {
                        Text(resume.email)
                            .font(.system(size: 10))
                    }
                    if !resume.phone.isEmpty {
                        Text(resume.fullPhone)
                            .font(.system(size: 10))
                    }
                    if !resume.linkedin.isEmpty {
                        Button {
                            let urlString = resume.linkedin.hasPrefix("http") ? resume.linkedin : "https://\(resume.linkedin)"
                            if let url = URL(string: urlString) { openURL(url) }
                        } label: {
                            Text("LinkedIn")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(.blue)
                        }
                    }
                    if !resume.github.isEmpty {
                        Button {
                            let urlString = resume.github.hasPrefix("http") ? resume.github : "https://\(resume.github)"
                            if let url = URL(string: urlString) { openURL(url) }
                        } label: {
                            Text("GitHub")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(.blue)
                        }
                    }
                }
                
                Spacer()
            }
            .frame(width: 140)
            .padding(20)
            .background(Color(red: 0.9, green: 0.95, blue: 0.95))
            
            // Right content
            VStack(alignment: .leading, spacing: 20) {
                // Experience
                if !resume.experience.isEmpty {
                    ModernSection(title: "EXPERIENCE") {
                        ForEach(resume.experience) { exp in
                            ModernExperienceItem(experience: exp)
                        }
                    }
                }
                
                // Projects
                if !resume.projects.isEmpty {
                    ModernSection(title: "PROJECTS") {
                        ForEach(resume.projects) { project in
                            VStack(alignment: .leading, spacing: 4) {
                                HStack {
                                    Text(project.name)
                                        .font(.system(size: 13, weight: .semibold))
                                    Spacer()
                                    Text(project.tools)
                                        .font(.system(size: 10))
                                        .foregroundColor(.gray)
                                }
                                ForEach(project.bullets, id: \.self) { bullet in
                                    Text("• \(bullet)")
                                        .font(.system(size: 11))
                                }
                            }
                            .padding(.bottom, 8)
                        }
                    }
                }
                
                // Bottom row: Education + Skills
                HStack(alignment: .top, spacing: 24) {
                    // Education
                    if !resume.education.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("EDUCATION")
                                .font(.system(size: 11, weight: .bold))
                                .tracking(1)
                            
                            ForEach(resume.education) { edu in
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(edu.year)
                                        .font(.system(size: 9))
                                        .foregroundColor(.gray)
                                    Text(edu.displayTitle)
                                        .font(.system(size: 11, weight: .medium))
                                    Text(edu.institution)
                                        .font(.system(size: 10))
                                        .foregroundColor(.gray)
                                }
                                .padding(.bottom, 6)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    // Skills
                    if !resume.skills.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("SKILLS")
                                .font(.system(size: 11, weight: .bold))
                                .tracking(1)
                            
                            ForEach(SkillCategory.allCases) { category in
                                if let skills = resume.skills[category], !skills.isEmpty {
                                    Text(skills.prefix(4).joined(separator: ", "))
                                        .font(.system(size: 10))
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                
                Spacer()
            }
            .padding(20)
        }
        .foregroundColor(.black)
    }
}

struct ModernSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 12, weight: .bold))
                .tracking(1.5)
            
            content
        }
    }
}

struct ModernExperienceItem: View {
    let experience: Experience
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(experience.duration)
                .font(.system(size: 10))
                .foregroundColor(.gray)
                .frame(width: 80, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(experience.title), \(experience.company)")
                    .font(.system(size: 12, weight: .medium))
                
                ForEach(experience.bullets, id: \.self) { bullet in
                    Text("• \(bullet)")
                        .font(.system(size: 11))
                }
            }
        }
        .padding(.bottom, 10)
    }
}

// MARK: - Print Views (simplified versions for PDF)

struct ClassicPrintView: View {
    let resume: Resume
    var body: some View {
        ClassicTemplateView(resume: resume, openURL: OpenURLAction { _ in .handled })
            .frame(width: 612, height: 792)
    }
}

struct SimplePrintView: View {
    let resume: Resume
    var body: some View {
        SimpleTemplateView(resume: resume, openURL: OpenURLAction { _ in .handled })
            .frame(width: 612, height: 792)
    }
}

struct ModernPrintView: View {
    let resume: Resume
    var body: some View {
        ModernTemplateView(resume: resume, openURL: OpenURLAction { _ in .handled })
            .frame(width: 612, height: 792)
    }
}
