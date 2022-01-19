//
//  Functions.swift
//  Swell
//
//  Created by Tanner Maasen on 1/18/22.
//

import Foundation

class UtilFunctions: ObservableObject {
    static var greeting = ""
    
    // Gets time of day to present in greeting message
    func getTimeOfDay(name: String?) -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        let googleName = name
        switch hour {
        case 5..<12 : UtilFunctions.greeting = "Good morning, \(googleName ?? "")"
        case 13..<17 : UtilFunctions.greeting = "Good afternoon, \(googleName ?? "")"
        case 17..<24 :
            UtilFunctions.greeting = "Good evening, \(googleName ?? "")"
            print("evening: \(UtilFunctions.greeting)")
        default:
            UtilFunctions.greeting = "Hello, "
            print("hello: \(UtilFunctions.greeting)")
        }
        return UtilFunctions.greeting
    }
}
