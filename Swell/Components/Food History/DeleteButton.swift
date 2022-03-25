//
//  DeleteButton.swift
//  Swell
//
//  Created by Tanner Maasen on 3/22/22.
//

import SwiftUI

struct DeleteButton: View {
    @State private var showDeleteActionSheet = false
    @EnvironmentObject var foodViewModel: FoodAndWaterViewModel
    var docId: String
    var collection: String
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                showDeleteActionSheet = true
            }, label: {
                Image(systemName: "trash")
                    .font(.title)
                    .foregroundColor(.white)
                    .background(Circle()
                                    .fill(Color.red)
                                    .frame(width: 50, height: 50))
            })
            .padding()
            .actionSheet(isPresented: $showDeleteActionSheet) {
                ActionSheet(
                    title: Text("This will permanently remove this item from your history, as well as all mood data accociated with this item."),
                    buttons: [
                        .destructive(Text("Delete")) {
                            foodViewModel.deleteFromHistory(doc: docId, collection: collection, completion: {
                                foodViewModel.getAllHistoryByDate()
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
        DeleteButton(docId: "", collection: "")
    }
}
