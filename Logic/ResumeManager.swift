import Foundation
import SwiftUI

class ResumeManager: ObservableObject {
    @Published var savedResumes: [Resume] = []
    
    private let fileManager = FileManager.default
    private let documentsDirectory: URL
    
    init() {
        // Get the Documents directory
        documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        print("ResumeManager initialized. Documents Directory: \(documentsDirectory.path)")
        loadResumes()
    }
    
    // MARK: - Save
    @discardableResult
    func save(resume: Resume) -> Bool {
        var resumeToSave = resume
        resumeToSave.lastModified = Date() // Update timestamp
        
        let filename = "\(resumeToSave.id.uuidString).json"
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        
        do {
            let data = try JSONEncoder().encode(resumeToSave)
            try data.write(to: fileURL)
            // Refresh list
            loadResumes()
            print("Successfully saved resume: \(resumeToSave.fullName)")
            return true
        } catch {
            print("Failed to save resume: \(error.localizedDescription)")
            return false
        }
    }
    
    // MARK: - Load
    func loadResumes() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            do {
                let fileURLs = try self.fileManager.contentsOfDirectory(at: self.documentsDirectory, includingPropertiesForKeys: nil)
                
                var loadedResumes: [Resume] = []
                
                for fileURL in fileURLs {
                    if fileURL.pathExtension == "json" {
                        do {
                            let data = try Data(contentsOf: fileURL)
                            let resume = try JSONDecoder().decode(Resume.self, from: data)
                            loadedResumes.append(resume)
                        } catch {
                            print("Failed to decode resume at \(fileURL.lastPathComponent): \(error.localizedDescription)")
                        }
                    }
                }
                
                // Sort by last modified (newest first)
                let sortedResumes = loadedResumes.sorted { $0.lastModified > $1.lastModified }
                
                DispatchQueue.main.async {
                    self.savedResumes = sortedResumes
                }
                
            } catch {
                print("Failed to list directory: \(error.localizedDescription)")
            }
            
            // Check if empty and load default if needed
            DispatchQueue.main.async {
                if self.savedResumes.isEmpty {
                    self.createDefaultResume()
                }
            }
        }
    }
    
    // MARK: - Default Data
    private func createDefaultResume() {
        let steveJobs = Resume(
            id: UUID(),
            lastModified: Date(),
            title: "Visionary & Founder",
            firstName: "Steve",
            lastName: "Jobs",
            email: "steve@apple.com",
            countryCode: CountryCode(name: "United States", code: "US", dialCode: "+1"),
            phone: "408-996-1010",
            location: "Cupertino, CA",
            linkedin: "linkedin.com/in/stevejobs",
            github: "github.com/stevejobs",
            education: [
                Education(
                    type: .degree,
                    institution: "Reed College",
                    degree: "Physics & Literature",
                    field: "Liberal Arts",
                    year: "1972",
                    score: "Dropout"
                )
            ],
            skills: [
                .softSkills: ["Visionary Leadership", "Design Thinking", "Public Speaking", "Negotiation"],
                .tools: ["Keynote", "Pixar RenderMan"],
                .languages: ["English"]
            ],
            experience: [
                Experience(
                    title: "Co-Founder & CEO",
                    company: "Apple Inc.",
                    duration: "1997 - 2011",
                    bullets: [
                        "Revolutionized the mobile phone industry with the iPhone.",
                        "Launched the iPad, creating the post-PC tablet category.",
                        "Oversaw the development of the App Store, creating a new developer economy."
                    ]
                ),
                Experience(
                    title: "CEO & Owner",
                    company: "Pixar Animation Studios",
                    duration: "1986 - 2006",
                    bullets: [
                        "Executive Producer for Toy Story, the first purely computer-animated feature film.",
                        "Scaled the company from a small hardware team to an animation powerhouse."
                    ]
                )
            ],
            projects: [
                Project(
                    name: "Macintosh",
                    link: "apple.com/mac",
                    tools: "Motorola 68000, QuickDraw",
                    bullets: [
                        "Led the team that built the first mass-market personal computer with a graphical user interface and mouse.",
                        "Championed the 'bicycle for the mind' concept.",
                        "Insisted on beautiful typography and rounded corners."
                    ]
                ),
                Project(
                    name: "NeXT Computer",
                    link: "en.wikipedia.org/wiki/NeXT",
                    tools: "Display PostScript, Mach Kernel",
                    bullets: [
                        "Created the workstation that Tim Berners-Lee used to invent the World Wide Web.",
                        "Built an advanced object-oriented operating system that eventually became macOS."
                    ]
                )
            ]
        )
        
        save(resume: steveJobs)
    }
    
    // MARK: - Delete
    func delete(resume: Resume) {
        let filename = "\(resume.id.uuidString).json"
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        
        do {
            try fileManager.removeItem(at: fileURL)
            // Refresh list
            loadResumes()
            print("Successfully deleted resume: \(resume.fullName)")
        } catch {
            print("Failed to delete resume: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Duplicate
    @discardableResult
    func duplicate(resume: Resume) -> Bool {
        var copy = resume
        copy.id = UUID()
        copy.lastModified = Date()
        
        // Append "(Copy)" to the title or name
        if let title = copy.title, !title.isEmpty {
            copy.title = title + " (Copy)"
        } else {
            copy.title = (resume.fullName.isEmpty ? "Untitled Resume" : resume.fullName) + " (Copy)"
        }
        
        return save(resume: copy)
    }
    
    // MARK: - Helper
    func getResume(withId id: UUID) -> Resume? {
        return savedResumes.first { $0.id == id }
    }
}
