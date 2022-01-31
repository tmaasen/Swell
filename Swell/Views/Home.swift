//
//  Home.swift
//  Swell
//
//  Created by Tanner Maasen on 1/12/22.
//

import SwiftUI
import FirebaseAuth
import JGProgressHUD_SwiftUI

struct Home: View {
    
    @State private var isShowingSidebar: Bool = true
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @EnvironmentObject var hudCoordinator: JGProgressHUDCoordinator
    @ObservedObject var userViewModel = UserViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
//                ScrollView(showsIndicators: false) {
                    ZStack(alignment: .leading) {
                        if isShowingSidebar {
                            VerticalSidebarMain(isShowingSidebar: $isShowingSidebar)
                                .withShowSidebarStyles(geometry: geometry)
                        }
                        VStack(alignment: .center) {
                            // HEADER CONTENT
                            Header(isShowingSidebar: $isShowingSidebar)
                            // MAIN CONTENT
                            PexelImage()
                        }
                        .blur(radius: isShowingSidebar ? 2 : 0)
                    }
                    .withDashboardStyles()
                    .onTapGesture {
                        if isShowingSidebar {
                            withAnimation(.spring()) {
                                isShowingSidebar = false
                            }
                        }
                    }
                    .onAppear { isShowingSidebar = false }
                    .gesture(DragGesture()
                        .onEnded {
                            if $0.translation.width < -100 {
                                withAnimation {isShowingSidebar = false}
                            }
                        })
//                }.ignoresSafeArea()
            }
        }
    }
    func showLoadingIndicator(pAfterDelay:Double) {
        hudCoordinator.showHUD {
            let hud = JGProgressHUD()
            hud.backgroundColor = UIColor(white: 0, alpha: 0.4)
            hud.shadow = JGProgressHUDShadow(color: .black, offset: .zero, radius: 4, opacity: 0.9)
            hud.vibrancyEnabled = true
            hud.textLabel.text = "Loading"
            hud.dismiss(afterDelay: pAfterDelay)
            return hud
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
