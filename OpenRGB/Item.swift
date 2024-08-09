//
//  Item.swift
//  OpenRGB
//
//  Created by Kavish Devar on 09/08/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var ip: String
    var name: String
    
    init(ip: String, name: String) {
        self.ip = ip
        self.name = name
    }
}
