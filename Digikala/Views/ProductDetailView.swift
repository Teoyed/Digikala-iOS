import SwiftUI

struct ProductDetailView: View {
    let product: Product
    @State private var quantity = 1
    @State private var showingAddToCartAlert = false
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var cartManager: CartManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Product Image
                AsyncImage(url: URL(string: product.imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                }
                .frame(height: 300)
                .clipped()
                
                // Product Details
                VStack(alignment: .leading, spacing: 16) {
                    // Header
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(product.name)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            Text(product.manufacturer)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Text("$\(String(format: "%.2f", product.price))")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                    
                    Divider()
                    
                    // Description
                    Text("Description")
                        .font(.headline)
                        .padding(.top, 8)
                    
                    Text(product.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    Divider()
                    
                    // Quantity and Add to Cart
                    VStack(spacing: 16) {
                        HStack {
                            Text("Quantity")
                                .font(.headline)
                            Spacer()
                            Stepper("\(quantity)", value: $quantity, in: 1...10)
                                .labelsHidden()
                        }
                        
                        Button(action: addToCart) {
                            HStack {
                                Image(systemName: "cart.badge.plus")
                                Text("Add to Cart")
                            }
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                        }
                    }
                }
                .padding()
            }
        }
        .ignoresSafeArea(edges: .top)
        .alert("Added to Cart", isPresented: $showingAddToCartAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("\(quantity) \(product.name) added to your cart")
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .font(.title3)
                }
            }
        }
    }
    
    private func addToCart() {
        Task {
            guard let userId = authManager.userId else {
                // Handle case where user is not logged in
                print("User not logged in. Cannot add to cart.")
                // Optionally show an alert to the user
                return
            }
            await cartManager.addToCart(productId: product.id, quantity: quantity, userId: userId)
            showingAddToCartAlert = true
        }
    }
} 