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
            <meta name="viewport" content="width=612, initial-scale=1.0">
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
                * { margin: 0; padding: 0; box-sizing: border-box; }
                body { font-family: 'Georgia', 'Times New Roman', serif; color: #2d2d2d; padding: 36px 40px; font-size: 12px; line-height: 1.4; }
                .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px; }
                .header-left { flex: 1; }
                h1 { font-size: 26px; font-weight: 700; letter-spacing: 3px; color: #2c5282; margin-bottom: 6px; text-transform: uppercase; }
                .contact-line { font-size: 11px; color: #555; line-height: 1.6; }
                .contact-line a { color: #2c5282; text-decoration: none; }
                .photo { width: 72px; height: 72px; border-radius: 50%; object-fit: cover; border: 2px solid #e2e8f0; margin-left: 16px; }
                .divider { height: 2px; background: linear-gradient(to right, #2c5282, #a0aec0); margin-bottom: 16px; }
                .summary { font-size: 11px; color: #555; line-height: 1.6; margin-bottom: 16px; }
                .section-title { font-size: 12px; font-weight: 700; letter-spacing: 2px; color: #2c5282; margin: 16px 0 8px; text-transform: uppercase; border-bottom: 1px solid #e2e8f0; padding-bottom: 3px; }
                .entry { margin-bottom: 10px; }
                .entry-header { display: flex; justify-content: space-between; align-items: baseline; }
                .title { font-size: 13px; font-weight: 700; color: #1a202c; }
                .title a { color: #1a202c; text-decoration: none; }
                .subtitle { font-size: 11px; color: #2c5282; }
                .date { font-size: 10px; color: #718096; white-space: nowrap; }
                .highlight { font-size: 10px; color: #2c5282; font-weight: 600; }
                .cert-date { font-size: 10px; color: #718096; margin-top: 1px; }
                ul { margin: 4px 0 0 16px; padding: 0; }
                li { font-size: 11px; margin-bottom: 2px; line-height: 1.4; color: #2d2d2d; }
                .skills-container { display: flex; flex-wrap: wrap; gap: 5px; }
                .skill-tag { font-size: 10px; padding: 3px 8px; border: 1px solid #cbd5e0; border-radius: 3px; color: #2d3748; background: #f7fafc; }
                a { color: inherit; text-decoration: none; }
            """
        case .simple:
            return """
                * { margin: 0; padding: 0; box-sizing: border-box; }
                body { font-family: -apple-system, 'Helvetica Neue', Arial, sans-serif; color: #1a1a1a; padding: 36px 40px; font-size: 12px; line-height: 1.4; }
                h1 { font-size: 26px; font-weight: 700; text-align: center; margin-bottom: 4px; color: #1a1a1a; }
                .contact-info { font-size: 11px; color: #666; text-align: center; margin-bottom: 3px; line-height: 1.6; }
                .contact-info a { color: #333; text-decoration: none; font-weight: 500; }
                .section-title { font-size: 13px; font-weight: 700; border-bottom: 1.5px solid #1a1a1a; padding-bottom: 3px; margin: 16px 0 8px; text-transform: uppercase; letter-spacing: 0.5px; }
                .entry { margin-bottom: 10px; }
                .entry-header { display: flex; justify-content: space-between; align-items: baseline; }
                .title { font-size: 13px; font-weight: 600; }
                .title a { color: #1a1a1a; text-decoration: none; }
                .subtitle { font-size: 11px; font-style: italic; color: #555; }
                .date { font-size: 10px; color: #666; white-space: nowrap; }
                .cert-date { font-size: 10px; color: #666; margin-top: 1px; }
                ul { margin: 4px 0 0 16px; padding: 0; }
                li { font-size: 11px; margin-bottom: 2px; line-height: 1.4; }
                .skill-row { margin-bottom: 3px; font-size: 11px; }
                .skill-label { font-weight: 600; }
                .summary { font-size: 11px; color: #555; text-align: center; line-height: 1.5; margin-bottom: 12px; }
                .photo { width: 80px; height: 80px; border-radius: 50%; object-fit: cover; border: 1px solid #eee; display: block; margin: 0 auto 10px; }
                a { color: inherit; text-decoration: none; }
            """
        case .modern:
            return """
                * { margin: 0; padding: 0; box-sizing: border-box; }
                body { font-family: -apple-system, 'Helvetica Neue', Arial, sans-serif; color: #1a202c; margin: 0; padding: 0; font-size: 12px; line-height: 1.4; }
                .header { background: linear-gradient(135deg, #e6fffa 0%, #f0fff4 50%, #ffffff 100%); padding: 28px 36px; display: flex; justify-content: space-between; align-items: center; }
                .header-left { display: flex; align-items: center; gap: 16px; }
                .photo { width: 72px; height: 72px; border-radius: 10px; object-fit: cover; border: 2px solid #b2dfdb; }
                .name-block div { font-size: 32px; font-weight: 300; color: #268c8c; line-height: 1.1; }
                .contact-stack { text-align: right; font-size: 11px; color: #555; line-height: 1.8; }
                .contact-stack a { color: #268c8c; text-decoration: none; font-weight: 600; }
                .content { padding: 16px 36px 24px; }
                .summary { font-size: 11px; color: #555; line-height: 1.6; margin-bottom: 14px; }
                .section-title { font-size: 11px; font-weight: 700; letter-spacing: 1.5px; color: #268c8c; margin: 16px 0 8px; text-transform: uppercase; border-left: 3px solid #268c8c; padding-left: 8px; }
                .entry { margin-bottom: 12px; }
                .entry-header { display: flex; justify-content: space-between; align-items: baseline; margin-bottom: 2px; }
                .title { font-size: 13px; font-weight: 600; }
                .title a { color: #1a202c; text-decoration: none; }
                .subtitle { font-size: 11px; color: #268c8c; }
                .date-badge { font-size: 10px; background-color: #e6fffa; color: #234e52; padding: 2px 8px; border-radius: 3px; white-space: nowrap; }
                .cert-date { font-size: 10px; color: #268c8c; margin-top: 1px; }
                .bullet { display: flex; align-items: baseline; margin-bottom: 2px; }
                .bullet-arrow { color: #268c8c; font-size: 9px; margin-right: 6px; flex-shrink: 0; }
                .bullet-text { font-size: 11px; line-height: 1.4; }
                .two-col { display: flex; gap: 24px; margin-top: 16px; }
                .two-col > div { flex: 1; }
                .lang-tag { font-size: 11px; font-weight: 500; background: #e6fffa; padding: 3px 8px; border-radius: 3px; display: inline-block; margin: 0 4px 4px 0; }
                a { color: inherit; text-decoration: none; }
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
        html += "<div class='header'>"
        html += "<div class='header-left'>"
        html += "<h1>\(resume.fullName.uppercased())</h1>"
        
        var contactParts: [String] = []
        if !resume.phone.isEmpty { contactParts.append(resume.fullPhone) }
        if !resume.email.isEmpty { contactParts.append(resume.email) }
        if !resume.location.isEmpty { contactParts.append(resume.location) }
        if !contactParts.isEmpty {
            html += "<div class='contact-line'>\(contactParts.joined(separator: "  |  "))</div>"
        }
        
        var linkParts: [String] = []
        if let linkedin = resume.linkedinURL { linkParts.append("<a href='\(linkedin.absoluteString)'>LinkedIn</a>") }
        if let github = resume.githubURL { linkParts.append("<a href='\(github.absoluteString)'>GitHub</a>") }
        if !linkParts.isEmpty {
            html += "<div class='contact-line'>\(linkParts.joined(separator: "  |  "))</div>"
        }
        
        html += "</div>"
        
        if let photoData = resume.photoData {
            let base64 = photoData.base64EncodedString()
            html += "<img src='data:image/jpeg;base64,\(base64)' class='photo'>"
        }
        html += "</div>"
        html += "<div class='divider'></div>"
        
        // Professional Summary
        if let summary = resume.summary, !summary.isEmpty {
            html += "<div class='summary'>\(summary)</div>"
        }
        
        // Education
        if !resume.education.isEmpty {
            html += "<div class='section-title'>Education</div>"
            for edu in resume.education {
                html += """
                <div class='entry'>
                    <div class='entry-header'>
                        <div>
                            <div class='title'>\(edu.displayTitle)</div>
                            <div class='subtitle'>\(edu.institution)</div>
                        </div>
                        <div style='text-align:right;'>
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
            html += "<div class='section-title'>Experience</div>"
            for exp in resume.experience {
                html += """
                <div class='entry'>
                    <div class='entry-header'>
                        <div>
                            <div class='title'>\(exp.title)</div>
                            <div class='subtitle'>\(exp.company)</div>
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
            html += "<div class='section-title'>Projects</div>"
            for project in resume.projects {
                let nameHtml = project.hasValidLink && project.url != nil ? "<a href='\(project.url!.absoluteString)'>\(project.name)</a>" : project.name
                html += """
                <div class='entry'>
                    <div class='entry-header'>
                        <div class='title'>\(nameHtml)</div>
                        \(!project.tools.isEmpty ? "<div class='date' style='background:#f7fafc; padding:2px 6px; border-radius:3px;'>\(project.tools)</div>" : "")
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
            html += "<div class='section-title'>Certifications</div>"
            for cert in certs {
                let nameHtml = cert.hasValidLink && cert.url != nil ? "<a href='\(cert.url!.absoluteString)'>\(cert.name)</a>" : cert.name
                html += """
                <div class='entry'>
                    <div class='title' style='font-weight:500;'>\(nameHtml)</div>
                    <div class='subtitle' style='color:#555;'>\(cert.issuer)</div>
                    \(!cert.issueDate.isEmpty ? "<div class='cert-date'>Issued: \(cert.issueDate)\(cert.expiryDate.isEmpty ? "" : " - Expires: " + cert.expiryDate)</div>" : "")
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
                    <div style='margin-bottom:6px;'>
                        <div style='font-size:10px; font-weight:700; color:#2c5282; margin-bottom:3px; text-transform:uppercase; letter-spacing:0.5px;'>\(category.rawValue)</div>
                        <div class='skills-container'>
                            \(skills.map { "<span class='skill-tag'>\($0)</span>" }.joined())
                        </div>
                    </div>
                    """
                }
            }
        }
        
        // Languages
        if let langs = resume.languages, !langs.isEmpty {
            html += "<div class='section-title'>Languages</div>"
            html += "<div class='skills-container'>"
            for lang in langs {
                html += "<span class='skill-tag'>\(lang.name)</span>"
            }
            html += "</div>"
        }
        
        // Custom Sections
        if let sections = resume.customSections, !sections.isEmpty {
            for section in sections {
                if section.hasValidLink, let url = section.url {
                    html += "<div class='section-title'><a href='\(url.absoluteString)' style='color:inherit; text-decoration:none;'>\(section.title.uppercased())</a></div>"
                } else {
                    html += "<div class='section-title'>\(section.title.uppercased())</div>"
                }
                html += "<ul>"
                for bullet in section.bullets {
                    html += "<li>\(bullet)</li>"
                }
                html += "</ul>"
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
            html += "<img src='data:image/jpeg;base64,\(base64)' class='photo'>"
        }
        html += "<h1>\(resume.fullName)</h1>"
        
        let items = [resume.location, resume.fullPhone, resume.email].filter { !$0.isEmpty }
        if !items.isEmpty {
            html += "<div class='contact-info'>\(items.joined(separator: "  &bull;  "))</div>"
        }
        
        var links: [String] = []
        if let linkedin = resume.linkedinURL { links.append("<a href='\(linkedin.absoluteString)'>LinkedIn</a>") }
        if let github = resume.githubURL { links.append("<a href='\(github.absoluteString)'>GitHub</a>") }
        if !links.isEmpty {
            html += "<div class='contact-info'>\(links.joined(separator: "  &bull;  "))</div>"
        }
        
        // Professional Summary
        if let summary = resume.summary, !summary.isEmpty {
            html += "<div class='summary'>\(summary)</div>"
        }
        
        // Certifications (Top for Simple)
        if let certs = resume.certifications, !certs.isEmpty {
            html += "<div class='section-title'>Certifications</div>"
            for cert in certs {
                let nameHtml = cert.hasValidLink && cert.url != nil ? "<a href='\(cert.url!.absoluteString)'>\(cert.name)</a>" : cert.name
                html += """
                <div class='entry'>
                    <div class='title' style='font-weight:500;'>\(nameHtml)</div>
                    <div class='subtitle'>\(cert.issuer)</div>
                    \(!cert.issueDate.isEmpty ? "<div class='cert-date'>Issued: \(cert.issueDate)\(cert.expiryDate.isEmpty ? "" : " - " + cert.expiryDate)</div>" : "")
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
                        <span class='skill-label'>\(category.rawValue): </span>
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
                    <ul>
                        \(exp.bullets.map { "<li>\($0)</li>" }.joined())
                    </ul>
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
                            \(!project.tools.isEmpty ? "<span class='date' style='margin-left:8px;'>(\(project.tools))</span>" : "")
                        </div>
                    </div>
                    <ul>
                        \(project.bullets.map { "<li>\($0)</li>" }.joined())
                    </ul>
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
                            <div class='title' style='font-size:12px;'>\(edu.displayTitle)</div>
                            <div class='subtitle'>\(edu.institution)</div>
                        </div>
                        <div style='text-align:right;'>
                            <div class='date'>\(edu.year)</div>
                            \(!edu.formattedScore.isEmpty ? "<div class='date'>\(edu.formattedScore)</div>" : "")
                        </div>
                    </div>
                </div>
                """
            }
        }
        
        // Languages
        if let langs = resume.languages, !langs.isEmpty {
            html += "<div class='section-title'>Languages</div>"
            html += "<div class='skill-row'>\(langs.map { $0.name }.joined(separator: ", "))</div>"
        }
        
        // Custom Sections
        if let sections = resume.customSections, !sections.isEmpty {
            for section in sections {
                if section.hasValidLink, let url = section.url {
                    html += "<div class='section-title'><a href='\(url.absoluteString)' style='color:inherit; text-decoration:none;'>\(section.title)</a></div>"
                } else {
                    html += "<div class='section-title'>\(section.title)</div>"
                }
                html += "<ul>"
                for bullet in section.bullets {
                    html += "<li>\(bullet)</li>"
                }
                html += "</ul>"
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
        
        var contactLines: [String] = []
        if !resume.email.isEmpty { contactLines.append(resume.email) }
        if !resume.phone.isEmpty { contactLines.append(resume.fullPhone) }
        if !resume.location.isEmpty { contactLines.append(resume.location) }
        
        var contactHtml = contactLines.map { "<div>\($0)</div>" }.joined()
        
        var linksHtml = ""
        if let linkedin = resume.linkedinURL { linksHtml += "<a href='\(linkedin.absoluteString)'>LinkedIn</a>" }
        if let github = resume.githubURL {
            if !linksHtml.isEmpty { linksHtml += " &nbsp; " }
            linksHtml += "<a href='\(github.absoluteString)'>GitHub</a>"
        }
        if !linksHtml.isEmpty { contactHtml += "<div style='margin-top:2px;'>\(linksHtml)</div>" }
        
        html += """
        <div class='header'>
            <div class='header-left'>
                \(resume.photoData != nil ? "<img src='data:image/jpeg;base64,\(resume.photoData!.base64EncodedString())' class='photo'>" : "")
                <div class='name-block'>\(nameHtml)</div>
            </div>
            <div class='contact-stack'>\(contactHtml)</div>
        </div>
        <div class='content'>
        """
        
        // Professional Summary
        if let summary = resume.summary, !summary.isEmpty {
            html += "<div class='summary'>\(summary)</div>"
        }
        
        // Experience
        if !resume.experience.isEmpty {
            html += "<div class='section-title'>Experience</div>"
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
                        <span class='bullet-arrow'>&#x25B8;</span>
                        <span class='bullet-text'>\($0)</span>
                    </div>
                    """ }.joined())
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
                        <span class='title'>\(nameHtml)</span>
                        \(!project.tools.isEmpty ? "<div class='date-badge'>\(project.tools)</div>" : "")
                    </div>
                    \(project.bullets.map { """
                    <div class='bullet'>
                        <span class='bullet-arrow'>&#x25B8;</span>
                        <span class='bullet-text'>\($0)</span>
                    </div>
                    """ }.joined())
                </div>
                """
            }
        }
        
        // Certifications
        if let certs = resume.certifications, !certs.isEmpty {
            html += "<div class='section-title'>Certifications</div>"
            for cert in certs {
                let nameHtml = cert.hasValidLink && cert.url != nil ? "<a href='\(cert.url!.absoluteString)'>\(cert.name)</a>" : cert.name
                html += """
                <div class='entry'>
                    <div class='title' style='font-size:12px; font-weight:500;'>\(nameHtml)</div>
                    <div class='subtitle'>\(cert.issuer)</div>
                    \(!cert.issueDate.isEmpty ? "<div class='cert-date'>Issued: \(cert.issueDate)\(cert.expiryDate.isEmpty ? "" : " - " + cert.expiryDate)</div>" : "")
                </div>
                """
            }
        }
        
        // Bottom Row (Education + Skills)
        html += "<div class='two-col'>"
        
        // Education
        if !resume.education.isEmpty {
            html += "<div>"
            html += "<div class='section-title' style='margin-top:0;'>Education</div>"
            for edu in resume.education {
                html += """
                <div style='margin-bottom:8px;'>
                    <div class='title' style='font-size:12px;'>\(edu.displayTitle)</div>
                    <div style='font-size:10px; color:#555;'>\(edu.institution)</div>
                    <div style='font-size:10px; color:#268c8c; margin-top:1px;'>
                        \(edu.year)\(!edu.formattedScore.isEmpty ? " &bull; " + edu.formattedScore : "")
                    </div>
                </div>
                """
            }
            html += "</div>"
        }
        
        // Skills
        if !resume.skills.isEmpty {
            html += "<div>"
            html += "<div class='section-title' style='margin-top:0;'>Skills</div>"
            for category in SkillCategory.allCases {
                if let skills = resume.skills[category], !skills.isEmpty {
                    html += """
                    <div style='margin-bottom:5px;'>
                        <div style='font-size:10px; font-weight:700; color:#555; text-transform:uppercase; letter-spacing:0.5px;'>\(category.rawValue)</div>
                        <div style='font-size:11px;'>\(skills.joined(separator: " &bull; "))</div>
                    </div>
                    """
                }
            }
            html += "</div>"
        }
        
        html += "</div></div>" // Close two-col and content
        
        // Languages
        if let langs = resume.languages, !langs.isEmpty {
            html += "<div style='padding:0 36px 16px;'>"
            html += "<div class='section-title'>Languages</div>"
            html += "<div>"
            for lang in langs {
                html += "<span class='lang-tag'>\(lang.name)</span>"
            }
            html += "</div></div>"
        }
        
        // Custom Sections
        if let sections = resume.customSections, !sections.isEmpty {
            html += "<div style='padding:0 36px 16px;'>"
            for section in sections {
                if section.hasValidLink, let url = section.url {
                    html += "<div class='section-title'><a href='\(url.absoluteString)' style='color:inherit; text-decoration:none;'>\(section.title.uppercased())</a></div>"
                } else {
                    html += "<div class='section-title'>\(section.title.uppercased())</div>"
                }
                for bullet in section.bullets {
                    html += """
                    <div class='bullet'>
                        <span class='bullet-arrow'>&#x25B8;</span>
                        <span class='bullet-text'>\(bullet)</span>
                    </div>
                    """
                }
            }
            html += "</div>"
        }
        
        html += "</div>" // Close content
        return html
    }
}
