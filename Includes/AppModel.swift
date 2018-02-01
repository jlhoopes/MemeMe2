//
//  AppModel.swift
//  MemeMe
//
//  Created by Jason on 12/23/17.
//  Copyright © 2017 Jason. All rights reserved.
//

import UIKit

struct AppModel {
    static let defaultTopText = "TOP"
    static let defaultBottomText = "BOTTOM"
    
    static let memeTextAttributes = [
        NSAttributedStringKey.strokeColor.rawValue : UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue : UIColor.white,
        NSAttributedStringKey.font.rawValue : UIFont(name: "impact", size: 40)!,
        NSAttributedStringKey.strokeWidth.rawValue : -1.0
        ] as [String : Any]
    static let fontsAvailable = UIFont.familyNames
    static let currentFontIndex: Int = -1
    static var selectedFont: String = ""
}
