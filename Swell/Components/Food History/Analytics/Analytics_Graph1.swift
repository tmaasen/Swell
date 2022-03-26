//
//  Analytics_Graph1.swift
//  Swell
//
//  Created by Tanner Maasen on 3/18/22.
//

import SwiftUI
import SwiftUICharts
import Firebase

struct Analytics_Graph1: View {
    @EnvironmentObject var foodViewModel: FoodAndWaterViewModel
    @StateObject var analyticsViewModel = HistoryAnalyticsViewModel()
    @State private var isLoading: Bool = false
    // Graph 1
    @State var g1HappyMoods: Double = 0
    @State var g1NeutralMoods: Double = 0
    @State var g1SickMoods: Double = 0
    @State var g1OverateMoods: Double = 0
    @State var g1TotalDataPoints: Int = 0
    @State var data: [Double] = [0, 0, 0, 0]
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .center) {
                Label("Refresh", systemImage: "arrow.clockwise")
                    .onTapGesture {
                        isLoading = true
                        DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
                            data = [2, 3, 5, 1]
//                            analyticsViewModel.getGraph1Data(total: g1TotalDataPoints, happy: g1HappyMoods, neutral: g1NeutralMoods, sick: g1SickMoods, overate: g1OverateMoods, completion: {
//                                isLoading = false
//                            })
//                            print(g1HappyMoods)
                        })
                    }
            }
            ZStack(alignment: .center) {
                //                BarChartView(data: ChartData(values: [
                //                    ((Mood.happy.text+Mood.happy.emoji), data[0]),
                //                    ((Mood.neutral.text+Mood.neutral.emoji), data[1]),
                //                    ((Mood.sick.text+Mood.sick.emoji), data[2]),
                //                    ((Mood.overate.text+Mood.overate.emoji), data[3])
                //                    //                    filterTag==0 ? "By Week" : "All Time",
                //                ]), title: "All Moods", legend: "All Time", form: ChartForm.extraLarge, valueSpecifier: "%.0f")
                //                    .padding(.horizontal)
                BarChart()
                    .data(data)
                    .chartStyle(ChartStyle(backgroundColor: .white,
                                           foregroundColor: ColorGradient(.blue, .purple))
                    )
                    .shadow(color: .black, radius: 10, x: 1, y: 1)
                    .onAppear() {
                        isLoading = true
                        analyticsViewModel.getGraph1Data(total: g1TotalDataPoints, happy: g1HappyMoods, neutral: g1NeutralMoods, sick: g1SickMoods, overate: g1OverateMoods, completion: {
                            isLoading = false
                        })
                    }
                
                if isLoading {
                    LottieAnimation(filename: "loading", loopMode: .loop, width: 50, height: 50)
                }
            }
            
            if g1TotalDataPoints != 0 {
                Text("\(g1TotalDataPoints) Records")
                    .foregroundColor(.gray)
                    .padding(.horizontal)
            }
        }
        .padding()
    }
}

struct Analytics_Graph1_Previews: PreviewProvider {
    static var previews: some View {
        Analytics_Graph1()
    }
}
