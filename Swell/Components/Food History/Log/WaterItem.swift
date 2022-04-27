//
//  HistoryWaterItem.swift
//  Swell
//
//  Created by Tanner Maasen on 3/15/22.
//

import SwiftUI

struct WaterItem: View {
//    @EnvironmentObject var foodViewModel: FoodAndWaterViewModel
    var waterOunces: Double
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                LottieAnimation(filename: "water", loopMode: .playOnce, width: 50, height: 60, animationSpeed: 2.5)
                VStack(spacing: 5) {
                    Text("You drank \(waterOunces, specifier: "%.1f") fluid ounces of water")
                        .font(.custom("Ubuntu", size: 16))
                }
            }
            .padding(.horizontal, 30)
            Divider()
                .frame(height: 1)
                .background(Color("FoodListItem_LightGray"))
                .padding(.horizontal, 30)
        }
    }
}

struct HistoryWaterItem_Previews: PreviewProvider {
    static var previews: some View {
        WaterItem(waterOunces: 0)
    }
}
