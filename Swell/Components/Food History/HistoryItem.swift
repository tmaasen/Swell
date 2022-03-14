//
//  HistoryItem.swift
//  Swell
//
//  Created by Tanner Maasen on 3/9/22.
//

import SwiftUI

struct HistoryItem: View {
    var item: FoodRetriever
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading) {
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
            .frame(width: 300, height: 100)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(colorScheme == .dark ? Color.white : Color.black, lineWidth: 5)
            )
            .padding(.horizontal)
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

struct HistoryItem_Previews: PreviewProvider {
    static var previews: some View {
        HistoryItem(item: FoodRetriever(id: UUID(), mealType: "Breakfast", servingSize: 1, mood: "Happy", comments: "Today was good!", fdcID: 111111, description: "Cheese Omelet"))
    }
}
