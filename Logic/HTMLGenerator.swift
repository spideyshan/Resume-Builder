import Foundation

struct HTMLGenerator {
    
    static func generateHTML(for resume: Resume, template: ResumeTemplate) -> String {
        let css = templateCSS(for: template)
        let body = templateBody(for: resume, template: template)
        
        return """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="UTF-8">
            <style>
                \(css)
            </style>
        </head>
        <body>
            \(body)
        </body>
        </html>
        """
    }
    
    // MARK: - CSS Generation
    
    private static func templateCSS(for template: ResumeTemplate) -> String {
        switch template {
        case .classic:
            return """
                body { font-family: 'Times New Roman', serif; color: #000; padding: 40px; }
                h1 { font-size: 28px; font-weight: 700; letter-spacing: 3px; color: #336699; margin-bottom: 5px; text-transform: uppercase; }
                .contact-info { font-size: 11px; color: #666; margin-bottom: 20px; }
                .contact-info a { color: #000; text-decoration: none; margin-right: 15px; }
                .divider { height: 2px; background-color: #336699; margin-bottom: 20px; }
                .section-title { font-size: 13px; font-weight: 700; letter-spacing: 2px; color: #336699; margin-bottom: 10px; margin-top: 20px; text-transform: uppercase; }
                .entry { margin-bottom: 12px; }
                .entry-header { display: flex; justify-content: space-between; align-items: flex-start; width: 100%; gap: 20px; }
                .title { font-size: 14px; font-weight: 600; }
                .title a { font-weight: inherit; text-decoration: none; color: #000; }
                .subtitle { font-size: 12px; color: #666; }
                .date { font-size: 11px; color: #666; text-align: right; white-space: nowrap; }
                .cert-date { font-size: 11px; color: #666; margin-top: 2px; }
                .highlight { color: #336699; font-weight: 500; }
                ul { list-style-type: disc; margin: 5px 0 0 15px; padding: 0; }
                li { font-size: 12px; margin-bottom: 2px; line-height: 1.4; }
                .skills-container { display: flex; flex-wrap: wrap; gap: 6px; }
                .skill-tag { font-size: 11px; padding: 4px 8px; border: 1px solid #ccc; border-radius: 4px; }
                a { color: #000; text-decoration: none; }
            """
        case .simple:
            return """
                body { font-family: -apple-system, BlinkMacSystemFont, sans-serif; color: #000; padding: 40px; }
                h1 { font-size: 28px; font-weight: 700; text-align: center; margin-bottom: 5px; }
                .contact-info { font-size: 11px; color: #666; text-align: center; margin-bottom: 20px; }
                .contact-info span { margin: 0 5px; }
                .contact-info a { color: #000; text-decoration: none; font-weight: 500; }
                .section-title { font-size: 16px; font-weight: 700; border-bottom: 1px solid #000; padding-bottom: 4px; margin-bottom: 10px; margin-top: 20px; }
                .entry { margin-bottom: 12px; }
                .entry-header { display: flex; justify-content: space-between; align-items: flex-start; width: 100%; gap: 20px; }
                .title { font-size: 14px; font-weight: 600; }
                .title a { font-weight: inherit; text-decoration: none; color: #000; }
                .subtitle { font-size: 13px; font-style: italic; }
                .date { font-size: 11px; color: #666; text-align: right; white-space: nowrap; }
                .cert-date { font-size: 11px; color: #666; margin-top: 2px; }
                ul { list-style-type: disc; margin: 5px 0 0 15px; padding: 0; }
                li { font-size: 12px; margin-bottom: 2px; }
                .skill-row { margin-bottom: 4px; font-size: 13px; }
                .skill-label { font-weight: 600; }
                a { color: #000; text-decoration: none; }
            """
        case .modern:
            return """
                body { font-family: -apple-system, BlinkMacSystemFont, sans-serif; color: #000; margin: 0; padding: 0; }
                .header { background: linear-gradient(to bottom, #d8f5f5, #ffffff); padding: 30px 40px; display: flex; justify-content: space-between; align-items: flex-start; }
                h1 { font-size: 36px; font-weight: 300; margin: 0; color: #268c8c; }
                .contact-stack { text-align: right; font-size: 11px; color: #666; }
                .contact-stack div { margin-bottom: 4px; }
                .contact-stack a { color: #000; text-decoration: none; font-weight: 600; margin-left: 10px; }
                .content { padding: 20px 40px; }
                .section-title { font-size: 12px; font-weight: 700; letter-spacing: 1.5px; color: #268c8c; margin-bottom: 10px; margin-top: 20px; text-transform: uppercase; border-left: 3px solid #268c8c; padding-left: 8px; }
                .entry { margin-bottom: 15px; }
                .entry-header { display: flex; justify-content: space-between; align-items: flex-start; width: 100%; gap: 20px; margin-bottom: 2px; }
                .title { font-size: 15px; font-weight: 600; }
                .title a { font-weight: inherit; text-decoration: none; color: #000; }
                .subtitle { font-size: 12px; color: #268c8c; }
                .date-badge { font-size: 11px; background-color: #d8f5f5; padding: 4px 8px; border-radius: 4px; white-space: nowrap; }
                .bullet { display: flex; align-items: flex-start; margin-bottom: 2px; }
                .bullet-arrow { color: #268c8c; font-size: 10px; margin-right: 6px; margin-top: 3px; }
                .bullet-text { font-size: 12px; }
                a { color: #000; text-decoration: none; }
            """
        }
    }
    
