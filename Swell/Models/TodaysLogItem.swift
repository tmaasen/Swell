//
//  TodaysLog.swift
//  Swell
//
//  Created by Tanner Maasen on 4/27/22.
//

import Foundation

struct TodaysLogItem: Identifiable, Comparable, Hashable {
    static func < (lhs: TodaysLogItem, rhs: TodaysLogItem) -> Bool {
        return true
    }
    
    static func == (lhs: TodaysLogItem, rhs: TodaysLogItem) -> Bool {
        return lhs.foodName == rhs.foodName
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(docId)
    }

    var id = UUID()
    var foodName: String?
    var docId: String?
    var mealType: String?
    var mood: String?
}
