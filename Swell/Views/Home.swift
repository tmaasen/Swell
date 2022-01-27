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
    
    @State private var isShowingSidebar: Bool = false
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authModel: AuthenticationViewModel
    @ObservedObject var api = Pexels()
    @ObservedObject var user = UserViewModel()
    var pexels = PexelImage()
    
    var body: some View {
        let drag = DragGesture()
            .onEnded {
                if $0.translation.width < -100 {
                    withAnimation {
                        isShowingSidebar = false
                    }
                }
            }
        GeometryReader { geometry in
            NavigationView {
                ZStack(alignment: .leading) {
                    if isShowingSidebar {
                        VerticalSidebarMain(isShowingSidebar: $isShowingSidebar)
                            .frame(width: geometry.size.width/1.5, height: geometry.size.height)
                            .background(RoundedRectangle(cornerRadius: 8)
                                            .fill(Color(.darkGray))
                                            .shadow(radius: 15))
                            .transition(.move(edge: .leading))
                    }
                    VStack(alignment: .leading) {
                        //Avatar
                        Button(action: {
                            withAnimation(.spring()) {
                                isShowingSidebar.toggle()
                            }
                        }, label: {AvatarIcon()}).buttonStyle(PlainButtonStyle())
                        //Greeting Message
                        Text((UtilFunctions.greeting))
                            .font(.custom("Ubuntu-Bold", size: 40))
                            .foregroundColor(.white)
                    }
                    // Continually test this as tappable area increases
                    .onTapGesture {
                        if isShowingSidebar {
                            withAnimation(.spring()) {
                                isShowingSidebar = false
                            }
                        }
                    }
                    .padding()
                    .offset(x: isShowingSidebar ? geometry.size.width/2 : 0)
                    .blur(radius: isShowingSidebar ? 2 : 0)
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .topLeading)
                    .navigationBarHidden(true)
                }
                .onAppear { isShowingSidebar = false }
                .gesture(drag)
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .topLeading)
                .background(
                    LinearGradient(
                        gradient: UtilFunctions.gradient,
                        startPoint: .top,
                        endPoint: .bottom)
                )
                .ignoresSafeArea()
            }
        }
    }
//    init() {
//        user.getUser()
//    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
//        let user = User(fname: "John", lname:"Doe")
        Home()
    }
}
