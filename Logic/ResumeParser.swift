import SwiftUI
import Vision
import PDFKit

struct ResumeParser {
    
    /// Entry point: Parses a file from a URL (PDF or Image)
    static func parse(url: URL) async -> Resume {
        let text = await extractText(from: url)
        return parse(text: text)
    }
    
    // MARK: - Text Extraction (OCR)
    
    private static func extractText(from url: URL) async -> String {
        // Handle PDF
        if url.pathExtension.lowercased() == "pdf" {
            if let pdf = PDFDocument(url: url) {
                return pdf.string ?? ""
            }
        }
        
        // Handle Image (via Vision)
        // Note: For now we assume the URL points to an image or we can load it.
        // If it's a PDF, PDFKit is better for text. If it's a scanned PDF (image only), we'd need to convert pages to images.
        // For simplicity v1: Text-based PDFs use PDFKit. Images use Vision.
        
        // Try loading as image
        if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
            return await extractText(from: image)
        }
        
        return ""
    }
    
    static func extractText(from image: UIImage) async -> String {
        guard let cgImage = image.cgImage else { return "" }
        
        return await withCheckedContinuation { continuation in
            let request = VNRecognizeTextRequest { request, error in
                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    continuation.resume(returning: "")
                    return
                }
                
                let text = observations.compactMap { $0.topCandidates(1).first?.string }.joined(separator: "\n")
                continuation.resume(returning: text)
            }
            
            request.recognitionLevel = .accurate
            
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            try? handler.perform([request])
        }
    }
    
    // MARK: - Parsing Logic (Heuristic)
    
    private static func parse(text: String) -> Resume {
        var resume = Resume(
            firstName: "", lastName: "",
            email: "", countryCode: CountryCode.defaultCode, phone: "",
            location: "", linkedin: "", github: "",
            education: [], skills: [:], experience: [], projects: []
        )
        
        let lines = text.components(separatedBy: .newlines).filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
        
        // 1. Name (Simple Heuristic: First line that isn't a label)
        if let firstLine = lines.first {
            let parts = firstLine.components(separatedBy: " ")
            if parts.count >= 2 {
                resume.firstName = parts[0]
                resume.lastName = parts.dropFirst().joined(separator: " ")
            } else {
                resume.firstName = firstLine
            }
        }
        
        // 2. Contact Info via Regex
        resume.email = extractEmail(from: text) ?? ""
        resume.phone = extractPhone(from: text) ?? ""
        resume.linkedin = extractLink(from: text, containing: "linkedin.com") ?? ""
        resume.github = extractLink(from: text, containing: "github.com") ?? ""
        
        // 3. Sections
        // We look for keywords like "Experience", "Education" on their own lines to split content.
        let sections = splitIntoSections(lines: lines)
        
        if let eduText = sections["education"] {
            resume.education = parseEducation(from: eduText)
        }
        
        if let expText = sections["experience"] {
            resume.experience = parseExperience(from: expText)
        }
        
        if let skillsText = sections["skills"] {
            resume.skills = parseSkills(from: skillsText)
        }
        
        resume.title = "Imported Resume"
        return resume
    }
    
    // MARK: - Helpers
    
    private static func extractEmail(from text: String) -> String? {
        let pattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return extractRegex(pattern: pattern, in: text)
    }
    
    private static func extractPhone(from text: String) -> String? {
        // Simple phone regex, looks for 10-15 digits, maybe separated
        let pattern = "\\+?[0-9]{1,3}?[ -]?[0-9]{3}?[ -]?[0-9]{3}?[ -]?[0-9]{4}"
        return extractRegex(pattern: pattern, in: text)
    }
    
    private static func extractLink(from text: String, containing host: String) -> String? {
        // Look for string containing host
        let dataDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = dataDetector?.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))
        
        for match in matches ?? [] {
            if let url = match.url?.absoluteString, url.contains(host) {
                return url
            }
        }
        return nil
    }
    
    private static func extractRegex(pattern: String, in text: String) -> String? {
        let regex = try? NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: text.utf16.count)
        if let match = regex?.firstMatch(in: text, options: [], range: range) {
            if let swRange = Range(match.range, in: text) {
                return String(text[swRange])
            }
        }
        return nil
    }
    
    private static func splitIntoSections(lines: [String]) -> [String: [String]] {
        var sections: [String: [String]] = [:]
        var currentSection = "header"
        
        let headers = ["education", "experience", "work experience", "skills", "projects", "technical skills"]
        
        for line in lines {
            let lower = line.lowercased().trimmingCharacters(in: .punctuationCharacters)
            if headers.contains(lower) {
                currentSection = lower.replacingOccurrences(of: "work ", with: "").replacingOccurrences(of: "technical ", with: "")
                sections[currentSection] = []
            } else {
                if sections[currentSection] == nil { sections[currentSection] = [] }
                sections[currentSection]?.append(line)
            }
        }
        
        return sections
    }
    
    private static func parseEducation(from lines: [String]) -> [Education] {
        // Very basic parser: Assumes Institution first, then Degree
        // This is hard to get right without structural analysis, but we try ONE entry.
        guard !lines.isEmpty else { return [] }
        
        var edu = Education(type: .degree, institution: "", degree: "", field: "", year: "", score: "")
        
        // Heuristic: First line is Uni, Second is Degree
        edu.institution = lines[0]
        if lines.count > 1 {
            edu.degree = lines[1]
        }
        
        return [edu]
    }
    
    private static func parseExperience(from lines: [String]) -> [Experience] {
        // Try to identify blocks of experience
        // Heuristic: Look for years (e.g., 2020-2022) to start a new block? 
        // Or just put everything in one big block for the user to edit.
        // Parsing unstructured experience is very hard. 
        // Strategy: Create one generic entry with all text as bullets.
        
        guard !lines.isEmpty else { return [] }
        
        var exp = Experience(title: "Role (Edit Me)", company: "Company (Edit Me)", duration: "", bullets: [])
        exp.bullets = lines
        
        return [exp]
    }
    
    private static func parseSkills(from lines: [String]) -> [SkillCategory: [String]] {
        var skills: [SkillCategory: [String]] = [:]
        
        // Join all lines and split by comma or dot
        let bigString = lines.joined(separator: " ")
        let potentialSkills = bigString.components(separatedBy: CharacterSet(charactersIn: ",•|")).map { $0.trimmingCharacters(in: .whitespaces) }
        
        // Naive mapping if we had a dictionary, but for now just put them all in 'Other' or 'Frontend'
        skills[.other] = potentialSkills.filter { !$0.isEmpty }
        
        return skills
    }
}
