// Copyright © 2023 Oleksandr Malinchuk. All rights reserved.

import Foundation

final class DiscoveryService: NSObject {
    
    // MARK: - Private properties

    private let browser = NetServiceBrowser()
    private var services: Array<NetService> = []
    private var serviceModels: Array<NetworkDevice> = []
    private var items = ["_airplay._tcp.",
                         "_spotify-connect._tcp.",
                         "_ipp._tcp.",
                         "_services._dns-sd._udp",
                         "_http._tcp"]
    
    // MARK: - Public

    func getDevices(completion: @escaping (_ devices: [NetworkDevice]) -> Void) {
        browser.delegate = self
        search(completion: completion)
    }
    
    private func search(completion: @escaping ((_ devices: [NetworkDevice]) -> Void)) {
        guard !items.isEmpty else {
            completion(serviceModels)
            return
        }
        let key = items.removeLast()
        self.browser.stop()
        self.browser.searchForServices(ofType: key, inDomain: "local.")
        if items.contains(key) {
            items.removeAll(where: { $0 == key })
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.search(completion: completion)
        }
    }
    
    private func stopDiscovery() {
        browser.stop()
    }
    
}

// MARK: - Private

private extension DiscoveryService {
    
    func parse(addressData: Data) -> String? {
        let addressGeneric = addressData.withUnsafeBytes { $0.bindMemory(to: sockaddr.self).baseAddress }
        if let addressGeneric = addressGeneric {
            switch addressGeneric.pointee.sa_family {
            case sa_family_t(AF_INET):
                var dest = [CChar](repeating: 0, count: Int(INET_ADDRSTRLEN))
                var ip4 = addressGeneric.withMemoryRebound(to: sockaddr_in.self, capacity: 1) { $0.pointee }
                let address = String(cString: inet_ntop(AF_INET, &ip4.sin_addr, &dest, socklen_t(INET_ADDRSTRLEN)))
                return address
            default: break
            }
        }

        return nil
    }
}

// MARK: - NetServiceBrowserDelegate

extension DiscoveryService: NetServiceBrowserDelegate {
    
    func netServiceBrowserWillSearch(_ browser: NetServiceBrowser) { }
    
    func netServiceBrowserDidStopSearch(_ browser: NetServiceBrowser) { }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        service.delegate = self
        service.resolve(withTimeout: 0.5)
        services.append(service)
        
        if !moreComing {
            stopDiscovery()
        }
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didRemove service: NetService, moreComing: Bool) {
        if let index = services.firstIndex(of: service) {
            services.remove(at: index)
        }
    }
    
    func netServiceBrowser(_ browser: NetServiceBrowser, didNotSearch errorDict: [String : NSNumber]) {
        print(errorDict)
    }
    
}

// MARK: - NetServiceDelegate

extension DiscoveryService: NetServiceDelegate {
    
    func netServiceDidResolveAddress(_ sender: NetService) {        
        sender.delegate = nil
        
        guard let addresses = sender.addresses else { return }
        
        if (addresses.isEmpty) {
            print("%@ resolved with 0 addresses, bailing ...", sender.name)
            return
        }

        var IPv4Address: String?
        
        for addressData in addresses {
            if let address = parse(addressData: addressData) {
                IPv4Address = address
                continue
            }
        }

        guard let address = IPv4Address else {
            print("\(sender.name): couldn't find resolved IPv4 addresses (\(addresses.count) total)")
            return
        }

        var uuid = ""

        if let recordData = sender.txtRecordData() {
            let record = String(decoding: recordData, as: UTF8.self)
            let uuidIdentifier = "deviceid="

            if let uuidRange = record.range(of: uuidIdentifier) {
                let uuidStartLocation = uuidRange.upperBound
                let macAddressLength = 14
                
                let endIndex = record.index(uuidStartLocation, offsetBy: macAddressLength)
                uuid = String(record[uuidStartLocation..<endIndex])
            } else {
                uuid = sender.name
            }
        }

        let device = NetworkDevice(name: sender.name, address: address, mac: uuid)
        print(device) //TODO: Send received device to devices manager
        serviceModels.append(device)
    }
    
    func netService(_ sender: NetService, didNotResolve errorDict: [String : NSNumber]) {
        print("failed to resolve service")
    }
    
}

public struct NetworkDevice {
    let name: String
    let address: String
    let mac: String
}
