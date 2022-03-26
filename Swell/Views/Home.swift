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
    @State private var isShowingSidebar: Bool = false
    @State private var isShowingSignOut: Bool = false
    @State private var showLoader: Bool = false
    @State private var showMoodLog: Bool = false
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @EnvironmentObject var hudCoordinator: JGProgressHUDCoordinator
    
    var body: some View {
        ZStack(alignment: .leading) {
            // For Mood Log view from Notification tap
            NavigationLink(
                destination: MoodLog(docRef: NotificationManager.instance.docRef, showMoodLog: self.$showMoodLog),
                isActive: self.$showMoodLog) {}
            
            GeometryReader { geometry in
                if isShowingSidebar {
                    VerticalSidebarMain(isShowingSidebar: $isShowingSidebar)
                        .withShowSidebarStyles(geometry: geometry)
                }
                // MAIN CONTENT
                ScrollView() {
                    VStack(alignment: .center, spacing: 10) {
                        Header(isShowingSidebar: $isShowingSidebar)
                            .padding(.bottom, 225)
                        MealCards()
                        WaterLog()
                        PexelImage()
                    }
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
            authViewModel.getAllUserInfo()
            // Observer for when user taps on notification to log mood in app
            NotificationCenter.default.addObserver(forName: NSNotification.Name("MoodLog"), object: nil, queue: .main) { (_) in
                self.showMoodLog = true
            }
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
