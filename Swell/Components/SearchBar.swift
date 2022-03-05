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
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color("LightGray"))
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(colorScheme == .dark ? .black : Color("FoodListItem_DarkGray"))
                TextField("Search...", text: $searchText)
                { startedEditing in
                    if startedEditing {
                        withAnimation {
                            searching = true
                        }
                    }
                } onCommit: {
                    withAnimation {
                        searching = false
                    }
                }
                .foregroundColor(colorScheme == .dark ? .black : Color("FoodListItem_DarkGray"))
                Spacer()
                Image(systemName: "mic.fill")
                    .foregroundColor(colorScheme == .dark ? .black : Color("FoodListItem_DarkGray"))
                    .padding()
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
        SearchBar(searchText: .constant("Search..."), searching: .constant(false))
    }
}
