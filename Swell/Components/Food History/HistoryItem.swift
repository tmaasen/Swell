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
        VStack {
            VStack(alignment: .leading) {
                Text("\(item.mealType ?? "")")
                    .font(.custom("Ubuntu-BoldItalic", size: 20))
            }
            HStack {
                // Food
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        Text("Food")
                            .font(.custom("Ubuntu-Bold", size: 12))
                    }
                    Text("\(item.description ?? "")")
                        .font(.custom("Ubuntu-Bold", size: 10))
                    Text("Servings: \(item.servingSize ?? 0)")
                        .font(.custom("Ubuntu-Bold", size: 10))
                    // Nutrition Data
                    
                }
                Divider()
                // Mood
                VStack(alignment: .center) {
                    HStack(alignment: .top) {
                        Text("Mood")
                            .font(.custom("Ubuntu-Bold", size: 12))
                    }
                    Text("\(getMoodEmoji(pMood: item.mood ?? ""))")
                        .font(.system(size: 30))
                    Text("\(item.mood != "" ? item.mood! : "No mood specified.")")
                        .font(.custom("Ubuntu-Bold", size: 10))
                }
                Divider()
                // Comments
                VStack(alignment: .leading) {
                    HStack(alignment: .top) {
                        Text("Comments")
                            .font(.custom("Ubuntu-Bold", size: 12))
                    }
                    Text("\(item.comments != "" ? item.comments! : "No comments.")")
                        .font(.custom("Ubuntu", size: 10))
                    
                }
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(colorScheme == .dark ? Color.white : Color.black, lineWidth: 5)
            )
            .padding(.horizontal)
        }
    }
    func getMoodEmoji(pMood: String) -> String {
        if pMood == "Happy" { return moodEmojis.happy.mood }
        if pMood == "Neutral" { return moodEmojis.neutral.mood }
        if pMood == "Sick" { return moodEmojis.sick.mood }
        if pMood == "Overate" { return moodEmojis.overate.mood }
        return ""
    }
}

struct HistoryItem_Previews: PreviewProvider {
    static var previews: some View {
        HistoryItem(item: FoodRetriever(id: UUID(), mealType: "Breakfast", servingSize: 1, mood: "Happy", comments: "Today was good!", fdcID: 111111, description: "Cheese Omelet"))
    }
}

public enum moodEmojis {
    case happy
    case neutral
    case sick
    case overate
    
    var mood: String {
        switch self {
        case .happy: return "😀"
        case .neutral: return "😐"
        case .sick: return "🤮"
        case .overate: return "🤢"
        }
    }
}
