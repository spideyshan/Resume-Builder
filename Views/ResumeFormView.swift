import SwiftUI

struct ResumeFormView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var resumeManager: ResumeManager
    
    // Resume ID (for updates)
    @State private var existingResumeId: UUID?
    
    // Resume passed in for editing
    var existingResume: Resume?
    
    // Personal Info
    @State private var firstName = ""
    @State private var lastName = ""
    
    // Contact
    @State private var email = ""
    @State private var selectedCountryCode = CountryCode.defaultCode
    @State private var phone = ""
    @State private var location = ""
    @State private var linkedin = ""
    @State private var github = ""
    @State private var showCountryPicker = false
    
    // Education
    @State private var educationList: [EducationInput] = []
    @State private var showEducationTypePicker = false
    
    // Skills
    @State private var selectedSkills: [SkillCategory: Set<String>] = [:]
    @State private var customSkillText = ""
    @State private var selectedCategory: SkillCategory = .frontend
    
    // Experience & Projects
    @State private var experiences: [ExperienceInput] = []
    @State private var projects: [ProjectInput] = []
    
    // Removed custom init to fix State initialization issues
    
    func loadExistingResume() {
        guard let resume = existingResume else { return }
        
        // Prevent reloading if already loaded (check ID match)
        // If existingResumeId is already set, we might not want to overwrite edits
        if existingResumeId != nil { return }
        
        existingResumeId = resume.id
        firstName = resume.firstName
        lastName = resume.lastName
        email = resume.email
        selectedCountryCode = resume.countryCode
        phone = resume.phone
        location = resume.location
        linkedin = resume.linkedin
        github = resume.github
        
        // Map models to inputs
        educationList = resume.education.map { edu in
            EducationInput(type: edu.type, institution: edu.institution, degree: edu.degree, field: edu.field, year: edu.year, score: edu.score)
        }
        
        // Map Skills
        var skills: [SkillCategory: Set<String>] = [:]
        for (category, skillList) in resume.skills {
            skills[category] = Set(skillList)
        }
        selectedSkills = skills
        
        // Map Experience
        experiences = resume.experience.map { exp in
            ExperienceInput(title: exp.title, company: exp.company, duration: exp.duration, bullets: exp.bullets.joined(separator: "\n"))
        }
        
        // Map Projects
        projects = resume.projects.map { proj in
            ProjectInput(name: proj.name, link: proj.link, tools: proj.tools, bullets: proj.bullets.joined(separator: "\n"))
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                
                // 01 - Personal Info
                FormSection(number: "01", title: "Personal Information") {
                    HStack(spacing: 12) {
                        SimpleField(label: "FIRST NAME", placeholder: "John", text: $firstName)
                        SimpleField(label: "LAST NAME", placeholder: "Doe", text: $lastName)
                    }
                }
                
                // 02 - Contact
                FormSection(number: "02", title: "Contact Information") {
                    SimpleField(label: "EMAIL", placeholder: "john@email.com", text: $email)
                    
                    // Phone with country code
                    VStack(alignment: .leading, spacing: 6) {
                        Text("PHONE")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.secondary)
                            .tracking(0.5)
                        
                        HStack(spacing: 8) {
                            Button {
                                showCountryPicker = true
                            } label: {
                                HStack(spacing: 6) {
                                    Text(selectedCountryCode.flag)
                                        .font(.system(size: 20))
                                    Text(selectedCountryCode.dialCode)
                                        .font(.system(size: 15))
                                        .foregroundColor(.primary)
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 10, weight: .semibold))
                                        .foregroundColor(.secondary)
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 12)
                                .background(Color(.systemGray5))
                                .cornerRadius(8)
                            }
                            
                            TextField("1234567890", text: $phone)
                                .font(.system(size: 16))
                                .keyboardType(.phonePad)
                                .padding(12)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }
                    }
                    
                    SimpleField(label: "LOCATION", placeholder: "New York, NY", text: $location)
                    SimpleField(label: "LINKEDIN", placeholder: "linkedin.com/in/johndoe", text: $linkedin)
                    SimpleField(label: "GITHUB", placeholder: "github.com/johndoe", text: $github)
                }
                
                // 03 - Education
                FormSection(number: "03", title: "Education") {
                    VStack(spacing: 14) {
                        ForEach($educationList) { $edu in
                            EducationCard(education: $edu) {
                                educationList.removeAll { $0.id == edu.id }
                            }
                        }
                        
                        // Add Education Button with Type Selection
                        Menu {
                            ForEach(EducationType.allCases, id: \.self) { type in
                                Button {
                                    educationList.append(EducationInput(type: type))
                                } label: {
                                    Label(type.rawValue, systemImage: educationIcon(for: type))
                                }
                            }
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "plus")
                                    .font(.system(size: 13, weight: .semibold))
                                Text("Add Education")
                                    .font(.system(size: 14, weight: .medium))
                            }
                            .foregroundColor(.primary)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemGray5))
                            .cornerRadius(8)
                        }
                    }
                }
                
                // 04 - Skills
                FormSection(number: "04", title: "Skills") {
                    SkillsSelectorView(
                        selectedSkills: $selectedSkills,
                        customSkillText: $customSkillText,
                        selectedCategory: $selectedCategory
                    )
                }
                
                // 05 - Experience
                FormSection(number: "05", title: "Experience") {
                    VStack(spacing: 14) {
                        ForEach($experiences) { $exp in
                            ExperienceCard(experience: $exp) {
                                experiences.removeAll { $0.id == exp.id }
                            }
                        }
                        
                        AddButton(text: "Add Experience") {
                            experiences.append(ExperienceInput())
                        }
                    }
                }
                
                // 06 - Projects
                FormSection(number: "06", title: "Projects") {
                    VStack(spacing: 14) {
                        ForEach($projects) { $proj in
                            ProjectCard(project: $proj) {
                                projects.removeAll { $0.id == proj.id }
                            }
                        }
                        
                        AddButton(text: "Add Project") {
                            projects.append(ProjectInput())
                        }
                    }
                }
                
                // Review Button
                NavigationLink {
                    let resume = buildResume()
                    ResumeAnalysisView(resume: resume)
                } label: {
                    HStack {
                        Text("Review Resume")
                            .font(.system(size: 17, weight: .semibold))
                        Spacer()
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(Color.black)
                    .cornerRadius(10)
                }
                .padding(.top, 8)
            }
            .padding(20)
        } // End ScrollView
        .background(Color(.systemGroupedBackground))
        .navigationTitle(existingResumeId != nil ? "Edit Resume" : "Resume Builder")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
             ToolbarItem(placement: .topBarTrailing) {
                 Button("Save") {
                     let resume = buildResume()
                     resumeManager.save(resume: resume)
                     dismiss()
                 }
                 .fontWeight(.bold)
             }
         }
        .sheet(isPresented: $showCountryPicker) {
            CountryPickerView(selectedCountry: $selectedCountryCode, isPresented: $showCountryPicker)
        }
        .onAppear {
            loadExistingResume()
        }
    }
    
    func educationIcon(for type: EducationType) -> String {
        switch type {
        case .classX, .classXII: return "building.columns"
        case .diploma: return "scroll"
        case .degree: return "graduationcap"
        case .postgraduate: return "book.closed"
        }
    }
    
    func buildResume() -> Resume {
        var skillsDict: [SkillCategory: [String]] = [:]
        for (category, skills) in selectedSkills {
            if !skills.isEmpty {
                skillsDict[category] = Array(skills).sorted()
            }
        }
        
        return Resume(
            id: existingResumeId ?? UUID(),
            firstName: firstName,
            lastName: lastName,
            email: email,
            countryCode: selectedCountryCode,
            phone: phone,
            location: location,
            linkedin: linkedin,
            github: github,
            education: educationList.compactMap { edu -> Education? in
                guard !edu.institution.isEmpty else { return nil }
                return Education(
                    type: edu.type,
                    institution: edu.institution,
                    degree: edu.degree,
                    field: edu.field,
                    year: edu.year,
                    score: edu.score
                )
            },
            skills: skillsDict,
            experience: experiences.compactMap { exp -> Experience? in
                guard !exp.title.isEmpty else { return nil }
                return Experience(
                    title: exp.title,
                    company: exp.company,
                    duration: exp.duration,
                    bullets: exp.bullets.split(separator: "\n").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
                )
            },
            projects: projects.compactMap { proj -> Project? in
                guard !proj.name.isEmpty else { return nil }
                return Project(
                    name: proj.name,
                    link: proj.link,
                    tools: proj.tools,
                    bullets: proj.bullets.split(separator: "\n").map { $0.trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
                )
            }
        )
    }
}

