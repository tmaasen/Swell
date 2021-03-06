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
//    case preLog
//    case goals
    case history
    case learn
    
    var destination: String {
        switch self {
        case .profile: return "Profile"
        case .myMeals: return "MyMeals"
//        case .preLog: return "Daily Pre-Log"
//        case .goals: return "Goals"
        case .history: return "History"
        case .learn: return "Learn"
        }
    }
    
    var title: String {
        switch self {
        case .profile: return "Profile"
        case .myMeals: return "MyMeals"
//        case .preLog: return "Daily Pre-Log"
//        case .goals: return "Goals"
        case .history: return "History"
        case .learn: return "Learn"
        }
    }
    
    var imageName: String {
        switch self {
        case .profile: return "person.circle.fill"
        case .myMeals: return "list.bullet"
//        case .preLog: return "calendar"
//        case .goals: return "checkmark"
        case .history: return "hourglass"
        case .learn: return "bookmark"
        }
    }
    
    @ViewBuilder
    var navDestination: some View {
        switch self {
        case .profile: Profile()
        case .myMeals: MyMeals()
//        case .preLog: DailyPreLog()
//        case .goals: Goals()
        case .history: History()
        case .learn: Learn()
        }
    }
}
