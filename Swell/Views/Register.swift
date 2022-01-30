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
    
    var disableForm: Bool {
        if emailAddress.isEmpty || password.isEmpty || confirmPassword.isEmpty || firstName.isEmpty || lastName.isEmpty || age.isEmpty || height.isEmpty || weight.isEmpty {
            return true
        }
        return false
    }
    
    var body: some View {
        VStack {
            Image("LoginImage")
                .resizable()
                .frame(width: 80, height: 80)
            Text("Welcome to Swell")
                .foregroundColor(.swellOrange)
                .font(.custom("Ubuntu-Bold", size: 40))
                .multilineTextAlignment(.center)
            Form {
                Section(header: Text("Email/Password")) {
                    TextField("Email Address", text: $emailAddress)
                        .padding()
                        .textContentType(.emailAddress)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                    SecureField("Password", text: $password)
                        .padding()
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                    SecureField("Confirm Password", text: $confirmPassword)
                        .padding()
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
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
            }
            Button("Sign Up") {
                authViewModel.signUp(email: emailAddress, password: password)
                if !password.elementsEqual(confirmPassword) {
                    showInvalidAlert = true
                }
            }
            .withButtonStyles()
            .disabled(disableForm)
            .opacity(disableForm ? 0.5 : 1.0)
            .alert(isPresented: $showInvalidAlert) {
                Alert(title: Text("Password fields do not match. Please try again."))
            }
        }.onTapGesture {
            hideKeyboard()
        }
    }
}

struct Register_Previews: PreviewProvider {
    static var previews: some View {
        Register()
    }
}
