//
//  CustomTextField.swift
//  Swell
//
//  Created by Tanner Maasen on 3/7/22.
//

import SwiftUI

// MARK: Custom TextField
struct CustomTextField: UIViewRepresentable {
    let keyboardType: UIKeyboardType
    let returnVal: UIReturnKeyType
    let tag: Int
    @Binding var text: String
    @Binding var isfocusAble: [Bool]
    @Binding var isLoading: Bool
    @Binding var searchText: String
    @Binding var searching: Bool
    @EnvironmentObject var foodViewModel: FoodDataCentralViewModel
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.keyboardType = self.keyboardType
        textField.returnKeyType = self.returnVal
        textField.placeholder = "Search"
        // TEXT NOT CLEARING
        textField.clearButtonMode = .always
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
//        if uiView.window != nil, !uiView.isFirstResponder {
//            //This triggers attribute cycle if not dispatched
//            DispatchQueue.main.async {
//                uiView.becomeFirstResponder()
//            }
//        }
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
            
            if !parent.searchText.isEmpty {
                parent.isLoading = true
                parent.foodViewModel.search(searchTerms: parent.searchText, pageSize: 200, completion: {
                    self.parent.isLoading = false
                })
            }
            return true
        }
        
    }
}
