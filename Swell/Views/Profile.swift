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
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @EnvironmentObject var hudCoordinator: JGProgressHUDCoordinator
    @ObservedObject var userViewModel = UserViewModel()
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var selectedGenderIndex: Int = 1
    @State private var age: String = ""
    @State private var height: String = ""
    @State private var weight: String = ""
    private var genderOptions = ["Male", "Female"]
    @State private var isFormDisabled: Bool = true
    
    var body: some View {
        NavigationView {
            ScrollView {
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
                        Text("Height")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .padding(.leading, 10)
                        TextField("", text: $height)
                            .withProfileStyles()
                            .keyboardType(.numberPad)
                            .disabled(isFormDisabled)
                    }
                    VStack(alignment: .leading) {
                        Text("Weight")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .padding(.leading, 10)
                        TextField("", text: $weight)
                            .withProfileStyles()
                            .keyboardType(.numberPad)
                            .disabled(isFormDisabled)
                    }
                    Spacer()
                }
                .padding()
                .navigationTitle("Profile")
                .navigationBarItems(trailing:
                                        Image(systemName: "square.and.pencil").foregroundColor(.accentColor).font(.title2).onTapGesture {
                                            isFormDisabled = false
                                        })
                .onAppear() {
                    userViewModel.getUser()
                    firstName = userViewModel.user.fname
                    lastName = userViewModel.user.lname
                    selectedGenderIndex = userViewModel.user.gender == "Female" ? 1 : 0
                    age = String(userViewModel.user.age)
                    height = String(userViewModel.user.height)
                    weight = String(userViewModel.user.weight)
                    
                }
                HStack(alignment: .bottom) {
                    Button("Save") {
                        userViewModel.setUser()
                    }
                    .withButtonStyles()
                    .disabled(isFormDisabled)
                }
            }
        }
    }
}

struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}
