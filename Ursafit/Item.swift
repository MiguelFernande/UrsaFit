//
//  Item.swift
//  Ursafit
//
//  Created by Miguel Fernandez on 10/28/24.
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
