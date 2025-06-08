import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var user: User?
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var showingEditProfile = false
    @State private var showingLoginSheet = false
    
    var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    ProgressView()
                } else if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                } else if authManager.isAuthenticated, let user = user {
                    List {
                        Section("Personal Information") {
                            HStack {
                                Text("Name")
                                Spacer()
                                Text(user.name)
                                    .foregroundColor(.gray)
                            }
                            
                            HStack {
                                Text("Phone")
                                Spacer()
                                Text(user.phone)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Section("Addresses") {
                            ForEach(user.addresses) { address in
                                VStack(alignment: .leading) {
                                    if address.isDefault {
                                        Text("Default Address")
                                            .font(.caption)
                                            .foregroundColor(.blue)
                                    }
                                    Text(address.street)
                                    Text("\(address.city), \(address.state) \(address.zipCode)")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        
                        Section {
                            Button("Edit Profile") {
                                showingEditProfile = true
                            }
                            
                            Button("Logout") {
                                authManager.logout()
                                self.user = nil
                            }
                            .foregroundColor(.red)
                        }
                    }
                } else {
                    VStack(spacing: 20) {
                        Image(systemName: "person.circle")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("Please log in to view your profile")
                            .font(.title2)
                            .foregroundColor(.gray)
                        Button("Login / Sign Up") {
                            showingLoginSheet = true
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
            .navigationTitle("Profile")
            .task {
                if authManager.isAuthenticated {
                    await loadProfile()
                }
            }
            .sheet(isPresented: $showingLoginSheet) {
                LoginView()
            }
            .sheet(isPresented: $showingEditProfile) {
                if let user = user {
                    EditProfileView(user: user)
                }
            }
        }
    }
    
    private func loadProfile() async {
        isLoading = true
        errorMessage = nil
        
        do {
            user = try await APIClient.shared.fetchProfile()
        } catch {
            errorMessage = "Failed to load profile: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}

struct LoginView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authManager: AuthManager
    @State private var isSignUp = false
    @State private var phone = ""
    @State private var password = ""
    @State private var name = ""
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            Form {
                if isSignUp {
                    Section {
                        TextField("Name", text: $name)
                    }
                }
                
                Section {
                    TextField("Phone", text: $phone)
                        .keyboardType(.phonePad)
                    SecureField("Password", text: $password)
                }
                
                if let error = errorMessage {
                    Section {
                        Text(error)
                            .foregroundColor(.red)
                    }
                }
                
                Section {
                    Button(isSignUp ? "Sign Up" : "Login") {
                        Task {
                            await authenticate()
                        }
                    }
                    .disabled(phone.isEmpty || password.isEmpty || (isSignUp && name.isEmpty))
                }
                
                Section {
                    Button(isSignUp ? "Already have an account? Login" : "Don't have an account? Sign Up") {
                        isSignUp.toggle()
                    }
                }
            }
            .navigationTitle(isSignUp ? "Sign Up" : "Login")
            .navigationBarItems(trailing: Button("Cancel") {
                dismiss()
            })
        }
    }
    
    private func authenticate() async {
        do {
            if isSignUp {
                let credentials = SignupCredentials(name: name, phone: phone, password: password)
                let token = try await APIClient.shared.signup(credentials: credentials)
                authManager.login(token: token)
            } else {
                let credentials = LoginCredentials(phone: phone, password: password)
                let token = try await APIClient.shared.login(credentials: credentials)
                authManager.login(token: token)
            }
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @State var user: User
    @State private var isLoading = false
    @State private var errorMessage: String?
    
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
                
                if let error = errorMessage {
                    Section {
                        Text(error)
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Save") {
                    Task {
                        await saveProfile()
                    }
                }
                .disabled(isLoading)
            )
        }
    }
    
    private func saveProfile() async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await APIClient.shared.updateProfile(user)
            dismiss()
        } catch {
            errorMessage = "Failed to update profile: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
} 