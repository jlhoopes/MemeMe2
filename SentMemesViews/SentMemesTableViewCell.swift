//
//  SentMemesTableViewCell.swift
//  MemeMe
//
//  Created by Jason on 2/1/18.
//  Copyright © 2018 Jason. All rights reserved.
//

import UIKit

class SentMemesTableViewCell: UITableViewCell {
    
    //MARK: Properties
    
    @IBOutlet weak var memedImage: UIImageView!
    @IBOutlet weak var topText: UILabel!
    @IBOutlet weak var bottomText: UILabel!
    
    //MARK: Custom Cell's Functions
    
    func updateCell(_ meme: Meme) {
        
        //update cell's view
        memedImage.image = meme.memedImage
        topText.text = meme.topText as String?
        bottomText.text = meme.bottomText as String?
    }
}
