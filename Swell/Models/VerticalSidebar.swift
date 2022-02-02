//
//  VerticalSidebar.swift
//  Swell
//
//  Created by Tanner Maasen on 1/22/22.
//

import Foundation

enum VerticalSidebar: Int, CaseIterable {
    case profile
    case myMeals
    case preLog
    case goals
    case history
    case learning
    
    var destination: String {
        switch self {
        case .profile: return "Profile"
        case .myMeals: return "MyMeals"
        case .preLog: return "Daily Pre-Log"
        case .goals: return "Goals"
        case .history: return "History"
        case .learning: return "Learning"
        }
    }
    
    var title: String {
        switch self {
        case .profile: return "Profile"
        case .myMeals: return "MyMeals"
        case .preLog: return "Daily Pre-Log"
        case .goals: return "Goals"
        case .history: return "History"
        case .learning: return "Learning"
        }
    }
    
    var imageName: String {
        switch self {
        case .profile: return "person.circle.fill"
        case .myMeals: return "list.bullet"
        case .preLog: return "calendar"
        case .goals: return "checkmark"
        case .history: return "hourglass"
        case .learning: return "bookmark"
        }
    }
}
