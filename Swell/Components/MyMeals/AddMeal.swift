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
    @State private var nutrients: [String : String] = [:]
    @State private var instructions = ""
    @State private var includes = [""]
    // do something to sanitize input before sending it off to firestore
    let dict = ["key1": "value1", "key2": "value2"]
    
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
                ForEach(nutrients.sorted(by: >), id: \.key){ key, value in
                    HStack(spacing: 5){
                        TextField("Nutrient", text: $nutrients[key].toUnwrapped(defaultValue: ""))
                        Divider()
                        TextField("Value", text: $nutrients[value].toUnwrapped(defaultValue: ""))
                    }
                }
                Button("Add Nutrient"){
//                    nutrients.append("")
                    nutrients[""] = ""
                }
            }
            
//            List {
//                ForEach(nutrients.sorted(by: >), id: \.key) { key, value in
//                    Section(header: Text(key)) {
//                        Text(value)
//                    }
//                }
//            }
            
            Section(header: Text("Instructions / Comments")) {
                VStack(alignment: .leading) {
                    TextEditor(text: $instructions)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: 400)
            }
                        
            HStack(alignment: .bottom) {
                Button(action: {
                    hideKeyboard()
                }) {
                    Text("Save")
                        .withButtonStyles()
                }
            }
        }
        .navigationTitle("New Meal")
    } 
}

struct AddMeal_Previews: PreviewProvider {
    static var previews: some View {
        AddMeal()
    }
}
