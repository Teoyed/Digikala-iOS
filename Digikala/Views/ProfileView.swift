import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var showingEditProfile = false
    @State private var showingAuthSheet = false
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationView {
            Group {
                if authManager.isAuthenticated, let user = authManager.currentUser {
                    ScrollView {
                        VStack(spacing: 25) {
                            // Profile Header
                            ProfileHeaderView(user: user)
                            
                            // Quick Stats
                            HStack(spacing: 20) {
                                StatCard(title: "Orders", value: "12", icon: "shippingbox.fill")
                                StatCard(title: "Wishlist", value: "5", icon: "heart.fill")
                                StatCard(title: "Reviews", value: "8", icon: "star.fill")
                            }
                            .padding(.horizontal)
                            
                            // Profile Sections
                            VStack(spacing: 20) {
                                ProfileSection(title: "Personal Information") {
                                    VStack(spacing: 15) {
                                        ProfileInfoRow(label: "Name", value: user.name, icon: "person.fill")
                                        ProfileInfoRow(label: "Phone", value: user.phone, icon: "phone.fill")
                                        ProfileInfoRow(label: "Email", value: "user@example.com", icon: "envelope.fill")
                                    }
                                }
                                
                                ProfileSection(title: "Addresses") {
                                    VStack(spacing: 12) {
                                        ForEach(user.addresses) { address in
                                            AddressCard(address: address)
                                        }
                                        
                                        Button(action: {}) {
                                            Label("Add New Address", systemImage: "plus.circle.fill")
                                                .font(.headline)
                                                .foregroundColor(.blue)
                                                .frame(maxWidth: .infinity)
                                                .padding()
                                                .background(Color.blue.opacity(0.1))
                                                .cornerRadius(12)
                                        }
                                    }
                                }
                                
                                ProfileSection(title: "Settings") {
                                    VStack(spacing: 0) {
                                        SettingsRow(title: "Notifications", icon: "bell.fill")
                                        SettingsRow(title: "Privacy", icon: "lock.fill")
                                        SettingsRow(title: "Help & Support", icon: "questionmark.circle.fill")
                                        SettingsRow(title: "About", icon: "info.circle.fill")
                                    }
                                }
                            }
                            .padding(.horizontal)
                            
                            // Action Buttons
                            VStack(spacing: 15) {
                                Button(action: { showingEditProfile = true }) {
                                    Label("Edit Profile", systemImage: "pencil")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(15)
                                        .shadow(color: .blue.opacity(0.3), radius: 5, x: 0, y: 3)
                                }
                                
                                Button(action: {
                                    withAnimation {
                                        authManager.logout()
                                    }
                                }) {
                                    Label("Logout", systemImage: "power.circle.fill")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.red.opacity(0.1))
                                        .foregroundColor(.red)
                                        .cornerRadius(15)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 20)
                        }
                        .padding(.vertical, 20)
                    }
                    .navigationTitle("Profile")
                    .background(Color(.systemGroupedBackground))
                } else {
                    WelcomeView(showingAuthSheet: $showingAuthSheet)
                }
            }
            .navigationTitle("Profile")
            .sheet(isPresented: $showingAuthSheet) {
                AuthView()
            }
            .sheet(isPresented: $showingEditProfile) {
                if let user = authManager.currentUser {
                    EditProfileView(user: user) { updatedUser in
                        authManager.currentUser = updatedUser
                    }
                }
            }
        }
    }
}

// MARK: - Supporting Views

struct ProfileHeaderView: View {
    let user: User
    
    var body: some View {
        VStack(spacing: 15) {
            // Profile Image
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
            }
            .shadow(color: .blue.opacity(0.2), radius: 10, x: 0, y: 5)
            
            // User Info
            VStack(spacing: 8) {
                Text(user.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text(user.phone)
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct ProfileSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            content
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
    }
}

struct ProfileInfoRow: View {
    let label: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(label)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.body)
                    .foregroundColor(.primary)
            }
            
            Spacer()
        }
    }
}

struct AddressCard: View {
    let address: User.Address
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: "mappin.circle.fill")
                .foregroundColor(.blue)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 4) {
                if address.isDefault {
                    Text("Default Address")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(4)
                }
                
                Text(address.street)
                    .font(.body)
                    .foregroundColor(.primary)
                
                Text("\(address.city), \(address.state) \(address.zipCode)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "pencil")
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
    }
}

struct SettingsRow: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            Text(title)
                .font(.body)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .font(.caption)
        }
        .padding()
        .background(Color.white)
        .contentShape(Rectangle())
        .onTapGesture {
            // Handle tap
        }
    }
}

struct WelcomeView: View {
    @Binding var showingAuthSheet: Bool
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            Image(systemName: "person.circle")
                .font(.system(size: 80))
                .foregroundColor(.blue)
                .padding()
                .background(Color.blue.opacity(0.1))
                .clipShape(Circle())
            
            VStack(spacing: 12) {
                Text("Welcome!")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Sign in to access your profile")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Button(action: { showingAuthSheet = true }) {
                Text("Sign In / Sign Up")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(15)
                    .shadow(color: .blue.opacity(0.3), radius: 5, x: 0, y: 3)
            }
            .padding(.horizontal, 40)
            
            Spacer()
        }
        .padding()
    }
}

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @State private var editedUser: User
    let onSave: (User) -> Void
    
    init(user: User, onSave: @escaping (User) -> Void) {
        _editedUser = State(initialValue: user)
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Personal Information") {
                    TextField("Name", text: $editedUser.name)
                    TextField("Phone", text: $editedUser.phone)
                        .keyboardType(.phonePad)
                }
                
                Section("Addresses") {
                    ForEach($editedUser.addresses) { $address in
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
                    onSave(editedUser)
                    dismiss()
                }
            )
        }
    }
} 