//
//  Item.swift
//  bioengineering_swift_demo
//
//  Created by Osk Mar on 31.08.24.
//

import Foundation
import SwiftData

@Model
final class ECGItem {
    var dataPoints: [Double]
    var title : String
    
    init(dataPoints: [Double], title: String) {
        self.dataPoints = dataPoints
        self.title = title
    }
}
