//
//  SettingView.swift
//  Digikala iOS
//
//  Created by Reza Ahmadizadeh on 3/12/1404 AP.
//

import SwiftUI

struct CartItem: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
    let price: Double
    var quantity: Int
}

struct CartView: View {
    @State private var cartItems: [CartItem] = [
        CartItem(title: "iPhone 15", imageName: "iphone", price: 999.99, quantity: 1),
        CartItem(title: "Running Shoes", imageName: "figure.walk", price: 120.00, quantity: 2),
        CartItem(title: "Headphones", imageName: "headphones", price: 89.99, quantity: 1)
    ]
    
    var totalPrice: Double {
        cartItems.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
    }

    var body: some View {
        NavigationStack {
            VStack {
                if cartItems.isEmpty {
                    Spacer()
                    Text("Your cart is empty 🛒")
                        .foregroundColor(.gray)
                        .font(.headline)
                    Spacer()
                } else {
                    List {
                        ForEach($cartItems) { $item in
                            HStack(spacing: 16) {
                                Image(systemName: item.imageName)
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .padding(8)
                                    .background(Color.gray.opacity(0.1))
                                    .clipShape(Circle())
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(item.title)
                                        .font(.headline)
                                    Text(String(format: "$%.2f", item.price))
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                HStack(spacing: 10) {
                                    Button {
                                        if item.quantity > 1 {
                                            item.quantity -= 1
                                        }
                                    } label: {
                                        Image(systemName: "minus.circle")
                                            .foregroundColor(.red)
                                    }
                                    
                                    Text("\(item.quantity)")
                                        .font(.subheadline)
                                        .frame(width: 30)
                                    
                                    Button {
                                        item.quantity += 1
                                    } label: {
                                        Image(systemName: "plus.circle")
                                            .foregroundColor(.green)
                                    }
                                }
                            }
                            .padding(.vertical, 8)
                        }
                        .onDelete { indexSet in
                            cartItems.remove(atOffsets: indexSet)
                        }
                    }
                    .listStyle(.plain)

                    // Total price section
                    HStack {
                        Text("Total:")
                            .font(.headline)
                        Spacer()
                        Text(String(format: "$%.2f", totalPrice))
                            .font(.title3)
                            .bold()
                    }
                    .padding()
                    .background(Color.white)
                    .shadow(radius: 2)
                }
            }
            .navigationTitle("Shopping Cart")
        }
    }
}

#Preview {
    CartView()
}
