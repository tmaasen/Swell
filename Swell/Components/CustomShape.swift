//
//  CustomShape.swift
//  Swell
//
//  Created by Tanner Maasen on 4/26/22.
//

import SwiftUI

struct CustomShape: Shape {
    var corner: UIRectCorner
    var radii: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corner, cornerRadii: CGSize(width: radii, height: radii))
        
        return Path(path.cgPath)
    }
}
