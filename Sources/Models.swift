// Models.swift
// MotivationalScreensaver

import Foundation

// MARK: - Quote Model

struct Quote: Codable {
    let content: String
    let author: String
    let tags: [String]

    var categoryDisplayName: String {
        // Use the first tag that maps to a known category — API quotes can have
        // multiple tags (e.g. ["success", "love"]) so we must not blindly take tags.first
        let known = ["success", "motivational", "inspirational",
                     "health", "happiness", "leadership", "business", "money", "investing"]
        let best = tags.first(where: { known.contains($0.lowercased()) }) ?? tags.first ?? ""
        switch best.lowercased() {
        case "success":                       return "SUCCESS"
        case "motivational", "inspirational": return "MINDSET"
        case "health", "happiness":           return "WELLNESS"
        case "leadership", "business":        return "LEADERSHIP"
        case "money", "investing":            return "TRADING & INVESTING"
        case "custom":                        return "MY QUOTES"
        default:                              return best.uppercased()
        }
    }

    static let fallbackQuotes: [Quote] = [

        // MARK: Success & Achievement
        Quote(content: "The only way to do great work is to love what you do.",
              author: "Steve Jobs", tags: ["success"]),
        Quote(content: "You miss 100% of the shots you don't take.",
              author: "Wayne Gretzky", tags: ["success"]),
        Quote(content: "Success is not final, failure is not fatal: it is the courage to continue that counts.",
              author: "Winston Churchill", tags: ["success"]),
        Quote(content: "The secret of getting ahead is getting started.",
              author: "Mark Twain", tags: ["success"]),
        Quote(content: "Success usually comes to those who are too busy to be looking for it.",
              author: "Henry David Thoreau", tags: ["success"]),
        Quote(content: "Don't be afraid to give up the good to go for the great.",
              author: "John D. Rockefeller", tags: ["success"]),
        Quote(content: "I find that the harder I work, the more luck I seem to have.",
              author: "Thomas Jefferson", tags: ["success"]),
        Quote(content: "The way to get started is to quit talking and begin doing.",
              author: "Walt Disney", tags: ["success"]),
        Quote(content: "Success is walking from failure to failure with no loss of enthusiasm.",
              author: "Winston Churchill", tags: ["success"]),
        Quote(content: "Opportunities don't happen. You create them.",
              author: "Chris Grosser", tags: ["success"]),

        // MARK: Mindset & Resilience
        Quote(content: "It does not matter how slowly you go as long as you do not stop.",
              author: "Confucius", tags: ["motivational"]),
        Quote(content: "Whether you think you can or you think you can't, you're right.",
              author: "Henry Ford", tags: ["motivational"]),
        Quote(content: "In the middle of every difficulty lies opportunity.",
              author: "Albert Einstein", tags: ["motivational"]),
        Quote(content: "Your time is limited, so don't waste it living someone else's life.",
              author: "Steve Jobs", tags: ["motivational"]),
        Quote(content: "The future belongs to those who believe in the beauty of their dreams.",
              author: "Eleanor Roosevelt", tags: ["inspirational"]),
        Quote(content: "It always seems impossible until it's done.",
              author: "Nelson Mandela", tags: ["inspirational"]),
        Quote(content: "Believe you can and you're halfway there.",
              author: "Theodore Roosevelt", tags: ["motivational"]),
        Quote(content: "The only limit to our realization of tomorrow is our doubts of today.",
              author: "Franklin D. Roosevelt", tags: ["motivational"]),
        Quote(content: "Act as if what you do makes a difference. It does.",
              author: "William James", tags: ["inspirational"]),
        Quote(content: "You are never too old to set another goal or to dream a new dream.",
              author: "C.S. Lewis", tags: ["inspirational"]),

        // MARK: Health & Wellness
        Quote(content: "The greatest wealth is health.",
              author: "Virgil", tags: ["health"]),
        Quote(content: "Take care of your body. It's the only place you have to live.",
              author: "Jim Rohn", tags: ["health"]),
        Quote(content: "Happiness is not something ready-made. It comes from your own actions.",
              author: "Dalai Lama", tags: ["happiness"]),
        Quote(content: "The first wealth is health.",
              author: "Ralph Waldo Emerson", tags: ["health"]),
        Quote(content: "It is health that is real wealth, and not pieces of gold and silver.",
              author: "Mahatma Gandhi", tags: ["health"]),
        Quote(content: "A healthy outside starts from the inside.",
              author: "Robert Urich", tags: ["health"]),
        Quote(content: "Happiness is when what you think, what you say, and what you do are in harmony.",
              author: "Mahatma Gandhi", tags: ["happiness"]),
        Quote(content: "To keep the body in good health is a duty, otherwise we shall not be able to keep our mind strong and clear.",
              author: "Buddha", tags: ["health"]),
        Quote(content: "Those who think they have no time for healthy eating will sooner or later have to find time for illness.",
              author: "Edward Stanley", tags: ["health"]),
        Quote(content: "The mind and body are not separate. What affects one, affects the other.",
              author: "Anonymous", tags: ["happiness"]),

        // MARK: Leadership & Business
        Quote(content: "Leadership is not about being in charge. It is about taking care of those in your charge.",
              author: "Simon Sinek", tags: ["leadership"]),
        Quote(content: "A leader is one who knows the way, goes the way, and shows the way.",
              author: "John C. Maxwell", tags: ["leadership"]),
        Quote(content: "The function of leadership is to produce more leaders, not more followers.",
              author: "Ralph Nader", tags: ["leadership"]),
        Quote(content: "Innovation distinguishes between a leader and a follower.",
              author: "Steve Jobs", tags: ["business"]),
        Quote(content: "Management is doing things right; leadership is doing the right things.",
              author: "Peter Drucker", tags: ["leadership"]),
        Quote(content: "Before you are a leader, success is all about growing yourself. When you become a leader, success is all about growing others.",
              author: "Jack Welch", tags: ["leadership"]),
        Quote(content: "A good leader takes a little more than his share of the blame and a little less than his share of the credit.",
              author: "Arnold H. Glasow", tags: ["leadership"]),
        Quote(content: "The greatest leader is not necessarily the one who does the greatest things. He is the one that gets the people to do the greatest things.",
              author: "Ronald Reagan", tags: ["leadership"]),
        Quote(content: "Leadership and learning are indispensable to each other.",
              author: "John F. Kennedy", tags: ["leadership"]),
        Quote(content: "Your most unhappy customers are your greatest source of learning.",
              author: "Bill Gates", tags: ["business"]),

        // MARK: Trading & Investing
        Quote(content: "The stock market is a device for transferring money from the impatient to the patient.",
              author: "Warren Buffett", tags: ["money"]),
        Quote(content: "In investing, what is comfortable is rarely profitable.",
              author: "Robert Arnott", tags: ["investing"]),
        Quote(content: "The four most dangerous words in investing are: 'This time it's different.'",
              author: "Sir John Templeton", tags: ["investing"]),
        Quote(content: "Know what you own, and know why you own it.",
              author: "Peter Lynch", tags: ["investing"]),
        Quote(content: "The most important quality for an investor is temperament, not intellect.",
              author: "Warren Buffett", tags: ["money"]),
        Quote(content: "Risk comes from not knowing what you're doing.",
              author: "Warren Buffett", tags: ["investing"]),
        Quote(content: "Price is what you pay. Value is what you get.",
              author: "Warren Buffett", tags: ["money"]),
        Quote(content: "The individual investor should act consistently as an investor and not as a speculator.",
              author: "Benjamin Graham", tags: ["investing"]),
        Quote(content: "It's not whether you're right or wrong that's important, but how much money you make when you're right and how much you lose when you're wrong.",
              author: "George Soros", tags: ["investing"]),
        Quote(content: "The market is a pendulum that forever swings between unsustainable optimism and unjustified pessimism.",
              author: "Benjamin Graham", tags: ["money"]),
    ]

