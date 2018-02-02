//
//  SentMemesCollectionViewCell.swift
//  MemeMe
//
//  Created by Jason on 2/1/18.
//  Copyright © 2018 Jason. All rights reserved.
//

import UIKit

class SentMemesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var memedImage: UIImageView!
    
    func updateCell(_ meme: Meme) {
        memedImage.image = meme.memedImage
    }
}
