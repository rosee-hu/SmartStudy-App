import SwiftUI

struct AuthView: View {
    @AppStorage("isLoggedIn") var isLoggedIn = false
    @State private var email = ""
    @State private var password = ""
    @State private var isLogin = true
    @State private var errorMessage = ""
    @State private var isPasswordVisible = false

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "lightbulb")
                .resizable()
                .frame(width: 80, height: 80)
                .padding(.top, 40)

            Text(isLogin ? "Log In" : "Sign Up")
                .font(.title)
                .bold()

            // Email input
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .keyboardType(.emailAddress)

            // Password input with toggle for visibility
            HStack {
                if isPasswordVisible {
                    TextField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                } else {
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                Button(action: { isPasswordVisible.toggle() }) {
                    Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                        .foregroundColor(.gray)
                }
            }

            // Display error message if any
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.footnote)
            }

            // Log In / Sign Up button
            Button(action: handleAuth) {
                Text(isLogin ? "Log In" : "Sign Up")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            // Switch between login and signup
            Button(action: { isLogin.toggle(); errorMessage = "" }) {
                Text(isLogin ? "Don't have an account? Sign Up" : "Already have an account? Log In")
                    .font(.footnote)
                    .foregroundColor(.blue)
            }

            Spacer()
        }
        .padding()
    }

    func handleAuth() {
        // Validate email and password fields
        if email.isEmpty || password.isEmpty {
            errorMessage = "All fields are required"
            return
        }

        // Handle Login or Sign Up
        let key = "user_\(email.lowercased())"
        if isLogin {
            if let storedPassword = UserDefaults.standard.string(forKey: key), storedPassword == password {
                isLoggedIn = true
                resetFields() // Reset fields on successful login
            } else {
                errorMessage = "Invalid credentials"
            }
        } else {
            // Sign-up: Store new password and log in
            if UserDefaults.standard.string(forKey: key) != nil {
                errorMessage = "Account already exists"
                return
            }
            UserDefaults.standard.set(password, forKey: key)
            isLoggedIn = true
            resetFields() // Reset fields on successful sign-up
        }
    }

    // Function to clear input fields after successful login or sign-up
    func resetFields() {
        email = ""
        password = ""
    }
}
