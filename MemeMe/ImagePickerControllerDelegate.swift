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
        }
        dismiss(animated: true, completion: nil)
        
        //updateButton()
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
