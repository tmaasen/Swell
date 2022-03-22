//
//  VerticalSidebarMain.swift
//  Swell
//
//  Created by Tanner Maasen on 1/20/22.
//
import SwiftUI

struct VerticalSidebarMain: View {
    @Binding var isShowingSidebar: Bool
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @State private var isShowingSignOut: Bool = false
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(alignment: .leading) {
                Spacer()
                HStack {
                    VerticalSidebarHeader(isShowingSidebar: $isShowingSidebar)
                        .frame(height: 140)
                }
                Spacer()
                // Options
                ForEach(VerticalSidebar.allCases, id: \.self) { option in
                        VerticalSidebarOption(viewModel: option)
                }.padding()
                Spacer()
                //Logout Functionality
                Divider()
                HStack {
                    NavigationLink(destination: Login()) { }
                    Image(systemName: "arrow.left.square.fill")
                        .font(.system(size: 25))
                    Text("Sign Out")
                        .font(.system(size: 20, weight: .semibold))
                    Spacer()
                }
                .onTapGesture { isShowingSignOut = true }
                .alert(isPresented: $isShowingSignOut) {
                    Alert(title: Text("Are You Sure?"), message: Text("If you sign out, you will return to the login screen."), primaryButton: .destructive(Text("Sign Out")) {
                        authViewModel.signOut()
                        presentationMode.wrappedValue.dismiss()
                    }, secondaryButton: .cancel(Text("Return")))
                }
                .padding(25)

                Spacer()
            }
        }
        .withSidebarStyles()
        .background(colorScheme == .dark ? Color(.black) : Color(.white))

    }
}

struct VerticalSidebarMain_Previews: PreviewProvider {
    static var previews: some View {
        VerticalSidebarMain(isShowingSidebar: .constant(true))
    }
}