// MARK: - Education Card (Updated)

struct EducationCard: View {
    @Binding var education: EducationInput
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with type badge
            HStack {
                Text(education.type.displayName.uppercased())
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(badgeColor)
                    .cornerRadius(4)
                
                Spacer()
                
                Button(action: onDelete) {
                    Image(systemName: "xmark")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.secondary)
                }
            }
            
            // Institution
            TextField(education.type.schoolLabel, text: $education.institution)
                .font(.system(size: 15, weight: .medium))
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(6)
            
            // Degree (only for college types)
            if let degreeLabel = education.type.degreeLabel {
                TextField(degreeLabel, text: $education.degree)
                    .font(.system(size: 14))
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(6)
            }
            
            // Field of Study (only for college types)
            if education.type.fieldLabel != nil {
                TextField("Field of Study (e.g., Computer Science)", text: $education.field)
                    .font(.system(size: 14))
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(6)
            }
            
            HStack(spacing: 10) {
                // Year
                VStack(alignment: .leading, spacing: 4) {
                    Text("YEAR")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.secondary)
                        .tracking(0.5)
                    TextField("2020 - 2024", text: $education.year)
                        .font(.system(size: 14))
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(6)
                }
                
                // Score
                VStack(alignment: .leading, spacing: 4) {
                    Text(education.type.scoreLabel.uppercased())
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.secondary)
                        .tracking(0.5)
                    TextField(education.type.scorePlaceholder, text: $education.score)
                        .font(.system(size: 14))
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(6)
                        .keyboardType(.decimalPad)
                }
            }
        }
        .padding(14)
        .background(Color(.systemGray6).opacity(0.5))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(badgeColor.opacity(0.5), lineWidth: 1)
        )
    }
    
    var badgeColor: Color {
        switch education.type {
        case .classX: return .orange
        case .classXII: return .purple
        case .diploma: return .green
        case .degree: return .blue
        case .postgraduate: return .red
        }
    }
}

