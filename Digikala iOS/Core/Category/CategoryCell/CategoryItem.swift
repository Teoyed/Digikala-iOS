//
//  CategoryItem.swift
//  Digikala iOS
//
//  Created by Reza Ahmadizadeh on 3/12/1404 AP.
//

import SwiftUI

import SwiftUI

struct CategoryItem: View {
    
    let title: String
    let iconName: String

    var body: some View {
        
        VStack(spacing: 8) {
            
            Image(systemName: iconName)
                .frame(width: 40, height: 40)
                .padding()

            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}
