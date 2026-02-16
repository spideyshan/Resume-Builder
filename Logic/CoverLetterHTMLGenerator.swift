import Foundation

struct CoverLetterHTMLGenerator {
    
    static func generateHTML(resume: Resume, coverLetter: CoverLetter) -> String {
        let body = CoverLetterGenerator.generate(resume: resume, coverLetter: coverLetter)
        let css = templateCSS(for: coverLetter.tone)
        let htmlBody = buildBody(resume: resume, coverLetter: coverLetter, bodyText: body)
        
        return """
        <!DOCTYPE html>
        <html>
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=612, initial-scale=1.0">
            <style>
                @page {
                    size: 612px 792px;
                    margin: 0;
                }
                @media print {
                    .letter { page-break-inside: avoid; }
                }
                \(css)
            </style>
        </head>
        <body>
            \(htmlBody)
        </body>
        </html>
        """
    }
    
    // MARK: - CSS
    
    private static func templateCSS(for tone: CoverLetterTone) -> String {
        switch tone {
        case .formal:
            return """
                * { margin: 0; padding: 0; box-sizing: border-box; }
                body { font-family: 'Georgia', 'Times New Roman', serif; color: #2d2d2d; padding: 48px 56px; font-size: 12px; line-height: 1.7; }
                .header { margin-bottom: 28px; }
                .sender-name { font-size: 22px; font-weight: 700; color: #2c5282; letter-spacing: 1px; text-transform: uppercase; }
                .contact-line { font-size: 11px; color: #555; margin-top: 4px; }
                .contact-line a { color: #2c5282; text-decoration: none; }
                .divider { height: 2px; background: linear-gradient(to right, #2c5282, #a0aec0); margin: 16px 0 24px; }
                .date { font-size: 11px; color: #718096; margin-bottom: 20px; }
                .greeting { font-size: 13px; font-weight: 600; margin-bottom: 16px; }
                .body-text { font-size: 12px; line-height: 1.7; color: #2d2d2d; }
                .body-text p { margin-bottom: 14px; text-align: justify; }
                .sign-off { margin-top: 24px; font-size: 12px; }
                .sign-off .closing { font-style: italic; margin-bottom: 24px; }
                .sign-off .name { font-size: 14px; font-weight: 700; color: #2c5282; }
            """
        case .modern:
            return """
                * { margin: 0; padding: 0; box-sizing: border-box; }
                body { font-family: -apple-system, 'Helvetica Neue', Arial, sans-serif; color: #1a202c; padding: 48px 56px; font-size: 12px; line-height: 1.7; }
                .header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 28px; }
                .sender-name { font-size: 24px; font-weight: 700; color: #1a202c; }
                .contact-line { font-size: 11px; color: #666; margin-top: 3px; }
                .contact-line a { color: #333; text-decoration: none; font-weight: 500; }
                .contact-right { text-align: right; font-size: 11px; color: #666; line-height: 1.8; }
                .divider { height: 1.5px; background: #1a202c; margin: 0 0 28px; }
                .date { font-size: 11px; color: #888; margin-bottom: 20px; }
                .greeting { font-size: 13px; font-weight: 600; margin-bottom: 16px; }
                .body-text { font-size: 12px; line-height: 1.7; }
                .body-text p { margin-bottom: 14px; }
                .sign-off { margin-top: 28px; font-size: 12px; }
                .sign-off .closing { margin-bottom: 24px; }
                .sign-off .name { font-size: 14px; font-weight: 600; }
            """
        case .creative:
            return """
                * { margin: 0; padding: 0; box-sizing: border-box; }
                body { font-family: -apple-system, 'Helvetica Neue', Arial, sans-serif; color: #1a202c; padding: 0; font-size: 12px; line-height: 1.7; }
                .header { background: linear-gradient(135deg, #e6fffa 0%, #f0fff4 50%, #ffffff 100%); padding: 36px 56px 24px; }
                .sender-name { font-size: 28px; font-weight: 300; color: #268c8c; }
                .contact-line { font-size: 11px; color: #555; margin-top: 4px; }
                .contact-line a { color: #268c8c; text-decoration: none; font-weight: 600; }
                .content { padding: 28px 56px 48px; }
                .date { font-size: 11px; color: #268c8c; margin-bottom: 20px; }
                .greeting { font-size: 14px; font-weight: 600; color: #268c8c; margin-bottom: 16px; }
                .body-text { font-size: 12px; line-height: 1.7; }
                .body-text p { margin-bottom: 14px; }
                .sign-off { margin-top: 28px; font-size: 12px; }
                .sign-off .closing { color: #268c8c; font-weight: 500; margin-bottom: 24px; }
                .sign-off .name { font-size: 16px; font-weight: 300; color: #268c8c; }
            """
        }
    }
    