// MARK: - Skills Selector

struct SkillsSelectorView: View {
    @Binding var selectedSkills: [SkillCategory: Set<String>]
    @Binding var customSkillText: String
    @Binding var selectedCategory: SkillCategory
    
    var totalSkillsCount: Int {
        selectedSkills.values.reduce(0) { $0 + $1.count }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            if totalSkillsCount > 0 {
                VStack(alignment: .leading, spacing: 8) {
                    Text("SELECTED (\(totalSkillsCount))")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.secondary)
                        .tracking(1)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(SkillCategory.allCases) { category in
                                ForEach(Array(selectedSkills[category] ?? []).sorted(), id: \.self) { skill in
                                    SelectedSkillChip(skill: skill) {
                                        selectedSkills[category]?.remove(skill)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.bottom, 8)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(SkillCategory.allCases) { category in
                        CategoryTab(
                            category: category,
                            isSelected: selectedCategory == category,
                            count: selectedSkills[category]?.count ?? 0
                        ) {
                            selectedCategory = category
                        }
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 12) {
                if selectedCategory == .other || selectedCategory.predefinedSkills.isEmpty {
                    CustomSkillInput(
                        text: $customSkillText,
                        onAdd: { skill in
                            if selectedSkills[selectedCategory] == nil {
                                selectedSkills[selectedCategory] = []
                            }
                            selectedSkills[selectedCategory]?.insert(skill)
                            customSkillText = ""
                        }
                    )
                } else {
                    SkillsGrid(
                        skills: selectedCategory.predefinedSkills,
                        selectedSkills: selectedSkills[selectedCategory] ?? [],
                        onToggle: { skill in
                            if selectedSkills[selectedCategory] == nil {
                                selectedSkills[selectedCategory] = []
                            }
                            if selectedSkills[selectedCategory]?.contains(skill) == true {
                                selectedSkills[selectedCategory]?.remove(skill)
                            } else {
                                selectedSkills[selectedCategory]?.insert(skill)
                            }
                        }
                    )
                    
                    CustomSkillInput(
                        text: $customSkillText,
                        placeholder: "Add custom \(selectedCategory.rawValue.lowercased()) skill",
                        onAdd: { skill in
                            if selectedSkills[selectedCategory] == nil {
                                selectedSkills[selectedCategory] = []
                            }
                            selectedSkills[selectedCategory]?.insert(skill)
                            customSkillText = ""
                        }
                    )
                }
            }
            .padding(14)
            .background(Color(.systemGray6).opacity(0.5))
            .cornerRadius(10)
        }
    }
}

struct CategoryTab: View {
    let category: SkillCategory
    let isSelected: Bool
    let count: Int
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: category.icon)
                    .font(.system(size: 12))
                Text(category.rawValue)
                    .font(.system(size: 13, weight: .medium))
                if count > 0 {
                    Text("\(count)")
                        .font(.system(size: 11, weight: .bold))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(isSelected ? Color.white.opacity(0.3) : Color.black.opacity(0.1))
                        .cornerRadius(10)
                }
            }
            .foregroundColor(isSelected ? .white : .primary)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(isSelected ? Color.black : Color(.systemGray5))
            .cornerRadius(20)
        }
    }
}

