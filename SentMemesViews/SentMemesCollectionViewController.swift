//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Jason on 1/31/18.
//  Copyright © 2018 Jason. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //per lesson
        let space: CGFloat
        let dimension: CGFloat
        if (UIDeviceOrientationIsPortrait(UIDevice.current.orientation)){
            space = 3
            dimension = (view.frame.size.width - (2*space))/3
        } else {
            space = 1
            dimension = (view.frame.size.width - (1*space))/5
        }
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        tabBarController?.tabBar.isHidden = false
        collectionView?.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Meme.count()
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppModel.memesCollectionCellReuseIdentifier, for: indexPath) as! SentMemesCollectionViewCell
        let meme = Meme.getMemeStorage().memes[indexPath.item]
        cell.updateCell(meme)
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let memeDetail = self.storyboard?.instantiateViewController(withIdentifier:AppModel.memeDetailStoryboardIdentifier) as! MemeDetailViewController
        memeDetail.meme = Meme.getMemeStorage().memes[indexPath.row]
        navigationController?.pushViewController(memeDetail, animated: true)
        
    }
}
