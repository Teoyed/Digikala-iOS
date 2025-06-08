import SwiftUI

struct CartView: View {
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var authManager: AuthManager
    @State private var showingCheckoutAlert = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(cartManager.cart.items) { item in
                    CartItemRow(item: item)
                }
                .onDelete { indexSet in
                    Task {
                        for index in indexSet {
                            let itemId = cartManager.cart.items[index].id
                            await cartManager.removeFromCart(itemId: itemId)
                        }
                    }
                }
                
                if !cartManager.cart.items.isEmpty { // Only show this section if there are items
                    Section {
                        HStack {
                            Text("Total")
                                .font(.headline)
                            Spacer()
                            Text("$\(String(format: "%.2f", cartManager.cart.total))")
                                .font(.headline)
                                .foregroundColor(.blue)
                        }
                        
                        Button {
                            showingCheckoutAlert = true
                        } label: {
                            Text("Place Order")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
            }
            .overlay(Group {
                if cartManager.cart.items.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "cart")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("Your cart is empty")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                }
            })
            .navigationTitle("Cart")
            .task {
                await cartManager.fetchCart()
            }
            .refreshable {
                await cartManager.fetchCart()
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
    @EnvironmentObject var cartManager: CartManager
    
    init(item: CartItem) {
        self.item = item
        _quantity = State(initialValue: item.quantity)
    }
    
    var body: some View {
        HStack {
            Image(item.product.imageNames[0])
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 60, height: 60)
                .cornerRadius(8)
            
            VStack(alignment: .leading) {
                Text(item.product.name)
                    .font(.headline)
                Text(item.product.manufacturer)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("$\(item.product.price)")
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }
            
            Spacer()
            
            HStack(spacing: 12) {
                Text("\(quantity)")
                    .font(.headline)
                    .foregroundColor(.blue)
                    .frame(minWidth: 30)
                Stepper("", value: $quantity, in: 1...10)
                    .labelsHidden()
                    .onChange(of: quantity) { _, newValue in
                        Task {
                            // Check if quantity has actually changed to avoid unnecessary API calls
                            if newValue != item.quantity {
                                await cartManager.updateQuantity(itemId: item.id, quantity: newValue)
                            }
                        }
                    }
            }
        }
        .padding(.vertical, 4)
    }
}

struct CheckoutView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var cartManager = CartManager.shared
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Checkout functionality will be implemented here")
                    .font(.headline)
                    .foregroundColor(.gray)
            }
            .navigationTitle("Checkout")
            .navigationBarItems(trailing: Button("Done") {
                dismiss()
            })
        }
    }
}

#Preview {
    CartView()
} 