//
//  CustomRoundedCorner.swift
//  Personal-Finance
//
//  Created by Ahmed Abd El Mgeed Sahm on 25/11/2025.
//

import Foundation
import SwiftUI

struct CustomRoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

extension View {
    func CustomCornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(CustomRoundedCorner(radius: radius, corners: corners))
    }
}
