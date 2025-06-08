import Foundation
import SwiftUI

class AuthManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    
    // Store registered users (in a real app, this would be in a database)
    private var registeredUsers: [String: (password: String, user: User)] = [
        "123": (
            password: "abc",
            user: User(
                id: 1,
                name: "Test User",
                phone: "123",
                addresses: [
                    User.Address(
                        id: 1,
                        street: "123 Test St",
                        city: "Testville",
                        state: "TS",
                        zipCode: "12345",
                        isDefault: true
                    )
                ]
            )
        )
    ]
    
    func signup(name: String, phone: String, password: String) -> Bool {
        // Check if user already exists
        if registeredUsers[phone] != nil {
            return false
        }
        
        // Create new user
        let newUser = User(
            id: registeredUsers.count + 1,
            name: name,
            phone: phone,
            addresses: []
        )
        
        // Register the user
        registeredUsers[phone] = (password: password, user: newUser)
        
        // Log them in
        self.currentUser = newUser
        self.isAuthenticated = true
        return true
    }
    
    func login(phone: String, password: String) {
        if let userData = registeredUsers[phone], userData.password == password {
            self.isAuthenticated = true
            self.currentUser = userData.user
            print("Login Successful!")
        } else {
            self.isAuthenticated = false
            self.currentUser = nil
            print("Login Failed: Invalid credentials.")
        }
    }
    
    func logout() {
        self.isAuthenticated = false
        self.currentUser = nil
        print("Logout Successful!")
    }
} 