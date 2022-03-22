//
//  HistoryItem.swift
//  Swell
//
//  Created by Tanner Maasen on 3/9/22.
//

import SwiftUI

struct HistoryFoodItem: View {
    var item: FoodRetriever
    @EnvironmentObject var foodViewModel: FoodDataCentralViewModel
    @Environment(\.colorScheme) var colorScheme
    @State private var showDeleteAlert = false
    
    var body: some View {
        ZStack(alignment: .leading) {
            HStack {
                // Food
                VStack(alignment: .leading) {
                    Text("\(item.description ?? "")")
                        .font(.custom("Ubuntu-Bold", size: 12))
                    Text("Servings: \(item.servingSize ?? 0)")
                        .font(.custom("Ubuntu", size: 12))
                }
                // Mood
                VStack(alignment: .center) {
                    Text("\(getMoodEmoji(pMood: item.mood ?? ""))")
                        .font(.system(size: 35))
                    Text("\(item.mood != "" ? item.mood! : "No mood specified.")")
                        .font(.custom("Ubuntu", size: 14))
                }
                // Comments
                VStack(alignment: .leading) {
                    Text("\(item.comments != "" ? item.comments! : "No comments.")")
                        .font(.custom("Ubuntu", size: 14))
                }
            }
            .frame(width: 275, height: 75)
            .padding()
            .contentShape(Rectangle())
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(colorScheme == .dark ? Color.white : Color.black, lineWidth: 5)
            )
            .padding(.horizontal)
            
            // Delete Button
            DeleteButton(docId: item.docId ?? "", collection: "food")
            
        }
        .padding(.bottom)
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
        HistoryFoodItem(item: FoodRetriever(id: UUID(), mealType: "Breakfast", servingSize: 1, mood: "Happy", comments: "Today was good!", fdcID: 111111, description: "Cheese Omelet"))
    }
}
