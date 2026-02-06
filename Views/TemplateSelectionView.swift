import SwiftUI

struct TemplateSelectionView: View {
    @Binding var selectedTemplate: ResumeTemplate
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Choose a template for your resume")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                        .padding(.top, 10)
                    
                    ForEach(ResumeTemplate.allCases) { template in
                        TemplateCard(
                            template: template,
                            isSelected: selectedTemplate == template
                        ) {
                            selectedTemplate = template
                        }
                    }
                }
                .padding(20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Templates")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

struct TemplateCard: View {
    let template: ResumeTemplate
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 0) {
                // Preview area
                TemplatePreviewThumbnail(template: template)
                    .frame(height: 200)
                    .clipped()
                
                // Info area
                HStack(spacing: 12) {
                    Image(systemName: template.icon)
                        .font(.system(size: 20))
                        .foregroundColor(isSelected ? .blue : .primary)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(template.rawValue)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                        Text(template.description)
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.blue)
                    }
                }
                .padding(16)
                .background(Color(.systemBackground))
            }
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.blue : Color(.systemGray4), lineWidth: isSelected ? 2 : 1)
            )
        }
    }
}

struct TemplatePreviewThumbnail: View {
    let template: ResumeTemplate
    
    var body: some View {
        GeometryReader { geo in
            switch template {
            case .classic:
                ClassicThumbnail()
            case .simple:
                SimpleThumbnail()
            case .modern:
                ModernThumbnail()
            }
        }
        .background(Color.white)
    }
}

// MARK: - Thumbnail Previews

struct ClassicThumbnail: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Name
            Text("JOHN DOE")
                .font(.system(size: 16, weight: .bold))
                .tracking(2)
            
            Text("john@email.com • +1 234-567-890")
                .font(.system(size: 6))
                .foregroundColor(.gray)
            
            // Education section
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 4) {
                    Text("EDUCATION")
                        .font(.system(size: 8, weight: .bold))
                        .tracking(1)
                    Rectangle().fill(Color.black).frame(height: 0.5)
                }
                
                HStack(alignment: .top, spacing: 8) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("2020 - 2024")
                            .font(.system(size: 5))
                            .foregroundColor(.gray)
                        Text("City, State")
                            .font(.system(size: 5))
                            .foregroundColor(.gray)
                    }
                    .frame(width: 50, alignment: .leading)
                    
                    Circle()
                        .fill(Color.black)
                        .frame(width: 6, height: 6)
                    
                    VStack(alignment: .leading, spacing: 1) {
                        Text("B.Tech in Computer Science")
                            .font(.system(size: 7, weight: .semibold))
                        Text("University Name")
                            .font(.system(size: 6))
                            .foregroundColor(.blue)
                        Text("CGPA: 8.5")
                            .font(.system(size: 5))
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.top, 6)
            
            // Experience section
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 4) {
                    Text("EXPERIENCE")
                        .font(.system(size: 8, weight: .bold))
                        .tracking(1)
                    Rectangle().fill(Color.black).frame(height: 0.5)
                }
                
                HStack(alignment: .top, spacing: 8) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("06/2023 - Present")
                            .font(.system(size: 5))
                            .foregroundColor(.gray)
                        Text("San Francisco")
                            .font(.system(size: 5))
                            .foregroundColor(.gray)
                    }
                    .frame(width: 50, alignment: .leading)
                    
                    Circle()
                        .fill(Color.black)
                        .frame(width: 6, height: 6)
                    
                    VStack(alignment: .leading, spacing: 1) {
                        Text("Software Engineer")
                            .font(.system(size: 7, weight: .semibold))
                        Text("Tech Company")
                            .font(.system(size: 6))
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.top, 4)
            
            Spacer()
        }
        .padding(16)
        .foregroundColor(.black)
    }
}

struct SimpleThumbnail: View {
    var body: some View {
        VStack(spacing: 6) {
            // Name
            Text("John Doe")
                .font(.system(size: 16, weight: .bold))
            
            Text("City, State • (555) 555-1234")
                .font(.system(size: 6))
                .foregroundColor(.gray)
            
            Text("john@email.com • linkedin.com/in/johndoe")
                .font(.system(size: 6))
                .foregroundColor(.gray)
            
            Text("Brief summary of your professional background")
                .font(.system(size: 6))
                .foregroundColor(.gray)
                .italic()
                .padding(.top, 2)
            
            // Skills
            VStack(spacing: 4) {
                Text("Top Skills")
                    .font(.system(size: 8, weight: .bold))
                    .padding(.top, 6)
                
                HStack(spacing: 4) {
                    Text("•")
                    Text("Skill 1 - Description of expertise")
                }
                .font(.system(size: 5))
                
                HStack(spacing: 4) {
                    Text("•")
                    Text("Skill 2 - Another skill description")
                }
                .font(.system(size: 5))
            }
            
            // Experience
            VStack(spacing: 4) {
                Text("Work Experience")
                    .font(.system(size: 8, weight: .bold))
                    .padding(.top, 4)
                
                HStack {
                    VStack(alignment: .leading, spacing: 1) {
                        Text("Company Name")
                            .font(.system(size: 6, weight: .medium))
                        Text("Job Title")
                            .font(.system(size: 5))
                            .italic()
                    }
                    Spacer()
                    Text("MM/YYYY - Present")
                        .font(.system(size: 5))
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .foregroundColor(.black)
    }
}

struct ModernThumbnail: View {
    var body: some View {
        HStack(spacing: 0) {
            // Left column
            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("John")
                        .font(.system(size: 18, weight: .light))
                    Text("Doe")
                        .font(.system(size: 18, weight: .light))
                }
                
                Text("SOFTWARE ENGINEER")
                    .font(.system(size: 6, weight: .medium))
                    .foregroundColor(.gray)
                    .tracking(1)
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 3) {
                    Text("john@email.com")
                        .font(.system(size: 5))
                    Text("(555) 555-0100")
                        .font(.system(size: 5))
                    Text("LinkedIn")
                        .font(.system(size: 5))
                        .foregroundColor(.blue)
                }
            }
            .frame(width: 80)
            .padding(12)
            .background(Color(red: 0.9, green: 0.95, blue: 0.95))
            
            // Right column
            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("EXPERIENCE")
                        .font(.system(size: 7, weight: .bold))
                        .tracking(1)
                    
                    HStack(alignment: .top) {
                        Text("2020 - Present")
                            .font(.system(size: 5))
                            .foregroundColor(.gray)
                            .frame(width: 40, alignment: .leading)
                        
                        VStack(alignment: .leading, spacing: 1) {
                            Text("Software Engineer, Company")
                                .font(.system(size: 6, weight: .medium))
                            Text("Description of responsibilities")
                                .font(.system(size: 5))
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                HStack(alignment: .top, spacing: 12) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("EDUCATION")
                            .font(.system(size: 6, weight: .bold))
                            .tracking(0.5)
                        Text("B.Tech CS")
                            .font(.system(size: 5))
                        Text("University")
                            .font(.system(size: 5))
                            .foregroundColor(.gray)
                    }
                    
                    VStack(alignment: .leading, spacing: 3) {
                        Text("SKILLS")
                            .font(.system(size: 6, weight: .bold))
                            .tracking(0.5)
                        Text("React, Node.js")
                            .font(.system(size: 5))
                        Text("Python, Swift")
                            .font(.system(size: 5))
                    }
                }
                .padding(.top, 4)
                
                Spacer()
            }
            .padding(12)
        }
        .foregroundColor(.black)
    }
}
