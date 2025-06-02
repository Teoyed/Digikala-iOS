//
//  Profile.swift
//  Digikala iOS
//
//  Created by Reza Ahmadizadeh on 3/12/1404 AP.
//

import SwiftUI

struct UserProfile {
    var name: String
    var phoneNumber: String
    var addresses: [String]
}

struct ProfileView: View {
    @State private var profile = UserProfile(
        name: "Reza Ahmadizadeh",
        phoneNumber: "+98 912 123 4567",
        addresses: [
            "No. 12, Baker Street, Tehran",
            "Unit 5, Azadi Tower Complex"
        ]
    )
    
    @State private var newAddress: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Personal Info")) {
                    HStack {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.blue)
                        Text(profile.name)
                            .font(.headline)
                    }
                    
                    HStack {
                        Image(systemName: "phone.fill")
                            .foregroundColor(.green)
                        Text(profile.phoneNumber)
                    }
                }
                
                Section(header: Text("Addresses")) {
                    ForEach(profile.addresses.indices, id: \.self) { index in
                        HStack(alignment: .top) {
                            Image(systemName: "mappin.and.ellipse")
                                .foregroundColor(.red)
                            Text(profile.addresses[index])
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .onDelete { indices in
                        profile.addresses.remove(atOffsets: indices)
                    }
                    
                    HStack {
                        TextField("Add new address", text: $newAddress)
                        Button(action: {
                            if !newAddress.isEmpty {
                                profile.addresses.append(newAddress)
                                newAddress = ""
                            }
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.blue)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }
}

#Preview {
    ProfileView()
}
