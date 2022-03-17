//
//  MealTypes.swift
//  Swell
//
//  Created by Tanner Maasen on 3/16/22.
//

import Foundation

public enum MealTypes: Int, CaseIterable {
    case breakfast
    case lunch
    case dinner
    case snack
    case water
    
    var text: String {
        switch self {
        case .breakfast: return "Breakfast"
        case .lunch: return "Lunch"
        case .dinner: return "Dinner"
        case .snack: return "Snack"
        case .water: return "Water"
        }
    }
}
