//
//  AnalyticHistory.swift
//  Swell
//
//  Created by Tanner Maasen on 3/14/22.
//

import SwiftUI
import SwiftUICharts

struct AnalyticHistory: View {
    @EnvironmentObject var foodViewModel: FoodDataCentralViewModel
    @Binding var filterTag: Int
    @State var labelTitle = "nutrient"
    
    var body: some View {
        VStack {
            HStack {
                Text("When I eat foods high in ")
                    .font(.custom("Ubuntu-Italic", size: 20))
                Menu {
                    Button("protein", action: calcProtein)
                    Button("fat", action: calcFat)
                    Button("sugar", action: calcSugar)
                } label: {
                    Label(labelTitle+",", systemImage: "chevron.down")
                        .font(.custom("Ubuntu-BoldItalic", size: 20))
                        .foregroundColor(.black)
                }
            }
            .padding()
            
            VStack(alignment: .leading) {
                Text("I usually feel...")
                    .font(.custom("Ubuntu-Italic", size: 20))
            }
                        
            BarChartView(data: ChartData(values: [("2018 Q4",63150), ("2019 Q1",50900), ("2019 Q2",77550), ("2019 Q3",79600), ("2019 Q4",92550)]), title: "Food & Mood", legend: filterTag==0 ? "By Day" : "By Week")
        }
    }
    func calcProtein() {self.labelTitle = "protein"}
    func calcFat() {self.labelTitle = "fat"}
    func calcSugar() {self.labelTitle = "sugar"}
}

struct AnalyticHistory_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticHistory(filterTag: .constant(0))
    }
}
