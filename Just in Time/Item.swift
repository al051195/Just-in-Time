//
//  Item.swift
//  Just in Time
//
//  Created by Antoine LEPRETRE on 18/08/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
