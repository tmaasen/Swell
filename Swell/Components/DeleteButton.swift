//
//  DeleteButton.swift
//  Swell
//
//  Created by Tanner Maasen on 3/22/22.
//

import SwiftUI

struct DeleteButton: View {
    var docId: String
    var collection: String
    var popUpText: String
    @State private var showDeleteActionSheet = false
    @StateObject var historyLogViewModel = HistoryLogViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        HStack {
            Button(action: {
                showDeleteActionSheet = true
            }, label: {
                Image(systemName: "trash")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .background(Circle()
                                    .fill(Color.red)
                                    .frame(width: 40, height: 40))
            })
            .padding()
            .actionSheet(isPresented: $showDeleteActionSheet) {
                ActionSheet(
                    title: Text(popUpText),
                    buttons: [
                        .destructive(Text("Delete")) {
                            historyLogViewModel.deleteFromHistory(doc: docId, collection: collection, completion: {
                                presentationMode.wrappedValue.dismiss()
                            })
                        },
                        .cancel()
                    ]
                )
            }
        }
    }
}

struct DeleteButton_Previews: PreviewProvider {
    static var previews: some View {
        DeleteButton(docId: "", collection: "", popUpText: "")
    }
}
