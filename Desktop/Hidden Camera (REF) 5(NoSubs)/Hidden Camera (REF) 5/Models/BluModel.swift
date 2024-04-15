//
//  BluModel.swift
//  Hidden Spy Camera Finder
//
//  Created by Evgeniy Bruchkovskiy on 08.11.2023.
//

import Foundation
import CoreBluetooth

typealias rejthnkjndrew = BluModel

struct BluModel: Hashable {
    
    let peripheral: CBPeripheral
    let rssi: Int
    
    init(peripheral: CBPeripheral, rssi: NSNumber) {
        self.peripheral = peripheral
        self.rssi = rssi.toCorrectDistance
    }
    
}

extension rejthnkjndrew {
    static func ==(lhs: BluModel, rhs: BluModel) -> Bool {
        return lhs.peripheral.identifier.uuidString == rhs.peripheral.identifier.uuidString && lhs.rssi == rhs.rssi
    }
}

extension NSNumber {
    var toCorrectDistance: Int {
        Int(pow(10, ((-59-Double(truncating: self))/(10*2)))*3.2808)
    }
}
