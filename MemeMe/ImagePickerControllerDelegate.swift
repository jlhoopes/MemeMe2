//
//  ImagePickerControllerDelegate.swift
//  MemeMe
//
//  Created by Jason on 12/10/17.
//  Copyright © 2017 Jason. All rights reserved.
//

import Foundation
import UIKit

extension MemeEditViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]){
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            self.view.layoutIfNeeded()
            //print(scrollView.bounds.size)
            setZoomScaleForImage(scrollViewSize: scrollView.bounds.size)
            centerImage()
            self.dismiss(animated: true, completion: nil)
        }
        //dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
