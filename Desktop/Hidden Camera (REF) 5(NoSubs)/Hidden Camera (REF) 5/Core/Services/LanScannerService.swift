//
//  LanScannerService.swift
//  Hidden Spy Camera Finder
//
//  Created by Evgeniy Bruchkovskiy on 16.11.2023.
//

import Foundation
import CoreGraphics

public struct LanDevice2 {
    public var name: String
    public var ipAddress: String
    public var mac: String
    public var brand: String
}

public protocol LanScannerDelegate2: AnyObject {
    func lanScanHasUpdatedProgress(_ progress: CGFloat, address: String)
    func lanScanDidFindNewDevice(_ device: LanDevice2)
    func lanScanDidFinishScanning(_ lanDevices: [LanDevice2])
}

public class LanScannerService: NSObject, LANScanDelegate2 {

    enum StateType {
        case start, pending, stop
    }
    
    // MARK: - Properties
    private var netServiceDevices: [NetworkDevice] = []
    private var lanDevices: [LanDevice2] = []
    private var netServiceScanner = DiscoveryService()
    private var stateType: StateType = .pending
    
    public var scanner: LanScan2?
    public weak var delegate: LanScannerDelegate2?
    
    // MARK: - Init

    public init(delegate: LanScannerDelegate2?) {
        self.delegate = delegate
    }

    // MARK: - Methods

    public func stop() {
        stateType = .stop
        scanner?.stop_S32HP_lan()
    }

    public func start() {
        netServiceDevices.removeAll()
        lanDevices.removeAll()
        stateType = .start
        netServiceScanner.getDevices { devices in
            self.netServiceDevices = devices
        }
        scanner?.stop_S32HP_lan()
        scanner = LanScan2(delegate: self)
        scanner?.start_S32HP_lan()
    }

    public func getCurrentWifiSSID() -> String? {
        nil // scanner?.getCurrentWifiSSID()
    }

    public func lanScanHasUpdatedProgress(_ counter: Int, address: String!) {
        let progress = CGFloat(counter) / CGFloat(MAX_IP_RANGE)
        delegate?.lanScanHasUpdatedProgress(progress, address: address)
    }

    public func lanScanDidFindNewDevice(_ device: [AnyHashable : Any]!) {
        guard let device = device as? [AnyHashable: String] else { return }
        let lanDevice: LanDevice2 = .init(name: device[DEVICE_NAME] ?? "",
                                          ipAddress: device[DEVICE_IP_ADDRESS] ?? "",
                                          mac: device[DEVICE_MAC] ?? "",
                                          brand: device[DEVICE_BRAND] ?? "")
        lanDevices.append(lanDevice)
        delegate?.lanScanDidFindNewDevice(lanDevice)
    }

    public func lanScanDidFinishScanning() {
        delegate?.lanScanDidFinishScanning(merge())
    }
    
    private func merge() -> [LanDevice2] {
        var lanItems = lanDevices
        lanItems.enumerated().forEach { index, lanDevice in
            if let device = netServiceDevices.first(where: { $0.address == lanDevice.ipAddress }) {
                lanItems[index].mac = device.mac
                lanItems[index].name = device.name
            }
            if lanItems[index].mac.contains("02:00:00:00:00:00") {
                lanItems[index].mac = "Unknown"
            }
        }
        return lanItems
    }
}
