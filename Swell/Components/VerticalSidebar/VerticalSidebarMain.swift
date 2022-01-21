//
//  VerticalSidebarMain.swift
//  Swell
//
//  Created by Tanner Maasen on 1/20/22.
//

import SwiftUI

struct VerticalSidebarMain: View {
    @Binding var isShowingSidebar: Bool
    
    var body: some View {
        ZStack {
            Color(.white)
            VStack {
                //Header
                VerticalSidebarHeader(isShowingSidebar: $isShowingSidebar)
                    .frame(height: 240)
                //Options
                ForEach(0..<5) {_ in
                    VerticalSidebarOptions()
                }
                
                Spacer()
            }
        }
        .navigationBarHidden(true)
        .zIndex(1.0)
    }
}

struct VerticalSidebarMain_Previews: PreviewProvider {
    static var previews: some View {
        VerticalSidebarMain(isShowingSidebar: .constant(true))
    }
}
