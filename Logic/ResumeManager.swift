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
    func save(resume: Resume) {
        var resumeToSave = resume
        resumeToSave.lastModified = Date() // Update timestamp
        
        // If ID is missing (shouldn't happen with new struct), generate one
        // UUID is constant in the struct, so we rely on the struct update to persist changes
        
        let filename = "\(resumeToSave.id.uuidString).json"
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        
        do {
            let data = try JSONEncoder().encode(resumeToSave)
            try data.write(to: fileURL)
            // Refresh list
            loadResumes()
            print("Successfully saved resume: \(resumeToSave.fullName)")
        } catch {
            print("Failed to save resume: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Load
    func loadResumes() {
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil)
            
            var loadedResumes: [Resume] = []
            
            for fileURL in fileURLs {
                if fileURL.pathExtension == "json" {
                    let data = try Data(contentsOf: fileURL)
                    let resume = try JSONDecoder().decode(Resume.self, from: data)
                    loadedResumes.append(resume)
                }
            }
            
            // Sort by last modified (newest first)
            DispatchQueue.main.async {
                self.savedResumes = loadedResumes.sorted { $0.lastModified > $1.lastModified }
            }
            
        } catch {
            print("Failed to load resumes: \(error.localizedDescription)")
        }
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
    
    // MARK: - Helper
    func getResume(withId id: UUID) -> Resume? {
        return savedResumes.first { $0.id == id }
    }
}
