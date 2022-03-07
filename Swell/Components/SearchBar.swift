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
    @EnvironmentObject var foodViewModel: FoodDataCentralViewModel
    
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
                if searching {
                    Image(systemName: "arrow.forward.circle")
                        .foregroundColor(Color("iosKeyboardFontColor"))
                        .padding()
                        .onTapGesture {
                            if !searchText.isEmpty {
                                isLoading = true
                                foodViewModel.search(searchTerms: searchText, pageSize: 200)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                    isLoading = false
                                })
                                withAnimation {
                                    hideKeyboard()
                                }
                            }
                        }
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
        SearchBar(searchText: .constant("Search"), searching: .constant(false), isLoading: .constant(false))
    }
}
