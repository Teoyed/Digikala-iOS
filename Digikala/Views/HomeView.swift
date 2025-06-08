import SwiftUI

struct HomeView: View {
    @State private var hotPicks: [Product] = []
    @State private var bestOffers: [Product] = []
    @State private var seasonalBuys: [Product] = []
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
                .padding()
            }
            .navigationTitle("Shop")
            .searchable(text: $searchText, prompt: "Search products")
            .sheet(item: $selectedProduct) { product in
                ProductDetailView(product: product)
            }
            .task {
                loadProducts()
            }
        }
    }
    
    private func loadProducts() {
        hotPicks = MockData.getProducts(forCategory: "Electronics")
        bestOffers = MockData.getProducts(forCategory: "Audio")
        seasonalBuys = MockData.getProducts(forCategory: "Sports")
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
            Image(product.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150)
                .cornerRadius(10)
            
            Text(product.name)
                .font(.subheadline)
                .lineLimit(2)
            
            Text("$\(product.price)")
                .font(.headline)
            
            Text(product.manufacturer)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(width: 150)
    }
} 