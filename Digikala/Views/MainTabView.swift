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