//
//  Colors.swift
//  Personal-Finance
//
//  Created by Ahmed Abd El Mgeed Sahm on 19/11/2025.
//

import Foundation
import SwiftUI


extension Color {
    static let lightBeige = Color(red: 0.96, green: 0.94, blue: 0.88)
    
    var uiColor: UIColor {
        let components = UIColor(self).cgColor.components ?? [1,1,1,1]
        return UIColor(red: components[0], green: components[1], blue: components[2], alpha: components[3])
    }
}
