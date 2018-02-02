//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Jason on 2/1/18.
//  Copyright © 2018 Jason. All rights reserved.
//


import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var memedImage: UIImageView!
    var meme: Meme! = nil
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        memedImage.image = meme.memedImage
    }
}

