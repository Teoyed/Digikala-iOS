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