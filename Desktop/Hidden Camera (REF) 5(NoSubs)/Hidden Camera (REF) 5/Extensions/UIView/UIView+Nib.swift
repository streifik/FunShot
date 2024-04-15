//
//  UIView+Ni.swift
//  Hidden Spy Camera Finder
//
//  Created by Evgeniy Bruchkovskiy on 09.11.2023.
//

import UIKit

extension EXT_BOUNCE_UIVIEW_HSCF_HS {
    static var nib: UINib {
        UINib(nibName: String(describing: Self.self), bundle: nil)
    }
}
