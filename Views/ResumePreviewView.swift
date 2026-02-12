import SwiftUI
import UIKit

struct ResumePreviewView: View {
    
    let resume: Resume
    @Binding var path: NavigationPath
    @EnvironmentObject var resumeManager: ResumeManager
    @Environment(\.openURL) private var openURL
    @State private var selectedTemplate: ResumeTemplate = .classic
    @State private var showTemplateSelector = false
    @State private var showShareSheet = false
    @State private var generatedPDFUrl: URL?
    @State private var showSaveError = false
    @State private var isGeneratingPDF = false
    
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
            .sheet(isPresented: $showTemplateSelector) {
                TemplateSelectionView(selectedTemplate: $selectedTemplate)
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
                HStack {
                    // Share Link (Native)
                    // Share Button (Lazy Generation)
                     if isGeneratingPDF {
                         ProgressView()
                             .scaleEffect(0.7)
                     } else {
                         Button {
                             generatePDFAndShare()
                         } label: {
                             Image(systemName: "square.and.arrow.up")
                         }
                     }
                    
                    Button {
                        if resumeManager.save(resume: resume) {
                            path = NavigationPath() // Pop to Root
                        } else {
                            showSaveError = true
                        }
                    } label: {
                        Text("Save & Exit")
                            .fontWeight(.bold)
                    }
                }
            }
        }
        .sheet(isPresented: $showShareSheet) {
            if let url = generatedPDFUrl {
                ShareSheet(items: [url])
            }
        }
        .alert("Save Failed", isPresented: $showSaveError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("There was an error saving your resume. Please try again.")
        }
        // Removed .task and .onChange to prevent eager memory usage
    }
    
    @MainActor
    func generatePDFAndShare() {
        isGeneratingPDF = true
        
        // Defer to next run loop to allow UI to update
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.performGeneration()
        }
    }
    
    @MainActor
    func performGeneration() {
        // Generate HTML
        let html = HTMLGenerator.generateHTML(for: resume, template: selectedTemplate)
        
        // Export to PDF
        PDFExporter.shared.exportToPDF(html: html) { pdfUrl in
            
            if let url = pdfUrl {
                // Rename with custom filename logic
                let baseName = (self.resume.title ?? "").isEmpty ? self.resume.fullName : self.resume.title!
                var safeName = baseName.components(separatedBy: CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "_- ")).inverted).joined(separator: "_")
                if safeName.isEmpty { safeName = "Resume" }
                let filename = "\(safeName).pdf"
                let targetURL = FileManager.default.temporaryDirectory.appendingPathComponent(filename)
                
                do {
                    if FileManager.default.fileExists(atPath: targetURL.path) {
                        try FileManager.default.removeItem(at: targetURL)
                    }
                    try FileManager.default.moveItem(at: url, to: targetURL)
                    self.generatedPDFUrl = targetURL
                    self.showShareSheet = true
                } catch {
                    print("Failed to rename PDF: \(error)")
                    // Fallback to original URL if rename fails
                    self.generatedPDFUrl = url
                    self.showShareSheet = true
                }
            } else {
                print("Failed to generate PDF")
            }
            
            self.isGeneratingPDF = false
        }
    }
}
struct ShareSheet: UIViewControllerRepresentable {
    var items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - Legacy / Helper


// MARK: - Classic Template (Professional with accent color)

struct ClassicTemplateView: View {
    let resume: Resume
    let openURL: OpenURLAction
    
    private let accentColor = Color(red: 0.2, green: 0.4, blue: 0.6)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(resume.fullName.isEmpty ? "YOUR NAME" : resume.fullName.uppercased())
                        .font(.system(size: 28, weight: .bold))
                        .tracking(3)
                        .foregroundColor(accentColor)
                }
                
                Spacer()
                
