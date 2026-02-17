import Foundation
import UIKit

struct PortfolioGenerator {
    
    static func generateHTML(for resume: Resume) -> String {
        let css = portfolioCSS()
        let js = portfolioJS()
        let body = portfolioBody(for: resume)
        
        return """
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>\(resume.fullName) - Portfolio</title>
            <meta name="description" content="Portfolio of \(resume.fullName)">
            <style>
                \(css)
            </style>
            <noscript>
                <style>
                    .btn { display: none; }
                </style>
            </noscript>
        </head>
        <body>
            \(body)
            <script>
                \(js)
            </script>
        </body>
        </html>
        """
    }
    
    // MARK: - CSS
    private static func portfolioCSS() -> String {
        return """
        :root {
            --primary: #2563eb;
            --primary-dark: #1e40af;
            --bg: #f8fafc;
            --surface: #ffffff;
            --text-main: #1e293b;
            --text-muted: #64748b;
            --border: #e2e8f0;
        }
        
        * { box-sizing: border-box; margin: 0; padding: 0; }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            background-color: var(--bg);
            color: var(--text-main);
            line-height: 1.6;
        }
        
        a { text-decoration: none; color: inherit; transition: color 0.2s; }
        ul { list-style: none; }
        
        /* Layout */
        .container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 0 20px;
        }
        
        /* Header / Nav */
        header {
            background-color: var(--surface);
            border-bottom: 1px solid var(--border);
            position: sticky;
            top: 0;
            z-index: 100;
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
        }
        
        nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            height: 70px;
        }
        
        .logo { font-weight: 700; font-size: 1.2rem; color: var(--text-main); }
        
        .nav-links { display: flex; gap: 24px; }
        .nav-links a { font-size: 0.95rem; font-weight: 500; color: var(--text-muted); }
        .nav-links a:hover { color: var(--primary); }
        
        .btn {
            background-color: var(--primary);
            color: white;
            padding: 8px 16px;
            border-radius: 6px;
            font-weight: 500;
            cursor: pointer;
            transition: background 0.2s;
            border: none;
            font-size: 0.9rem;
        }
        .btn:hover { background-color: var(--primary-dark); }
        
        /* Hero */
        .hero {
            padding: 80px 0;
            text-align: center;
        }
        
        .hero-img {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid white;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            margin-bottom: 24px;
        }
        
        .hero h1 { font-size: 2.5rem; font-weight: 800; margin-bottom: 12px; letter-spacing: -0.02em; }
        .hero p { font-size: 1.1rem; color: var(--text-muted); max-width: 600px; margin: 0 auto 32px; }
        
        .hero-actions { display: flex; justify-content: center; gap: 16px; margin-bottom: 40px; }
        
        .social-link {
            display: flex; align-items: center; gap: 8px;
            color: var(--text-muted); border: 1px solid var(--border);
            padding: 8px 16px; border-radius: 50px; background: white;
            font-size: 0.9rem;
        }
        .social-link:hover { border-color: var(--primary); color: var(--primary); }
        
        /* Sections */
        section { padding: 60px 0; }
        .section-title {
            font-size: 1.5rem; font-weight: 700; margin-bottom: 32px;
            display: flex; align-items: center; gap: 12px;
        }
        .section-title::after {
            content: ""; flex: 1; height: 1px; background: var(--border);
        }
        
        /* Grid */
        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 24px;
        }
        
        /* Cards */
        .card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 24px;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .card:hover {
            transform: translateY(-4px);
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
            border-color: var(--primary);
        }
        
        .card-header { display: flex; justify-content: space-between; margin-bottom: 12px; }
        .card-title { font-weight: 600; font-size: 1.1rem; }
        .card-subtitle { color: var(--text-muted); font-size: 0.9rem; }
        .card-date { font-size: 0.85rem; color: var(--text-muted); background: #f1f5f9; padding: 2px 8px; border-radius: 4px; height: fit-content; }
        
        .card ul { margin-top: 16px; padding-left: 20px; list-style: disc; color: var(--text-muted); font-size: 0.95rem; }
        .card li { margin-bottom: 6px; }
        
        /* Skills Chips */
        .skills-wrapper { display: flex; flex-wrap: wrap; gap: 12px; }
        .skill-category { width: 100%; font-weight: 600; margin-top: 12px; margin-bottom: 8px; font-size: 0.9rem; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.05em; }
        .skill-tag {
            background: white; border: 1px solid var(--border);
            padding: 6px 12px; border-radius: 20px; font-size: 0.9rem;
            color: var(--text-main); font-weight: 500;
        }
        
        /* Footer */
        footer {
            border-top: 1px solid var(--border);
            text-align: center; padding: 40px 0;
            color: var(--text-muted); font-size: 0.9rem;
            background: var(--surface);
        }
        
        @media (max-width: 600px) {
            .hero h1 { font-size: 2rem; }
            .nav-links { display: none; } /* Simplified mobile nav */
        }
        
        @media print {
            .btn, nav { display: none; }
            body { background: white; }
            .card { break-inside: avoid; border: none; padding: 0; box-shadow: none; margin-bottom: 24px; }
            .hero { padding: 0; text-align: left; margin-bottom: 30px; }
            .hero-actions { display: none; }
            .hero-img { display: none; }
        }
        """
    }
    
