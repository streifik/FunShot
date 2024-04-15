//
//  Network.swift
//  Hidden Spy Camera Finder
//
//  Created by Evgeniy Bruchkovskiy on 07.11.2023.
//

import Foundation
import SystemConfiguration.CaptiveNetwork
import CoreLocation

public class SSID {
    class func fetchNetworkInfo_HSCF() -> [NetworkInfo_HSCF]? {
        if let interfaces: NSArray = CNCopySupportedInterfaces() {
            var networkInfos = [NetworkInfo_HSCF]()
            for interface in interfaces {
                let interfaceName = interface as! String
                var networkInfo = NetworkInfo_HSCF(interface: interfaceName,
                                              success: false,
                                              ssid: nil,
                                              bssid: nil)
                if let dict = CNCopyCurrentNetworkInfo(interfaceName as CFString) as NSDictionary? {
                    networkInfo.success = true
                    networkInfo.ssid = dict[kCNNetworkInfoKeySSID as String] as? String
                    networkInfo.bssid = dict[kCNNetworkInfoKeyBSSID as String] as? String
                }
                networkInfos.append(networkInfo)
            }
            return networkInfos
        }
        return nil
    }
}
