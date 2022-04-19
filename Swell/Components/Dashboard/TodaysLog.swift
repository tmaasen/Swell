//
//  TodaysLog.swift
//  Swell
//
//  Created by Tanner Maasen on 3/27/22.
//

import SwiftUI

struct TodaysLog: View {
    @EnvironmentObject var foodViewModel: FoodAndWaterViewModel
    @State private var isLoading = true
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Today's Log")
                .font(.custom("Ubuntu-Bold", size: 30))
                .foregroundColor(.white)
            if isLoading {
                HStack(spacing: 20) {
                    LoadingShimmer(width: 200, height: 150)
                    LoadingShimmer(width: 200, height: 150)
                    LoadingShimmer(width: 200, height: 150)
                }
            }
            if !isLoading && !foodViewModel.foodHistory.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(MealTypes.allCases, id: \.self) { meal in
                            if foodViewModel.foodHistory.first(where: {$0.mealType == meal.text}) != nil {
                                ForEach(foodViewModel.foodHistory, id: \.self.id) { food in
                                    if food.mealType == meal.text {
                                        TodaysLogCard(food: food)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .onChange(of: foodViewModel.isLoadingHistory, perform: { newValue in
            isLoading = foodViewModel.isLoadingHistory
        })
    }
}

struct TodaysLogCard: View {
    var food: FoodRetriever
    @State private var showMoodLog: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            NavigationLink(
                destination: MoodLog(docRef: food.docId ?? ""),
                isActive: self.$showMoodLog) {}            
            VStack(alignment: .leading) {
                Text("\(food.foodDescription?.capitalizingFirstLetter() ?? "")")
                    .font(.custom("Ubuntu-Bold", size: 16))
                    .foregroundColor(.black)
                    .fixedSize(horizontal: false, vertical: true)
                    .lineLimit(2)
                Spacer()
                    .frame(height: 20)
                Text("\(food.mealType ?? "")")
                    .font(.custom("Ubuntu-BoldItalic", size: 16))
                    .foregroundColor(.black)
                Spacer()
                    .frame(height: 20)
                HStack {
                    Capsule()
                        .fill(food.mood == "" ? Color.gray : getMoodColor())
                        .frame(width: 65, height: 25)
                        .overlay(
                            Text(food.mood == "" ? "Log Mood" : food.mood!)
                                .foregroundColor(.black)
                                .font(.custom("Ubuntu", size: 10))
                                .disabled(food.mood != "")
                        )
                }
            }
            .padding()
        }
        .onTapGesture {
            if food.mood == "" {
                showMoodLog = true
            }
        }
        .padding()
        .frame(maxWidth: 250)
        .background(Color("FoodListItem_LightGray"))
        .cornerRadius(10)
    }
    func getMoodColor() -> Color {
        if food.mood == "Happy" {
            return Color.green
        } else if food.mood == "Neutral" {
            return Color.yellow
        } else if food.mood == "Sick" {
            return Color.red
        } else {
            return Color.purple
        }
    }
}

struct TodaysLog_Previews: PreviewProvider {
    static var previews: some View {
        TodaysLog()
    }
}
