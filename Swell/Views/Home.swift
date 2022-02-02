//
//  Home.swift
//  Swell
//
//  Created by Tanner Maasen on 1/12/22.
//

import SwiftUI
import FirebaseAuth
import GoogleSignIn

struct Home: View {
    
    @State private var isShowingSidebar: Bool = true
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @ObservedObject var userViewModel = UserViewModel()
    @State var isShowingSignOut: Bool = false
    
    var body: some View {
        NavigationView {
        GeometryReader { geometry in
            
                ZStack(alignment: .leading) {
                    if isShowingSidebar {
                        showSidebar(isShowingSidebar: $isShowingSidebar)
//                            .withShowSidebarStyles(geometry: geometry)
                    }
                    ScrollView() {
                        LazyVStack(alignment: .center) {
                            // HEADER CONTENT
                            Header(isShowingSidebar: $isShowingSidebar)
                                .padding(.bottom, 300)
                            // MAIN CONTENT
                            PexelImage()
                        }
                        .blur(radius: isShowingSidebar ? 2 : 0)
                    }
                }
                .withDashboardStyles()
                .onTapGesture {
                    if isShowingSidebar {
                        withAnimation(.spring()) {
                            isShowingSidebar = false
                        }
                    }
                }
                .onAppear {
                    isShowingSidebar = false
                }
                .gesture(DragGesture()
                    .onEnded {
                        if $0.translation.width < -100 {
                            withAnimation {isShowingSidebar = false}
                        }
                    })
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}


struct showSidebar: View {
    @Binding var isShowingSidebar: Bool
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @ObservedObject var userViewModel = UserViewModel()
    @State var isShowingSignOut: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VerticalSidebarHeader(isShowingSidebar: $isShowingSidebar)
                    .frame(height: 240)
            }
            // Options
            ForEach(VerticalSidebar.allCases, id: \.self) {option in
                NavigationLink(destination: Text(option.title)) {
                    VerticalSidebarOptions(viewModel: option)
                }.buttonStyle(PlainButtonStyle())
            }.padding()

            Spacer()
            //Logout Functionality
            Divider()
            HStack {
                NavigationLink(destination: Login()) {}
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
        .withSidebarStyles()
    }
}
