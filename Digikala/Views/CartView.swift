import SwiftUI

struct CartView: View {
    @State private var cart: Cart?
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showingCheckoutAlert = false
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    ProgressView()
                } else if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                } else if let cart = cart, !cart.items.isEmpty {
                    List {
                        ForEach(cart.items) { item in
                            CartItemRow(item: item)
                        }
                        
                        Section {
                            HStack {
                                Text("Total")
                                    .font(.headline)
                                Spacer()
                                Text("$\(String(format: "%.2f", cart.total))")
                                    .font(.headline)
                            }
                            
                            Button(action: checkout) {
                                Text("Place Order")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                        }
                    }
                } else {
                    VStack(spacing: 20) {
                        Image(systemName: "cart")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("Your cart is empty")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Cart")
            .task {
                await loadCart()
            }
            .alert("Checkout", isPresented: $showingCheckoutAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                if authManager.isAuthenticated {
                    Text("Your order has been placed!")
                } else {
                    Text("Please log in to place an order")
                }
            }
        }
    }
    
    private func loadCart() async {
        isLoading = true
        errorMessage = nil
        
        do {
            cart = try await APIClient.shared.fetchCart()
        } catch {
            errorMessage = "Failed to load cart: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    private func checkout() {
        if authManager.isAuthenticated {
            // In a real app, this would make an API call to place the order
            showingCheckoutAlert = true
        } else {
            showingCheckoutAlert = true
        }
    }
}

struct CartItemRow: View {
    let item: CartItem
    @State private var quantity: Int
    
    init(item: CartItem) {
        self.item = item
        _quantity = State(initialValue: item.quantity)
    }
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: item.product.imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
            }
            .frame(width: 60, height: 60)
            .cornerRadius(8)
            
            VStack(alignment: .leading) {
                Text(item.product.name)
                    .font(.headline)
                Text(item.product.manufacturer)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("$\(String(format: "%.2f", item.product.price))")
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            
            Spacer()
            
            Stepper("\(quantity)", value: $quantity, in: 1...10)
                .onChange(of: quantity) { oldValue, newValue in
                    // In a real app, this would update the cart via API
                    print("Updated quantity to \(newValue)")
                }
        }
        .padding(.vertical, 4)
    }
} 