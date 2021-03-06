//
//  CustomTextField.swift
//  Swell
//
//  Created by Tanner Maasen on 3/7/22.
//

import SwiftUI

struct CustomTextField: UIViewRepresentable {
    let tag: Int
    let keyboardType: UIKeyboardType
    let returnVal: UIReturnKeyType
    @Binding var text: String
    @Binding var isfocusAble: [Bool]
    @Binding var isLoading: Bool
    @Binding var searchText: String
    @Binding var searching: Bool
    @EnvironmentObject var foodAndMoodViewModel: FoodAndMoodViewModel
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.keyboardType = self.keyboardType
        textField.returnKeyType = self.returnVal
        textField.placeholder = "Search"
//        textField.clearButtonMode = .whileEditing
        textField.adjustsFontSizeToFitWidth = true
        textField.tag = self.tag
        textField.delegate = context.coordinator
        
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        if isfocusAble[tag] {
            uiView.becomeFirstResponder()
        } else {
            uiView.resignFirstResponder()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: CustomTextField
        
        init(_ textField: CustomTextField) {
            self.parent = textField
        }
        
        func updatefocus(textfield: UITextField) {
            textfield.becomeFirstResponder()
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if parent.tag == 0 {
                parent.isfocusAble = [false, true]
                parent.text = textField.text ?? ""
            } else if parent.tag == 1 {
                parent.isfocusAble = [false, false]
                parent.text = textField.text ?? ""
            }
            // Search for the food
            if !parent.searchText.isEmpty {
                parent.isLoading = true
                parent.foodAndMoodViewModel.search(searchTerms: parent.searchText, pageSize: 200, completion: {
                    self.parent.isLoading = false
                })
            }
            return true
        }
        
    }
}
