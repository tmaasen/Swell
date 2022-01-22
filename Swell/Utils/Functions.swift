//
//  Functions.swift
//  Swell
//
//  Created by Tanner Maasen on 1/18/22.
//

import Foundation
import SwiftUI

class UtilFunctions: ObservableObject {
    static var greeting: String = ""
    static var gradient: Gradient = Gradient(stops: [
                                                .init(color: Color.morningLinear1, location: 0),
                                                .init(color: Color.morningLinear2, location: 0.22),
                                                .init(color: Color.morningLinear3, location: 0.35)])
    
    // Gets time of day to present in greeting message
    func getTimeOfDay(name: String?) {
        let hour = Calendar.current.component(.hour, from: Date())
        let googleName = name
        switch hour {
        case 5..<12 : UtilFunctions.greeting = "Good morning, \n\(googleName ?? "")"
        case 13..<17 : UtilFunctions.greeting = "Good afternoon, \n\(googleName ?? "")"
        case 17..<24 :
            UtilFunctions.gradient = Gradient(stops: [
                                                .init(color: Color.eveningLinear1, location: 0.23),
                                                .init(color: Color.eveningLinear2, location: 0.84)])
            UtilFunctions.greeting = "Good evening, \n\(googleName ?? "")"
        default:
            UtilFunctions.greeting = "Hello"
        }
    }
}
