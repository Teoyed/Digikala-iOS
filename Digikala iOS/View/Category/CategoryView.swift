//
//  ExploreView.swift
//  Digikala iOS
//
//  Created by Reza Ahmadizadeh on 3/12/1404 AP.
//

import SwiftUI

struct CategoryView: View {
    
    let categories: [Category] = [
            Category(name: "Electronics", icon: "iphone"),
            Category(name: "Fashion", icon: "tshirt"),
            Category(name: "Home", icon: "bed.double"),
            Category(name: "Beauty", icon: "sparkles"),
            Category(name: "Grocery", icon: "cart"),
            Category(name: "Books", icon: "book"),
            Category(name: "Toys", icon: "gamecontroller"),
            Category(name: "Sports", icon: "sportscourt")
        ]
        
        // Grid layout: 2 columns
        let columns = [
            GridItem(.flexible()),
            GridItem(.flexible())
        ]

    
    var body: some View {
        
        NavigationStack {
            
            ScrollView {
                
                LazyVGrid(columns: columns, spacing: 20) {
                    
                    ForEach(categories) { category in
                        CategoryItem(category: category)
                    }
                }
                .padding()
            }
                .navigationTitle("Search")
        }
    }
}

#Preview {
    CategoryView()
}
