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
