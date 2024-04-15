//
//  UIFont+Custom.swift
//  Hidden Spy Camera Finder
//
//  Created by Evgeniy Bruchkovskiy on 06.11.2023.
//

import UIKit

enum InterFont: String {
    case InterBlack = "Inter-Black"
    case InterBold = "Inter-Bold"
    case InterExtraBold = "Inter-ExtraBold"
    case InterExtraLight = "Inter-ExtraLight"
    case InterLight = "Inter-Light"
    case InterMedium = "Inter-Medium"
    case InterRegular = "Inter-Regular"
    case InterSemiBold = "Inter-SemiBold"
    case InterThin = "Inter-Thin"
}

typealias HSCF_UIFONT_HS_OE = UIFont

extension HSCF_UIFONT_HS_OE {
    convenience init?(name: InterFont, size: CGFloat) {
        self.init(name: name.rawValue, size: size)
    }
}

extension HSCF_UIFONT_HS_OE {
    static let defaultFont = UIFont().withSize(17)
    
    static func inter(_ inter: InterFont, size: CGFloat) -> UIFont {
        return UIFont(name: inter, size: size) ?? defaultFont
    }
}