    // MARK: - HTML Body Generation
    
    private static func templateBody(for resume: Resume, template: ResumeTemplate) -> String {
        switch template {
        case .classic:
            return classicBody(resume)
        case .simple:
            return simpleBody(resume)
        case .modern:
            return modernBody(resume)
        }
    }
    
    // MARK: - Classic Template
    
    private static func classicBody(_ resume: Resume) -> String {
        var html = "<div>"
        
        // Header
        html += "<div style='display: flex; justify-content: space-between; align-items: flex-start;'>"
        html += "<div><h1>\(resume.fullName.uppercased())</h1>"
        
        var contacts: [String] = []
        if !resume.phone.isEmpty { contacts.append("📞 \(resume.fullPhone)") }
        if !resume.email.isEmpty { contacts.append("✉️ \(resume.email)") }
        if !resume.location.isEmpty { contacts.append("📍 \(resume.location)") }
        if let linkedin = resume.linkedinURL { contacts.append("<a href='\(linkedin.absoluteString)'>🔗 LinkedIn</a>") }
        if let github = resume.githubURL { contacts.append("<a href='\(github.absoluteString)'>💻 GitHub</a>") }
        
        html += "<div class='contact-info'>\(contacts.joined(separator: "&nbsp;&nbsp;&nbsp;"))</div></div>"
        
        if let photoData = resume.photoData {
            let base64 = photoData.base64EncodedString()
            html += "<img src='data:image/jpeg;base64,\(base64)' style='width: 80px; height: 80px; border-radius: 50%; object-fit: cover; border: 1px solid #ccc;'>"
        }
        html += "</div>"
        html += "<div class='divider'></div>"
        
        // Education
        if !resume.education.isEmpty {
            html += "<div class='section-title'>EDUCATION</div>"
            for edu in resume.education {
                html += """
                <div class='entry'>
                    <div class='entry-header'>
                        <div>
                            <div class='title'>\(edu.displayTitle)</div>
                            <div class='subtitle'>\(edu.institution)</div>
                        </div>
                        <div style='text-align: right;'>
                            <div class='date'>\(edu.year)</div>
                            <div class='highlight'>\(edu.formattedScore)</div>
                        </div>
                    </div>
                </div>
                """
            }
        }
        
        // Experience
        if !resume.experience.isEmpty {
            html += "<div class='section-title'>EXPERIENCE</div>"
            for exp in resume.experience {
                html += """
                <div class='entry'>
                    <div class='entry-header'>
                        <div>
                            <div class='title'>\(exp.title)</div>
                            <div class='subtitle' style='color: #336699;'>\(exp.company)</div>
                        </div>
                        <div class='date'>\(exp.duration)</div>
                    </div>
                    <ul>
                        \(exp.bullets.map { "<li>\($0)</li>" }.joined())
                    </ul>
                </div>
                """
            }
        }
        
        // Projects
        if !resume.projects.isEmpty {
            html += "<div class='section-title'>PROJECTS</div>"
            for project in resume.projects {
                let nameHtml = project.hasValidLink && project.url != nil ? "<a href='\(project.url!.absoluteString)'>\(project.name)</a>" : project.name
                html += """
                <div class='entry'>
                    <div class='entry-header'>
                        <div class='title'>\(nameHtml)</div>
                        \(!project.tools.isEmpty ? "<div class='date' style='background:#f2f2f7; padding:2px 6px; border-radius:4px;'>\(project.tools)</div>" : "")
                    </div>
                    <ul>
                        \(project.bullets.map { "<li>\($0)</li>" }.joined())
                    </ul>
                </div>
                """
            }
        }
        
        // Certifications
        if let certs = resume.certifications, !certs.isEmpty {
            html += "<div class='section-title'>CERTIFICATIONS</div>"
            for cert in certs {
                let nameHtml = cert.hasValidLink && cert.url != nil ? "<a href='\(cert.url!.absoluteString)'>\(cert.name)</a>" : cert.name
                html += """
                <div class='entry'>
                    <div>
                        <div class='title' style='font-weight: 500;'>\(nameHtml)</div>
                        <div class='subtitle'>\(cert.issuer)</div>
                        <div class='cert-date'>Issued: \(cert.issueDate) \(cert.expiryDate.isEmpty ? "" : "• Expires: " + cert.expiryDate)</div>
                    </div>
                </div>
                """
            }
        }
        
        // Skills
        if !resume.skills.isEmpty {
            html += "<div class='section-title'>SKILLS</div>"
            for category in SkillCategory.allCases {
                if let skills = resume.skills[category], !skills.isEmpty {
                    html += """
                    <div style='margin-bottom: 8px;'>
                        <div class='subtitle' style='color:#336699; font-weight:bold; font-size:11px; margin-bottom:4px;'>\(category.rawValue)</div>
                        <div class='skills-container'>
                            \(skills.map { "<span class='skill-tag'>\($0)</span>" }.joined())
                        </div>
                    </div>
                    """
                }
            }
        }
        
        html += "</div>"
        return html
    }
    
