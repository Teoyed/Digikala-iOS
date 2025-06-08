import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var user: User? // This will be set based on local auth state
    @State private var showingEditProfile = false
    @State private var showingAuthSheet = false
    
    var body: some View {
        NavigationView {
            Group {
                if authManager.isAuthenticated, let user = user {
                    ScrollView {
                        VStack(spacing: 25) {
                            // User Header
                            VStack(spacing: 10) {
                                Image(systemName: "person.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(.blue)
                                    .shadow(radius: 5)
                                
                                Text(user.name)
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.primary)
                                
                                Text(user.phone)
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 20)
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(20)
                            .padding(.horizontal)
                            
                            // Personal Information Card
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Personal Information")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                
                                ProfileInfoRow(label: "Name", value: user.name)
                                ProfileInfoRow(label: "Phone", value: user.phone)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 5)
                            .padding(.horizontal)
                            
                            // Addresses Section
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Addresses")
                                    .font(.title2)
                                    .fontWeight(.semibold)
                                
                                ForEach(user.addresses) { address in
                                    VStack(alignment: .leading, spacing: 5) {
                                        if address.isDefault {
                                            Text("Default Address")
                                                .font(.caption)
                                                .fontWeight(.bold)
                                                .foregroundColor(.blue)
                                        }
                                        Text(address.street)
                                            .font(.body)
                                        Text("\(address.city), \(address.state) \(address.zipCode)")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(Color.gray.opacity(0.05))
                                    .cornerRadius(10)
                                }
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(color: .gray.opacity(0.2), radius: 5, x: 0, y: 5)
                            .padding(.horizontal)
                            
                            // Action Buttons
                            VStack(spacing: 15) {
                                Button(action: { showingEditProfile = true }) {
                                    Label("Edit Profile", systemImage: "pencil")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.accentColor)
                                        .foregroundColor(.white)
                                        .cornerRadius(15)
                                }
                                
                                Button(action: {
                                    authManager.logout()
                                    self.user = nil // Clear user data on logout
                                }) {
                                    Label("Logout", systemImage: "power.circle.fill")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.red)
                                        .foregroundColor(.white)
                                        .cornerRadius(15)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 20)
                        }
                        .padding(.vertical, 20) // Add vertical padding to the entire scroll view content
                    }
                    .navigationTitle("Profile")
                } else {
                    VStack(spacing: 20) {
                        Image(systemName: "person.circle")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("Please log in to view your profile")
                            .font(.title2)
                            .foregroundColor(.gray)
                        Button("Login / Sign Up") {
                            showingAuthSheet = true
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
            .navigationTitle("Profile")
            .onAppear { // Use onAppear to set mock user data
                if authManager.isAuthenticated {
                    loadProfile()
                }
            }
            .sheet(isPresented: $showingAuthSheet) {
                AuthView()
            }
            .sheet(isPresented: $showingEditProfile) {
                if let user = user {
                    EditProfileView(user: user)
                }
            }
        }
    }
    
    private func loadProfile() {
        // For prototype, use mock user data
        self.user = User(
            id: 1,
            name: "Prototype User",
            phone: "123-456-7890",
            addresses: [
                User.Address(
                    id: 1,
                    street: "123 Mock St",
                    city: "Mockville",
                    state: "MK",
                    zipCode: "00000",
                    isDefault: true
                ),
                User.Address(
                    id: 2,
                    street: "456 Demo Ave",
                    city: "Demotown",
                    state: "DM",
                    zipCode: "11111",
                    isDefault: false
                )
            ]
        )
    }
}

// Helper View for Profile Information Rows
struct ProfileInfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            Spacer()
            Text(value)
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
}

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @State var user: User
    
    var body: some View {
        NavigationView {
            Form {
                Section("Personal Information") {
                    TextField("Name", text: $user.name)
                    TextField("Phone", text: $user.phone)
                        .keyboardType(.phonePad)
                }
                
                Section("Addresses") {
                    ForEach($user.addresses) { $address in
                        VStack {
                            Toggle("Default Address", isOn: $address.isDefault)
                            TextField("Street", text: $address.street)
                            TextField("City", text: $address.city)
                            TextField("State", text: $address.state)
                            TextField("ZIP Code", text: $address.zipCode)
                                .keyboardType(.numberPad)
                        }
                    }
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Save") {
                    // For prototype, just dismiss. No API call.
                    dismiss()
                }
            )
        }
    }
    
    private func saveProfile() {
        // No API call for prototype. Just simulate saving.
        print("Mock Profile Saved: \(user.name)")
        dismiss()
    }
} 