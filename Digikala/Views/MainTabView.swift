import SwiftUI

struct MainTabView: View {
    @StateObject private var authManager = AuthManager()
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            CategoriesView()
                .tabItem {
                    Label("Categories", systemImage: "list.bullet")
                }
            
            CartView()
                .tabItem {
                    Label("Cart", systemImage: "cart.fill")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
        .environmentObject(authManager)
    }
}

class AuthManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var authToken: String?
    @Published var userId: Int?
    
    func login(token: String, userId: Int) {
        self.authToken = token
        self.userId = userId
        self.isAuthenticated = true
        UserDefaults.standard.set(token, forKey: "authToken")
        UserDefaults.standard.set(userId, forKey: "userId")
    }
    
    func logout() {
        self.authToken = nil
        self.userId = nil
        self.isAuthenticated = false
        UserDefaults.standard.removeObject(forKey: "authToken")
        UserDefaults.standard.removeObject(forKey: "userId")
    }
    
    func checkAuthStatus() {
        if let token = UserDefaults.standard.string(forKey: "authToken"),
           let userId = UserDefaults.standard.integer(forKey: "userId") as Int? {
            self.authToken = token
            self.userId = userId
            self.isAuthenticated = true
        }
    }
} 