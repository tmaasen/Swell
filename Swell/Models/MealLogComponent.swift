//
//  MealLogCard.swift
//  Swell
//
//  Created by Tanner Maasen on 2/14/22.
//

import Foundation
import SwiftUI

enum MealButtonModel: Int, CaseIterable {
    case breakfast
    case lunch
    case dinner
    case snack
    
    var title: String {
        switch self {
        case .breakfast: return "Breakfast"
        case .lunch: return "Lunch"
        case .dinner: return "Dinner"
        case .snack: return "Snack"
        }
    }
    
    var imageName: String {
        switch self {
        case .breakfast: return "Breakfast"
        case .lunch: return "Lunch"
        case .dinner: return "Dinner"
        case .snack: return "Snack"
        }
    }
}
