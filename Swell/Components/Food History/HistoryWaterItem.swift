//
//  HistoryWaterItem.swift
//  Swell
//
//  Created by Tanner Maasen on 3/15/22.
//

import SwiftUI

struct HistoryWaterItem: View {
//    var item: FoodRetriever
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var foodViewModel: FoodDataCentralViewModel
        
        var body: some View { 
            VStack(alignment: .leading) {
                HStack {
                    LottieAnimation(filename: "water", loopMode: .playOnce, width: 80, height: 90, animationSpeed: 2.5)
                    VStack(spacing: 5) {
                        Text("You drank \(foodViewModel.waters.waterOuncesToday ?? 0, specifier: "%.1f") fl oz of water")
                            .font(.custom("Ubuntu", size: 16))
//                        Text("You logged \(foodViewModel.waters.waterLoggedToday ?? 0) waters")
//                            .font(.custom("Ubuntu", size: 16))
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
    }
}

struct HistoryWaterItem_Previews: PreviewProvider {
    static var previews: some View {
//        HistoryWaterItem(item: FoodRetriever(id: UUID(), mealType: "Water", waterOuncesToday: 50, waterLoggedToday: 3))
        HistoryWaterItem()
    }
}
