//
//  Analytics_Graph2.swift
//  Swell
//
//  Created by Tanner Maasen on 3/18/22.
//

import SwiftUI
import SwiftUICharts
import Firebase

struct Analytics_Graph2: View {
    @EnvironmentObject var foodViewModel: FoodAndWaterViewModel
    let db = Firestore.firestore()
    // Graph 2
    @State var g2Label = "nutrient"
    @State var g2HappyMoods: Double = 0
    @State var g2NeutralMoods: Double = 0
    @State var g2SickMoods: Double = 0
    @State var g2OverateMoods: Double = 0
    @State var g2TotalDataPoints: Int = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("When I eat foods high in ")
                    .font(.system(size: 16))
                Menu {
                    Button("protein", action: {getGraph2Data(pNutrient: "Protein")})
                    Button("sugar", action: {getGraph2Data(pNutrient: "Sugar")})
                    Button("carbohydrates", action: {getGraph2Data(pNutrient: "Carbohydrates")})
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
            title: "High In \(g2Label.capitalizingFirstLetter())",
            legend: "All Time",
            form: ChartForm.extraLarge,
//                    filterTag==0 ? "By Week" : "All Time",
            valueSpecifier: "%.0f")
            .padding(.horizontal)
            
            if g2TotalDataPoints != 0 {
                Text("\(g2TotalDataPoints) Records")
                    .foregroundColor(.gray)
                    .padding(.horizontal)
            }
        }
        .padding(.bottom)
        .onAppear() {
            getGraph2Data(pNutrient: "Protein")
        }
    }
    
    func getGraph2Data(pNutrient: String?) {
        g2Label = pNutrient?.lowercased() ?? self.g2Label
        
        db.collection("users")
            .document(Auth.auth().currentUser?.uid ?? "test")
            .collection("food")
            .whereField("highIn", arrayContains: pNutrient ?? "")
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

struct Analytics_Graph2_Previews: PreviewProvider {
    static var previews: some View {
        Analytics_Graph2()
    }
}
