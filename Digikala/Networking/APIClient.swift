import Foundation

enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case decodingError(Error)
}

// New struct for authentication response
struct AuthResponse: Codable {
    let token: String
    let userId: Int
    
    enum CodingKeys: String, CodingKey {
        case token
        case userId = "user_id" // Assuming your backend sends 'user_id'
    }
}

class APIClient {
    static let shared = APIClient()
    private let baseURL = "http://localhost:3000/api"
    
    private init() {}
    
    // MARK: - Products
    func fetchProducts(category: String? = nil) async throws -> [Product] {
        var urlString = "\(baseURL)/products"
        if let category = category {
            urlString += "?category=\(category)"
        }
        
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        print(String(data: data, encoding: .utf8) ?? "No data")
        return try JSONDecoder().decode([Product].self, from: data)
    }
    
    // MARK: - Authentication
    func login(credentials: LoginCredentials) async throws -> (token: String, userId: Int) {
        guard let url = URL(string: "\(baseURL)/login") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(credentials)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        print("Raw Login Data: \(String(data: data, encoding: .utf8) ?? "Unable to decode login data")")
        let authResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
        return (authResponse.token, authResponse.userId)
    }
    
    func signup(credentials: SignupCredentials) async throws -> (token: String, userId: Int) {
        guard let url = URL(string: "\(baseURL)/signup") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(credentials)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        print("Raw Signup Data: \(String(data: data, encoding: .utf8) ?? "Unable to decode signup data")")
        let authResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
        return (authResponse.token, authResponse.userId)
    }
    
    // MARK: - Cart
    func fetchCart() async throws -> Cart {
        guard let url = URL(string: "\(baseURL)/cart") else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard httpResponse.statusCode == 200 else {
            // Attempt to read error message from response if available
            if let errorMessage = String(data: data, encoding: .utf8) {
                print("API Error Status Code: \(httpResponse.statusCode), Message: \(errorMessage)")
            } else {
                print("API Error Status Code: \(httpResponse.statusCode), No error message provided.")
            }
            throw APIError.invalidResponse // Or a more specific error
        }

        print("Raw Cart Data: \(String(data: data, encoding: .utf8) ?? "Unable to decode data")")
        return try JSONDecoder().decode(Cart.self, from: data)
    }
    
    func addToCart(productId: Int, quantity: Int, userId: Int) async throws {
        guard let url = URL(string: "\(baseURL)/cart") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["product_id": productId, "quantity": quantity, "user_id": userId]
        request.httpBody = try JSONEncoder().encode(body)
        
        _ = try await URLSession.shared.data(for: request)
    }
    
    func removeFromCart(itemId: Int) async throws {
        guard let url = URL(string: "\(baseURL)/cart/\(itemId)") else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        _ = try await URLSession.shared.data(for: request)
    }
    
    func updateCartItem(itemId: Int, quantity: Int) async throws {
        guard let url = URL(string: "\(baseURL)/cart/\(itemId)") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["quantity": quantity]
        request.httpBody = try JSONEncoder().encode(body)
        
        _ = try await URLSession.shared.data(for: request)
    }
    
    // MARK: - Profile
    func fetchProfile() async throws -> User {
        guard let url = URL(string: "\(baseURL)/profile") else {
            throw APIError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(User.self, from: data)
    }
    
    func updateProfile(_ user: User) async throws {
        guard let url = URL(string: "\(baseURL)/profile") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(user)
        
        _ = try await URLSession.shared.data(for: request)
    }
} 
