//
//  HistoryWaterItem.swift
//  Swell
//
//  Created by Tanner Maasen on 3/15/22.
//

import SwiftUI

struct WaterItem: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var foodViewModel: FoodAndWaterViewModel
        
        var body: some View {
            ZStack(alignment: .leading) {
                HStack {
                    LottieAnimation(filename: "water", loopMode: .playOnce, width: 80, height: 90, animationSpeed: 2.5)
                    VStack(spacing: 5) {
                        Text("You drank \(foodViewModel.waters.waterOuncesToday ?? 0, specifier: "%.1f") fl oz of water")
                            .font(.custom("Ubuntu", size: 16))
                    }
                }
                .padding()
                .frame(width: 275, height: 75)
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
        WaterItem()
    }
}
