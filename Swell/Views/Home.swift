//
//  Home.swift
//  Swell
//
//  Created by Tanner Maasen on 1/12/22.
//
import SwiftUI
import FirebaseAuth
import SDWebImageSwiftUI

struct Home: View {
    
    @State private var isShowingSidebar: Bool = true
    @State private var isShowingSignOut: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @ObservedObject var userViewModel = UserViewModel()
    
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
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
