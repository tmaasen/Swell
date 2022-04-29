//
//  Analytics_Graph1.swift
//  Swell
//
//  Created by Tanner Maasen on 3/18/22.
//

import SwiftUI
import SwiftUICharts

struct Analytics_Graph1: View {
    var analyticsViewModel: HistoryAnalyticsViewModel
    @State private var isLoading: Bool = false
    @State private var g1HappyMoods: Double = 0
    @State private var g1NeutralMoods: Double = 0
    @State private var g1SickMoods: Double = 0
    @State private var g1OverateMoods: Double = 0
    @State private var g1TotalDataPoints: Int = 0
    @Environment(\.colorScheme) var colorScheme

    let multiStyle = ChartStyle(backgroundColor: Color.green.opacity(0.2),
                                foregroundColor:
                                    [ColorGradient(.purple, .blue),
                                     ColorGradient(.orange, .red),
                                     ColorGradient(.green, .yellow),
                                     ColorGradient(.red, .purple),
                                     ColorGradient(.yellow, .orange),
                                    ])
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text("All Moods")
                    .font(.title2)
                    .bold()
            }
            .padding(.horizontal)
            
            VStack(alignment: .center) {
                Label("Refresh", systemImage: "arrow.clockwise")
                    .onTapGesture { getData() }
                    .padding(.horizontal)
            }
            
            ZStack(alignment: .center) {
                CardView {
                    BarChart()
                }
                .data(
                    [((Mood.happy.text+Mood.happy.emoji), g1HappyMoods),
                     ((Mood.neutral.text+Mood.neutral.emoji), g1NeutralMoods),
                     ((Mood.sick.text+Mood.sick.emoji), g1SickMoods),
                     ((Mood.overate.text+Mood.overate.emoji), g1OverateMoods)
                    ])
                .chartStyle(multiStyle)
                .frame(height: 200)
                .padding(.horizontal)
                .onAppear() {
                    getData()
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
            Text("\(g1TotalDataPoints) Records")
                .foregroundColor(.gray)
                .padding(.horizontal)
        }
        .padding()
    }
    func getData() {
        isLoading = true
        analyticsViewModel.getGraph1Data(completion: { moods in
            g1TotalDataPoints = Int(moods[0])
            g1HappyMoods = moods[1]
            g1NeutralMoods = moods[2]
            g1SickMoods = moods[3]
            g1OverateMoods = moods[4]
            isLoading = false
        })
    }
}

struct Analytics_Graph1_Previews: PreviewProvider {
    static var previews: some View {
        Analytics_Graph1(analyticsViewModel: HistoryAnalyticsViewModel())
    }
}
