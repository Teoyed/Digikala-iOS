//
//  SeasonalOffCell.swift
//  Digikala iOS
//
//  Created by Reza Ahmadizadeh on 3/12/1404 AP.
//

import SwiftUI

struct SeasonalOffCell: View {
    
    let title: String
    
    var body: some View {
        
        VStack {
            
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.green.opacity(0.2))
                .frame(width: 200, height: 150)
                .overlay(Text(title).multilineTextAlignment(.center).padding(8))
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

#Preview {
    SeasonalOffCell(title: "Reza")
}
