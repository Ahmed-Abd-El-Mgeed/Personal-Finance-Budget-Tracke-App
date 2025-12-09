//
//  DateHelper.swift
//  Personal-Finance
//
//  Created by Ahmed Abd El Mgeed Sahm on 09/12/2025.
//

import Foundation

struct DateHelper {
    
    // Format a date to "Today", "Yesterday", or "MMM dd"
    static func formatDate(_ date: Date) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM dd"
            return formatter.string(from: date)
        }
    }
    
    // Format a date to time string like "10:42 AM"
    static func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: date)
    }
}
