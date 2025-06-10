import SwiftUI

// MARK: - Main Profile View
struct ProfileView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var showingEditProfile = false
    @State private var showingAuthSheet = false
    
    var body: some View {
        NavigationView {
            Group {
                if authManager.isAuthenticated, let user = authManager.currentUser {
                    AuthenticatedProfileView(
                        user: user,
                        showingEditProfile: $showingEditProfile,
                        showingAuthSheet: $showingAuthSheet
                    )
                } else {
                    UnauthenticatedProfileView(showingAuthSheet: $showingAuthSheet)
                }
            }
            .sheet(isPresented: $showingAuthSheet) {
                AuthView()
            }
        }
    }
}

// MARK: - Authenticated Profile View
private struct AuthenticatedProfileView: View {
    let user: User
    @Binding var showingEditProfile: Bool
    @Binding var showingAuthSheet: Bool
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                ProfileHeaderView(user: user)
                
                StatsSection()
                
                ProfileSectionsView(
                    user: user,
                    showingEditProfile: $showingEditProfile
                )
                
                SignOutButton()
            }
            .padding(.vertical)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Profile")
    }
}

// MARK: - Stats Section
private struct StatsSection: View {
    var body: some View {
        HStack(spacing: 20) {
            StatCard(title: "Orders", value: "12", icon: "shippingbox.fill")
            StatCard(title: "Wishlist", value: "5", icon: "heart.fill")
            StatCard(title: "Reviews", value: "8", icon: "star.fill")
        }
        .padding(.horizontal)
    }
}

// MARK: - Profile Sections
private struct ProfileSectionsView: View {
    let user: User
    @Binding var showingEditProfile: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            PersonalInfoSection(user: user)
            AddressesSection(addresses: user.addresses)
        }
    }
}

// MARK: - Personal Info Section
private struct PersonalInfoSection: View {
    let user: User
    
    var body: some View {
        ProfileSection(title: "Personal Information") {
            VStack(spacing: 15) {
                ProfileInfoRow(label: "Name", value: user.name, icon: "person.fill")
                ProfileInfoRow(label: "Phone", value: user.phone, icon: "phone.fill")
            }
        }
    }
}

// MARK: - Addresses Section
private struct AddressesSection: View {
    let addresses: [User.Address]
    
    var body: some View {
        ProfileSection(title: "Addresses") {
            if addresses.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "mappin.slash")
                        .font(.system(size: 30))
                        .foregroundColor(.gray)
                    Text("No addresses added yet")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
            } else {
                VStack(spacing: 15) {
                    ForEach(addresses) { address in
                        AddressCard(address: address)
                    }
                }
            }
        }
    }
}

// MARK: - Address Card
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
        .background(Color(.tertiarySystemGroupedBackground))
        .cornerRadius(12)
    }
}

// MARK: - Sign Out Button
private struct SignOutButton: View {
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        Button(action: {
            authManager.logout()
        }) {
            Text("Sign Out")
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
                .cornerRadius(10)
        }
        .padding(.horizontal)
    }
}

// MARK: - Unauthenticated Profile View
private struct UnauthenticatedProfileView: View {
    @Binding var showingAuthSheet: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            Text("Sign in to view your profile")
                .font(.title2)
                .fontWeight(.medium)
            
            Button(action: { showingAuthSheet = true }) {
                Text("Sign In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
}

// MARK: - Supporting Views
struct ProfileHeaderView: View {
    let user: User
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 15) {
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
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(20)
        .shadow(color: Color(.systemGray4).opacity(0.5), radius: 10, x: 0, y: 5)
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
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(15)
        .shadow(color: Color(.systemGray4).opacity(0.5), radius: 5, x: 0, y: 2)
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
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(15)
                .shadow(color: Color(.systemGray4).opacity(0.5), radius: 5, x: 0, y: 2)
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
                if !value.isEmpty {
                    Text(value)
                        .font(.body)
                        .foregroundColor(.primary)
                }
            }
            
            Spacer()
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

