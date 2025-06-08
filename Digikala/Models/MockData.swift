import Foundation

struct MockData {
    static let products: [Product] = [
        Product(id: 1, name: "Apple iPhone 14", price: "899.00", manufacturer: "Apple", imageName: "test", category: "Electronics", description: "The latest iPhone with incredible features."),
        Product(id: 2, name: "Samsung Galaxy S23", price: "799.00", manufacturer: "Samsung", imageName: "test", category: "Electronics", description: "Experience the next level of mobile technology."),
        Product(id: 3, name: "MacBook Air M2", price: "1299.00", manufacturer: "Apple", imageName: "test", category: "Computers", description: "Powerful and portable, redesigned for M2."),
        Product(id: 4, name: "Dell XPS 15", price: "1599.00", manufacturer: "Dell", imageName: "test", category: "Computers", description: "High-performance laptop for creators."),
        Product(id: 5, name: "Sony WH-1000XM5", price: "349.00", manufacturer: "Sony", imageName: "test", category: "Audio", description: "Industry-leading noise-canceling headphones."),
        Product(id: 6, name: "Bose QuietComfort Earbuds II", price: "299.00", manufacturer: "Bose", imageName: "test", category: "Audio", description: "World-class noise cancellation and sound."),
        Product(id: 7, name: "Nike Air Zoom Pegasus 40", price: "120.00", manufacturer: "Nike", imageName: "test", category: "Sports", description: "Responsive and comfortable running shoes."),
        Product(id: 8, name: "Adidas Ultraboost 23", price: "190.00", manufacturer: "Adidas", imageName: "test", category: "Sports", description: "Energy-returning cushioning for an effortless ride."),
        Product(id: 9, name: "Kindle Paperwhite", price: "139.00", manufacturer: "Amazon", imageName: "test", category: "Books", description: "Read comfortably with a glare-free display."),
        Product(id: 10, name: "The Lord of the Rings Box Set", price: "50.00", manufacturer: "HarperCollins", imageName: "test", category: "Books", description: "The epic fantasy masterpiece in one collection."),
        Product(id: 11, name: "Instant Pot Duo Nova", price: "99.00", manufacturer: "Instant Brands", imageName: "test", category: "Home & Kitchen", description: "7-in-1 multi-use pressure cooker."),
        Product(id: 12, name: "Dyson V15 Detect Absolute", price: "749.00", manufacturer: "Dyson", imageName: "test", category: "Home & Kitchen", description: "Powerful, intelligent, and cord-free vacuum cleaner."),
        Product(id: 13, name: "Levi's 501 Original Fit Jeans", price: "69.50", manufacturer: "Levi's", imageName: "test", category: "Clothing", description: "The original blue jean since 1873."),
        Product(id: 14, name: "Columbia Fleece Jacket", price: "50.00", manufacturer: "Columbia", imageName: "test", category: "Clothing", description: "Warm and versatile fleece jacket for outdoor adventures."),
        Product(id: 15, name: "LEGO Creator Expert NASA Apollo 11 Lunar Lander", price: "99.99", manufacturer: "LEGO", imageName: "test", category: "Toys", description: "Build and display an iconic space exploration vehicle."),
        Product(id: 16, name: "Barbie Dreamhouse", price: "199.99", manufacturer: "Mattel", imageName: "test", category: "Toys", description: "Three stories, 10 indoor and outdoor living areas."),
        Product(id: 17, name: "Neutrogena Hydro Boost Water Gel", price: "18.00", manufacturer: "Neutrogena", imageName: "test", category: "Beauty", description: "Quenches dry skin and keeps it looking smooth."),
        Product(id: 18, name: "The Ordinary Niacinamide 10% + Zinc 1%", price: "5.90", manufacturer: "The Ordinary", imageName: "test", category: "Beauty", description: "High-strength vitamin and mineral blemish formula."),
        Product(id: 19, name: "Organic Bananas (1 lb)", price: "0.79", manufacturer: "Fresh Farms", imageName: "test", category: "Grocery", description: "Naturally sweet and packed with potassium."),
        Product(id: 20, name: "Whole Wheat Bread", price: "3.49", manufacturer: "Healthy Grains", imageName: "test", category: "Grocery", description: "Baked fresh daily with whole grains.")
    ]

    static func getProducts(forCategory category: String? = nil) -> [Product] {
        if let category = category {
            return products.filter { $0.category == category }
        }
        return products
    }
} 