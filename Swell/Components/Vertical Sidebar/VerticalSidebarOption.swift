//
//  VerticalSidebarOptions.swift
//  Swell
//
//  Created by Tanner Maasen on 1/20/22.
//

import SwiftUI

struct VerticalSidebarOption: View {
    let viewModel: VerticalSidebar
    
    var body: some View {
        NavigationLink(destination: viewModel.navDestination) {
            Label(viewModel.title, systemImage: viewModel.imageName)
                .font(.system(size: 20, weight: .semibold))
                .padding(.leading, 10)
            Spacer()
        }.buttonStyle(PlainButtonStyle())
    }
}

struct VerticalSidebarOption_Previews: PreviewProvider {
    static var previews: some View {
        VerticalSidebarOption(viewModel: .profile)
    }
}
