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