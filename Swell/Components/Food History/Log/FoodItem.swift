//
//  HistoryItem.swift
//  Swell
//
//  Created by Tanner Maasen on 3/9/22.
//

import SwiftUI

struct FoodItem: View {
    var item: FoodRetriever
    @EnvironmentObject var foodViewModel: FoodAndWaterViewModel
    @Environment(\.colorScheme) var colorScheme
    @State private var showDeleteAlert = false
    @State private var showFoodDataSheet = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                // Mood
                VStack(alignment: .center) {
                    if getMoodEmoji(pMood: item.mood ?? "") != "" {
                        Text("\(getMoodEmoji(pMood: item.mood ?? ""))")
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
                    Text("\(item.foodDescription?.capitalizingFirstLetter() ?? "")")
                        .font(.custom("Ubuntu-Bold", size: 12))
//                    Text("Servings: \(item.servingSize ?? 0)")
//                        .font(.custom("Ubuntu", size: 12))
                }
                Spacer()
                // Comments
                VStack(alignment: .leading) {
                    Text("Comments")
                        .italic()
                        .foregroundColor(.gray)
                        .font(.system(size: 12))
                    Text("\(item.comments != "" ? item.comments! : "No comments.")")
                        .font(.custom("Ubuntu", size: 14))
                }
                Spacer()
                // Info icon
                VStack(alignment: .center) {
                    Image(systemName: "info.circle")
                        .font(.system(size: 22))
                        .foregroundColor(.blue)
                        .sheet(isPresented: $showFoodDataSheet) {
                            FoodHistorySheet(foodRetriever: item, showFoodDataSheet: $showFoodDataSheet)
                        }
                        .onTapGesture {
                            showFoodDataSheet = true
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
        FoodItem(item: FoodRetriever(id: UUID(), mealType: "Breakfast", mood: "Happy", comments: "Today was good!", fdcID: 111111, foodDescription: "Cheese Omelet"))
    }
}