struct SkillsGrid: View {
    let skills: [String]
    let selectedSkills: Set<String>
    let onToggle: (String) -> Void
    
    let columns = [
        GridItem(.adaptive(minimum: 80), spacing: 8)
    ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(skills, id: \.self) { skill in
                SkillChip(
                    skill: skill,
                    isSelected: selectedSkills.contains(skill),
                    onTap: { onToggle(skill) }
                )
            }
        }
    }
}

struct SkillChip: View {
    let skill: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Text(skill)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(isSelected ? .white : Color(.label))
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .background(isSelected ? Color.blue : Color(.systemGray5))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isSelected ? Color.clear : Color(.systemGray4), lineWidth: 1)
                )
        }
    }
}

struct SelectedSkillChip: View {
    let skill: String
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 6) {
            Text(skill)
                .font(.system(size: 13, weight: .medium))
            Button(action: onRemove) {
                Image(systemName: "xmark")
                    .font(.system(size: 10, weight: .bold))
            }
        }
        .foregroundColor(.white)
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.blue)
        .cornerRadius(20)
    }
}

struct CustomSkillInput: View {
    @Binding var text: String
    var placeholder: String = "Type a custom skill"
    let onAdd: (String) -> Void
    
    var body: some View {
        HStack(spacing: 10) {
            TextField(placeholder, text: $text)
                .font(.system(size: 14))
                .padding(10)
                .background(Color(.systemGray5))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
            
            Button {
                let trimmed = text.trimmingCharacters(in: .whitespaces)
                if !trimmed.isEmpty {
                    onAdd(trimmed)
                }
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(12)
                    .background(text.trimmingCharacters(in: .whitespaces).isEmpty ? Color.gray : Color.blue)
                    .cornerRadius(8)
            }
            .disabled(text.trimmingCharacters(in: .whitespaces).isEmpty)
        }
    }
}

// MARK: - Country Picker

struct CountryPickerView: View {
    @Binding var selectedCountry: CountryCode
    @Binding var isPresented: Bool
    @State private var searchText = ""
    
    var filteredCountries: [CountryCode] {
        if searchText.isEmpty {
            return CountryCode.all
        }
        return CountryCode.all.filter {
            $0.name.lowercased().contains(searchText.lowercased()) ||
            $0.dialCode.contains(searchText) ||
            $0.code.lowercased().contains(searchText.lowercased())
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredCountries) { country in
                    Button {
                        selectedCountry = country
                        isPresented = false
                    } label: {
                        HStack(spacing: 12) {
                            Text(country.flag)
                                .font(.system(size: 28))
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(country.name)
                                    .font(.system(size: 16))
                                    .foregroundColor(.primary)
                                Text(country.dialCode)
                                    .font(.system(size: 13))
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            if country.code == selectedCountry.code {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .searchable(text: $searchText, prompt: "Search country")
            .navigationTitle("Select Country")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        isPresented = false
                    }
                }
            }
        }
    }
}

