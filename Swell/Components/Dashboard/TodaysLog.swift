//
//  TodaysLog.swift
//  Swell
//
//  Created by Tanner Maasen on 3/27/22.
//

import SwiftUI

struct TodaysLog: View {
    @EnvironmentObject var foodViewModel: FoodAndWaterViewModel
    @State private var isLoading: Bool = false
    
    var body: some View {
        if !foodViewModel.foodHistory.isEmpty && !isLoading {
            VStack(alignment: .leading) {
                Text("Today's Log")
                    .font(.custom("Ubuntu-Bold", size: 30))
                    .foregroundColor(.white)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(foodViewModel.foodHistory, id: \.self.id) { food in
                            TodaysLogCard(food: food)
                        }
                    }
                }
            }
        } else {
            // handle loading with new shimmer feature
        }
    }
}

struct TodaysLogCard: View {
    var food: FoodRetriever
    @State private var showMoodLog: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            NavigationLink(
                destination: MoodLog(docRef: food.docId ?? "", showMoodLog: self.$showMoodLog),
                isActive: self.$showMoodLog) {}
            
            VStack(alignment: .leading) {
                Text("\(food.foodDescription ?? "")")
                    .font(.custom("Ubuntu-Bold", size: 16))
                    .truncationMode(.tail)
                Spacer()
                    .frame(height: 20)
                Text("\(food.mealType ?? "")")
                    .font(.custom("Ubuntu-BoldItalic", size: 16))
                Spacer()
                    .frame(height: 20)
                HStack {
                    Capsule()
                        .fill(food.mood == "" ? Color.gray : Color.green)
                        .frame(width: 65, height: 25)
                        .overlay(
                            Text(food.mood == "" ? "Log Mood" : food.mood!)
                                .font(.custom("Ubuntu", size: 10))
                        )
                }
            }
            .padding()
            .frame(width: 200, height: 125)
        }
        .onTapGesture {
            if food.mood == "" {
                showMoodLog = true
            }
        }
        .background(
            Rectangle()
                .fill(Color("FoodListItem_LightGray"))
                .frame(width: 175, height: 125)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 5)
                )
        )
    }
}

struct TodaysLog_Previews: PreviewProvider {
    static var previews: some View {
        TodaysLog()
    }
}
