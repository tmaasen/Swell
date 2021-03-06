//
//  Home.swift
//  Swell
//
//  Created by Tanner Maasen on 1/12/22.
//

import SwiftUI
import JGProgressHUD_SwiftUI

/// Main dashboard view and contains all the content the user sees when they first open Swell and have logged in.
struct Home: View {
    @State private var isShowingSidebar: Bool = false
    @State private var isShowingSignOut: Bool = false
    @State private var showMoodLog: Bool = false
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @EnvironmentObject var hudCoordinator: JGProgressHUDCoordinator
    
    var body: some View {
        ZStack(alignment: .leading) {
            GeometryReader { geometry in
                if isShowingSidebar {
                    VerticalSidebarMain(isShowingSidebar: $isShowingSidebar)
                        .withShowSidebarStyles(geometry: geometry)
                }
                // MAIN CONTENT
                ScrollView() {
                    VStack(alignment: .leading, spacing: 25) {
                        Header(isShowingSidebar: $isShowingSidebar)
                            .padding(.bottom, 235)
                        TodaysLog()
                        WaterLog()
                        MealCards()
                        PexelImage()
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                    .blur(radius: isShowingSidebar ? 2 : 0)
                    .disabled(isShowingSidebar ? true : false)
                }
            }
        }
        .background(
            LinearGradient(
                gradient: authViewModel.gradient,
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
        }
        .gesture(DragGesture()
                    .onEnded {
                        if $0.translation.width > 50 {
                            withAnimation {isShowingSidebar = true}
                        }
                    }
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