    // MARK: - Simple Template
    
    private static func simpleBody(_ resume: Resume) -> String {
        var html = "<div>"
        
        // Header
        if let photoData = resume.photoData {
            let base64 = photoData.base64EncodedString()
            html += "<div style='text-align: center; margin-bottom: 10px;'><img src='data:image/jpeg;base64,\(base64)' style='width: 90px; height: 90px; border-radius: 50%; object-fit: cover; border: 1px solid #eee;'></div>"
        }
        html += "<h1>\(resume.fullName)</h1>"
        
        let items = [resume.location, resume.fullPhone, resume.email].filter { !$0.isEmpty }
        html += "<div class='contact-info'>\(items.joined(separator: " &bull; "))</div>"
        
        var links: [String] = []
        if let linkedin = resume.linkedinURL { links.append("<a href='\(linkedin.absoluteString)'>LinkedIn</a>") }
        if let github = resume.githubURL { links.append("<a href='\(github.absoluteString)'>GitHub</a>") }
        if !links.isEmpty {
            html += "<div class='contact-info'>\(links.joined(separator: "&nbsp;&nbsp;&nbsp;&nbsp;"))</div>"
        }
        
        // Certifications (Top for Simple)
        if let certs = resume.certifications, !certs.isEmpty {
            html += "<div class='section-title'>Certifications</div>"
            for cert in certs {
                let nameHtml = cert.hasValidLink && cert.url != nil ? "<a href='\(cert.url!.absoluteString)'>\(cert.name)</a>" : cert.name
                html += """
                <div class='entry'>
                    <div>
                        <div class='title' style='font-size:13px; font-weight: 500;'>\(nameHtml)</div>
                        <div class='subtitle' style='font-size:12px; color:gray;'>\(cert.issuer)</div>
                        <div class='cert-date' style='font-size:10px;'>Issued: \(cert.issueDate) \(cert.expiryDate.isEmpty ? "" : "- " + cert.expiryDate)</div>
                    </div>
                </div>
                """
            }
        }
        
        // Skills
        if !resume.skills.isEmpty {
            html += "<div class='section-title'>Skills</div>"
            for category in SkillCategory.allCases {
                if let skills = resume.skills[category], !skills.isEmpty {
                    html += """
                    <div class='skill-row'>
                        <span class='skill-label'>• \(category.rawValue): </span>
                        <span>\(skills.joined(separator: ", "))</span>
                    </div>
                    """
                }
            }
        }
        
        // Experience
        if !resume.experience.isEmpty {
            html += "<div class='section-title'>Experience</div>"
            for exp in resume.experience {
                html += """
                <div class='entry'>
                    <div class='entry-header'>
                        <div>
                            <div class='title'>\(exp.company)</div>
                            <div class='subtitle'>\(exp.title)</div>
                        </div>
                        <div class='date'>\(exp.duration)</div>
                    </div>
                    \(exp.bullets.map { "<div style='font-size:12px; margin-left:8px;'>\( $0 )</div>" }.joined())
                </div>
                """
            }
        }
        
        // Projects
        if !resume.projects.isEmpty {
            html += "<div class='section-title'>Projects</div>"
            for project in resume.projects {
                let nameHtml = project.hasValidLink && project.url != nil ? "<a href='\(project.url!.absoluteString)'>\(project.name)</a>" : project.name
                html += """
                <div class='entry'>
                    <div class='entry-header'>
                        <div>
                            <span class='title'>\(nameHtml)</span>
                            \(!project.tools.isEmpty ? "<span class='date'>(\(project.tools))</span>" : "")
                        </div>
                    </div>
                    \(project.bullets.map { "<div style='font-size:12px;'>• \( $0 )</div>" }.joined())
                </div>
                """
            }
        }
        
        // Education
        if !resume.education.isEmpty {
            html += "<div class='section-title'>Education</div>"
            for edu in resume.education {
                html += """
                <div class='entry'>
                    <div class='entry-header'>
                        <div>
                            <div class='title' style='font-size:13px;'>\(edu.displayTitle)</div>
                            <div class='subtitle' style='font-size:12px; color:gray;'>\(edu.institution)</div>
                        </div>
                        <div style='text-align: right;'>
                            <div class='date'>\(edu.year)</div>
                            <div class='date'>\(edu.formattedScore)</div>
                        </div>
                    </div>
                </div>
                """
            }
        }
        
        html += "</div>"
        return html
    }
    
