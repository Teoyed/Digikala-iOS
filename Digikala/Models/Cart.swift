import Foundation

struct CartItem: Identifiable, Codable {
    let id: Int
    let productId: Int
    var quantity: Int
    let product: Product
    
    enum CodingKeys: String, CodingKey {
        case id
        case productId = "product_id"
        case quantity
        case product
    }
}

struct Cart: Codable {
    var items: [CartItem]
    
    var total: Double {
        items.reduce(0) { sum, item in
            let price = Double(item.product.price) ?? 0
            return sum + (price * Double(item.quantity))
        }
    }
}

class CartManager: ObservableObject {
    @Published var cart: Cart? = nil
    @Published var isLoading = false
    @Published var error: String? = nil
    static let shared = CartManager()
    private init() {}
    
    @MainActor
    func fetchCart() async {
        isLoading = true
        error = nil
        do {
            let cart = try await APIClient.shared.fetchCart()
            self.cart = cart
        } catch {
            self.error = error.localizedDescription
        }
        isLoading = false
    }
    
    @MainActor
    func addToCart(productId: Int, quantity: Int, userId: Int) async {
        isLoading = true
        error = nil
        do {
            try await APIClient.shared.addToCart(productId: productId, quantity: quantity, userId: userId)
            await fetchCart()
        } catch {
            self.error = error.localizedDescription
        }
        isLoading = false
    }
    
    @MainActor
    func removeFromCart(itemId: Int) async {
        isLoading = true
        error = nil
        do {
            try await APIClient.shared.removeFromCart(itemId: itemId)
            await fetchCart()
        } catch {
            self.error = error.localizedDescription
        }
        isLoading = false
    }
    
    @MainActor
    func updateQuantity(itemId: Int, quantity: Int) async {
        isLoading = true
        error = nil
        do {
            try await APIClient.shared.updateCartItem(itemId: itemId, quantity: quantity)
            await fetchCart()
        } catch {
            self.error = error.localizedDescription
        }
        isLoading = false
    }
} 