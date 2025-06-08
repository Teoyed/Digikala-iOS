import Foundation
import SwiftUI

class AuthManager: ObservableObject {
    @Published var isAuthenticated = false
    
    // This is a test comment to force recompilation
    func login(phone: String, password: String) {
        // For prototype, simply check against hardcoded credentials
        if phone == "123" && password == "abc" {
            self.isAuthenticated = true
            print("Mock Login Successful!")
        } else {
            self.isAuthenticated = false
            print("Mock Login Failed: Invalid credentials.")
        }
    }
    
    func logout() {
        self.isAuthenticated = false
        print("Mock Logout Successful!")
    }
} 