//
//  HomeView.swift
//  Digikala iOS
//
//  Created by Reza Ahmadizadeh on 3/12/1404 AP.
//

import SwiftUI

struct HomeView: View {
    
    var body: some View {
        
        NavigationStack {
            
            ScrollView {
                
                VStack(alignment: .leading, spacing: 24) {
                    
                    RecentlyViewedSection(title: "Recently Viewed", items: ["rreza","jw"])
                    
                    GoodPricesSection(title: "Good Prices", items: ["rreza","jw"])
                    
                    SeasonalOffSection(title: "SeasonalOff", items: ["rreza","jw"])
                                }
                                .padding()
            }
                .navigationTitle("Home")
        }
    }
}

#Preview {
    HomeView()
}