// MARK: - Input Models

struct EducationInput: Identifiable {
    let id = UUID()
    var type: EducationType = .degree
    var institution = ""
    var degree = ""
    var field = ""
    var year = ""
    var score = ""
}

struct ExperienceInput: Identifiable {
    let id = UUID()
    var title = ""
    var company = ""
    var duration = ""
    var bullets = ""
}

struct ProjectInput: Identifiable {
    let id = UUID()
    var name = ""
    var link = ""
    var tools = ""
    var bullets = ""
}

// MARK: - Cards

struct ExperienceCard: View {
    @Binding var experience: ExperienceInput
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("EXPERIENCE")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.secondary)
                    .tracking(1)
                Spacer()
                Button(action: onDelete) {
                    Image(systemName: "xmark")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.secondary)
                }
            }
            
            TextField("Job Title", text: $experience.title)
                .font(.system(size: 15, weight: .medium))
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(6)
            
            HStack(spacing: 10) {
                TextField("Company", text: $experience.company)
                    .font(.system(size: 14))
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(6)
                
                TextField("Jan 2023 - Present", text: $experience.duration)
                    .font(.system(size: 14))
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(6)
                    .frame(width: 150)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("BULLET POINTS (ONE PER LINE)")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.secondary)
                    .tracking(0.5)
                
                TextEditor(text: $experience.bullets)
                    .font(.system(size: 14))
                    .frame(minHeight: 70)
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(6)
            }
            
            Text("Use action verbs: Developed, Designed, Led...")
                .font(.system(size: 11))
                .foregroundColor(.secondary)
        }
        .padding(14)
        .background(Color(.systemGray6).opacity(0.5))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
    }
}

struct ProjectCard: View {
    @Binding var project: ProjectInput
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("PROJECT")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.secondary)
                    .tracking(1)
                Spacer()
                Button(action: onDelete) {
                    Image(systemName: "xmark")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.secondary)
                }
            }
            
            TextField("Project Name", text: $project.name)
                .font(.system(size: 15, weight: .medium))
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(6)
            
            TextField("Link (optional)", text: $project.link)
                .font(.system(size: 14))
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(6)
                .keyboardType(.URL)
                .autocapitalization(.none)
            
            TextField("Technologies used", text: $project.tools)
                .font(.system(size: 14))
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(6)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("BULLET POINTS (ONE PER LINE)")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.secondary)
                    .tracking(0.5)
                
                TextEditor(text: $project.bullets)
                    .font(.system(size: 14))
                    .frame(minHeight: 70)
                    .padding(8)
                    .background(Color(.systemGray6))
                    .cornerRadius(6)
            }
            
            Text("Use action verbs: Built, Created, Deployed...")
                .font(.system(size: 11))
                .foregroundColor(.secondary)
        }
        .padding(14)
        .background(Color(.systemGray6).opacity(0.5))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
    }
}

// MARK: - Components

struct FormSection<Content: View>: View {
    let number: String
    let title: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Text(number)
                    .font(.system(size: 12, weight: .medium, design: .monospaced))
                    .foregroundColor(.secondary)
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
            }
            
            VStack(alignment: .leading, spacing: 12) {
                content
            }
            .padding(16)
            .background(Color(.systemBackground))
            .cornerRadius(12)
        }
    }
}

struct SimpleField: View {
    let label: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.secondary)
                .tracking(0.5)
            
            TextField(placeholder, text: $text)
                .font(.system(size: 16))
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(8)
        }
    }
}

struct AddButton: View {
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: "plus")
                    .font(.system(size: 13, weight: .semibold))
                Text(text)
                    .font(.system(size: 14, weight: .medium))
            }
            .foregroundColor(.primary)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(Color(.systemGray5))
            .cornerRadius(8)
        }
    }
}
