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
                ForEach(MealButton.allCases, id: \.self) { card in
                    MealCard(mealModel: card)
                }
            }
        }
    }
}

struct MealCard: View {
    let mealModel: MealButton
    
    var body: some View {
        NavigationLink(
            destination: MealLog(mealType: mealModel.title),
            label: {
                VStack {
                    Spacer()
                    Image(mealModel.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150)
                    Spacer()
                    Text(mealModel.title)
                        .font(.custom("Ubuntu-Bold", size: 33))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                }
                .padding(10)
                .frame(width: 200, height: 165)
                .background(Color("MealCardBlue"))
                .cornerRadius(5)
            })
    }
}

struct MealCards_Previews: PreviewProvider {
    static var previews: some View {
        MealCards()
    }
}
