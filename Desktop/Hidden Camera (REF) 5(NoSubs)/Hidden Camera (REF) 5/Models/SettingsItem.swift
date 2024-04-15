//
//  SettingsItem.swift
//  Hidden Spy Camera Finder
//
//  Created by Evgeniy Bruchkovskiy on 06.11.2023.
//

import Foundation

struct SettingsItem: Hashable {
    static func == (lhs: SettingsItem, rhs: SettingsItem) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    let title: String
    let subtitle: String?
    
    var completion: (() -> Void)?

    private let identifier = UUID()
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.identifier)
    }
}
