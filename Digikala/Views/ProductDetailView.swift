import SwiftUI

struct ProductDetailView: View {
    let product: Product
    @State private var quantity = 1
    @State private var showingAddToCartAlert = false
    @State private var selectedImageIndex = 0
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var cartManager: CartManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Product Image Gallery
                VStack(spacing: 12) {
                    // Main Image
                    Image(product.imageNames[selectedImageIndex])
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 300)
                        .clipped()
                    
                    // Thumbnail Gallery
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(0..<product.imageNames.count, id: \.self) { index in
                                Button(action: {
                                    selectedImageIndex = index
                                }) {
                                    Image(product.imageNames[index])
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 60, height: 60)
                                        .cornerRadius(8)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(selectedImageIndex == index ? Color.blue : Color.clear, lineWidth: 2)
                                        )
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                
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
                            HStack(spacing: 12) {
                                Text("\(quantity)")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                    .frame(minWidth: 30)
                                Stepper("", value: $quantity, in: 1...10)
                                    .labelsHidden()
                            }
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