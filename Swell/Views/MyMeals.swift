//
//  MyMeals.swift
//  Swell
//
//  Created by Tanner Maasen on 2/14/22.
//

import SwiftUI

struct MyMeals: View {
    var body: some View {
        VStack {
            Text("MyMeals")
            NavigationLink(destination: MoodLog(docRef: "")) {
                Text("Mood Log")
            }
        }.navigationTitle("MyMeals")
    }
}

struct MyMeals_Previews: PreviewProvider {
    static var previews: some View {
        MyMeals()
    }
}
