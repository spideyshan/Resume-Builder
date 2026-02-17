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
                    .btn, .theme-toggle, .hire-me { display: none; }
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
            --shadow: 0 1px 3px rgba(0,0,0,0.05);
            --card-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }
        
        [data-theme="dark"] {
            --primary: #3b82f6;
            --primary-dark: #60a5fa;
            --bg: #0f172a;
            --surface: #1e293b;
            --text-main: #f1f5f9;
            --text-muted: #94a3b8;
            --border: #334155;
            --shadow: 0 1px 3px rgba(0,0,0,0.5);
            --card-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.3);
        }
        
        * { box-sizing: border-box; margin: 0; padding: 0; transition: background-color 0.3s, color 0.3s, border-color 0.3s; }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            background-color: var(--bg);
            color: var(--text-main);
            line-height: 1.6;
            overflow-x: hidden;
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
            box-shadow: var(--shadow);
        }
        
        nav {
            display: flex;
            justify-content: space-between;
            align-items: center;
            height: 70px;
        }
        
        .logo { font-weight: 700; font-size: 1.2rem; color: var(--text-main); }
        
        .nav-links { display: flex; gap: 24px; align-items: center; }
        .nav-links a { font-size: 0.95rem; font-weight: 500; color: var(--text-muted); position: relative; }
        .nav-links a:hover { color: var(--primary); }
        .nav-links a::after {
            content: ''; position: absolute; width: 0; height: 2px; bottom: -4px; left: 0;
            background-color: var(--primary); transition: width 0.3s;
        }
        .nav-links a:hover::after { width: 100%; }
        
        .btn {
            background-color: var(--primary);
            color: white;
            padding: 8px 16px;
            border-radius: 6px;
            font-weight: 500;
            cursor: pointer;
            border: none;
            font-size: 0.9rem;
        }
        .btn:hover { background-color: var(--primary-dark); transform: translateY(-1px); }
        
        /* Theme Toggle */
        .theme-toggle {
            background: none; border: none; font-size: 1.2rem; cursor: pointer; color: var(--text-muted);
            padding: 8px; border-radius: 50%; display: flex; align-items: center; justify-content: center;
        }
        .theme-toggle:hover { background-color: var(--bg); color: var(--primary); }
        
        /* Hero */
        .hero {
            padding: 100px 0 80px;
            text-align: center;
        }
        
        /* Only animate if JS is enabled */
        .js-enabled .hero {
            opacity: 0;
            transform: translateY(20px);
            animation: fadeUp 0.8s ease forwards;
        }
        
        .hero-img {
            width: 140px;
            height: 140px;
            border-radius: 50%;
            object-fit: cover;
            border: 4px solid var(--surface);
            box-shadow: var(--card-shadow);
            margin-bottom: 24px;
            transition: transform 0.3s;
        }
        .hero-img:hover { transform: scale(1.05); }
        
        .hero h1 { font-size: 3rem; font-weight: 800; margin-bottom: 16px; letter-spacing: -0.02em; }
        .hero p { font-size: 1.2rem; color: var(--text-muted); max-width: 600px; margin: 0 auto 32px; }
        
        .hero-actions { display: flex; justify-content: center; gap: 16px; margin-bottom: 40px; }
        
        .social-link {
            display: flex; align-items: center; gap: 8px;
            color: var(--text-muted); border: 1px solid var(--border);
            padding: 10px 20px; border-radius: 50px; background: var(--surface);
            font-size: 0.95rem; font-weight: 500;
        }
        .social-link:hover { border-color: var(--primary); color: var(--primary); transform: translateY(-2px); box-shadow: var(--shadow); }
        
        /* Sections */
        section { padding: 80px 0; }
        .section-title {
            font-size: 1.8rem; font-weight: 700; margin-bottom: 40px;
            display: flex; align-items: center; gap: 16px;
        }
        
        .js-enabled .section-title {
            opacity: 0; transform: translateY(20px); transition: all 0.6s ease;
        }
        .section-title.visible { opacity: 1; transform: translateY(0); }
        
        .section-title::after {
            content: ""; flex: 1; height: 1px; background: var(--border);
        }
        
        /* Grid */
        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 24px;
        }
        
        /* Cards */
        .card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 32px;
            transition: all 0.6s ease, transform 0.2s, box-shadow 0.2s;
        }
        
        .js-enabled .card {
            opacity: 0;
            transform: translateY(30px);
        }
        .card.visible { opacity: 1; transform: translateY(0); }
        
        .card:hover {
            transform: translateY(-5px);
            box-shadow: var(--card-shadow);
            border-color: var(--primary);
        }
        
        .card-header { display: flex; justify-content: space-between; margin-bottom: 16px; align-items: flex-start; }
        .card-title { font-weight: 700; font-size: 1.2rem; margin-bottom: 4px; }
        .card-subtitle { color: var(--text-muted); font-size: 0.95rem; font-weight: 500; }
        .card-date { font-size: 0.85rem; color: var(--text-muted); background: var(--bg); padding: 4px 10px; border-radius: 20px; height: fit-content; white-space: nowrap; border: 1px solid var(--border); }
        
        .card ul { margin-top: 16px; padding-left: 20px; list-style: disc; color: var(--text-muted); font-size: 1rem; }
        .card li { margin-bottom: 8px; }
        
        /* Skills Chips */
        .skills-wrapper { display: flex; flex-wrap: wrap; gap: 12px; }
        .skill-category { width: 100%; font-weight: 700; margin-top: 24px; margin-bottom: 12px; font-size: 0.9rem; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.05em; }
        .skill-tag {
            background: var(--surface); border: 1px solid var(--border);
            padding: 8px 16px; border-radius: 50px; font-size: 0.95rem;
            color: var(--text-main); font-weight: 500;
            transition: all 0.4s ease;
        }
        
        .js-enabled .skill-tag {
            opacity: 0; transform: scale(0.9);
        }
        .skill-tag.visible { opacity: 1; transform: scale(1); }
        .skill-tag:hover { border-color: var(--primary); color: var(--primary); }
        
        /* Floating Hire Me */
        .hire-me {
            position: fixed; bottom: 30px; right: 30px;
            background: var(--primary); color: white;
            padding: 12px 24px; border-radius: 50px;
            font-weight: 600; box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);
            z-index: 90; transition: transform 0.2s;
        }
        .hire-me:hover { transform: scale(1.05); }
        
        /* Footer */
        footer {
            border-top: 1px solid var(--border);
            text-align: center; padding: 60px 0;
            color: var(--text-muted); font-size: 0.9rem;
            background: var(--bg); margin-top: 60px;
        }
        
        /* Animations */
        @keyframes fadeUp {
            to { opacity: 1; transform: translateY(0); }
        }
        
        /* Mobile */
        @media (max-width: 600px) {
            .hero h1 { font-size: 2.2rem; }
            .nav-links { display: none; }
            .hire-me { bottom: 20px; right: 20px; padding: 10px 20px; font-size: 0.9rem; }
            .card { padding: 24px; }
        }
        
        /* Print */
        @media print {
            .btn, nav, .theme-toggle, .hire-me { display: none; }
            body { background: white; color: black; }
            .card { break-inside: avoid; border: none; padding: 0; box-shadow: none; margin-bottom: 24px; }
            .hero { padding: 0; text-align: left; margin-bottom: 30px; opacity: 1; transform: none; }
            .hero-actions { display: none; }
            .hero-img { display: block; border: none; }
            .section-title, .card, .skill-tag { opacity: 1 !important; transform: none !important; }
        }
        """
    }
    
    // MARK: - JavaScript
    private static func portfolioJS() -> String {
        return """
        // Enable animations only if JS runs
        document.body.classList.add('js-enabled');

        function printResume() {
            window.print();
        }
        
        // Theme Toggle
        const toggleBtn = document.getElementById('theme-toggle');
        const icon = toggleBtn.querySelector('span');
        const html = document.documentElement;
        
        // Check Saved Theme
        const savedTheme = localStorage.getItem('theme') || 'light';
        html.setAttribute('data-theme', savedTheme);
        updateIcon(savedTheme);
        
        toggleBtn.addEventListener('click', () => {
            const current = html.getAttribute('data-theme');
            const newTheme = current === 'light' ? 'dark' : 'light';
            
            html.setAttribute('data-theme', newTheme);
            localStorage.setItem('theme', newTheme);
            updateIcon(newTheme);
        });
        
        function updateIcon(theme) {
            icon.textContent = theme === 'light' ? '🌙' : '☀️';
        }
        
        // Scroll Animations (Intersection Observer)
        const observerOptions = {
            threshold: 0.1,
            rootMargin: "0px 0px -50px 0px"
        };
        
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('visible');
                    
                    // Stagger children if needed (e.g. skills)
                    if (entry.target.classList.contains('skills-wrapper')) {
                        const tags = entry.target.querySelectorAll('.skill-tag');
                        tags.forEach((tag, index) => {
                            setTimeout(() => {
                                tag.classList.add('visible');
                            }, index * 50); // 50ms stagger
                        });
                    }
                }
            });
        }, observerOptions);
        
        document.querySelectorAll('.section-title, .card').forEach(el => observer.observe(el));
        
        // Special observer for skill wrapper to trigger staggered children
        document.querySelectorAll('.skills-wrapper').forEach(el => observer.observe(el));
        
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
                        <button class="theme-toggle" id="theme-toggle" aria-label="Toggle Dark Mode"><span>🌙</span></button>
                        <button class="btn" onclick="printResume()">Download PDF</button>
                    </div>
                    <!-- Mobile Menu Placeholder (hidden for now to keep simple) -->
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
            <section id="experience">
                <div class="container">
                    <h2 class="section-title">Experience</h2>
                    <div class="grid">
            """
            for (index, exp) in resume.experience.enumerated() {
                // Add slight delay for grid items
                let delay = Double(index) * 0.1
                html += """
                <div class="card" style="transition-delay: \(delay)s">
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
            for (index, proj) in resume.projects.enumerated() {
                let delay = Double(index) * 0.1
                let linkAtts = (proj.hasValidLink && proj.url != nil) ? "href='\(proj.url!.absoluteString)' target='_blank'" : ""
                let titleHtml = linkAtts.isEmpty ? proj.name : "<a \(linkAtts) style='color:var(--primary);'>\(proj.name) ↗</a>"
                
                html += """
                <div class="card" style="transition-delay: \(delay)s">
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
            <section id="skills">
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
        
        // --- Hire Me Button ---
        if !resume.email.isEmpty {
            html += "<a href='mailto:\(resume.email)' class='hire-me'>Hire Me 👋</a>"
        }
        
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
