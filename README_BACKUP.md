# 📄 Resume Builder

A professional, minimalist resume builder app built with **SwiftUI** for iOS/iPadOS.

## ✨ Features

### 📝 Personal Information
- First Name & Last Name input
- Clean, organized form layout

### 📞 Contact Information
- Email address
- Phone number with **country code picker** (50+ countries with flag emojis)
- Location
- LinkedIn profile link
- GitHub profile link

### 🎓 Education (Categorized)
Different education types with appropriate fields:

| Type | Score Type |
|------|------------|
| Class X (10th) | Marks / Percentage |
| Class XII (12th) | Marks / Percentage |
| Diploma | CGPA |
| Degree (B.Tech, BCA, etc.) | CGPA |
| Post Graduate (M.Tech, MBA, etc.) | CGPA |

### 🛠️ Skills (Categorized Selection)
Click-to-select skills organized by categories:
- **Frontend**: React, Angular, Vue.js, Next.js, TypeScript, etc.
- **Backend**: Node.js, Python, Java, Django, Flask, etc.
- **Database**: MySQL, PostgreSQL, MongoDB, Redis, etc.
- **Mobile**: Swift, SwiftUI, Kotlin, React Native, Flutter, etc.
- **DevOps**: Docker, Kubernetes, AWS, Azure, etc.
- **Tools**: Git, GitHub, Figma, VS Code, etc.
- **Languages**: Python, JavaScript, Java, C++, etc.
- **Soft Skills**: Communication, Leadership, Teamwork, etc.
- **Other**: Custom skills input

### 💼 Experience
- Job Title, Company, Duration
- Bullet points with action verb suggestions

### 🚀 Projects
- Project Name with optional clickable link
- Technologies used
- Bullet points description

### 📊 Resume Analysis
- Automated feedback on resume completeness
- Checks for action verbs in bullet points
- Validates required fields

### 📋 Resume Preview
- Clean, professional, minimalist design
- Left-aligned editorial layout
- Categorized skills display
- Clickable project links

## 🖼️ Screenshots

*Coming soon*

## 🏗️ Project Structure

```
My App copy.swiftpm/
├── MyAppCopy.swift          # App entry point
├── ContentView.swift        # Main navigation
├── README.md
├── Models/
│   └── Resume.swift         # Data models
├── Views/
│   ├── WelcomeView.swift
│   ├── ResumeFormView.swift
│   ├── ResumePreviewView.swift
│   └── ResumeAnalysisView.swift
└── Logic/
    └── ResumeAnalyzer.swift # Resume validation logic
```

## 🔧 Requirements

- iOS 16.0+
- iPadOS 16.0+
- Xcode 14.0+
- Swift 5.7+

## 🚀 Getting Started

1. Clone the repository
2. Open in Swift Playgrounds or Xcode
3. Build and run on simulator or device

## 📱 Built With

- **SwiftUI** - Modern declarative UI framework
- **Swift** - Programming language

## 👤 Author

**spideyshan**

## 📄 License

This project is open source and available under the MIT License.