    // MARK: - Body HTML
    
    private static func buildBody(resume: Resume, coverLetter: CoverLetter, bodyText: String) -> String {
        let tone = coverLetter.tone
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        let dateStr = dateFormatter.string(from: Date())
        
        // Parse body into greeting, paragraphs, sign-off
        let lines = bodyText.components(separatedBy: "\n\n")
        guard lines.count >= 3 else { return "<p>\(bodyText)</p>" }
        
        let greeting = lines[0]
        let bodyParagraphs = lines[1..<(lines.count - 1)]
        let signOffParts = lines.last?.components(separatedBy: "\n") ?? []
        let closingLine = signOffParts.first ?? ""
        let signName = signOffParts.count > 1 ? signOffParts[1] : resume.fullName
        
        // Contact info
        var contactParts: [String] = []
        if !resume.email.isEmpty { contactParts.append(resume.email) }
        if !resume.phone.isEmpty { contactParts.append(resume.fullPhone) }
        if !resume.location.isEmpty { contactParts.append(resume.location) }
        
        var linkParts: [String] = []
        if let linkedin = resume.linkedinURL { linkParts.append("<a href='\(linkedin.absoluteString)'>LinkedIn</a>") }
        if let github = resume.githubURL { linkParts.append("<a href='\(github.absoluteString)'>GitHub</a>") }
        
        switch tone {
        case .formal:
            var html = "<div class='letter'>"
            html += "<div class='header'>"
            html += "<div class='sender-name'>\(resume.fullName)</div>"
            if !contactParts.isEmpty {
                html += "<div class='contact-line'>\(contactParts.joined(separator: "  |  "))</div>"
            }
            if !linkParts.isEmpty {
                html += "<div class='contact-line'>\(linkParts.joined(separator: "  |  "))</div>"
            }
            html += "</div>"
            html += "<div class='divider'></div>"
            html += "<div class='date'>\(dateStr)</div>"
            html += "<div class='greeting'>\(greeting)</div>"
            html += "<div class='body-text'>"
            for para in bodyParagraphs {
                html += "<p>\(para)</p>"
            }
            html += "</div>"
            html += "<div class='sign-off'>"
            html += "<div class='closing'>\(closingLine)</div>"
            html += "<div class='name'>\(signName)</div>"
            html += "</div>"
            html += "</div>"
            return html
            
        case .modern:
            var html = "<div class='letter'>"
            html += "<div class='header'>"
            html += "<div><div class='sender-name'>\(resume.fullName)</div>"
            if !contactParts.isEmpty {
                html += "<div class='contact-line'>\(contactParts.joined(separator: "  •  "))</div>"
            }
            html += "</div>"
            if !linkParts.isEmpty {
                html += "<div class='contact-right'>\(linkParts.joined(separator: "<br>"))</div>"
            }
            html += "</div>"
            html += "<div class='divider'></div>"
            html += "<div class='date'>\(dateStr)</div>"
            html += "<div class='greeting'>\(greeting)</div>"
            html += "<div class='body-text'>"
            for para in bodyParagraphs {
                html += "<p>\(para)</p>"
            }
            html += "</div>"
            html += "<div class='sign-off'>"
            html += "<div class='closing'>\(closingLine)</div>"
            html += "<div class='name'>\(signName)</div>"
            html += "</div>"
            html += "</div>"
            return html
            
        case .creative:
            var html = "<div class='letter'>"
            html += "<div class='header'>"
            html += "<div class='sender-name'>\(resume.fullName)</div>"
            if !contactParts.isEmpty {
                html += "<div class='contact-line'>\(contactParts.joined(separator: "  •  "))</div>"
            }
            if !linkParts.isEmpty {
                html += "<div class='contact-line'>\(linkParts.joined(separator: "  •  "))</div>"
            }
            html += "</div>"
            html += "<div class='content'>"
            html += "<div class='date'>\(dateStr)</div>"
            html += "<div class='greeting'>\(greeting)</div>"
            html += "<div class='body-text'>"
            for para in bodyParagraphs {
                html += "<p>\(para)</p>"
            }
            html += "</div>"
            html += "<div class='sign-off'>"
            html += "<div class='closing'>\(closingLine)</div>"
            html += "<div class='name'>\(signName)</div>"
            html += "</div>"
            html += "</div>"
            html += "</div>"
            return html
        }
    }
}
