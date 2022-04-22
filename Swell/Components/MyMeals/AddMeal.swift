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
    @State private var ingredientValues: [Int : String] = [:]
    @State private var nutrientNames = [""]
    @State private var nutrientValues: [String : Int] = [:]
    @State private var instructions = ""
    @State private var includes = [""]
    // do something to sanitize input before sending it off to firestore
    
    var body: some View {
        Form {
            TextField("Meal Name", text: $name)
            
            Section(header: Text("Ingredients")) {
                ForEach(0..<ingredients.count, id: \.self){ ingredient in
                    HStack(spacing: 5){
                        TextField("Ingredient", text: $ingredients[ingredient])
                    }
                }
                Button("Add Ingredient"){
                    ingredients.append("")
                }
            }
            
            Section(header: Text("Nutrition Facts")) {
//                ForEach(nutrientValues.sorted(by: >), id: \.key){ key, value in
//                    HStack(spacing: 5){
//                        TextField("Nutrient", text: $nutrients[key].toUnwrapped(defaultValue: ""))
//                        Divider()
//                        TextField("Value", text: $nutrients[value].toUnwrapped(defaultValue: ""))
//                    }
//                }
                ForEach(0...nutrientNames.count-1, id: \.self) { nutrient in
                    HStack(spacing: 5){
                        TextField("Nutrient", text: $nutrientNames[nutrient])
                        Divider()
                    }
                }
                Button("Add Nutrient"){
                    nutrientNames.append("")
                }
            }
            
            Section(header: Text("Instructions / Comments")) {
                VStack(alignment: .leading) {
                    TextEditor(text: $instructions)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: 400)
            }
                        
//            HStack(alignment: .bottom) {
                Button(action: {
                    hideKeyboard()
                }) {
                    Text("Save")
                        .withButtonStyles()
                }
//            }
        }
        .navigationTitle("New Meal")
        .onAppear() {
            print("Nutrient names: \(nutrientNames)")
        }
    } 
}

struct AddMeal_Previews: PreviewProvider {
    static var previews: some View {
        AddMeal()
    }
}
