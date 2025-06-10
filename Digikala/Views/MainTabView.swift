import SwiftUI

struct MainTabView: View {
    @StateObject private var authManager = AuthManager()
    @StateObject private var cartManager = CartManager.shared
    @State private var selectedTab = 0
    @Namespace private var namespace

    private let tabIcons = ["house.fill", "list.bullet", "cart.fill", "person.fill"]

    init() {
        UITabBar.appearance().isHidden = true
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tag(0)
                    .environmentObject(authManager)
                    .environmentObject(cartManager)

                CategoriesView()
                    .tag(1)
                    .environmentObject(authManager)
                    .environmentObject(cartManager)

                CartView()
                    .tag(2)
                    .environmentObject(authManager)
                    .environmentObject(cartManager)

                ProfileView()
                    .tag(3)
                    .environmentObject(authManager)
                    .environmentObject(cartManager)
            }

            customTabBar
        }
    }

    private var customTabBar: some View {
        HStack(spacing: 0) {
            ForEach(0..<tabIcons.count, id: \.self) { index in
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = index
                    }
                }) {
                    Image(systemName: tabIcons[index])
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(selectedTab == index ? .white : .gray)
                        .frame(width: 44, height: 44)
                        .background(
                            ZStack {
                                if selectedTab == index {
                                    Capsule()
                                        .fill(.ultraThinMaterial)
                                        .background(
                                            Capsule()
                                                .strokeBorder(Color.white.opacity(0.2), lineWidth: 1)
                                        )
                                        .matchedGeometryEffect(id: "tab", in: namespace)
                                        .shadow(color: .white.opacity(0.15), radius: 4, x: 0, y: 2)
                                }
                            }
                        )
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .shadow(radius: 10)
        .padding(.horizontal, 10)
    }
}

#Preview {
    MainTabView()
}