    // MARK: - Custom Quote Parsing

    /// Parse a plain-text block (one quote per line, optional " — Author" suffix)
    /// into Quote values tagged as "custom".
    static func parseCustomQuotes(_ text: String) -> [Quote] {
        text.components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
            .compactMap { line -> Quote? in
                // Split on em-dash (—), en-dash (–), or " - " as author separator
                let separators = [" \u{2014} ", " \u{2013} ", " - "]
                for sep in separators {
                    if let range = line.range(of: sep) {
                        let content = String(line[..<range.lowerBound])
                            .trimmingCharacters(in: .whitespaces)
                        let author  = String(line[range.upperBound...])
                            .trimmingCharacters(in: .whitespaces)
                        if !content.isEmpty {
                            return Quote(content: content,
                                         author: author.isEmpty ? "Me" : author,
                                         tags: ["custom"])
                        }
                    }
                }
                // No separator found — whole line is the quote
                return Quote(content: line, author: "Me", tags: ["custom"])
            }
    }
}

// MARK: - Quote Category

enum QuoteCategory: String, CaseIterable, Equatable {
    case success    = "success"
    case mindset    = "motivational"
    case health     = "health"
    case leadership = "leadership"
    case trading    = "money"

    var displayName: String {
        switch self {
        case .success:    return "Success & Achievement"
        case .mindset:    return "Mindset & Resilience"
        case .health:     return "Health & Wellness"
        case .leadership: return "Leadership & Business"
        case .trading:    return "Trading & Investing"
        }
    }

    var apiTags: [String] {
        switch self {
        case .success:    return ["success"]
        case .mindset:    return ["motivational", "inspirational"]
        case .health:     return ["health", "happiness"]
        case .leadership: return ["leadership", "business"]
        case .trading:    return ["money"]
        }
    }
}
