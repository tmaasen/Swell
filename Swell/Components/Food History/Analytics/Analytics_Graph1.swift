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
    let db = Firestore.firestore()
    // Graph 1
    @State var g1HappyMoods: Double = 0
    @State var g1NeutralMoods: Double = 0
    @State var g1SickMoods: Double = 0
    @State var g1OverateMoods: Double = 0
    @State var g1TotalDataPoints: Int = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            BarChartView(data: ChartData(values: [
                ((Mood.happy.text+Mood.happy.emoji),g1HappyMoods),
                ((Mood.neutral.text+Mood.neutral.emoji),g1NeutralMoods),
                ((Mood.sick.text+Mood.sick.emoji),g1SickMoods),
                ((Mood.overate.text+Mood.overate.emoji),g1OverateMoods)
            ]),
            title: "All Moods",
            legend: "All Time",
            form: ChartForm.detail,
//                    filterTag==0 ? "By Week" : "All Time",
            valueSpecifier: "%.0f")
            .padding(.horizontal)
            
            if g1TotalDataPoints != 0 {
                Text("\(g1TotalDataPoints) Records")
                    .foregroundColor(.gray)
                    .padding(.horizontal)
            }
        }
        .padding()
        .onAppear() {
            getGraph1Data()
        }
    }
    
    func getGraph1Data() {
        db.collection("users")
            .document(Auth.auth().currentUser?.uid ?? "test")
            .collection("food")
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
}

struct Analytics_Graph1_Previews: PreviewProvider {
    static var previews: some View {
        Analytics_Graph1()
    }
}
