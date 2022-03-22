//
//  DeleteButton.swift
//  Swell
//
//  Created by Tanner Maasen on 3/22/22.
//

import SwiftUI

struct DeleteButton: View {
    @State private var showDeleteAlert = false
    @EnvironmentObject var foodViewModel: FoodDataCentralViewModel
    var docId: String
    var collection: String
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                showDeleteAlert = true
            }, label: {
                Image(systemName: "trash")
                    .font(.body)
                    .foregroundColor(.white)
                    .background(Circle()
                                    .fill(Color.red)
                                    .frame(width: 30, height: 30))
            })
            .padding()
            .alert(isPresented: $showDeleteAlert) {
                Alert(title: Text("Are You Sure?"), message: Text("Delete this item from your history? This will also remove your mood history"), primaryButton: .destructive(Text("Delete")) {
                    foodViewModel.deleteFromHistory(doc: docId, collection: collection, completion: {
                        foodViewModel.getAllHistoryByDate()
                    })
                }, secondaryButton: .cancel(Text("Return")))
            }
        }
    }
}

struct DeleteButton_Previews: PreviewProvider {
    static var previews: some View {
        DeleteButton(docId: "", collection: "")
    }
}
