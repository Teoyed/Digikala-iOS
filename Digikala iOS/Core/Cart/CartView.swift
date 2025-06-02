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
                    VStack(spacing: 12) {
                        Image(systemName: "cart")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("Your cart is empty")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach($cartItems) { $item in
                                CartItemCard(item: $item) {
                                    cartItems.removeAll { $0.id == item.id }
                                }
                            }

                            Divider()
                            
                            HStack {
                                Text("Total:")
                                    .font(.headline)
                                Spacer()
                                Text(String(format: "$%.2f", totalPrice))
                                    .font(.title3)
                                    .bold()
                            }
                            .padding(.horizontal)
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Shopping Cart")
        }
    }
}

struct CartItemCard: View {
    @Binding var item: CartItem
    var onDelete: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: item.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .padding(10)
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.headline)
                Text(String(format: "$%.2f", item.price))
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()

            VStack(spacing: 8) {
                HStack(spacing: 10) {
                    Button {
                        if item.quantity > 1 {
                            item.quantity -= 1
                        }
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(.red)
                            .font(.title3)
                    }

                    Text("\(item.quantity)")
                        .font(.subheadline)
                        .frame(width: 30)

                    Button {
                        item.quantity += 1
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.green)
                            .font(.title3)
                    }
                }

                Button(role: .destructive) {
                    onDelete()
                } label: {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    CartView()
}
