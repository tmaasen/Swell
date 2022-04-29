//
//  Analytics_Graph2.swift
//  Swell
//
//  Created by Tanner Maasen on 3/18/22.
//

import SwiftUI
import SwiftUICharts

struct Analytics_Graph2: View {
    var analyticsViewModel: HistoryAnalyticsViewModel
    @State private var isLoading: Bool = false
    @State private var g2Label = "protein"
    @State private var g2HappyMoods: Double = 0
    @State private var g2NeutralMoods: Double = 0
    @State private var g2SickMoods: Double = 0
    @State private var g2OverateMoods: Double = 0
    @State private var g2TotalDataPoints: Int = 0
    @Environment(\.colorScheme) var colorScheme

    let mixedColorStyle = ChartStyle(backgroundColor: .white, foregroundColor: [
        ColorGradient(ChartColors.orangeBright, ChartColors.orangeDark),
        ColorGradient(.purple, .blue)
    ])
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("Foods High In \(g2Label.capitalizingFirstLetter())")
                    .font(.title2)
                    .bold()
            }
            .padding(.horizontal)
            
            HStack {
                Text("When I eat foods high in ")
                    .font(.system(size: 16))
                Menu {
                    Button("protein", action: {
                        g2Label = "protein"
                        getData(pNutrient: "Protein")
                    })
                    Button("sugar", action: {
                        g2Label = "sugar"
                        getData(pNutrient: "Sugar")
                    })
                    Button("carbohydrates", action: {
                        g2Label = "carbohydrates"
                        getData(pNutrient: "Carbohydrates")
                    })
                } label: {
                    Label(g2Label+",", systemImage: "chevron.down")
                        .font(.custom("Ubuntu-BoldItalic", size: 16))
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                }
            }
            .padding(.horizontal)
            Text("I usually feel...")
                .font(.system(size: 16))
                .padding(.horizontal)
                .padding(.bottom)
            
            ZStack(alignment: .center) {
                CardView {
                    BarChart()
                }
                .data(
                    [((Mood.happy.text+Mood.happy.emoji), g2HappyMoods),
                     ((Mood.neutral.text+Mood.neutral.emoji), g2NeutralMoods),
                     ((Mood.sick.text+Mood.sick.emoji), g2SickMoods),
                     ((Mood.overate.text+Mood.overate.emoji), g2OverateMoods)
                    ])
                .chartStyle(mixedColorStyle)
                .frame(height: 200)
                .padding(.horizontal)
                .onAppear() {
                    getData(pNutrient: "Protein")
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
            Text("\(g2TotalDataPoints) Records")
                .foregroundColor(.gray)
                .padding(.horizontal)
        }
        .padding()
    }
    func getData(pNutrient: String) {
        isLoading = true
        analyticsViewModel.getGraph2Data(pNutrient: pNutrient, completion: { moods in
            g2TotalDataPoints = Int(moods[0])
            g2HappyMoods = moods[1]
            g2NeutralMoods = moods[2]
            g2SickMoods = moods[3]
            g2OverateMoods = moods[4]
            isLoading = false
        })
    }
}

struct Analytics_Graph2_Previews: PreviewProvider {
    static var previews: some View {
        Analytics_Graph2(analyticsViewModel: HistoryAnalyticsViewModel())
    }
}
