import Foundation

struct Product: Identifiable, Codable {
    let id: Int
    let name: String
    let price: String
    let manufacturer: String
    let imageURL: String
    let category: String
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case price
        case manufacturer
        case imageURL = "image_url"
        case category
        case description
    }
} 