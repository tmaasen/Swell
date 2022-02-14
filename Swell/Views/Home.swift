//
//  Home.swift
//  Swell
//
//  Created by Tanner Maasen on 1/12/22.
//
import SwiftUI
import FirebaseAuth
import JGProgressHUD_SwiftUI
import GoogleSignIn
import CareKitUI

struct Home: View {
    
    @State private var isShowingSidebar: Bool = false
    @State private var isShowingSignOut: Bool = false
    @State private var showLoader: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var hudCoordinator: JGProgressHUDCoordinator
    
    var body: some View {
        ZStack(alignment: .leading) {
            GeometryReader { geometry in
                if isShowingSidebar {
                    VerticalSidebarMain(isShowingSidebar: $isShowingSidebar)
                        .withShowSidebarStyles(geometry: geometry)
                }
                ScrollView() {
                    VStack(alignment: .center) {
                        // HEADER CONTENT
                        Header(isShowingSidebar: $isShowingSidebar)
                            .padding(.bottom, 300)
                        // MAIN CONTENT
                        PexelImage()
                    }
                    .blur(radius: isShowingSidebar ? 2 : 0)
                }
            }
        }
        .background(
                LinearGradient(
                    gradient: userViewModel.gradient,
                    startPoint: .top,
                    endPoint: .bottom)
            )
        .ignoresSafeArea()
        .onTapGesture {
            if isShowingSidebar {
                withAnimation(.spring()) {
                    isShowingSidebar = false
                }
            }
        }
        .onAppear {
            isShowingSidebar = false
            // avatar icon is broken on register -> login
            userViewModel.getUser()
            userViewModel.getGreeting(name: GIDSignIn.sharedInstance.currentUser?.profile?.givenName ?? userViewModel.user.fname)
        }
        .gesture(DragGesture()
                    .onEnded {
                        if $0.translation.width < -100 {
                            withAnimation {isShowingSidebar = false}
                        }
                    })
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
