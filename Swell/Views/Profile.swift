//
//  Profile.swift
//  Swell
//
//  Created by Tanner Maasen on 2/1/22.
//

import SwiftUI
import FirebaseAuth
import JGProgressHUD_SwiftUI

struct Profile: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @EnvironmentObject var hudCoordinator: JGProgressHUDCoordinator
    @State private var showDeleteAccountAlert: Bool = false
    @State private var showPhotoPickerSheet: Bool = false
    @State private var isFormDisabled: Bool = true
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var selectedGenderIndex: Int = 0
    var genderOptions = ["Male", "Female"]
    @State private var age: String = ""
    @State private var height: String = ""
    @State private var weight: String = ""
    @State private var activeAlert: ActiveAlert = .deleteUser
    
    var body: some View {
        ScrollView {
            Section {
                ZStack(alignment: .bottomTrailing) {
                    AvatarIcon(isShowingSidebar: .constant(true), showPhotoPickerSheet: $showPhotoPickerSheet, width: 120, height: 120)
                        .foregroundColor(.black)
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .frame(width: 25, height: 25)
                        .background(Color.blue)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                }
                .disabled(isFormDisabled)
                .onTapGesture { showPhotoPickerSheet = true }
            }
            Section {
                VStack(alignment: .leading) {
                    Text("First Name")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding(.leading, 10)
                    TextField("", text: $firstName)
                        .withProfileStyles()
                        .textContentType(.givenName)
                        .disabled(isFormDisabled)
                }
                VStack(alignment: .leading) {
                    Text("Last Name")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding(.leading, 10)
                    TextField("", text: $lastName)
                        .withProfileStyles()
                        .textContentType(.name)
                        .disabled(isFormDisabled)
                }
                VStack(alignment: .leading) {
                    Text("Gender")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding(.leading, 10)
                    Picker("", selection: $selectedGenderIndex) {
                        ForEach(0..<genderOptions.count) {
                            Text(self.genderOptions[$0])
                        }
                    }
                    .disabled(isFormDisabled)
                    .padding()
                    .pickerStyle(SegmentedPickerStyle())
                }
                VStack(alignment: .leading) {
                    Text("Age")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding(.leading, 10)
                    TextField("", text: $age)
                        .withProfileStyles()
                        .keyboardType(.numberPad)
                        .disabled(isFormDisabled)
                }
                VStack(alignment: .leading) {
                    Text("Height (inches)")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding(.leading, 10)
                    TextField("", text: $height)
                        .withProfileStyles()
                        .keyboardType(.numberPad)
                        .disabled(isFormDisabled)
                }
                VStack(alignment: .leading) {
                    Text("Weight (lbs)")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .padding(.leading, 10)
                    TextField("", text: $weight)
                        .withProfileStyles()
                        .keyboardType(.numberPad)
                        .disabled(isFormDisabled)
                }
            }
            Spacer()
            HStack(alignment: .bottom) {
                Button(action: {
                    hideKeyboard()
                    toggleLoadingIndicator()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        authViewModel.updateUser(
                            fname: firstName,
                            lname: lastName,
                            age: Int(age) ?? 0,
                            gender: (selectedGenderIndex == 0 ? "Male" : "Female"),
                            height: Int(height) ?? 0,
                            weight: Int(weight) ?? 0
                        )
//                        authViewModel.setAvatarImage(pImage: authViewModel.avatarImage)
                    }
                }) {
                    Text("Save")
                        .withButtonStyles()
                        .padding(.top, 30)
                }
            }
            Spacer()
            HStack {
                NavigationLink(destination: Login()) { }
                Image(systemName: "trash")
                Text("Delete Account")
            }
            .padding(.top, 30)
            .foregroundColor(.red)
            .onTapGesture {
                showDeleteAccountAlert = true
            }
            .alert(isPresented: $showDeleteAccountAlert) {
                switch activeAlert {
                case .deleteUser:
                    return Alert(title: Text("Delete Account"), message: Text("Are you sure? This action cannot be undone and your data will be deleted."), primaryButton: .destructive(Text("Delete")) {
                        toggleLoadingIndicator()
                        authViewModel.removeAccount()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            if authViewModel.needsToReauthenticate {
                                self.activeAlert = .reauthenticate
                                self.showDeleteAccountAlert = true
                            } else {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }, secondaryButton: .cancel() {self.showDeleteAccountAlert = false})
                case .reauthenticate:
                    return Alert(title: Text("Reauthentication Required"), message: Text(authViewModel.errorMessage), primaryButton: .destructive(Text("Log Out")) {
                        toggleLoadingIndicator()
                        authViewModel.signOut()
                        presentationMode.wrappedValue.dismiss()
                    }, secondaryButton: .cancel() {
                        self.activeAlert = .deleteUser
                        self.showDeleteAccountAlert = false
                    })
                }
            }
        }
        .disabled(isFormDisabled)
        .opacity(isFormDisabled ? 0.6 : 1.0)
        .padding()
        .navigationTitle("Profile")
        .navigationBarItems(trailing:
                                Button(action: {
                                    isFormDisabled.toggle()
                                }, label: {
                                    HStack {
                                        Text("Edit")
                                        Image(systemName: "square.and.pencil").foregroundColor(.accentColor).font(.title3)
                                    }
                                })
        )
        .onAppear() {
            firstName = authViewModel.user.fname
            lastName = authViewModel.user.lname
            selectedGenderIndex = authViewModel.user.gender == "Female" ? 1 : 0
            age = String(authViewModel.user.age)
            height = String(authViewModel.user.height)
            weight = String(authViewModel.user.weight)
        }
        .onDisappear() {
            firstName = ""
            lastName = ""
            selectedGenderIndex = 0
            age = ""
            height = ""
            weight = ""
        }
    }
    func toggleLoadingIndicator() {
        hudCoordinator.showHUD {
            let hud = JGProgressHUD()
            hud.backgroundColor = UIColor(white: 0, alpha: 0.4)
            hud.shadow = JGProgressHUDShadow(color: .black, offset: .zero, radius: 4, opacity: 0.9)
            hud.vibrancyEnabled = true
            hud.textLabel.text = "Loading"
            hud.dismiss(afterDelay: 2.0)
            return hud
        }
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}

enum ActiveAlert {
    case deleteUser, reauthenticate
}
