import SwiftUI

struct CategoriesView: View {
    @State private var categories = [
        "Electronics",
        "Clothing",
        "Home & Kitchen",
        "Books",
        "Sports",
        "Beauty",
        "Toys",
        "Grocery"
    ]
    @State private var searchText = ""
    @State private var selectedProduct: Product?
    
    var filteredCategories: [String] {
        if searchText.isEmpty {
            return categories
        } else {
            return categories.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            List(filteredCategories, id: \.self) { category in
                NavigationLink(destination: CategoryProductListView(category: category, selectedProduct: $selectedProduct)) {
                    HStack {
                        Text(category)
                            .font(.headline)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Categories")
            .searchable(text: $searchText, prompt: "Search categories")
            .sheet(item: $selectedProduct) { product in
                ProductDetailView(product: product)
            }
        }
    }
}

struct CategoryProductListView: View {
    let category: String
    @Binding var selectedProduct: Product?
    @State private var products: [Product] = []
    @State private var searchText = ""
    
    var filteredProducts: [Product] {
        if searchText.isEmpty {
            return products
        } else {
            return products.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        VStack {
            List(filteredProducts) { product in
                Button {
                    selectedProduct = product
                } label: {
                    ProductRow(product: product)
                }
            }
        }
        .navigationTitle(category)
        .searchable(text: $searchText, prompt: "Search products")
        .task {
            loadProducts()
        }
    }
    
    private func loadProducts() {
        products = MockData.getProducts(forCategory: category)
    }
}

struct ProductRow: View {
    let product: Product
    
    var body: some View {
        HStack {
            Image(product.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
                .cornerRadius(8)
            
            VStack(alignment: .leading) {
                Text(product.name)
                    .font(.headline)
                Text(product.manufacturer)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("$\(product.price)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
        }
        .padding(.vertical, 4)
    }
} 