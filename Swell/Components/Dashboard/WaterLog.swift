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
    @EnvironmentObject var foodViewModel: FoodDataCentralViewModel
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
                        } else {
                            LottieAnimation(filename: "water", loopMode: .playOnce, width: 60, height: 70, animationSpeed: 2.5, play: true)
                        }
                    }
                }
            }
            VStack {
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
                        .font(.custom("Ubuntu-Bold", size: 12))
                        .foregroundColor(UserViewModel.isEveningGradient ? .white : .black)
                }
                // Log Button
                Button("Add Water") {
                    watersLogged+=1
                    waterLogDict[watersLogged] = true
                    foodViewModel.logWater(pSize: label, watersLoggedToday: watersLogged, ounces: ounces)
                }
                .padding(6)
                .font(.custom("Ubuntu-Bold", size: 12))
                .foregroundColor(UserViewModel.isEveningGradient ? .white : .black)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(UserViewModel.isEveningGradient ? Color.white : Color.black, lineWidth: 2)
                )
            }
        }
        .padding()
        .onAppear() {
            if foodViewModel.isNewDay() == true {
                ounces = 0
                watersLogged = 0
                waterLogDict = [
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
            }
            foodViewModel.getWater()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                let waters = foodViewModel.waters.waterLoggedToday ?? 0
                for i in 0...waters {
                    waterLogDict[i] = true
                }
            }
        }
    }
}

struct WaterLog_Previews: PreviewProvider {
    static var previews: some View {
        WaterLog()
    }
}
