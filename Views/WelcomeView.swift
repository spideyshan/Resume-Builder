import SwiftUI
import UniformTypeIdentifiers

struct WelcomeView: View {
    @EnvironmentObject var resumeManager: ResumeManager
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var showingResumeForm = false
    @State private var path = NavigationPath()
    
    // Import State
    @State private var isImporting = false
    @State private var importedResume: Resume? // Use this to trigger navigation if needed, or just pass to form
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 0) {
                // Top Header Section
                HStack(alignment: .top) {
                    Spacer()
                    // Adaptive Dark Mode Toggle
                    Button {
                        isDarkMode.toggle()
                    } label: {
                        Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                        .font(.system(size: 20))
                        .foregroundColor(isDarkMode ? .yellow : .blue)
                        .padding(10)
                        .background(Circle().fill(isDarkMode ? Color.white.opacity(0.1) : Color.black.opacity(0.05)))
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                // Centered App Name and Tagline
                VStack(spacing: 8) {
                    Text("ResumeCraft")
                        .font(.custom("Times New Roman", size: 36).weight(.bold))
                    
                    Text("Professional resumes in minutes")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.bottom, 20)
                
                if resumeManager.savedResumes.isEmpty {
                    // Empty State
                    emptyStateView
                } else {
                    // List of Resumes
                    List {
                        Section("My Resumes") {
                            ForEach(resumeManager.savedResumes) { resume in
                                NavigationLink(value: resume) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text((resume.title ?? "").isEmpty ? (resume.fullName.isEmpty ? "Untitled Resume" : resume.fullName) : resume.title!)
                                                .font(.headline)
                                                .foregroundColor(.primary)
                                            if !(resume.title ?? "").isEmpty && !resume.fullName.isEmpty {
                                                Text(resume.fullName)
                                                    .font(.subheadline)
                                                    .foregroundColor(.secondary)
                                            }
                                            Text("Last modified: " + resume.lastModified.formatted(date: .abbreviated, time: .shortened))
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        Spacer()
                                    }
                                    .padding(.vertical, 4)
                                }
                            }
                            .onDelete { indexSet in
                                for index in indexSet {
                                    resumeManager.delete(resume: resumeManager.savedResumes[index])
                                }
                            }
                        }
                    }
                }
                
                Spacer()
                
                // Action Buttons
                VStack(spacing: 12) {
                    // Create New Button
                    Button {
                        showingResumeForm = true
                    } label: {
                        HStack {
                            Image(systemName: "plus")
                            Text("Create New Resume")
                        }
                        .font(.headline)
                        .foregroundStyle(isDarkMode ? .black : .white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isDarkMode ? Color.white : Color.black)
                        .cornerRadius(12)
                    }
                    
                    // Import Resume Button
                    Button {
                        isImporting = true
                    } label: {
                        HStack {
                            Image(systemName: "square.and.arrow.down")
                            Text("Import from PDF/Image")
                        }
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                    }
                    .padding(.bottom, 5)
                }
                .padding()
            }
            .navigationBarHidden(true)
            .navigationDestination(isPresented: $showingResumeForm) {
                // Determine if we are passing an imported resume or nil
                if let resume = importedResume {
                    ResumeFormView(path: $path, existingResume: resume)
                        .onDisappear { importedResume = nil } // Reset after use
                } else {
                    ResumeFormView(path: $path, existingResume: nil)
                }
            }
            .navigationDestination(for: Resume.self) { resume in
                ResumeFormView(path: $path, existingResume: resume)
            }
            .fileImporter(
                isPresented: $isImporting,
                allowedContentTypes: [UTType.pdf, UTType.image],
                allowsMultipleSelection: false
            ) { result in
                switch result {
                case .success(let urls):
                    guard let url = urls.first else { return }
                    // Start accessing security scoped resource
                    guard url.startAccessingSecurityScopedResource() else { return }
                    
                    defer { url.stopAccessingSecurityScopedResource() }
                    
                    Task {
                        let parsedResume = await ResumeParser.parse(url: url)
                        await MainActor.run {
                            self.importedResume = parsedResume
                            self.showingResumeForm = true
                        }
                    }
                    
                case .failure(let error):
                    print("Import failed: \(error.localizedDescription)")
                }
            }
        }
        .onAppear {
            resumeManager.loadResumes()
        }
    }
    
    var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "doc.text.fill")
                .font(.system(size: 60))
                .foregroundStyle(.quaternary)
                .padding()
                .background(
                    Circle()
                        .fill(Color.secondary.opacity(0.1))
                        .frame(width: 120, height: 120)
                )
            
            Text("No Resumes Yet")
                .font(.title3)
                .fontWeight(.semibold)
            
            Text("Create your first resume to get started.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
        }
    }
}
