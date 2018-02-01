//
//  MemeModel.swift
//  MemeMe
//
//  Created by Jason on 12/10/17.
//  Copyright © 2017 Jason. All rights reserved.
//

import Foundation
import UIKit

struct Meme {
    var topText: String!
    var bottomText: String!
    var image: UIImage!
    var memedImage: UIImage!
    
    //Meme Storage
    static func getMemeStorage() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    //Count all created memes
    static func count() -> Int {
        return getMemeStorage().memes.count
    }
    
}
