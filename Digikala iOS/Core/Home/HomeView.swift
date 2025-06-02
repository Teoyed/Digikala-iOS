//
//  HomeView.swift
//  Digikala iOS
//
//  Created by Reza Ahmadizadeh on 3/12/1404 AP.
//

import SwiftUI

// MARK: - Home View
struct HomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    RecentlyViewedSection(title: "Recently Viewed", items: ["MacBook", "iPhone", "Camera"])
                    GoodPricesSection(title: "Good Prices", items: ["Shoes", "T-shirt", "Backpack"])
                    SeasonalOffSection(title: "Seasonal Off", items: ["Fan", "Sunglasses", "Sunscreen"])
                }
                .padding()
            }
            .navigationTitle("Home")
        }
    }
}

// MARK: - Recently Viewed Section
struct RecentlyViewedSection: View {
    let title: String
    let items: [String]

    var body: some View {
        SectionView(title: title, items: items) { item in
            RecentlyViewedCell(title: item)
        }
    }
}

struct RecentlyViewedCell: View {
    let title: String

    var body: some View {
        ItemCard(title: title, color: .red.opacity(0.2), width: 230, height: 180)
    }
}

// MARK: - Good Prices Section
struct GoodPricesSection: View {
    let title: String
    let items: [String]

    var body: some View {
        SectionView(title: title, items: items) { item in
            GoodPricesCell(title: item)
        }
    }
}

struct GoodPricesCell: View {
    let title: String

    var body: some View {
        ItemCard(title: title, color: .gray.opacity(0.2))
    }
}

// MARK: - Seasonal Off Section
struct SeasonalOffSection: View {
    let title: String
    let items: [String]

    var body: some View {
        SectionView(title: title, items: items) { item in
            SeasonalOffCell(title: item)
        }
    }
}

struct SeasonalOffCell: View {
    let title: String

    var body: some View {
        ItemCard(title: title, color: .green.opacity(0.2))
    }
}

// MARK: - Reusable Section View
struct SectionView<Content: View>: View {
    let title: String
    let items: [String]
    let content: (String) -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.horizontal, 4)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(items, id: \.self) { item in
                        content(item)
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }
}

// MARK: - Reusable Item Card
struct ItemCard: View {
    let title: String
    let color: Color
    var width: CGFloat = 200
    var height: CGFloat = 150

    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(color)
                .frame(width: width, height: height)
                .overlay(
                    Text(title)
                        .multilineTextAlignment(.center)
                        .padding(8)
                )
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

// MARK: - Preview
#Preview {
    HomeView()
}
