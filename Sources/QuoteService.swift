// QuoteService.swift
// MotivationalScreensaver
//
// Uses the free quotable.io API — no API key required.

import Foundation

final class QuoteService {

    static let shared = QuoteService()
    private init() {}

    private struct QuotableQuote: Codable {
        let content: String
        let author: String
        let tags: [String]
    }

    func fetchQuotes(for categories: [QuoteCategory],
                     completion: @escaping ([Quote]) -> Void) {

        let allTags   = categories.flatMap { $0.apiTags }
        let tagString = Array(Set(allTags)).joined(separator: "|")

        guard let url = URL(string: "https://api.quotable.io/quotes/random?limit=50&tags=\(tagString)") else {
            DispatchQueue.main.async { completion([]) }
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async { completion([]) }
                return
            }
            do {
                let raw    = try JSONDecoder().decode([QuotableQuote].self, from: data)
                let quotes = raw.map { Quote(content: $0.content, author: $0.author, tags: $0.tags) }
                DispatchQueue.main.async { completion(quotes.shuffled()) }
            } catch {
                DispatchQueue.main.async { completion([]) }
            }
        }.resume()
    }
}
