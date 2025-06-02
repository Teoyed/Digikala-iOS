//
//  CategoryView.swift
//  Digikala iOS
//
//  Created by Reza Ahmadizadeh on 3/12/1404 AP.
//

import SwiftUI

// MARK: - Model
struct Category: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
}

// MARK: - Reusable Row View
struct CategoryItem: View {
    let category: Category

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: category.icon)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundColor(.blue)
                .padding(8)
                .background(Color.gray.opacity(0.1))
                .clipShape(Circle())

            Text(category.name)
                .font(.headline)

            Spacer()
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Main Category View
struct CategoryView: View {
    let categories: [Category] = [
        Category(name: "Electronics", icon: "iphone"),
        Category(name: "Fashion", icon: "tshirt"),
        Category(name: "Home", icon: "house"),
        Category(name: "Beauty", icon: "sparkles"),
        Category(name: "Grocery", icon: "cart"),
        Category(name: "Books", icon: "book"),
        Category(name: "Toys", icon: "gamecontroller"),
        Category(name: "Sports", icon: "sportscourt")
    ]

    var body: some View {
        NavigationStack {
            List(categories) { category in
                CategoryItem(category: category)
            }
            .listStyle(.plain)
            .navigationTitle("Categories")
        }
    }
}

// MARK: - Preview
#Preview {
    CategoryView()
}
