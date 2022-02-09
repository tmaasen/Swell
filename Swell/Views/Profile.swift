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
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var showDeleteAccountAlert: Bool = false
    @State private var accountDeleted: Bool = false
    @State private var isFormDisabled: Bool = true
    @State private var showLoader: Bool = false
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var selectedGenderIndex: Int = 1
    @State private var age: String = ""
    @State private var height: String = ""
    @State private var weight: String = ""
    private var genderOptions = ["Male", "Female"]
    
    var body: some View {
        VStack {
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
                .pickerStyle(SegmentedPickerStyle())
                .disabled(isFormDisabled)
                .padding(.horizontal)
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
            Spacer()
            HStack(alignment: .bottom) {
                Button("Save") {
                    self.userViewModel.updateUser(
                        fname: firstName,
                        lname: lastName,
                        age: Int(age) ?? 0,
                        gender: (selectedGenderIndex == 0 ? "Male" : "Female"),
                        height: Int(height) ?? 0,
                        weight: Int(weight) ?? 0
                    )
                }
                .withButtonStyles()
            }
            Spacer()
            HStack {
                NavigationLink(destination: Login()) { }
                Image(systemName: "trash")
                Text("Delete Account")
            }
            .foregroundColor(.red)
            .onTapGesture { showDeleteAccountAlert = true }
            .alert(isPresented: $showDeleteAccountAlert) {
                Alert(title: Text("Delete Account"), message: Text("Are you sure? This action cannot be undone and your data will be deleted."), primaryButton: .destructive(Text("Delete")) {
                    toggleLoadingIndicator()
                    authViewModel.removeAccount()
                    presentationMode.wrappedValue.dismiss()
                }, secondaryButton: .cancel(Text("Return")))
            }
        }
        .disabled(isFormDisabled)
        .opacity(isFormDisabled ? 0.6 : 1.0)
        .onTapGesture {
                hideKeyboard()
            }
        .padding()
        .navigationTitle("Profile")
        .navigationBarItems(trailing:
                                Image(systemName: "square.and.pencil").foregroundColor(.accentColor).font(.title2).onTapGesture {
                                    isFormDisabled.toggle()
                                })
        .onAppear() {
            firstName = userViewModel.user.fname
            lastName = userViewModel.user.lname
            selectedGenderIndex = userViewModel.user.gender == "Female" ? 1 : 0
            age = String(userViewModel.user.age)
            height = String(userViewModel.user.height)
            weight = String(userViewModel.user.weight)
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
            hud.dismiss(afterDelay: 3.0)
            return hud
        }
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}
