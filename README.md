# ResumeCraft: Craft Your Professional Story

### Apple Swift Student Challenge Submission

## 📱 App Description

**ResumeCraft** is more than just a resume builder; it is a comprehensive career companion designed to help students and professionals craft compelling narratives, optimize for Applicant Tracking Systems (ATS), and prepare for interviews—all within a beautiful, native iOS experience.

Born from the frustration of formatting complex documents, ResumeCraft leverages the power of **SwiftUI** and **Core ML** to transform a tedious chore into an engaging, creative process.

---

## 🚀 Key Features

### 1. ✍️ **Smart Resume Builder**

- **Structured Data Entry**: Validated inputs for Education, Experience, Skills, and Projects ensure data integrity.
- **Context-Aware Hints**: Suggested action verbs and skill categories based on the user's role (e.g., "Frontend" suggests React, SwiftUI).
- **Real-Time Preview**: Split-screen editing with instant visual feedback on changes.
- **Multi-Template Support**: Choose from Classic, Modern, and Minimalist designs that adapt to your content.

### 2. 🧠 **AI-Powered Analysis & Feedback**

- **ATS Scoring Engine**: Algorithms analyze content depth, keyword density, and structural completeness to provide a score (0-100).
- **Natural Language Processing**: Utilizing Apple's **NaturalLanguage** framework, the app identifies weak verbs and suggests impactful alternatives.
- **Completeness Checks**: Flags missing essential sections like LinkedIn profiles or contact details.

### 3. 🎓 **Interview Prep (Core ML)**

- **Dynamic Question Generation**: The app reads your resume content and generates tailored interview questions using on-device ML.
- **Flashcard Mode**: Practice answering "Tell me about..." questions specific to your listed projects and skills.
- **Skill Correlation**: Understands relationships between skills (e.g., Python → Django) to ask relevant technical questions.

### 4. ✉️ **Intelligent Cover Letter Generator**

- **Tone Selection**: Generate cover letters in Formal, Modern, or Creative tones.
- **Auto-Drafting**: Pulls key highlights from your resume to verify alignment between your application and your CV.
- **Export Options**: Save as PDF or copy text directly to your clipboard.

### 5. 📇 **Digital Business Card**

- **Quick Connection**: Instantly generate a personalized QR code containing your vCard information.
- **Contact Sharing**: A fast, seamless way to share contact details with recruiters and peers at networking events.

### 6. 📤 **Professional Export & Sharing**

- **PDF Generation**: High-fidelity export using `PDFKit` and `ImageRenderer`.
- **ATS-Friendly Text**: Plain text export option optimized for automated parsers.
- **QR Code Integration**: Generates scannable codes for your portfolio or GitHub.

---

## 🛠️ Technical Implementation

ResumeCraft showcases advanced usage of the Apple ecosystem:

- **SwiftUI & MVVM**: Built entirely with SwiftUI, utilizing a clean MVVM architecture for separation of concerns and testability.
- **Data Persistence**: Custom JSON-based storage engine with FileManager for saving, duplicating, and managing multiple resumes.
- **NaturalLanguage Framework**: Used for `NLEmbedding` to find semantic similarities in skills and generate context-aware questions.
- **PDFKit**: Leverages `UIGraphicsPDFRenderer` for pixel-perfect document generation.
- **AVKit**: Integrates a seamless video walkthrough for user onboarding.
- **Accessibility**: Full support for Dynamic Type and VoiceOver across all main views.

---

## 🎨 User Interface & Design

- **Dark Mode First**: A sleek, modern aesthetic that looks great in both Light and Dark modes.
- **Adaptive Layouts**: Responsive design that scales from iPhone SE to iPad Pro with split views.
- **Haptics & Animations**: Subtle haptic feedback on success actions and smooth transitions enhance the "feel" of the app.

## 🔮 Future Roadmap

- **iCloud Sync**: Seamless synchronization across devices using CloudKit.
- **SharePlay**: Real-time collaborative editing for peer reviews.
- **App Clips**: A lightweight version for quick resume sharing.

---

## 🖼️ Screenshots

_Add screenshots here_

## 📹 Video Demo

A comprehensive video walkthrough is included within the app to help you get started.

## 🏆 Credits

- **Zero Third-Party Dependencies**: This project relies entirely on native Apple frameworks (SwiftUI, Core ML, PDFKit) and contains no external libraries.
- **Assets**: All icons used are native SF Symbols.

---

## 🔧 Requirements

- iOS 16.0+
- iPadOS 16.0+
- Xcode 14.0+
- Swift 5.7+

## 🚀 Getting Started

1. Clone the repository
2. Open in Swift Playgrounds or Xcode
3. Build and run on simulator or device

## 🛡️ Privacy

This app requests access to:

- **Camera**: For scanning QR codes and placing AR Business Cards.

---

_Built with ❤️ in Swift._
