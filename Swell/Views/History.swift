//
//  History.swift
//  Swell
//
//  Created by Tanner Maasen on 2/14/22.
//

import SwiftUI
import Firebase

struct History: View {
    @EnvironmentObject var foodViewModel: FoodDataCentralViewModel
    @State private var isLoading = false
    @State private var selectedDate = Date()
    
    var body: some View {
        VStack {
            DatePicker("Date", selection: $selectedDate, in: ...Date(), displayedComponents: .date)
                .padding()
                .labelsHidden()
                .onChange(of: selectedDate, perform: { value in
                    isLoading = true
                    foodViewModel.getFoodIds(date: selectedDate)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                        isLoading = false
                    })
                })
            ScrollView {
                ForEach(foodViewModel.foodHistory, id: \.self.id) { item in
                    VStack {
                        Text("\(item.description ?? "")")
                        Text("\(item.mealType ?? "")")
                        Text("Serving Size: \(item.servingSize ?? 0)")
                    }
                }
            }
        }
        .navigationTitle("History")
        .onAppear() {
            isLoading = true
            foodViewModel.getFoodIds(date: Timestamp(date: Date()).dateValue())
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                isLoading = false
            })
        }
        if isLoading {
            ZStack(alignment: .leading) {
                LottieAnimation(filename: "loading", loopMode: .loop, width: 50, height: 50)
            }
        }
    }
}

struct History_Previews: PreviewProvider {
    static var previews: some View {
        History()
    }
}
