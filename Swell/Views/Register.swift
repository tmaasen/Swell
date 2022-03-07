//
//  Register.swift
//  Swell
//
//  Created by Tanner Maasen on 1/15/22.
//

import SwiftUI
import JGProgressHUD_SwiftUI

struct Register: View {
    @State private var showInvalidAlert: Bool = false
    @State private var isAuthenticated: Bool = false
    @State private var emailAddress: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var selectedGenderIndex: Int = 0
    @State private var currentDate = Date()
    @State private var age: Int = 0
    @State private var height: String = ""
    @State private var weight: String = ""
    private var genderOptions = ["Male", "Female"]
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var hudCoordinator: JGProgressHUDCoordinator
    @EnvironmentObject var notificationDelegate: NotificationDelegate
    @Environment(\.colorScheme) var colorScheme
    
    var disableForm: Bool {
        if emailAddress.isEmpty || password.isEmpty || confirmPassword.isEmpty || firstName.isEmpty || lastName.isEmpty || height.isEmpty || weight.isEmpty {
            return true
        }
        return false
    }
    
    var body: some View {
        ScrollView {
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
                    Picker("Gender", selection: $selectedGenderIndex) {
                        ForEach(0..<genderOptions.count) {
                            Text(self.genderOptions[$0])
                        }
                    }
                    .padding()
                    .pickerStyle(SegmentedPickerStyle())
                    DatePicker("Birthdate", selection: $currentDate, in: ...Date(), displayedComponents: .date)
                        .onChange(of: currentDate, perform: { value in
                            let diff = Calendar.current.dateComponents([.year], from: currentDate, to: Date())
                            self.age = diff.year!
                        })
                        .padding()
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
                        authViewModel.signInWithGoogle()
                    }.frame(width: 220, height: 80)
                
                HStack() {
                    Text("Already have an account?")
                        .foregroundColor(Color("FoodListItem_DarkGray"))
                    NavigationLink(destination: Login(), label: {
                        Text("Login")
                            .bold()
                            .foregroundColor(.swellOrange)
                    })
                }
                
                NavigationLink(
                    destination: Home(),
                    isActive: $isAuthenticated,
                    label: {
                        Button(action: {
                            if !password.elementsEqual(confirmPassword) {
                                showInvalidAlert = true
                            } else {
                                toggleLoadingIndicator()
                                authViewModel.signUp(email: emailAddress, password: password)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    userViewModel.setNewUser(
                                        fname: firstName,
                                        lname: lastName,
                                        age: age,
                                        gender: (selectedGenderIndex == 0 ? "Male" : "Female"),
                                        height: Int(height) ?? 0,
                                        weight: Int(weight) ?? 0
                                    )
                                    userViewModel.getUser()
                                    userViewModel.setLoginTimestamp()
                                    if authViewModel.state == .signedIn {
                                        self.isAuthenticated = true
                                    }
                                }
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
                    })
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .onTapGesture {
            hideKeyboard()
        }
        .onAppear() {
            UNUserNotificationCenter.current().delegate = notificationDelegate
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
