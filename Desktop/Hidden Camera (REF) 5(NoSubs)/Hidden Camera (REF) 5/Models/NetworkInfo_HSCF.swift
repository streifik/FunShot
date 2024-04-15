//
//  NetworkInfo.swift
//  Hidden Spy Camera Finder
//
//  Created by Evgeniy Bruchkovskiy on 07.11.2023.
//

import Foundation
import CoreLocation

struct NetworkInfo_HSCF {
    var interface: String
    var success: Bool = false
    var ssid: String?
    var bssid: String?
}
