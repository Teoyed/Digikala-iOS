import SwiftUI

struct HomeView: View {
    @State private var hotPicks: [Product] = []
    @State private var bestOffers: [Product] = []
    @State private var seasonalBuys: [Product] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var searchText = ""
    @State private var selectedProduct: Product?
    
    var filteredProducts: [Product] {
        let allProducts = hotPicks + bestOffers + seasonalBuys
        if searchText.isEmpty {
            return []
        } else {
            return allProducts.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    if isLoading {
                        ProgressView()
                    } else if let error = errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                    } else {
                        if !searchText.isEmpty {
                            // Show search results
                            VStack(alignment: .leading) {
                                Text("Search Results")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .padding(.horizontal)
                                
                                LazyVGrid(columns: [
                                    GridItem(.flexible()),
                                    GridItem(.flexible())
                                ], spacing: 15) {
                                    ForEach(filteredProducts) { product in
                                        Button {
                                            selectedProduct = product
                                        } label: {
                                            ProductCard(product: product)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                        } else {
                            // Show regular sections
                            ProductSection(title: "Hot Picks", products: hotPicks, selectedProduct: $selectedProduct)
                            ProductSection(title: "Best Offers", products: bestOffers, selectedProduct: $selectedProduct)
                            ProductSection(title: "Seasonal Buys", products: seasonalBuys, selectedProduct: $selectedProduct)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Shop")
            .searchable(text: $searchText, prompt: "Search products")
            .sheet(item: $selectedProduct) { product in
                ProductDetailView(product: product)
            }
            .task {
                await loadProducts()
            }
        }
    }
    
    private func loadProducts() async {
        isLoading = true
        errorMessage = nil
        
        do {
            // In a real app, these would be different API endpoints
            hotPicks = try await APIClient.shared.fetchProducts()
            bestOffers = try await APIClient.shared.fetchProducts()
            seasonalBuys = try await APIClient.shared.fetchProducts()
        } catch {
            errorMessage = "Failed to load products: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}

struct ProductSection: View {
    let title: String
    let products: [Product]
    @Binding var selectedProduct: Product?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(products) { product in
                        Button {
                            selectedProduct = product
                        } label: {
                            ProductCard(product: product)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct ProductCard: View {
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: product.imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
            }
            .frame(width: 150, height: 150)
            .cornerRadius(10)
            
            Text(product.name)
                .font(.subheadline)
                .lineLimit(2)
            
            Text("$\(String(format: "%.2f", product.price))")
                .font(.headline)
            
            Text(product.manufacturer)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(width: 150)
    }
} 