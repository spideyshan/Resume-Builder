import Foundation
import NaturalLanguage

struct SmartTextAnalyzer {
    
    /// Analyzes the tone of the text to determine if it is formal or casual.
    /// Returns a score from -1.0 (very casual/negative) to 1.0 (very formal/positive).
    /// Note: NLTagger sentiment score is actually -1 (negative) to 1 (positive).
    /// We will use it as a proxy for "professionalism" in this context, assuming positive sentiment correlates with confident, professional language.
    static func analyzeTone(text: String) -> Double {
        let tagger = NLTagger(tagSchemes: [.sentimentScore])
        tagger.string = text
        let (sentiment, _) = tagger.tag(at: text.startIndex, unit: .paragraph, scheme: .sentimentScore)
        return Double(sentiment?.rawValue ?? "0") ?? 0.0
    }
    
    /// Finds synonyms or related professional terms for a given word using Word Embeddings.
    /// This helps suggestions (e.g., "managed" -> "orchestrated", "led").
    static func findBetterSynonyms(for word: String) -> [String] {
        guard let embedding = NLEmbedding.wordEmbedding(for: .english) else { return [] }
        
        // Find 5 neighbors, filter for words that are not the same stem if possible, but keep it simple for now.
        return embedding.neighbors(for: word, maximumCount: 10).map { $0.0 }
    }
    
    /// Calculates a semantic score (0.0 to 1.0) based on how closely the text aligns with professional concepts.
    /// Uses NLEmbedding to compare resume keywords against a set of "Golden" professional terms.
    static func calculateSemanticScore(text: String) -> Double {
        guard let embedding = NLEmbedding.wordEmbedding(for: .english) else { return 0.0 }
        
        let keywords = extractKeywords(from: text)
        guard !keywords.isEmpty else { return 0.0 }
        
        // "Golden Vector" concepts - words that represent high-value professional traits
        let professionalTerms = [
            "accomplished", "achieved", "adapted", "administered", "analyzed", "assessed",
            "budgeted", "built", "collaborated", "communicated", "completed", "coordinated",
            "created", "delegated", "delivered", "designed", "developed", "directed", "earned",
            "effective", "efficient", "engineered", "established", "evaluated", "expanded",
            "experience", "expertise", "facilitated", "formulated", "generated", "guided",
            "impact", "implemented", "improved", "increased", "initiated", "innovated",
            "integrated", "launched", "led", "managed", "mentored", "negotiated", "organized",
            "oversaw", "planned", "presented", "produced", "proficiency", "programmed",
            "project", "promoted", "proposed", "reduced", "resolved", "revenue", "saved",
            "solved", "spearheaded", "strategic", "streamlined", "supervised", "supported",
            "target", "taught", "team", "technical", "tested", "trained", "upgraded",
            "utilized", "won", "wrote"
        ]
        
        var totalScore = 0.0
        var matchCount = 0
        
        // For each keyword in the resume, find its similarity to the closest professional term.
        // We limit to the top 20 keywords to avoid noise from common nouns.
        let significantKeywords = keywords.prefix(50)
        
        for word in significantKeywords {
            var maxSimilarity = 0.0
            
            // Optimization: Only check against a subset if performance is an issue, 
            // but 70 terms * 50 keywords = 3500 comparisons is fast for NLEmbedding.
            for term in professionalTerms {
                let distance = embedding.distance(between: word, and: term)
                // distance is typically 0.0 (same) to ~2.0 (far).
                // We interpret distance < 1.0 as "somewhat related".
                let similarity = 1.0 - distance
                if similarity > maxSimilarity {
                    maxSimilarity = similarity
                }
            }
            
            // Only count if it has some relevance (similarity > 0.3)
            if maxSimilarity > 0.3 {
                totalScore += maxSimilarity
                matchCount += 1
            }
        }
        
        // Normalize: If 20% of your words are "strong", that's a good resume.
        // Let's say if we have 10 strong matches, we are doing well.
        // We cap the score at 1.0.
        let normalizedScore = min(Double(matchCount) * 0.1, 1.0)
        
        return normalizedScore
    }
    
    /// Extracts likely skills or keywords from a block of text (e.g. job description).
    static func extractKeywords(from text: String) -> [String] {
        let tagger = NLTagger(tagSchemes: [.nameType, .lemma])
        tagger.string = text
        var keywords: [String] = []
        
        // We look for Nouns and specific named entities which might be technologies.
        // Since .nameType is limited, we can also just look for significant words.
        let options: NLTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]
        
        tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: .lemma, options: options) { tag, tokenRange in
            if tag != nil {
                let word = String(text[tokenRange])
                // Filter out common stop words if needed, or rely on length
                if word.count > 3 { 
                    keywords.append(word.lowercased())
                }
            }
            return true
        }
        
        return Array(Set(keywords)) // Unique
    }
}
