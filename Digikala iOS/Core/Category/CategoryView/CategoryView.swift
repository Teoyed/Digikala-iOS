//
//  ExploreView.swift
//  Digikala iOS
//
//  Created by Reza Ahmadizadeh on 3/12/1404 AP.
//

import SwiftUI

import SwiftUI

struct CategoryView: View {
    
    struct Category: Identifiable {
        let id = UUID()
        let title: String
        let iconName: String
    }
    
    let categories: [Category] = [
        Category(title: "Electronics", iconName: "iphone"),
        Category(title: "Fashion", iconName: "tshirt"),
        Category(title: "Home", iconName: "house"),
        Category(title: "Beauty", iconName: "sparkles"),
        Category(title: "Grocery", iconName: "cart"),
        Category(title: "Books", iconName: "book"),
        Category(title: "Toys", iconName: "gamecontroller"),
        Category(title: "Sports", iconName: "sportscourt")
    ]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        
        NavigationStack {
            
            ScrollView {
                
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(categories) { category in
                        CategoryItem(title: category.title, iconName: category.iconName)
                    }
                }
                .padding()
            }
            .navigationTitle("Categories")
        }
    }
}
