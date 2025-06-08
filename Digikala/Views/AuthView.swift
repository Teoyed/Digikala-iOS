import SwiftUI

struct AuthView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authManager: AuthManager
    @State private var isSignUp = false
    @State private var phone = ""
    @State private var password = ""
    @State private var name = ""
    @State private var showingError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 16) {
                        Image(systemName: isSignUp ? "person.badge.plus" : "person.circle")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                        
                        Text(isSignUp ? "Create Account" : "Welcome Back")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text(isSignUp ? "Sign up to get started" : "Sign in to continue")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 40)
                    
                    // Form Fields
                    VStack(spacing: 20) {
                        if isSignUp {
                            CustomTextField(
                                text: $name,
                                placeholder: "Full Name",
                                systemImage: "person"
                            )
                        }
                        
                        CustomTextField(
                            text: $phone,
                            placeholder: "Phone Number",
                            systemImage: "phone",
                            keyboardType: .phonePad
                        )
                        
                        CustomTextField(
                            text: $password,
                            placeholder: "Password",
                            systemImage: "lock",
                            isSecure: true
                        )
                    }
                    .padding(.horizontal)
                    
                    // Action Button
                    Button {
                        Task {
                            authenticate()
                        }
                    } label: {
                        HStack {
                            Text(isSignUp ? "Create Account" : "Sign In")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .disabled(phone.isEmpty || password.isEmpty || (isSignUp && name.isEmpty))
                    .padding(.horizontal)
                    
                    // Toggle Sign In/Sign Up
                    Button {
                        withAnimation {
                            isSignUp.toggle()
                        }
                    } label: {
                        Text(isSignUp ? "Already have an account? Sign In" : "Don't have an account? Sign Up")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                    .padding(.top, 8)
                }
                .padding(.bottom, 40)
            }
            .navigationBarItems(trailing: Button("Cancel") {
                dismiss()
            })
            .alert("Error", isPresented: $showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func authenticate() {
        if isSignUp {
            // Handle signup
            if authManager.signup(name: name, phone: phone, password: password) {
                print("Signup Successful! Name: \(name), Phone: \(phone)")
                dismiss()
            } else {
                errorMessage = "A user with this phone number already exists."
                showingError = true
            }
        } else {
            // Handle login
            authManager.login(phone: phone, password: password)
            if authManager.isAuthenticated {
                dismiss()
            } else {
                errorMessage = "Invalid credentials. Please try again."
                showingError = true
            }
        }
    }
}

struct CustomTextField: View {
    @Binding var text: String
    let placeholder: String
    let systemImage: String
    var keyboardType: UIKeyboardType = .default
    var isSecure: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: systemImage)
                .foregroundColor(.gray)
                .frame(width: 24)
            
            if isSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
                    .keyboardType(keyboardType)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    AuthView()
        .environmentObject(AuthManager())
} 