                if let photoData = resume.photoData, let uiImage = UIImage(data: photoData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(accentColor.opacity(0.3), lineWidth: 1))
                }
            }
            
            // Sub-header (Contact)
            VStack(alignment: .leading, spacing: 8) {
                
                // Contact row with icons
                HStack(spacing: 16) {
                    if !resume.phone.isEmpty {
                        Label(resume.fullPhone, systemImage: "phone.fill")
                    }
                    if !resume.email.isEmpty {
                        Label(resume.email, systemImage: "envelope.fill")
                    }
                    if !resume.location.isEmpty {
                        Label(resume.location, systemImage: "location.fill")
                    }
                }
                .font(.system(size: 11))
                .foregroundColor(.gray)
                
                // Social links
                HStack(spacing: 16) {
                    if let linkedinURL = resume.linkedinURL {
                        Link(destination: linkedinURL) {
                            Label("LinkedIn", systemImage: "link")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(.black)
                        }
                    }
                    if let githubURL = resume.githubURL {
                        Link(destination: githubURL) {
                            Label("GitHub", systemImage: "chevron.left.forwardslash.chevron.right")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(.black)
                        }
                    }
                }
            }
            .padding(.bottom, 20)
            
            // Divider
            Rectangle()
                .fill(accentColor)
                .frame(height: 2)
                .padding(.bottom, 20)
            
            // Education
            if !resume.education.isEmpty {
                ClassicSection(title: "EDUCATION", accentColor: accentColor) {
                    ForEach(resume.education) { edu in
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(edu.displayTitle)
                                    .font(.system(size: 14, weight: .semibold))
                                Text(edu.institution)
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            VStack(alignment: .trailing, spacing: 4) {
                                Text(edu.year)
                                    .font(.system(size: 11))
                                    .foregroundColor(.gray)
                                if !edu.formattedScore.isEmpty {
                                    Text(edu.formattedScore)
                                        .font(.system(size: 11, weight: .medium))
                                        .foregroundColor(accentColor)
                                }
                            }
                        }
                        .padding(.bottom, 12)
                    }
                }
            }
            
            // Experience
            if !resume.experience.isEmpty {
                ClassicSection(title: "EXPERIENCE", accentColor: accentColor) {
                    ForEach(resume.experience) { exp in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(alignment: .top) {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(exp.title)
                                        .font(.system(size: 14, weight: .semibold))
                                    Text(exp.company)
                                        .font(.system(size: 12))
                                        .foregroundColor(accentColor)
                                }
                                Spacer()
                                Text(exp.duration)
                                    .font(.system(size: 11))
                                    .foregroundColor(.gray)
                            }
                            
                            ForEach(exp.bullets, id: \.self) { bullet in
                                HStack(alignment: .top, spacing: 8) {
                                    Circle()
                                        .fill(accentColor)
                                        .frame(width: 4, height: 4)
                                        .padding(.top, 6)
                                    Text(bullet)
                                        .font(.system(size: 12))
                                        .lineSpacing(2)
                                }
                            }
                        }
                        .padding(.bottom, 14)
                    }
                }
            }
            
            // Projects
            if !resume.projects.isEmpty {
                ClassicSection(title: "PROJECTS", accentColor: accentColor) {
                    ForEach(resume.projects) { project in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                if project.hasValidLink, let url = project.url {
                                    Link(destination: url) {
                                        Text(project.name)
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(.black)
                                    }
                                } else {
                                    Text(project.name)
                                        .font(.system(size: 14, weight: .semibold))
                                }
                                Spacer()
                                if !project.tools.isEmpty {
                                    Text(project.tools)
                                        .font(.system(size: 10))
                                        .foregroundColor(.gray)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 3)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(4)
                                }
                            }
                            
                            ForEach(project.bullets, id: \.self) { bullet in
                                HStack(alignment: .top, spacing: 8) {
                                    Circle()
                                        .fill(accentColor)
                                        .frame(width: 4, height: 4)
                                        .padding(.top, 6)
                                    Text(bullet)
                                        .font(.system(size: 12))
                                        .lineSpacing(2)
                                }
                            }
                        }
                        .padding(.bottom, 14)
                    }
                }
            }
            
            // Certifications
            if let certs = resume.certifications, !certs.isEmpty {
                ClassicSection(title: "CERTIFICATIONS", accentColor: accentColor) {
                    ForEach(certs) { cert in
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 2) {
                                if cert.hasValidLink, let url = cert.url {
                                    Link(destination: url) {
                                        Text(cert.name)
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(.black)
                                    }
                                } else {
                                    Text(cert.name)
                                        .font(.system(size: 14, weight: .medium))
                                }
                                Text(cert.issuer)
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                                
                                HStack(spacing: 8) {
                                    Text("Issued: \(cert.issueDate)")
                                    if !cert.expiryDate.isEmpty {
                                        Text("•")
                                        Text("Expires: \(cert.expiryDate)")
                                    }
                                }
                                .font(.system(size: 10))
                                .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                        .padding(.bottom, 8)
                    }
                }
            }

            // Skills
            if !resume.skills.isEmpty {
                ClassicSection(title: "SKILLS", accentColor: accentColor) {
                    ForEach(SkillCategory.allCases) { category in
                        if let skills = resume.skills[category], !skills.isEmpty {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(category.rawValue)
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundColor(accentColor)
                                
                                FlowLayout(spacing: 6) {
                                    ForEach(skills, id: \.self) { skill in
                                        Text(skill)
                                            .font(.system(size: 11))
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 5)
                                            .background(Color.white)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 4)
                                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                            )
                                            .cornerRadius(4)
                                    }
                                }
                            }
                            .padding(.bottom, 10)
                        }
                    }
                }
            }
        }
        .padding(28)
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundColor(.black)
    }
}

