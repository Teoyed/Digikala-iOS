import Foundation

enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case decodingError(Error)
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
    func login(credentials: LoginCredentials) async throws -> String {
        guard let url = URL(string: "\(baseURL)/login") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(credentials)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode([String: String].self, from: data)
        guard let token = response["token"] else {
            throw APIError.invalidResponse
        }
        return token
    }
    
    func signup(credentials: SignupCredentials) async throws -> String {
        guard let url = URL(string: "\(baseURL)/signup") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(credentials)
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode([String: String].self, from: data)
        guard let token = response["token"] else {
            throw APIError.invalidResponse
        }
        return token
    }
    
    // MARK: - Cart
    func fetchCart() async throws -> Cart {
        guard let url = URL(string: "\(baseURL)/cart") else {
            throw APIError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(Cart.self, from: data)
    }
    
    func addToCart(productId: Int, quantity: Int) async throws {
        guard let url = URL(string: "\(baseURL)/cart") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["product_id": productId, "quantity": quantity]
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