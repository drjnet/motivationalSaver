// Models.swift
// MotivationalScreensaver

import Foundation

// MARK: - Quote Model

struct Quote: Codable {
    let content: String
    let author: String
    let tags: [String]

    var categoryDisplayName: String {
        guard let tag = tags.first else { return "INSPIRATION" }
        switch tag.lowercased() {
        case "success":                       return "SUCCESS"
        case "motivational", "inspirational": return "MINDSET"
        case "health", "happiness":           return "WELLNESS"
        case "leadership", "business":        return "LEADERSHIP"
        default:                              return tag.uppercased()
        }
    }

    static let fallbackQuotes: [Quote] = [
        Quote(content: "The only way to do great work is to love what you do.",
              author: "Steve Jobs", tags: ["success"]),
        Quote(content: "It does not matter how slowly you go as long as you do not stop.",
              author: "Confucius", tags: ["motivational"]),
        Quote(content: "The future belongs to those who believe in the beauty of their dreams.",
              author: "Eleanor Roosevelt", tags: ["inspirational"]),
        Quote(content: "You miss 100% of the shots you don't take.",
              author: "Wayne Gretzky", tags: ["success"]),
        Quote(content: "Whether you think you can or you think you can't, you're right.",
              author: "Henry Ford", tags: ["motivational"]),
        Quote(content: "The greatest wealth is health.",
              author: "Virgil", tags: ["health"]),
        Quote(content: "Leadership is not about being in charge. It is about taking care of those in your charge.",
              author: "Simon Sinek", tags: ["leadership"]),
        Quote(content: "In the middle of every difficulty lies opportunity.",
              author: "Albert Einstein", tags: ["motivational"]),
        Quote(content: "Success is not final, failure is not fatal: it is the courage to continue that counts.",
              author: "Winston Churchill", tags: ["success"]),
        Quote(content: "Take care of your body. It's the only place you have to live.",
              author: "Jim Rohn", tags: ["health"]),
        Quote(content: "The secret of getting ahead is getting started.",
              author: "Mark Twain", tags: ["success"]),
        Quote(content: "A leader is one who knows the way, goes the way, and shows the way.",
              author: "John C. Maxwell", tags: ["leadership"]),
        Quote(content: "Your time is limited, so don't waste it living someone else's life.",
              author: "Steve Jobs", tags: ["motivational"]),
        Quote(content: "It always seems impossible until it's done.",
              author: "Nelson Mandela", tags: ["inspirational"]),
        Quote(content: "Happiness is not something ready-made. It comes from your own actions.",
              author: "Dalai Lama", tags: ["happiness"]),
    ]
}

// MARK: - Quote Category

enum QuoteCategory: String, CaseIterable, Equatable {
    case success    = "success"
    case mindset    = "motivational"
    case health     = "health"
    case leadership = "leadership"

    var displayName: String {
        switch self {
        case .success:    return "Success & Achievement"
        case .mindset:    return "Mindset & Resilience"
        case .health:     return "Health & Wellness"
        case .leadership: return "Leadership & Business"
        }
    }

    var apiTags: [String] {
        switch self {
        case .success:    return ["success"]
        case .mindset:    return ["motivational", "inspirational"]
        case .health:     return ["health", "happiness"]
        case .leadership: return ["leadership", "business"]
        }
    }
}
