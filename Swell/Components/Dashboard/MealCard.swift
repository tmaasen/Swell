//
//  MealLogCard.swift
//  Swell
//
//  Created by Tanner Maasen on 2/14/22.
//

import SwiftUI

struct MealCards: View {
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 30) {
                ForEach(MealButtonModel.allCases, id: \.self) { card in
                    MealCard(mealModel: card)
                }
            }.padding(.leading, 20)
        }
    }
}

struct MealCard: View {
    let mealModel: MealButtonModel
    
    var body: some View {
        VStack {
            Spacer()
            Image(mealModel.imageName)
                .resizable()
                .scaledToFit()
            Spacer()
            Text(mealModel.title)
                .font(.custom("Ubuntu-Bold", size: 33))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .frame(width: 200, height: 165)
        .background(Color("MealCardBlue"))
        .cornerRadius(5)
    }
}

struct MealCards_Previews: PreviewProvider {
    static var previews: some View {
        MealCards()
    }
}
