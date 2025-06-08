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
    @Published var cart: Cart = Cart(items: []) // Initialize with an empty cart
    static let shared = CartManager()
    private var nextItemId: Int = 1 // New property for generating unique IDs

    private init() {}
    
    @MainActor
    func fetchCart() async {
        // For prototype, no actual fetching from API. Simulate empty cart or load mock data.
        // If you want to start with some mock data, you can uncomment the following:
        /*
        self.cart = Cart(items: [
            CartItem(id: 1, productId: 1, quantity: 1, product: Product(id: 1, name: "Sample Product 1", price: "19.99", manufacturer: "ProtoCo", imageURL: "https://example.com/sample1.jpg", category: "Mock", description: "A sample product for prototyping.")),
            CartItem(id: 2, productId: 2, quantity: 2, product: Product(id: 2, name: "Sample Product 2", price: "29.99", manufacturer: "ProtoCo", imageURL: "https://example.com/sample2.jpg", category: "Mock", description: "Another sample product."))
        ])
        */
        // For now, we'll keep it empty and rely on addToCart to populate
    }
    
    @MainActor
    func addToCart(productId: Int, quantity: Int, userId: Int) async {
        if let existingItemIndex = cart.items.firstIndex(where: { $0.productId == productId }) {
            cart.items[existingItemIndex].quantity += quantity
        } else if let productToAdd = MockData.products.first(where: { $0.id == productId }) {
            // Use the actual product details from MockData
            let newItem = CartItem(id: nextItemId, productId: productId, quantity: quantity, product: productToAdd)
            cart.items.append(newItem)
            nextItemId += 1 // Increment for next item
        } else {
            // Fallback for unexpected product ID, though it shouldn't happen with current setup
            print("Error: Product with ID \(productId) not found in MockData.")
            // Optionally, you could still add a generic mock product here or show an error
        }
    }
    
    @MainActor
    func removeFromCart(itemId: Int) async {
        cart.items.removeAll(where: { $0.id == itemId })
    }
    
    @MainActor
    func updateQuantity(itemId: Int, quantity: Int) async {
        if let index = cart.items.firstIndex(where: { $0.id == itemId }) {
            cart.items[index].quantity = quantity
        }
    }
} 