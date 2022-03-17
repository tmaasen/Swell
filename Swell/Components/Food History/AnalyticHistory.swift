//
//  AnalyticHistory.swift
//  Swell
//
//  Created by Tanner Maasen on 3/14/22.
//

import SwiftUI
import SwiftUICharts
import Firebase

struct AnalyticHistory: View {
    @EnvironmentObject var foodViewModel: FoodDataCentralViewModel
    var filterOptions = ["All Time"]
    @State private var filterTag: Int = 0
    let db = Firestore.firestore()
    // Graph 1
    @State var g1Label = "nutrient"
    @State var g1HappyMoods: Double = 0
    @State var g1NeutralMoods: Double = 0
    @State var g1SickMoods: Double = 0
    @State var g1OverateMoods: Double = 0
    @State var g1TotalDataPoints: Int = 0
    // Graph 2
    @State var g2Label = "nutrient"
    @State var g2HappyMoods: Double = 0
    @State var g2NeutralMoods: Double = 0
    @State var g2SickMoods: Double = 0
    @State var g2OverateMoods: Double = 0
    @State var g2TotalDataPoints: Int = 0
    
    var body: some View {
        ScrollView {
            // GRAPH 1
            VStack(alignment: .leading) {
                HStack {
                    Text("When I eat foods high in ")
                        .font(.system(size: 16))
                    Menu {
                        Button("protein", action: {getGraph1Data(pNutrient: "Protein")})
                        Button("sugar", action: {getGraph1Data(pNutrient: "Sugar")})
                        Button("carbohydrates", action: {getGraph1Data(pNutrient: "Carbohydrates")})
                    } label: {
                        Label(g1Label+",", systemImage: "chevron.down")
                            .font(.custom("Ubuntu-BoldItalic", size: 16))
                            .foregroundColor(.black)
                    }
                }
                Text("I usually feel...")
                    .font(.system(size: 16))
                    .padding(.bottom)

                // CANNOT DO LARGE CHART FORM
                BarChartView(data: ChartData(values: [
                    ((Mood.happy.text+Mood.happy.emoji),g1HappyMoods),
                    ((Mood.neutral.text+Mood.neutral.emoji),g1NeutralMoods),
                    ((Mood.sick.text+Mood.sick.emoji),g1SickMoods),
                    ((Mood.overate.text+Mood.overate.emoji),g1OverateMoods)
                ]),
                title: "High In \(g1Label.capitalizingFirstLetter())",
                legend: "All Time",
//                    filterTag==0 ? "By Week" : "All Time",
                valueSpecifier: "%.0f")
                .padding(.horizontal)
                
                if g1TotalDataPoints != 0 {
                    Text("\(g1TotalDataPoints) Records")
                        .foregroundColor(.gray)
                }
            }
            .padding(.bottom)
            
            // GRAPH 2
            VStack(alignment: .leading) {
                HStack {
                    Text("When I eat foods containing ")
                        .font(.system(size: 16))
                    Menu {
                        Button("whole grain", action: {getGraph2Data(pContains: "Whole Grain")})
                        Button("dairy", action: {getGraph2Data(pContains: "Dairy")})
                        Button("gluten", action: {getGraph2Data(pContains: "Gluten")})
                    } label: {
                        Label(g2Label+",", systemImage: "chevron.down")
                            .font(.custom("Ubuntu-BoldItalic", size: 16))
                            .foregroundColor(.black)
                    }
                }
                Text("I usually feel...")
                    .font(.system(size: 16))
                    .padding(.bottom)
                
                BarChartView(data: ChartData(values: [
                    ((Mood.happy.text+Mood.happy.emoji),g2HappyMoods),
                    ((Mood.neutral.text+Mood.neutral.emoji),g2NeutralMoods),
                    ((Mood.sick.text+Mood.sick.emoji),g2SickMoods),
                    ((Mood.overate.text+Mood.overate.emoji),g2OverateMoods)
                ]),
                title: "\(g2Label.capitalizingFirstLetter()) Foods",
                legend: "All Time",
//                    filterTag==0 ? "By Week" : "All Time",
                valueSpecifier: "%.0f")
                .padding(.horizontal)
                
                if g2TotalDataPoints != 0 {
                    Text("\(g2TotalDataPoints) Records")
                        .foregroundColor(.gray)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Picker("Filter by: ", selection: $filterTag) {
                    ForEach(0..<filterOptions.count) {
                        Text(self.filterOptions[$0])
                    }
                }
            }
        }
    }
    func getGraph1Data(pNutrient: String?) {
        g1Label = pNutrient?.lowercased() ?? self.g1Label
        
        db.collection("users")
            .document(Auth.auth().currentUser?.uid ?? "test")
            .collection("food")
            .whereField("highIn", arrayContains: pNutrient ?? "")
            .getDocuments(completion: { querySnapshot, error in
            if let error = error {
                print("Error in getAggregateData method: \(error.localizedDescription)")
            } else {
                g1TotalDataPoints = querySnapshot?.count ?? 0
                g1HappyMoods = 0
                g1NeutralMoods = 0
                g1SickMoods = 0
                g1OverateMoods = 0
                // sort them by mood
                for document in querySnapshot!.documents {
                    let mood = document.get("mood") as! String
                    switch mood {
                    case Mood.happy.text:
                        g1HappyMoods+=1
                    case Mood.neutral.text:
                        g1NeutralMoods+=1
                    case Mood.sick.text:
                        g1SickMoods+=1
                    default:
                        g1OverateMoods+=1
                    }
                }
            }
        })
    }
    
    func getGraph2Data(pContains: String?) {
        g2Label = pContains?.lowercased() ?? self.g2Label
        
        db.collection("users")
            .document(Auth.auth().currentUser?.uid ?? "test")
            .collection("food")
            .whereField("highIn", arrayContains: pContains ?? "")
            .getDocuments(completion: { querySnapshot, error in
            if let error = error {
                print("Error in getAggregateData method: \(error.localizedDescription)")
            } else {
                g2TotalDataPoints = querySnapshot?.count ?? 0
                g2HappyMoods = 0
                g2NeutralMoods = 0
                g2SickMoods = 0
                g2OverateMoods = 0
                // sort them by mood
                for document in querySnapshot!.documents {
                    let mood = document.get("mood") as! String
                    switch mood {
                    case Mood.happy.text:
                        g2HappyMoods+=1
                    case Mood.neutral.text:
                        g2NeutralMoods+=1
                    case Mood.sick.text:
                        g2SickMoods+=1
                    default:
                        g2OverateMoods+=1
                    }
                }
            }
        })
    }
}

struct AnalyticHistory_Previews: PreviewProvider {
    static var previews: some View {
        AnalyticHistory()
    }
}
