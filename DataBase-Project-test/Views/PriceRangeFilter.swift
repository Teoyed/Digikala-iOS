import SwiftUI

struct PriceRangeFilter: View {
    @Binding var minPrice: Double
    @Binding var maxPrice: Double
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Price Range: $\(Int(minPrice)) - $\(Int(maxPrice))")
                .font(.caption)
            
            HStack {
                Text("$\(Int(minPrice))")
                Slider(value: $minPrice, in: 0...maxPrice)
                Text("$\(Int(maxPrice))")
            }
            
            HStack {
                Text("$\(Int(minPrice))")
                Slider(value: $maxPrice, in: minPrice...1000)
                Text("$\(Int(maxPrice))")
            }
        }
        .padding(.horizontal)
    }
} 