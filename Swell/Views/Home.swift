//
//  Home.swift
//  Swell
//
//  Created by Tanner Maasen on 1/12/22.
//

import SwiftUI
import FirebaseAuth

struct Home: View {
    
    @State private var isShowingSidebar: Bool = true
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @ObservedObject var userViewModel = UserViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ZStack(alignment: .leading) {
                    if isShowingSidebar {
                        VerticalSidebarMain(isShowingSidebar: $isShowingSidebar)
                            .withShowSidebarStyles(geometry: geometry)
                    }
                    VStack(alignment: .center) {
                        // HEADER
                        Header(isShowingSidebar: $isShowingSidebar)
                        // CONTENT
                        PexelImage()                        
                    }
                    .blur(radius: isShowingSidebar ? 2 : 0)
                    
                }
                .withDashboardStyles(geometry: geometry)
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
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
