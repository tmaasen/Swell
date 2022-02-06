//
//  VerticalSidebar.swift
//  Swell
//
//  Created by Tanner Maasen on 1/22/22.
//

import Foundation
import SwiftUI

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
    
    var navDestination: some View {
        switch self {
        case .profile: return AnyView(Profile())
        case .myMeals: return AnyView(Home())
        case .preLog: return AnyView(Profile())
        case .goals: return AnyView(Profile())
        case .history: return AnyView(Profile())
        case .learning: return AnyView(Profile())
        }
    }
}
