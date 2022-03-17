//
//  Mood.swift
//  Swell
//
//  Created by Tanner Maasen on 3/16/22.
//

import Foundation

public enum Mood: Int, CaseIterable {
    case happy
    case neutral
    case sick
    case overate
    
    var emoji: String {
        switch self {
        case .happy: return "😀"
        case .neutral: return "😐"
        case .sick: return "🤮"
        case .overate: return "🤢"
        }
    }
    
    var text: String {
        switch self {
        case .happy: return "Happy"
        case .neutral: return "Neutral"
        case .sick: return "Sick"
        case .overate: return "Overate"
        }
    }
}
