import Foundation

struct User: Codable {
    let id: Int
    var name: String
    var phone: String
    var addresses: [Address]
    
    struct Address: Codable, Identifiable {
        let id: Int
        var street: String
        var city: String
        var state: String
        var zipCode: String
        var isDefault: Bool
        
        enum CodingKeys: String, CodingKey {
            case id
            case street
            case city
            case state
            case zipCode = "zip_code"
            case isDefault = "is_default"
        }
    }
}

struct LoginCredentials: Codable {
    let phone: String
    let password: String
}

struct SignupCredentials: Codable {
    let name: String
    let phone: String
    let password: String
} 