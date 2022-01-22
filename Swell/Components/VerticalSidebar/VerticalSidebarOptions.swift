//
//  VerticalSidebarOptions.swift
//  Swell
//
//  Created by Tanner Maasen on 1/20/22.
//

import SwiftUI

struct VerticalSidebarOptions: View {
    let viewModel: VerticalSidebar
    
    var body: some View {
        HStack {
            Image(systemName: viewModel.imageName)
                .font(.system(size: 25))
            Text(viewModel.title)
                .font(.system(size: 20, weight: .semibold))
            Spacer()
        }
        .padding(.leading, 15)
    }
}

struct VerticalSidebarOptions_Previews: PreviewProvider {
    static var previews: some View {
        VerticalSidebarOptions(viewModel: .profile)
    }
}
