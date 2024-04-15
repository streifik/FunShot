//
//  LanModel.swift
//  Hidden Spy Camera Finder
//
//  Created by Evgeniy Bruchkovskiy on 14.11.2023.
//

import Foundation

struct LanModel {
    var name: String
    var ipAddress: String
    var mac: String?
    var brand: String?
}

func macJsonData() -> [MacJsonData]? {
    if let url = Bundle.main.url(forResource: "mac-s", withExtension: "json") {
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode([MacJsonData].self, from: data)
            return jsonData
        } catch {
            print("error:\(error)")
        }
    }
    return nil
}

struct MacResponseData: Decodable {
    var macAdresses: [MacJsonData]
}

struct MacJsonData: Decodable {
    var mac: String
    var brandName: String
}


