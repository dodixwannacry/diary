//
//  Item.swift
//  diary
//
//  Created by Rodolfo Falanga on 14/11/23.
//

import Foundation
import SwiftData

@Model
final class Diary {
    @Attribute(.unique)
    var timestamp: Date
    var name: String
    var isDone: Bool
    
    init(name: String, isDone: Bool = false) {
        self.timestamp = Date()
        self.name = name
        self.isDone = isDone
    }
}