    // MARK: - JavaScript
    private static func portfolioJS() -> String {
        return """
        function printResume() {
            window.print();
        }
        
        // Smooth scroll
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                document.querySelector(this.getAttribute('href')).scrollIntoView({
                    behavior: 'smooth'
                });
            });
        });
        """
    }
    
    // MARK: - HTML Body
    private static func portfolioBody(for resume: Resume) -> String {
        var html = ""
        
        // --- Navbar ---
        html += """
        <header>
            <div class="container">
                <nav>
                    <div class="logo">\(resume.fullName)</div>
                    <div class="nav-links">
                        <a href="#about">About</a>
                        <a href="#experience">Experience</a>
                        <a href="#projects">Projects</a>
                        <a href="#skills">Skills</a>
                    </div>
                    <button class="btn" onclick="printResume()">Download PDF</button>
                </nav>
            </div>
        </header>
        """
        
        html += "<main>"
        
        // --- Hero ---
        html += "<div class='container hero' id='about'>"
        if let photoData = resume.photoData, let _ = UIImage(data: photoData) {
            let base64 = photoData.base64EncodedString()
            html += "<img src='data:image/jpeg;base64,\(base64)' class='hero-img' alt='Profile Photo'>"
        }
        html += "<h1>Hi, I'm \(resume.firstName).</h1>"
        if let summary = resume.summary, !summary.isEmpty {
            html += "<p>\(summary)</p>"
        } else {
            html += "<p>I build things for the web and mobile.</p>"
        }
        
        // Socials
        html += "<div class='hero-actions'>"
        if let url = resume.linkedinURL {
            html += "<a href='\(url.absoluteString)' target='_blank' class='social-link'>LinkedIn</a>"
        }
        if let url = resume.githubURL {
            html += "<a href='\(url.absoluteString)' target='_blank' class='social-link'>GitHub</a>"
        }
        if !resume.email.isEmpty {
             html += "<a href='mailto:\(resume.email)' class='social-link'>Email</a>"
        }
        html += "</div>"
        html += "</div>" // End Hero
        
        // --- Experience ---
        if !resume.experience.isEmpty {
            html += """
            <section id="experience" style="background: white;">
                <div class="container">
                    <h2 class="section-title">Experience</h2>
                    <div class="grid">
            """
            for exp in resume.experience {
                html += """
                <div class="card">
                    <div class="card-header">
                        <div>
                            <div class="card-title">\(exp.company)</div>
                            <div class="card-subtitle">\(exp.title)</div>
                        </div>
                        <div class="card-date">\(exp.duration)</div>
                    </div>
                    <ul>
                        \(exp.bullets.map { "<li>\($0)</li>" }.joined())
                    </ul>
                </div>
                """
            }
            html += """
                    </div>
                </div>
            </section>
            """
        }
        
        // --- Projects ---
        if !resume.projects.isEmpty {
            html += """
            <section id="projects">
                <div class="container">
                    <h2 class="section-title">Projects</h2>
                    <div class="grid">
            """
            for proj in resume.projects {
                let linkAtts = (proj.hasValidLink && proj.url != nil) ? "href='\(proj.url!.absoluteString)' target='_blank'" : ""
                let titleHtml = linkAtts.isEmpty ? proj.name : "<a \(linkAtts) style='color:var(--primary);'>\(proj.name) ↗</a>"
                
                html += """
                <div class="card">
                    <div class="card-header">
                        <div class="card-title">\(titleHtml)</div>
                        \(!proj.tools.isEmpty ? "<div class='card-date'>\(proj.tools)</div>" : "")
                    </div>
                    <ul>
                         \(proj.bullets.map { "<li>\($0)</li>" }.joined())
                    </ul>
                </div>
                """
            }
            html += """
                    </div>
                </div>
            </section>
            """
        }
        
        // --- Skills ---
        if !resume.skills.isEmpty {
            html += """
            <section id="skills" style="background: white;">
                <div class="container">
                    <h2 class="section-title">Skills</h2>
                    <div class="skills-wrapper">
            """
            for category in SkillCategory.allCases {
                if let skills = resume.skills[category], !skills.isEmpty {
                    html += "<div class='skill-category'>\(category.rawValue)</div>"
                    for skill in skills {
                        html += "<div class='skill-tag'>\(skill)</div>"
                    }
                }
            }
            html += """
                    </div>
                </div>
            </section>
            """
        }
        
        html += "</main>"
        
        // --- Footer ---
        html += """
        <footer>
            <div class="container">
                <p>&copy; \(Calendar.current.component(.year, from: Date())) \(resume.fullName). Generated by ResumeCraft.</p>
            </div>
        </footer>
        """
        
        return html
    }
}
