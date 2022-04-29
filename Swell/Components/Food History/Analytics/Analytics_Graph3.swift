//
//  Analytics_Graph3.swift
//  Swell
//
//  Created by Tanner Maasen on 3/18/22.
//

import SwiftUI
import SwiftUICharts

struct Analytics_Graph3: View {
    var analyticsViewModel: HistoryAnalyticsViewModel
    @State private var isLoading: Bool = false
    @State private var g3Label = "whole grain"
    @State private var g3HappyMoods: Double = 0
    @State private var g3NeutralMoods: Double = 0
    @State private var g3SickMoods: Double = 0
    @State private var g3OverateMoods: Double = 0
    @State private var g3TotalDataPoints: Int = 0
    @Environment(\.colorScheme) var colorScheme
    
    let blueStyle = ChartStyle(backgroundColor: .white,
                               foregroundColor: [ColorGradient(.purple, .blue)])
    let orangeStyle = ChartStyle(backgroundColor: .white,
                                 foregroundColor: [ColorGradient(ChartColors.orangeBright, ChartColors.orangeDark)])
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("Foods Containing \(g3Label.capitalizingFirstLetter())")
                    .font(.title2)
                    .bold()
            }
            .padding(.horizontal)
            
            HStack {
                Text("When I eat foods containing ")
                    .font(.system(size: 16))
                Menu {
                    Button("whole grain", action: {
                        g3Label = "whole grain"
                        getData(pNutrient: "Whole Grain")
                    })
                    Button("dairy", action: {
                        g3Label = "dairy"
                        getData(pNutrient: "Dairy")
                    })
                    Button("gluten", action: {
                        g3Label = "gluten"
                        getData(pNutrient: "Gluten")
                    })
                    Button("caffeine", action: {
                        g3Label = "caffeine"
                        getData(pNutrient: "Caffeine")
                    })
                } label: {
                    Label(g3Label+",", systemImage: "chevron.down")
                        .font(.custom("Ubuntu-BoldItalic", size: 16))
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                }
            }
            .padding(.horizontal)
            Text("I usually feel...")
                .font(.system(size: 16))
                .padding(.bottom)
                .padding(.horizontal)
            
            ZStack(alignment: .center) {
                CardView {
                    BarChart()
                }
                .data(
                    [((Mood.happy.text+Mood.happy.emoji), g3HappyMoods),
                     ((Mood.neutral.text+Mood.neutral.emoji), g3NeutralMoods),
                     ((Mood.sick.text+Mood.sick.emoji), g3SickMoods),
                     ((Mood.overate.text+Mood.overate.emoji), g3OverateMoods)
                    ])
                .chartStyle(orangeStyle)
                .frame(height: 200)
                .padding(.horizontal)
                .onAppear() {
                    getData(pNutrient: "Whole Grain")
                }
                
                if isLoading {
                    LottieAnimation(filename: "loading", loopMode: .loop, width: 50, height: 50)
                }
            }
            
            // Legend
            HStack(alignment: .center) {
                ForEach(Mood.allCases, id: \.self) { mood in
                    Text("\(mood.emoji)")
                        .padding(.horizontal)
                    Spacer()
                }
            }
            Text("\(g3TotalDataPoints) Records")
                .foregroundColor(.gray)
                .padding(.horizontal)
        }
        .padding()
    }
    func getData(pNutrient: String) {
        isLoading = true
        analyticsViewModel.getGraph3Data(pContains: pNutrient, completion: { moods in
            g3TotalDataPoints = Int(moods[0])
            g3HappyMoods = moods[1]
            g3NeutralMoods = moods[2]
            g3SickMoods = moods[3]
            g3OverateMoods = moods[4]
            isLoading = false
        })
    }
}

struct Analytics_Graph3_Previews: PreviewProvider {
    static var previews: some View {
        Analytics_Graph3(analyticsViewModel: HistoryAnalyticsViewModel())
    }
}
