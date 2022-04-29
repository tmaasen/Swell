//
//  SearchBar.swift
//  Swell
//
//  Created by Tanner Maasen on 2/15/22.
//

import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    @Binding var searching: Bool
    @Binding var isLoading: Bool
    @State var focused: [Bool] = [false, true]
    @EnvironmentObject var foodAndMoodViewModel: FoodAndMoodViewModel
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color("iosKeyboardBackground"))
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color("iosKeyboardFontColor"))
                CustomTextField(tag: 0, keyboardType: .default, returnVal: .search, text: $searchText, isfocusAble: $focused, isLoading: $isLoading, searchText: $searchText, searching: $searching).foregroundColor(Color("iosKeyboardFontColor"))
            }
            .padding(.leading, 13)
        }
        .frame(height: 40)
        .cornerRadius(13)
        .padding()
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(searchText: .constant("Search"), searching: .constant(false), isLoading: .constant(false))
    }
}
