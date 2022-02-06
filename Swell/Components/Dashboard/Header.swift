//
//  Header.swift
//  Swell
//
//  Created by Tanner Maasen on 1/29/22.
//

import SwiftUI
import GoogleSignIn
import FirebaseAuth

struct Header: View {
    @State private var greeting: String = ""
    @Binding var isShowingSidebar: Bool
    @EnvironmentObject var utils: UtilFunctions
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                //Avatar
                Button(action: {
                    withAnimation(.spring()) {
                        isShowingSidebar.toggle()
                    }
                }, label: {AvatarIcon(isShowingSidebar: $isShowingSidebar)}).buttonStyle(PlainButtonStyle())
                //Greeting Message
                Text(greeting)
                    .font(.custom("Ubuntu-Bold", size: 40))
                    .foregroundColor(.white)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding()
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .topLeading)
            .navigationBarHidden(true)
            .onAppear() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    getGreeting(name: GIDSignIn.sharedInstance.currentUser?.profile?.givenName ?? userViewModel.user.fname)
                }
            }
        }
    }
    
    // Gets greeting message
    func getGreeting(name: String) {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 0..<5 :
            UtilFunctions.gradient = Gradient(stops: [
                                                .init(color: Color.eveningLinear1, location: 0.23),
                                                .init(color: Color.eveningLinear2, location: 0.84)])
            self.greeting = "Good evening, \n\(name)"
        case 5..<12 : self.greeting = "Good morning, \n\(name)"
        case 12..<17 : self.greeting = "Good afternoon, \n\(name)"
        case 17..<24 :
            UtilFunctions.gradient = Gradient(stops: [
                                                .init(color: Color.eveningLinear1, location: 0.23),
                                                .init(color: Color.eveningLinear2, location: 0.84)])
            self.greeting = "Good evening, \n\(name)"
        default:
            self.greeting = "Hello"
        }
    }
}

struct Header_Previews: PreviewProvider {
    static var previews: some View {
        Header(isShowingSidebar: .constant(true))
    }
}
