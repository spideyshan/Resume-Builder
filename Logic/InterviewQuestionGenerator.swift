import Foundation
import NaturalLanguage

struct InterviewQuestionGenerator {
    
    // --- Expanded Static Database (The "Knowledge Base") ---
    private static let technicalQuestionsDB: [String: [(question: String, answer: String)]] = [
        "swift": [
            ("What is the difference between a Struct and a Class in Swift?", "Structs are value types (copied when passed), while Classes are reference types (shared). Structs do not support inheritance, but Classes do."),
            ("What is Optional Chaining?", "A concise way to query properties, methods, and subscripts on an optional that might be nil. If the optional is nil, the call returns nil."),
            ("Explain ARC (Automatic Reference Counting).", "ARC tracks and manages your app's memory usage. It automatically frees up the memory used by class instances when those instances are no longer needed."),
            ("What are Closures?", "Self-contained blocks of functionality that can be passed around and used in your code. They can capture and store references to variables from their context."),
            ("Values vs. Reference Types?", "Value types (struct, enum) are copied on assignment. Reference types (class, actor) share a single instance."),
            ("What is the `guard` statement?", "A control flow statement that exits early if a condition is not met, ensuring that variables are valid for the rest of the scope."),
            ("Explain the purpose of `defer`.", "A block of code that is executed just before the current scope acts, regardless of how the scope is exited (return, break, error)."),
            ("What is Protocol Oriented Programming?", "A paradigm in Swift favoring protocols and protocol extensions over class inheritance for code reuse and flexibility."),
            ("What are Generics?", "Flexible, reusable functions and types that can work with any type, subject to requirements that you define.")
        ],
        "ios": [
            ("Explain the App Lifecycle states.", "Not Running, Inactive (foreground but not receiving events), Active, Background, Suspended."),
            ("What is a ReuseIdentifier in UITableView?", "A string used to identify a cell that can be reused for performance, avoiding the expensive creation of new views."),
            ("ViewController Lifecycle methods?", "viewDidLoad (loaded), viewWillAppear (about to show), viewDidAppear (shown), viewWillDisappear (about to hide), viewDidDisappear (hidden)."),
            ("Exceptions vs Errors in Swift?", "Swift favors `Error` protocol and `do-catch` blocks for recoverable errors. Exceptions (NSException) are generally for programmer errors and crash the app."),
            ("What is Auto Layout?", "A constraint-based layout system that calculates the size and position of all views in your view hierarchy dynamically."),
            ("Bounds vs Frame?", "Frame is the view's location and size in its Superview's coordinate system. Bounds is its location and size in its Own coordinate system.")
        ],
        "swiftui": [
            ("What is the difference between `@State` and `@Binding`?", "`@State` is for data owned by the view. `@Binding` is for data owned by a parent view but modified by the child."),
            ("What is `@EnvironmentObject`?", "A dependency injection wrapper that allows data to be passed down the view hierarchy without passing it through init parameters."),
            ("Explain the `View` protocol.", "The central protocol in SwiftUI. It requires a `body` property that returns `some View`, describing the UI."),
            ("What is the purpose of `GeometryReader`?", "A container view that defines its content as a function of its own size and coordinate space."),
            ("Why do we use `id: \\.self` in ForEach?", "It tells SwiftUI to use the hashable value of the element itself as the unique identifier for diffing.")

        ],
        "python": [
            ("List vs Tuple?", "Lists are mutable `[]`. Tuples are immutable `()`. Use tuples for fixed collections."),
            ("What are Decorators?", "Functions that wrap other functions to modify their behavior without changing their code."),
            ("Explain the GIL (Global Interpreter Lock).", "A mutex that prevents multiple native threads from executing Python bytecodes at once, limiting true parallelism."),
            ("What is `__init__`?", "The constructor method in Python classes, called when an object is instantiated."),
            ("Deep copy vs Shallow copy?", "Shallow copy creates a new object but inserts references to the original elements. Deep copy recursively creates copies of the nested objects.")
        ],
        "javascript": [
            ("`==` vs `===`?", "`==` converts types before comparing (coercion). `===` is strict equality (no coercion)."),
            ("What is a Closure?", "A function that remembers and accesses variables from an outer scope even after that scope has finished execution."),
            ("Explain the Event Loop.", "Call Stack -> Web APIs -> Callback Queue. The Event Loop pushes tasks from the Queue to the Stack when the Stack is empty."),
            ("`var`, `let`, `const` differences?", "`var` is function-scoped. `let` and `const` are block-scoped. `const` cannot be reassigned."),
            ("What is `this` keyword?", "It refers to the object that is executing the current function. Its value depends on how the function is invoked.")
        ],
        "react": [
            ("State vs Props?", "Props are immutable arguments passed to components. State is mutable data managed within the component."),
            ("What are Hooks?", "Functions like `useState` and `useEffect` that let you use state and lifecycle features in functional components."),
            ("What is the Virtual DOM?", "A lightweight in-memory representation of the DOM. React updates this first, diffs it, and then efficiently updates specific parts of the real DOM.")
        ],
        "git": [
            ("Merge vs Rebase?", "Merge creates a commit combining histories. Rebase rewrites history by moving your commits on top of the base branch."),
            ("What is `git clone`?", "Downloads a repository from a remote server to your local machine."),
            ("Difference between `fetch` and `pull`?", "`fetch` downloads changes but doesn't integrate them. `pull` downloads matches AND attempts to merge them."),
            ("How to undo the last commit?", "`git reset HEAD~1`. Use `--soft` to keep changes in staging, `--hard` to discard them.")
        ],
        "general_tech": [
            ("Explain REST APIs.", "REpresentational State Transfer. An architectural style for networked applications using standard HTTP methods (GET, POST, PUT, DELETE)."),
            ("What is CI/CD?", "Continuous Integration (merging code frequently) and Continuous Deployment (automating release)."),
            ("SQL vs NoSQL?", "SQL (Relational, Structured, Schema-based). NoSQL (Non-relational, Flexible schema, Document/Key-Value based)."),
            ("What is Docker?", "A platform for developing, shipping, and running applications in containers.")
        ]
    ]
    
