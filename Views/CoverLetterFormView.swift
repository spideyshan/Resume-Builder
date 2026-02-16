import SwiftUI

struct CoverLetterFormView: View {
    @EnvironmentObject var resumeManager: ResumeManager
    @Binding var path: NavigationPath
    
    @State private var coverLetter = CoverLetter()
    @State private var selectedResume: Resume?
    @State private var navigateToPreview = false
    
    var body: some View {
        Form {
            // Resume Picker
            Section {
                if resumeManager.savedResumes.isEmpty {
                    Text("No saved resumes. Create one first.")
                        .foregroundColor(.secondary)
                } else {
                    Picker("Based on Resume", selection: $selectedResume) {
                        Text("Select a resume").tag(nil as Resume?)
                        ForEach(resumeManager.savedResumes) { resume in
                            Text(resumeDisplayName(resume))
                                .tag(resume as Resume?)
                        }
                    }
                }
            } header: {
                Text("Source Resume")
            } footer: {
                Text("Your skills, experience, and contact info will be auto-filled from this resume.")
            }
            
            // Job Details
            Section("Job Details") {
                TextField("Company Name", text: $coverLetter.companyName)
                    .textContentType(.organizationName)
                
                TextField("Job Title / Position", text: $coverLetter.jobTitle)
                
                TextField("Hiring Manager (optional)", text: $coverLetter.hiringManagerName)
                    .textContentType(.name)
            }
            
            // Tone
            Section {
                Picker("Tone", selection: $coverLetter.tone) {
                    ForEach(CoverLetterTone.allCases) { tone in
                        VStack(alignment: .leading) {
                            Text(tone.rawValue)
                        }
                        .tag(tone)
                    }
                }
                .pickerStyle(.segmented)
                
                Text(coverLetter.tone.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            } header: {
                Text("Style")
            }
            
            // Custom Paragraph
            Section {
                TextEditor(text: $coverLetter.whyInterested)
                    .frame(minHeight: 80)
            } header: {
                Text("Why This Role? (Optional)")
            } footer: {
                Text("Add a personal touch — mention what excites you about this company or role. This gets woven into the opening paragraph.")
            }
            
            // Generate Button
            Section {
                Button {
                    navigateToPreview = true
                } label: {
                    HStack {
                        Spacer()
                        Image(systemName: "doc.text.fill")
                        Text("Generate Cover Letter")
                            .fontWeight(.semibold)
                        Spacer()
                    }
                    .foregroundColor(.white)
                    .padding(.vertical, 8)
                }
                .listRowBackground(
                    (selectedResume != nil && !coverLetter.companyName.isEmpty && !coverLetter.jobTitle.isEmpty)
                    ? Color.blue
                    : Color.gray
                )
                .disabled(selectedResume == nil || coverLetter.companyName.isEmpty || coverLetter.jobTitle.isEmpty)
            }
        }
        .navigationTitle("Cover Letter")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $navigateToPreview) {
            if let resume = selectedResume {
                CoverLetterPreviewView(resume: resume, coverLetter: coverLetter, path: $path)
            }
        }
        .onAppear {
            // Auto-select first resume if only one exists
            if resumeManager.savedResumes.count == 1 {
                selectedResume = resumeManager.savedResumes.first
            }
        }
    }
    
    private func resumeDisplayName(_ resume: Resume) -> String {
        if let title = resume.title, !title.isEmpty {
            return title
        }
        return resume.fullName.isEmpty ? "Untitled Resume" : resume.fullName
    }
}
