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
            HStack {
                Image(systemName: viewModel.imageName)
                    .font(.system(size: 25))
                Text(viewModel.title)
                    .font(.system(size: 20, weight: .semibold))
                Spacer()
            }
            .padding(.leading, 10)
        }.buttonStyle(PlainButtonStyle())
    }
}

struct VerticalSidebarOption_Previews: PreviewProvider {
    static var previews: some View {
        VerticalSidebarOption(viewModel: .profile)
    }
}
