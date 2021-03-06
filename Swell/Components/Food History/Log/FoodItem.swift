//
//  HistoryItem.swift
//  Swell
//
//  Created by Tanner Maasen on 3/9/22.
//

import SwiftUI

struct FoodItem: View {
    var fdcFoodHistory: FoodRetriever
    var customFoodHistory: MyMeal
    @State private var showFoodDataSheet = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                // Mood
                VStack(alignment: .center) {
                    if getMoodEmoji(pMood: fdcFoodHistory.mood ?? customFoodHistory.mood ?? "") != "" {
                        Text("\(getMoodEmoji(pMood: fdcFoodHistory.mood ?? customFoodHistory.mood ?? ""))")
                            .font(.system(size: 45))
                    } else {
                        Circle()
                            .fill(Color("FoodListItem_LightGray"))
                            .frame(width: 45, height: 45)
                    }
                }
                Spacer()
                // Food
                VStack(alignment: .leading) {
                    Text("Food")
                        .italic()
                        .foregroundColor(.gray)
                        .font(.system(size: 12))
                    Text("\(fdcFoodHistory.foodDescription?.capitalizingFirstLetter() ?? customFoodHistory.name ?? "")")
                        .font(.custom("Ubuntu-Bold", size: 12))
                }
                Spacer()
                // Comments
                VStack(alignment: .leading) {
                    Text("Comments")
                        .italic()
                        .foregroundColor(.gray)
                        .font(.system(size: 12))
                    if fdcFoodHistory == FoodRetriever() {
                        Text("\(customFoodHistory.comments != "" ? customFoodHistory.comments ?? "" : "No comments.")")
                            .font(.custom("Ubuntu", size: 14))
                    } else {
                        Text("\(fdcFoodHistory.comments != "" ? fdcFoodHistory.comments ?? "" : "No comments.")")
                            .font(.custom("Ubuntu", size: 14))
                    }
                }
                Spacer()
                // Info icon
                VStack(alignment: .center) {
                    Image(systemName: "info.circle")
                        .font(.system(size: 22))
                        .foregroundColor(.blue)
                        .onTapGesture {
                            showFoodDataSheet.toggle()
                        }
                        .fullScreenCover(isPresented: $showFoodDataSheet) {
                            if fdcFoodHistory == FoodRetriever() {
                                CustomMealsSheet(myMeal: customFoodHistory, isFromHistory: true, contains: .constant([""]))
                            } else {
                                FoodHistorySheet(foodRetriever: fdcFoodHistory, showFoodDataSheet: $showFoodDataSheet)
                            }
                        }
                }
            }
            .padding(.horizontal, 30)
            
            Divider()
                .frame(height: 1)
                .background(Color("FoodListItem_LightGray"))
                .padding(.horizontal, 30)
        }
    }
    func getMoodEmoji(pMood: String) -> String {
        if pMood == "Happy" { return Mood.happy.emoji }
        if pMood == "Neutral" { return Mood.neutral.emoji }
        if pMood == "Sick" { return Mood.sick.emoji }
        if pMood == "Overate" { return Mood.overate.emoji }
        return ""
    }
}

struct HistoryFoodItem_Previews: PreviewProvider {
    static var previews: some View {
        FoodItem(fdcFoodHistory: FoodRetriever(id: UUID(), mealType: "Breakfast", mood: "Happy", comments: "Today was good!", fdcID: 111111, foodDescription: "Cheese Omelet"), customFoodHistory: MyMeal())
    }
}
