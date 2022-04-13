//
//  AddMeal.swift
//  Swell
//
//  Created by Tanner Maasen on 4/9/22.
//

import SwiftUI

struct AddMeal: View {
    @State private var name = ""
    @State private var ingredients = [""]
    @State private var nutrients = [""]
    @State private var instructions = ""
    @State private var includes = [""]
    // do something to sanitize input before sending it off to firestore
    
    var body: some View {
        ScrollView {
            Form {
                TextField("Food Name", text: $name)
                    .padding()
                
                Section(header: Text("Ingredients")) {
                    ForEach(0..<ingredients.count, id: \.self){ ingredient in
                        HStack(spacing: 5){
                            TextField("New Ingredient", text: $ingredients[ingredient])
                        }
                    }
                    Button("Add Ingredient"){
                        ingredients.append("")
                    }
                }
                .padding()
                
                Section(header: Text("Nutrition Facts")) {
                    ForEach(0..<nutrients.count, id: \.self){ nutrient in
                        HStack(spacing: 5){
                            TextField("New Nutrient", text: $nutrients[nutrient])
                        }
                    }
                    Button("Add Nutrient"){
                        nutrients.append("")
                    }
                }
                .padding()
                
                Section(header: Text("Instructions / Comments")) {
                    TextEditor(text: $instructions)
                        .foregroundColor(.secondary)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray, lineWidth: 3)
                        )
//                    VStack(alignment: .leading) {
//                        Text("Comments")
//                            .italic()
//                        TextEditor(text: $comments)
//                            .foregroundColor(.secondary)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 20)
//                                    .stroke(Color.gray, lineWidth: 3)
//                            )
//                    }
//                    .padding(.horizontal)
//                    .frame(maxWidth: .infinity, maxHeight: 260)
                }
                .padding()
            }
        }
    }
}

struct AddMeal_Previews: PreviewProvider {
    static var previews: some View {
        AddMeal()
    }
}
