//
//  CustomMealsSheet_Section.swift
//  Swell
//
//  Created by Tanner Maasen on 4/26/22.
//

import SwiftUI

struct CustomMealsSheet_Section: View {
    var title: String
    var array1: [String]
    var array2: [String]
    
    var body: some View {
        Section(header:
                    Text(title)
                    .bold()
                    .font(.custom("Ubuntu", size: 18))) {
            VStack(alignment: .leading) {
                ForEach(0..<array1.count) { i in
                    HStack {
                        Text(array1[i].capitalizingFirstLetter())
                            .font(.custom("Ubuntu", size: 16))
                        Text(array2[i])
                            .font(.custom("Ubuntu", size: 16))
                    }
                    if i < array1.count {
                        Divider()
                    }
                }
            }
        }
    }
}