    // --- Behavioral & Situational Templates (Dynamic) ---
    private static let behavioralTemplates: [(question: String, guide: String)] = [
        ("Tell me about yourself.", "Start with your current role, give a brief career history, and end with why you're here. Keep it under 2 minutes."),
        ("What is your greatest strength?", "Pick a strength that aligns with the job description. Back it up with a concrete example."),
        ("What is your greatest weakness?", "Choose a real weakness (not 'I work too hard') and show how you are actively managing or improving it."),
        ("Why are you leaving your current role?", "Focus on 'pull' factors (seeking growth, new challenges) rather than 'push' factors (bad boss, boredom)."),
        ("Describe a time you failed.", "Focus on what you learned from the failure and how you applied that lesson later."),
        ("How do you handle tight deadlines?", "Discuss prioritization, communication with stakeholders, and staying focused."),
        ("Where do you see yourself in 5 years?", "Show ambition but keep it realistic and aligned with the company's potential growth path.")
    ]
    
    static func generate(for resume: Resume) -> [InterviewQuestion] {
        var questions: [InterviewQuestion] = []
        var usedQuestions = Set<String>()
        
        // 1. High-Priority: Contextual Questions from Bullet Points (The "Smartest" feature)
        // We pick specific achievements and ask about them.
        let bulletQuestions = generateQuestionsFromContent(resume: resume)
        for q in bulletQuestions {
            if !usedQuestions.contains(q.question) {
                questions.append(q)
                usedQuestions.insert(q.question)
            }
            if questions.count >= 4 { break } // Limit to 4 specific deep-dives
        }
        
        // 2. Medium-Priority: Technical Questions based on Semantic Matching
        // Use NLEmbedding to find related skills even if exact words don't match
        let semanticQuestions = generateSemanticTechQuestions(resume: resume, existing: usedQuestions)
        for q in semanticQuestions {
            if !usedQuestions.contains(q.question) {
                questions.append(q)
                usedQuestions.insert(q.question)
            }
            if questions.count >= 8 { break } // Limit to reach 8 total mixed questions
        }
        
        // 3. Low-Priority: General Behavioral (Fallback to ensure 10)
        // Deterministic order, not random shuffled every time
        for template in behavioralTemplates {
            if questions.count >= 10 { break }
            if !usedQuestions.contains(template.question) {
                questions.append(InterviewQuestion(
                    question: template.question,
                    answer: template.guide,
                    type: .general,
                    context: "Standard Interview Question"
                ))
                usedQuestions.insert(template.question)
            }
        }
        
        return questions
    }
    
