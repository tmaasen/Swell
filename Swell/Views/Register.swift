//
//  Register.swift
//  Swell
//
//  Created by Tanner Maasen on 1/15/22.
//

import SwiftUI

struct Register: View {
    @State private var showInvalidAlert: Bool = false
    @State var emailAddress: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State private var selectedGenderIndex: Int = 0
    @State var age: String = ""
    @State var height: String = ""
    @State var weight: String = ""
    private var genderOptions = ["Male", "Female"]
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    
    var body: some View {
        VStack {
            Image("LoginImage")
                .aspectRatio(contentMode: .fit)
            Text("Welcome to Swell")
                .foregroundColor(.swellOrange)
                .font(.custom("Ubuntu-Bold", size: 40))
                .multilineTextAlignment(.center)
            Form {
                Section(header: Text("Email/Password")) {
                    TextField("Email Address", text: $emailAddress)
                        .padding()
                        .textContentType(.emailAddress)
                    SecureField("Password", text: $password)
                        .padding()
                    SecureField("Confirm Password", text: $confirmPassword)
                        .padding()
                }
                Section(header: Text("Personal Information")) {
                    TextField("First Name", text: $firstName)
                        .padding()
                        .textContentType(.givenName)
                    TextField("Last Name", text: $lastName)
                        .padding()
                        .textContentType(.name)
                    Picker("Gender", selection: $selectedGenderIndex) {
                        ForEach(0..<genderOptions.count) {
                            Text(self.genderOptions[$0])
                        }
                    }.padding()
                    TextField("Age", text: $age)
                        .padding()
                        .keyboardType(.numberPad)
                    TextField("Height", text: $height)
                        .padding()
                        .keyboardType(.numberPad)
                    TextField("Weight", text: $weight)
                        .padding()
                        .keyboardType(.numberPad)
                }
                Divider()
                Button("Sign Up") {
                    authViewModel.signUp(email: emailAddress, password: password)
                    if password.elementsEqual(confirmPassword) {
                        showInvalidAlert = true
                    }
                }
                .withButtonStyles()
                .disabled(emailAddress.isEmpty || password.isEmpty || confirmPassword.isEmpty || firstName.isEmpty || lastName.isEmpty || age.isEmpty || height.isEmpty || weight.isEmpty)
                .alert(isPresented: $showInvalidAlert) {
                    Alert(title: Text("Password fields do not match."))
                }
            }
        }
    }
}

struct Register_Previews: PreviewProvider {
    static var previews: some View {
        Register()
    }
}
