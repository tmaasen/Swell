//
//  Register.swift
//  Swell
//
//  Created by Tanner Maasen on 1/15/22.
//

import SwiftUI
import JGProgressHUD_SwiftUI
import GoogleSignIn

/// View that contains a form a new user fills out in order to create a new account. Or, the user can Sign In with Google and skip the form.
struct Register: View {
    @State private var showInvalidAlert: Bool = false
    @State private var isAuthenticated: Bool = false
    @State private var emailAddress: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var gender: String = "Gender"
    @State private var currentDate = Date()
    @State private var age: Int = 0
    @State private var height: String = ""
    @State private var weight: String = ""
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @EnvironmentObject var hudCoordinator: JGProgressHUDCoordinator
    @Environment(\.colorScheme) var colorScheme
    
    var disableForm: Bool {
        if emailAddress.isEmpty || password.isEmpty || confirmPassword.isEmpty || firstName.isEmpty || lastName.isEmpty || height.isEmpty || weight.isEmpty {
            return true
        }
        return false
    }
    
    var body: some View {
        ScrollView {
            NavigationLink(destination: Home(), isActive: $isAuthenticated) {}
            VStack {
                Section() {
                    Image("LoginImage")
                        .resizable()
                        .frame(width: 80, height: 80)
                    Text("Welcome to Swell")
                        .foregroundColor(colorScheme == .dark ? .white : .swellOrange)
                        .font(.custom("Ubuntu-Bold", size: 35))
                        .multilineTextAlignment(.center)
                }
                .padding()
                Section() {
                    TextField("Email Address", text: $emailAddress)
                        .padding()
                        .textContentType(.emailAddress)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                    Divider()
                        .frame(height: 1)
                        .padding(.horizontal, 30)
                        .background(Color.gray)
                    SecureField("Password", text: $password)
                        .padding()
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                    Divider()
                        .frame(height: 1)
                        .padding(.horizontal, 30)
                        .background(Color.gray)
                    SecureField("Confirm Password", text: $confirmPassword)
                        .padding()
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                    Divider()
                        .frame(height: 1)
                        .padding(.horizontal, 30)
                        .background(Color.gray)
                }
                .padding(.horizontal, 30)
                Section() {
                    TextField("First Name", text: $firstName)
                        .padding()
                        .textContentType(.givenName)
                    Divider()
                        .frame(height: 1)
                        .padding(.horizontal, 30)
                        .background(Color.gray)
                    TextField("Last Name", text: $lastName)
                        .padding()
                        .textContentType(.name)
                    Divider()
                        .frame(height: 1)
                        .padding(.horizontal, 30)
                        .background(Color.gray)
                }
                .padding(.horizontal, 30)
                Section() {
                    HStack {
                        Menu {
                            Button("Male", action: {gender = "Male"})
                            Button("Female", action: {gender = "Female"})
                        } label: {
                            Label(gender, systemImage: "chevron.down")
                        }
                        .padding()
                        .foregroundColor(Color.gray)
                        Spacer()
                    }
                    Divider()
                        .frame(height: 1)
                        .padding(.horizontal, 30)
                        .background(Color.gray)
                    DatePicker("Birthdate", selection: $currentDate, in: ...Date(), displayedComponents: .date)
                        .onChange(of: currentDate, perform: { value in
                            let diff = Calendar.current.dateComponents([.year], from: currentDate, to: Date())
                            self.age = diff.year!
                        })
                        .padding()
                        .foregroundColor(Color.gray)
                    Divider()
                        .frame(height: 1)
                        .padding(.horizontal, 30)
                        .background(Color.gray)
                    TextField("Height (inches)", text: $height)
                        .padding()
                        .keyboardType(.numberPad)
                    Divider()
                        .frame(height: 1)
                        .padding(.horizontal, 30)
                        .background(Color.gray)
                    TextField("Weight (lbs)", text: $weight)
                        .padding()
                        .keyboardType(.numberPad)
                    Divider()
                        .frame(height: 1)
                        .padding(.horizontal, 30)
                        .background(Color.gray)
                }
                .padding(.horizontal, 30)

                GoogleSignInButton()
                    .padding()
                    .onTapGesture {
                        hideKeyboard()
                        authViewModel.signInWithGoogle(completion: {
                            isAuthenticated = true
                            authViewModel.setNewUser(
                                fname: GIDSignIn.sharedInstance.currentUser?.profile?.givenName ?? "",
                                lname: GIDSignIn.sharedInstance.currentUser?.profile?.familyName ?? "",
                                completion: {
                                    authViewModel.getAllUserInfo()
                                    authViewModel.setLoginTimestamp()
                                }
                            )
                        })
                    }
                    .frame(width: 220, height: 80)
                
                HStack() {
                    Text("Already have an account?")
                        .foregroundColor(Color("FoodListItem_DarkGray"))
                    NavigationLink(destination: Login(), label: {
                        Text("Login")
                            .bold()
                            .foregroundColor(.swellOrange)
                    })
                }

                Button(action: {
                    if !password.elementsEqual(confirmPassword) {
                        showInvalidAlert = true
                    } else {
                        hideKeyboard()
                        toggleLoadingIndicator()
                        authViewModel.signUp(email: emailAddress, password: password, completion: {
                            isAuthenticated = true
                            authViewModel.setNewUser(
                                fname: firstName,
                                lname: lastName,
                                age: age,
                                gender: gender,
                                height: Int(height) ?? 0,
                                weight: Int(weight) ?? 0,
                                completion: {
                                    authViewModel.getAllUserInfo()
                                    authViewModel.setLoginTimestamp()
                                }
                            )
                        })
                    }
                }) {
                    Text("Sign Up")
                        .withButtonStyles()
                        .padding()
                        .disabled(disableForm)
                        .opacity(disableForm ? 0.5 : 1.0)
                        .alert(isPresented: $showInvalidAlert) {
                            Alert(title: Text("Password fields do not match. Please try again."))
                        }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .onTapGesture {
            hideKeyboard()
        }
    }
    func toggleLoadingIndicator() {
        hudCoordinator.showHUD {
            let hud = JGProgressHUD()
            hud.backgroundColor = UIColor(white: 0, alpha: 0.4)
            hud.shadow = JGProgressHUDShadow(color: .black, offset: .zero, radius: 4, opacity: 0.9)
            hud.vibrancyEnabled = true
            hud.textLabel.text = "Loading"
            hud.dismiss(afterDelay: 3.0)
            return hud
        }
    }
}

struct Register_Previews: PreviewProvider {
    static var previews: some View {
        Register()
    }
}
