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
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color("iosKeyboardBackground"))
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color("iosKeyboardFontColor"))
                TextField("Search", text: $searchText)
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
                .foregroundColor(Color("iosKeyboardFontColor"))
                Spacer()
                Image(systemName: "mic.fill")
                    .font(.system(size: 30))
                    .foregroundColor(Color("iosKeyboardFontColor"))
                    .onTapGesture {
                        // start voice dictation mode on keyboard
                    }
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
        SearchBar(searchText: .constant("Search"), searching: .constant(false))
    }
}
