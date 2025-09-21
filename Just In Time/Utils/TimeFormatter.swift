//
//  TimeFormatter.swift
//  Just In Time
//
//  Created by Antoine LEPRETRE on 21/09/2025.
//


// Utils/TimeFormatter.swift
import Foundation

enum TimeFormatter {
    static func mmss(_ t: TimeInterval) -> String {
        let total = Int(t.rounded())
        let m = total / 60
        let s = total % 60
        return String(format: "%02d:%02d", m, s)
    }
    static func hms(_ t: TimeInterval) -> String {
        let total = Int(t)
        let h = total / 3600
        let m = (total % 3600) / 60
        let s = total % 60
        return h > 0 ? String(format: "%02d:%02d:%02d", h, m, s) : String(format: "%02d:%02d", m, s)
    }
}
