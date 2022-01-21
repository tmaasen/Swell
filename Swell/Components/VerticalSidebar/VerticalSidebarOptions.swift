//
//  VerticalSidebarOptions.swift
//  Swell
//
//  Created by Tanner Maasen on 1/20/22.
//

import SwiftUI

struct VerticalSidebarOptions: View {
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "person")
                .frame(width: 24, height: 24)
            Text("My Profile")
                .font(.system(size: 24, weight: .semibold))
            
            Spacer()
            
        }
        .padding(.leading, 20)
    }
}

struct VerticalSidebarOptions_Previews: PreviewProvider {
    static var previews: some View {
        VerticalSidebarOptions()
    }
}