    // --- Smart Logic: Generate Questions from Bullet Points ---
    private static func generateQuestionsFromContent(resume: Resume) -> [InterviewQuestion] {
        var generated: [InterviewQuestion] = []
        
        // Analyze Experience Bullets
        for exp in resume.experience.prefix(3) {
            for bullet in exp.bullets.prefix(2) {
                // Heuristic: If bullet is long enough, turn it into a question
                if bullet.count > 30 {
                    let qText = "In your role at \(exp.company), you mentioned: \"\(truncate(bullet))\". Can you walk me through your specific contribution here?"
                    generated.append(InterviewQuestion(
                        question: qText,
                        answer: "Focus on the 'How'. Explain the challenges you faced in this specific task and the impact of your actions.",
                        type: .behavioral,
                        context: "Deep Dive: \(exp.title)"
                    ))
                }
            }
        }
        
        // Analyze Project Bullets
        for proj in resume.projects.prefix(3) {
            for bullet in proj.bullets.prefix(2) {
                if bullet.count > 30 {
                    let qText = "For project \(proj.name), you stated: \"\(truncate(bullet))\". What were the key technical decisions behind this?"
                    generated.append(InterviewQuestion(
                        question: qText,
                        answer: "Discuss trade-offs. Why did you choose this approach over others? What did you learn?",
                        type: .technical,
                        context: "Deep Dive: \(proj.name)"
                    ))
                }
            }
        }
        
        return generated.shuffled() // Shuffle only within this high-quality set
    }
    
    // --- Smart Logic: Semantic Matching with CoreML ---
    private static func generateSemanticTechQuestions(resume: Resume, existing: Set<String>) -> [InterviewQuestion] {
        var generated: [InterviewQuestion] = []
        let allSkills = resume.skills.values.flatMap { $0 }
        
        // Provide a default embedding if on older iOS or model unavailable
        let embedding = NLEmbedding.wordEmbedding(for: .english)
        
        for skill in allSkills {
            let normalizedSkill = skill.lowercased().trimmingCharacters(in: .whitespaces)
            
            // 1. Try Exact Match first
            if let directQuestions = technicalQuestionsDB[normalizedSkill] {
                for dq in directQuestions {
                    generated.append(InterviewQuestion(question: dq.question, answer: dq.answer, type: .technical, context: "Skill: \(skill)"))
                }
                continue // Found exact match, move to next skill
            }
            
            // 2. Try Semantic Neighbor Match
            // Check if user's skill (e.g., "FastAPI") is close to a known key (e.g., "Python")
            if let embedding = embedding {
                for (knownKey, dbQuestions) in technicalQuestionsDB {
                    // Distance is 0.0 (identical) to 2.0 (far)
                    // We accept < 0.8 as "related"
                    if embedding.distance(between: normalizedSkill, and: knownKey) < 0.8 {
                        for dq in dbQuestions {
                             generated.append(InterviewQuestion(
                                question: dq.question,
                                answer: dq.answer,
                                type: .technical,
                                context: "Related to your skill: \(skill) (matched via CoreML)"
                             ))
                        }
                    }
                }
            }
        }
        
        return generated.shuffled()
    }
    
    private static func truncate(_ text: String, length: Int = 60) -> String {
        if text.count <= length { return text }
        return String(text.prefix(length)) + "..."
    }
    
    // Removed unused extractTags to simplify logic and rely on explicit skills + semantics
}

