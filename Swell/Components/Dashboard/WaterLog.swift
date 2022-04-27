//
//  WaterLog.swift
//  Swell
//
//  Created by Tanner Maasen on 3/15/22.
//

import SwiftUI

struct WaterLog: View {
    @State private var label: String = "8 fl oz"
    @State private var ounces: Double = 8
    @State private var watersLogged: Int = 0
    @EnvironmentObject var foodViewModel: FoodAndWaterViewModel
    @Environment(\.colorScheme) var colorScheme
    @State private var waterLogDict = [
        1: false,
        2: false,
        3: false,
        4: false,
        5: false,
        6: false,
        7: false,
        8: false,
        9: false,
        10: false
    ]
    
    var body: some View {
        HStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(1..<11) { i in
                        if waterLogDict[i] == false {
                            LottieAnimation(filename: "water", loopMode: .playOnce, width: 60, height: 70, animationSpeed: 2.5, play: false)
                                .onTapGesture {
                                    watersLogged+=1
                                    waterLogDict[watersLogged] = true
                                    foodViewModel.logWater(pSize: label, watersLoggedToday: watersLogged, ounces: ounces)
                                }
                        } else {
                            LottieAnimation(filename: "water", loopMode: .playOnce, width: 60, height: 70, animationSpeed: 2.5, play: true)
                        }
                    }
                }
            }
            // Menu with size options
            Menu {
                Button("8 fl oz", action: {
                        label = "8 fl oz"
                        ounces = 8})
                Button("12 fl oz", action: {
                        label = "12 fl oz"
                        ounces = 12})
                Button("16.9 fl oz", action: {
                        label = "16.9 fl oz"
                        ounces = 16.9})
                Button("24 fl oz", action: {
                        label = "24 fl oz"
                        ounces = 24})
                Button("32 fl oz", action: {
                        label = "32 fl oz"
                        ounces = 32})
                Button("40 fl oz", action: {
                        label = "40 fl oz"
                        ounces = 40})
                Button("64 fl oz", action: {
                        label = "64 fl oz"
                        ounces = 64})
            } label: {
                Label(label, systemImage: "chevron.down")
                    .font(.custom("Ubuntu-Bold", size: 16))
                    .foregroundColor(UserViewModel.isEveningGradient ? .white : .black)
            }
        }
        .onAppear() {
            foodViewModel.getWater(completion: { didCompleteSuccessfully in
                if didCompleteSuccessfully {
                    if foodViewModel.isNewDay == true {
                        ounces = 8
                        watersLogged = 0
                        waterLogDict.keys.forEach { waterLogDict[$0] = false }
                    } else {
                        let waters = foodViewModel.waters.waterLoggedToday ?? 0
                        for i in 0...waters {
                            waterLogDict[i] = true
                        }
                    }
                } else {
                    // handle error
                }
            })
        }
    }
}

struct WaterLog_Previews: PreviewProvider {
    static var previews: some View {
        WaterLog()
    }
}