struct ClassicSection<Content: View>: View {
    let title: String
    let accentColor: Color
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 13, weight: .bold))
                .tracking(2)
                .foregroundColor(accentColor)
            
            content
        }
        .padding(.bottom, 16)
    }
}

// MARK: - Simple Template (Clean & Minimal)

struct SimpleTemplateView: View {
    let resume: Resume
    let openURL: OpenURLAction
    
    var body: some View {
        VStack(spacing: 0) {
            // Header - centered
            VStack(spacing: 6) {
                if let photoData = resume.photoData, let uiImage = UIImage(data: photoData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 90, height: 90)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 1))
                        .padding(.bottom, 4)
                }
                
                Text(resume.fullName.isEmpty ? "Your Name" : resume.fullName)
                    .font(.system(size: 28, weight: .bold))
                
                // Contact line
                HStack(spacing: 0) {
                    let items = [resume.location, resume.fullPhone, resume.email].filter { !$0.isEmpty }
                    ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                        Text(item)
                        if index < items.count - 1 {
                            Text("  •  ")
                        }
                    }
                }
                .font(.system(size: 11))
                .foregroundColor(.gray)
                
                // Links
                HStack(spacing: 16) {
                    if let linkedinURL = resume.linkedinURL {
                        Link(destination: linkedinURL) {
                            Text("LinkedIn")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(.black)
                        }
                    }
                    if let githubURL = resume.githubURL {
                        Link(destination: githubURL) {
                            Text("GitHub")
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(.black)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 24)
            
            // Certifications
            if let certs = resume.certifications, !certs.isEmpty {
                SimpleSection(title: "Certifications") {
                    ForEach(certs) { cert in
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                if cert.hasValidLink, let url = cert.url {
                                    Link(destination: url) {
                                        Text(cert.name)
                                            .font(.system(size: 13, weight: .medium))
                                            .foregroundColor(.black)
                                    }
                                } else {
                                    Text(cert.name)
                                        .font(.system(size: 13, weight: .medium))
                                }
                                Text(cert.issuer)
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                                
                                HStack(spacing: 6) {
                                    Text(cert.issueDate)
                                    if !cert.expiryDate.isEmpty {
                                        Text("-")
                                        Text(cert.expiryDate)
                                    }
                                }
                                .font(.system(size: 10))
                                .foregroundColor(.secondary)
                            }
                            Spacer()
                        }
                        .padding(.bottom, 8)
                    }
                }
            }
            
            // Skills
            if !resume.skills.isEmpty {
                SimpleSection(title: "Skills") {
                    ForEach(SkillCategory.allCases) { category in
                        if let skills = resume.skills[category], !skills.isEmpty {
                            HStack(alignment: .top, spacing: 8) {
                                Text("•")
                                    .font(.system(size: 13, weight: .bold))
                                Text("\(category.rawValue): ")
                                    .font(.system(size: 13, weight: .semibold)) +
                                Text(skills.joined(separator: ", "))
                                    .font(.system(size: 13))
                            }
                            .padding(.bottom, 4)
                        }
                    }
                }
            }
            
            // Experience
            if !resume.experience.isEmpty {
                SimpleSection(title: "Experience") {
                    ForEach(resume.experience) { exp in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(alignment: .top) {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(exp.company)
                                        .font(.system(size: 14, weight: .semibold))
                                    Text(exp.title)
                                        .font(.system(size: 13))
                                        .italic()
                                }
                                Spacer()
                                Text(exp.duration)
                                    .font(.system(size: 11))
                                    .foregroundColor(.gray)
                            }
                            
                            ForEach(exp.bullets, id: \.self) { bullet in
                                Text(bullet)
                                    .font(.system(size: 12))
                                    .padding(.leading, 8)
                            }
                        }
                        .padding(.bottom, 14)
                    }
                }
            }
            
            // Projects
            if !resume.projects.isEmpty {
                SimpleSection(title: "Projects") {
                    ForEach(resume.projects) { project in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                if project.hasValidLink, let url = project.url {
                                    Link(destination: url) {
                                        Text(project.name)
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(.black)
                                    }
                                } else {
                                    Text(project.name)
                                        .font(.system(size: 14, weight: .semibold))
                                }
                                if !project.tools.isEmpty {
                                    Text("(\(project.tools))")
                                        .font(.system(size: 11))
                                        .foregroundColor(.gray)
                                }
                                Spacer()
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
            
            // Education
            if !resume.education.isEmpty {
                SimpleSection(title: "Education") {
                    ForEach(resume.education) { edu in
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(edu.displayTitle)
                                    .font(.system(size: 13, weight: .medium))
                                Text(edu.institution)
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            VStack(alignment: .trailing, spacing: 2) {
                                Text(edu.year)
                                    .font(.system(size: 11))
                                    .foregroundColor(.gray)
                                if !edu.formattedScore.isEmpty {
                                    Text(edu.formattedScore)
                                        .font(.system(size: 11))
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .padding(.bottom, 8)
                    }
                }
            }
        }
        .padding(28)
        .frame(maxWidth: .infinity)
        .foregroundColor(.black)
    }
}

struct SimpleSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 16, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .center)
            
            Rectangle()
                .fill(Color.black)
                .frame(height: 1)
                .padding(.bottom, 4)
            
            content
        }
        .padding(.bottom, 16)
    }
}

