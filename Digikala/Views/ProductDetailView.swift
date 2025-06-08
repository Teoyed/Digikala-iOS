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
                Image(product.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
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
                        
                        Text("$\(product.price)")
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
            // For prototype, no need to check userId from AuthManager.
            // A mock userId can be passed as CartManager now handles data locally.
            await cartManager.addToCart(productId: product.id, quantity: quantity, userId: 1) // Using a mock userId of 1
            showingAddToCartAlert = true
        }
    }
} 