    // MARK: - Modern Template
    
    private static func modernBody(_ resume: Resume) -> String {
        var html = ""
        
        // Header
        let names = resume.fullName.split(separator: " ").map(String.init)
        let nameHtml = names.map { "<div>\($0)</div>" }.joined()
        
        var contactHtml = ""
        if !resume.email.isEmpty { contactHtml += "<div>\(resume.email) ✉️</div>" }
        if !resume.phone.isEmpty { contactHtml += "<div>\(resume.fullPhone) 📞</div>" }
        if !resume.location.isEmpty { contactHtml += "<div>\(resume.location) 📍</div>" }
        
        var linksHtml = ""
        if let linkedin = resume.linkedinURL { linksHtml += "<a href='\(linkedin.absoluteString)'>LinkedIn</a>" }
        if let github = resume.githubURL { linksHtml += "<a href='\(github.absoluteString)'>GitHub</a>" }
        if !linksHtml.isEmpty { contactHtml += "<div style='margin-top:4px;'>\(linksHtml)</div>" }
        
        html += """
        <div class='header'>
            <div style='display:flex; align-items:center; gap: 20px;'>
                 \(resume.photoData != nil ? "<img src='data:image/jpeg;base64,\(resume.photoData!.base64EncodedString())' style='width: 85px; height: 85px; border-radius: 12px; object-fit: cover; border: 1px solid #d8f5f5;'>" : "")
                 <div style='font-size: 36px; font-weight: 300; color: #268c8c;'>\(nameHtml)</div>
            </div>
            <div class='contact-stack'>\(contactHtml)</div>
        </div>
        <div class='content'>
        """
        
        // Experience
        if !resume.experience.isEmpty {
            html += "<div class='section-title'>EXPERIENCE</div>"
            for exp in resume.experience {
                html += """
                <div class='entry'>
                    <div class='entry-header'>
                        <div>
                            <div class='title'>\(exp.title)</div>
                            <div class='subtitle'>\(exp.company)</div>
                        </div>
                        <div class='date-badge'>\(exp.duration)</div>
                    </div>
                    \(exp.bullets.map { """
                    <div class='bullet'>
                        <span class='bullet-arrow'>➔</span>
                        <span class='bullet-text'>\($0)</span>
                    </div>
                    """ }.joined())
                </div>
                """
            }
        }
        
        // Projects
        if !resume.projects.isEmpty {
            html += "<div class='section-title'>PROJECTS</div>"
            for project in resume.projects {
                let nameHtml = project.hasValidLink && project.url != nil ? "<a href='\(project.url!.absoluteString)'>\(project.name)</a>" : project.name
                html += """
                <div class='entry'>
                    <div class='entry-header'>
                        <div>
                            <span class='title'>\(nameHtml)</span>
                        </div>
                         \(!project.tools.isEmpty ? "<div class='date-badge' style='background:#f2f2f7; color:#268c8c;'>\(project.tools)</div>" : "")
                    </div>
                    \(project.bullets.map { """
                    <div class='bullet'>
                        <span class='bullet-arrow'>➔</span>
                        <span class='bullet-text'>\($0)</span>
                    </div>
                    """ }.joined())
                </div>
                """
            }
        }
        
        // Certifications
        if let certs = resume.certifications, !certs.isEmpty {
            html += "<div class='section-title'>CERTIFICATIONS</div>"
            for cert in certs {
                let nameHtml = cert.hasValidLink && cert.url != nil ? "<a href='\(cert.url!.absoluteString)'>\(cert.name)</a>" : cert.name
                html += """
                <div class='entry'>
                    <div>
                        <div class='title' style='font-size:13px; font-weight: 500;'>\(nameHtml)</div>
                        <div class='subtitle'>\(cert.issuer)</div>
                        <div class='cert-date' style='color:#268c8c;'>Issued: \(cert.issueDate) \(cert.expiryDate.isEmpty ? "" : "→ " + cert.expiryDate)</div>
                    </div>
                </div>
                """
            }
        }
        
        // Bottom Row (Education + Skills)
        html += "<div style='display: flex; gap: 30px; margin-top: 20px;'>"
        
        // Education
        if !resume.education.isEmpty {
            html += "<div style='flex: 1;'>"
            html += "<div class='section-title' style='margin-top:0;'>EDUCATION</div>"
            for edu in resume.education {
                html += """
                <div style='margin-bottom: 10px;'>
                    <div class='title' style='font-size:13px;'>\(edu.displayTitle)</div>
                    <div class='subtitle' style='font-size:11px; color:#666;'>\(edu.institution)</div>
                    <div style='font-size:10px; color:#268c8c; margin-top:2px;'>
                        \(edu.year) \(edu.formattedScore.isEmpty ? "" : "• " + edu.formattedScore)
                    </div>
                </div>
                """
            }
            html += "</div>"
        }
        
        // Skills
        if !resume.skills.isEmpty {
            html += "<div style='flex: 1;'>"
            html += "<div class='section-title' style='margin-top:0;'>SKILLS</div>"
            for category in SkillCategory.allCases {
                if let skills = resume.skills[category], !skills.isEmpty {
                    html += """
                    <div style='margin-bottom: 6px;'>
                        <div style='font-size:10px; font-weight:bold; color:#666;'>\(category.rawValue)</div>
                        <div style='font-size:11px;'>\(skills.joined(separator: " • "))</div>
                    </div>
                    """
                }
            }
            html += "</div>"
        }
        
        html += "</div></div>" // Close flex and content
        return html
    }
}
