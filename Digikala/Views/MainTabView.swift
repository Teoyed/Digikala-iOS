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
    
    func login(token: String) {
        self.authToken = token
        self.isAuthenticated = true
        UserDefaults.standard.set(token, forKey: "authToken")
    }
    
    func logout() {
        self.authToken = nil
        self.isAuthenticated = false
        UserDefaults.standard.removeObject(forKey: "authToken")
    }
    
    func checkAuthStatus() {
        if let token = UserDefaults.standard.string(forKey: "authToken") {
            self.authToken = token
            self.isAuthenticated = true
        }
    }
} 