// MARK: - Modern Template (Creative with colored header)

struct ModernTemplateView: View {
    let resume: Resume
    let openURL: OpenURLAction
    
    private let accentColor = Color(red: 0.15, green: 0.55, blue: 0.55)
    private let lightAccent = Color(red: 0.85, green: 0.95, blue: 0.95)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header with gradient
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .top) {
                    // Name
                    VStack(alignment: .leading, spacing: 0) {
                        let names = resume.fullName.isEmpty ? ["Your", "Name"] : resume.fullName.split(separator: " ").map(String.init)
                        ForEach(names, id: \.self) { name in
                            Text(name)
                                .font(.system(size: 36, weight: .light))
                        }
                    }
                    .foregroundColor(accentColor)
                    
                    Spacer()
                    
                    // Photo
                    if let photoData = resume.photoData, let uiImage = UIImage(data: photoData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 85, height: 85)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(accentColor.opacity(0.3), lineWidth: 1))
                            .padding(.trailing, 16)
                    }
                    
                    // Contact
                    VStack(alignment: .trailing, spacing: 6) {
                        if !resume.email.isEmpty {
                            HStack(spacing: 6) {
                                Text(resume.email)
                                Image(systemName: "envelope.fill")
                            }
                        }
                        if !resume.phone.isEmpty {
                            HStack(spacing: 6) {
                                Text(resume.fullPhone)
                                Image(systemName: "phone.fill")
                            }
                        }
                        if !resume.location.isEmpty {
                            HStack(spacing: 6) {
                                Text(resume.location)
                                Image(systemName: "location.fill")
                            }
                        }
                        
                        HStack(spacing: 12) {
                            if let linkedinURL = resume.linkedinURL {
                                Link(destination: linkedinURL) {
                                    Text("LinkedIn")
                                        .font(.system(size: 11, weight: .semibold))
                                        .foregroundColor(.black)
                                }
                            }
                            if let githubURL = resume.githubURL {
                                Link(destination: githubURL) {
                                    Text("GitHub")
                                        .font(.system(size: 11, weight: .semibold))
                                        .foregroundColor(.black)
                                }
                            }
                        }
                    }
                    .font(.system(size: 11))
                    .foregroundColor(.gray)
                }
            }
            .padding(24)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                LinearGradient(
                    colors: [lightAccent, Color.white],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            
            // Content
            VStack(alignment: .leading, spacing: 20) {
                // Experience
                if !resume.experience.isEmpty {
                    ModernSection(title: "EXPERIENCE", accentColor: accentColor) {
                        ForEach(resume.experience) { exp in
                            VStack(alignment: .leading, spacing: 8) {
                                HStack(alignment: .top) {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(exp.title)
                                            .font(.system(size: 15, weight: .semibold))
                                        Text(exp.company)
                                            .font(.system(size: 12))
                                            .foregroundColor(accentColor)
                                    }
                                    Spacer()
                                    Text(exp.duration)
                                        .font(.system(size: 11))
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(lightAccent)
                                        .cornerRadius(4)
                                }
                                
                                ForEach(exp.bullets, id: \.self) { bullet in
                                    HStack(alignment: .top, spacing: 8) {
                                        Image(systemName: "arrow.right")
                                            .font(.system(size: 8))
                                            .foregroundColor(accentColor)
                                            .padding(.top, 4)
                                        Text(bullet)
                                            .font(.system(size: 12))
                                    }
                                }
                            }
                            .padding(.bottom, 14)
                        }
                    }
                }
                
                // Projects
                if !resume.projects.isEmpty {
                    ModernSection(title: "PROJECTS", accentColor: accentColor) {
                        ForEach(resume.projects) { project in
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    if project.hasValidLink, let url = project.url {
                                        Link(destination: url) {
                                            Text(project.name)
                                                .font(.system(size: 15, weight: .semibold))
                                                .foregroundColor(.black)
                                        }
                                    } else {
                                        Text(project.name)
                                            .font(.system(size: 15, weight: .semibold))
                                    }
                                    Spacer()
                                    if !project.tools.isEmpty {
                                        Text(project.tools)
                                            .font(.system(size: 10))
                                            .foregroundColor(accentColor)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 3)
                                            .background(lightAccent)
                                            .cornerRadius(4)
                                    }
                                }
                                
                                ForEach(project.bullets, id: \.self) { bullet in
                                    HStack(alignment: .top, spacing: 8) {
                                        Image(systemName: "arrow.right")
                                            .font(.system(size: 8))
                                            .foregroundColor(accentColor)
                                            .padding(.top, 4)
                                        Text(bullet)
                                            .font(.system(size: 12))
                                    }
                                }
                            }
                            .padding(.bottom, 12)
                        }
                    }
                }
                
                // Certifications
                if let certs = resume.certifications, !certs.isEmpty {
                    ModernSection(title: "CERTIFICATIONS", accentColor: accentColor) {
                        ForEach(certs) { cert in
                            HStack(alignment: .top) {
                                VStack(alignment: .leading, spacing: 2) {
                                    if cert.hasValidLink, let url = cert.url {
                                        Link(destination: url) {
                                            Text(cert.name)
                                                .font(.system(size: 13, weight: .medium))
                                                .foregroundColor(accentColor)
                                                .underline()
                                        }
                                    } else {
                                        Text(cert.name)
                                            .font(.system(size: 13, weight: .medium))
                                    }
                                    Text(cert.issuer)
                                        .font(.system(size: 11))
                                        .foregroundColor(accentColor)
                                    
                                    HStack(spacing: 6) {
                                        Text(cert.issueDate)
                                        if !cert.expiryDate.isEmpty {
                                            Text("→")
                                            Text(cert.expiryDate)
                                        }
                                    }
                                    .font(.system(size: 10))
                                    .foregroundColor(accentColor.opacity(0.8))
                                }
                                Spacer()
                            }
                            .padding(.bottom, 8)
                        }
                    }
                }

                // Bottom row
                HStack(alignment: .top, spacing: 32) {
                    // Education
                    if !resume.education.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 6) {
                                Rectangle()
                                    .fill(accentColor)
                                    .frame(width: 3)
                                Text("EDUCATION")
                                    .font(.system(size: 12, weight: .bold))
                                    .tracking(1.5)
                                    .foregroundColor(accentColor)
                            }
                            .frame(height: 16)
                            
                            ForEach(resume.education) { edu in
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(edu.displayTitle)
                                        .font(.system(size: 13, weight: .medium))
                                    Text(edu.institution)
                                        .font(.system(size: 11))
                                        .foregroundColor(.gray)
                                    HStack(spacing: 8) {
                                        Text(edu.year)
                                        if !edu.formattedScore.isEmpty {
                                            Text("•")
                                            Text(edu.formattedScore)
                                        }
                                    }
                                    .font(.system(size: 10))
                                    .foregroundColor(accentColor)
                                }
                                .padding(.bottom, 8)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    // Skills
                    if !resume.skills.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 6) {
                                Rectangle()
                                    .fill(accentColor)
                                    .frame(width: 3)
                                Text("SKILLS")
                                    .font(.system(size: 12, weight: .bold))
                                    .tracking(1.5)
                                    .foregroundColor(accentColor)
                            }
                            .frame(height: 16)
                            
                            ForEach(SkillCategory.allCases) { category in
                                if let skills = resume.skills[category], !skills.isEmpty {
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text(category.rawValue)
                                            .font(.system(size: 10, weight: .medium))
                                            .foregroundColor(.gray)
                                        Text(skills.joined(separator: " • "))
                                            .font(.system(size: 11))
                                    }
                                    .padding(.bottom, 6)
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .padding(24)
        }
        .foregroundColor(.black)
    }
}

struct ModernSection<Content: View>: View {
    let title: String
    let accentColor: Color
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Rectangle()
                    .fill(accentColor)
                    .frame(width: 3)
                Text(title)
                    .font(.system(size: 12, weight: .bold))
                    .tracking(1.5)
                    .foregroundColor(accentColor)
            }
            .frame(height: 16)
            
            content
        }
    }
}

// MARK: - Flow Layout for Skills

struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrangeSubviews(proposal: proposal, subviews: subviews)
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrangeSubviews(proposal: proposal, subviews: subviews)
        for (index, frame) in result.frames.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + frame.minX, y: bounds.minY + frame.minY), proposal: ProposedViewSize(frame.size))
        }
    }
    
    private func arrangeSubviews(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, frames: [CGRect]) {
        let maxWidth = proposal.width ?? .infinity
        var frames: [CGRect] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth && x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            frames.append(CGRect(x: x, y: y, width: size.width, height: size.height))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
        }
        
        return (CGSize(width: maxWidth, height: y + rowHeight), frames)
    }
}

// MARK: - Print Views

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
