//
//  SeasonalOffSection.swift
//  Digikala iOS
//
//  Created by Reza Ahmadizadeh on 3/12/1404 AP.
//

import SwiftUI

struct SeasonalOffSection: View {
    
    let title: String
    let items: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.horizontal, 4)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(items, id: \.self) { item in
                        SeasonalOffCell(title: item)
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }
}
