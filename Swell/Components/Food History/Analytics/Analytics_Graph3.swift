//
//  Analytics_Graph3.swift
//  Swell
//
//  Created by Tanner Maasen on 3/18/22.
//

import SwiftUI
import SwiftUICharts
import Firebase

struct Analytics_Graph3: View {
    @EnvironmentObject var foodViewModel: FoodAndWaterViewModel
    let db = Firestore.firestore()
    // Graph 3
    @State var g3Label = "nutrient"
    @State var g3HappyMoods: Double = 0
    @State var g3NeutralMoods: Double = 0
    @State var g3SickMoods: Double = 0
    @State var g3OverateMoods: Double = 0
    @State var g3TotalDataPoints: Int = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("When I eat foods containing ")
                    .font(.system(size: 16))
                Menu {
                    Button("whole grain", action: {getGraph3Data(pContains: "Whole Grain")})
                    Button("dairy", action: {getGraph3Data(pContains: "Dairy")})
                    Button("gluten", action: {getGraph3Data(pContains: "Gluten")})
                } label: {
                    Label(g3Label+",", systemImage: "chevron.down")
                        .font(.custom("Ubuntu-BoldItalic", size: 16))
                        .foregroundColor(.black)
                }
            }
            Text("I usually feel...")
                .font(.system(size: 16))
                .padding(.bottom)
            
            BarChartView(data: ChartData(values: [
                ((Mood.happy.text+Mood.happy.emoji),g3HappyMoods),
                ((Mood.neutral.text+Mood.neutral.emoji),g3NeutralMoods),
                ((Mood.sick.text+Mood.sick.emoji),g3SickMoods),
                ((Mood.overate.text+Mood.overate.emoji),g3OverateMoods)
            ]),
            title: "\(g3Label.capitalizingFirstLetter()) Foods",
            legend: "All Time",
            form: ChartForm.small,
//                    filterTag==0 ? "By Week" : "All Time",
            valueSpecifier: "%.0f")
            .padding(.horizontal)
            
            if g3TotalDataPoints != 0 {
                Text("\(g3TotalDataPoints) Records")
                    .foregroundColor(.gray)
                    .padding(.horizontal)
            }
        }
        .padding(.bottom)
        .onAppear() {
            getGraph3Data(pContains: "Whole Grain")
        }
    }
    
    func getGraph3Data(pContains: String?) {
        g3Label = pContains?.lowercased() ?? self.g3Label
        
        db.collection("users")
            .document(Auth.auth().currentUser?.uid ?? "test")
            .collection("food")
            .whereField("highIn", arrayContains: pContains ?? "")
            .getDocuments(completion: { querySnapshot, error in
            if let error = error {
                print("Error in getAggregateData method: \(error.localizedDescription)")
            } else {
                g3TotalDataPoints = querySnapshot?.count ?? 0
                g3HappyMoods = 0
                g3NeutralMoods = 0
                g3SickMoods = 0
                g3OverateMoods = 0
                // sort them by mood
                for document in querySnapshot!.documents {
                    let mood = document.get("mood") as! String
                    switch mood {
                    case Mood.happy.text:
                        g3HappyMoods+=1
                    case Mood.neutral.text:
                        g3NeutralMoods+=1
                    case Mood.sick.text:
                        g3SickMoods+=1
                    default:
                        g3OverateMoods+=1
                    }
                }
            }
        })
    }
}

struct Analytics_Graph3_Previews: PreviewProvider {
    static var previews: some View {
        Analytics_Graph3()
    }
}
