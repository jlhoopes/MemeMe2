//
//  MemeEditViewController.swift
//  MemeMe
//
//  Created by Jason on 12/9/17.
//  Copyright © 2017 Jason. All rights reserved.
//

import UIKit

class MemeEditViewController: UIViewController, UINavigationControllerDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var shareBar: UIToolbar!
    @IBOutlet weak var selectBar: UIToolbar!
    @IBOutlet weak var scrollView: UIScrollView!

    //MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setText(textObject: topText, string: AppModel.defaultTopText)
        setText(textObject: bottomText, string: AppModel.defaultBottomText)
        scrollView.delegate = self;
        scrollView.backgroundColor = UIColor.black
    }
    
    //MARK: Interface Modifications
    override var prefersStatusBarHidden: Bool {
        //Hide Status Bar
        return true
    }
    
    //MARK: UIImagePickerController Functions
    
    @IBAction func imageFromAlbum(_ sender: Any) {
        pickImage(.photoLibrary)
    }
    @IBAction func imageFromCamera(_ sender: Any) {
        pickImage(.camera)
    }
    
    func pickImage(_ imageSource: UIImagePickerControllerSourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = imageSource
        present(imagePicker, animated: true, completion: nil)
    }
    // MARK: TopButton Actions
    @IBAction func shareAction(_ sender: Any) {
        
        let memedImage = generateMemedImage()
        
        let shareActivityViewController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        shareActivityViewController.completionWithItemsHandler = { activity, completed, items, error in
            
            if completed {
                
                //Dismiss
                self.dismiss(animated: true, completion: nil)
            
            }
            
        }
        
        present(shareActivityViewController, animated: true, completion: nil)
    }
    
    // MARK: Generate Meme
    
    func generateMemedImage() -> UIImage {
        
        barVisibility(hidden: true)
        
        // render scrollView contents to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        barVisibility(hidden: false)
        
        return memedImage
    }
    
    // MARK: Misc Functions
    func barVisibility(hidden: Bool){
        shareBar.isHidden = hidden
        selectBar.isHidden = hidden
    }
    
}

extension MemeEditViewController: UITextFieldDelegate{
    
    //MARK: TextField Functions
    
    func setText(textObject: UITextField, string:String){
        //defaults
        textObject.defaultTextAttributes = AppModel.memeTextAttributes
        textObject.text = string
        textObject.textAlignment = NSTextAlignment.center
        textObject.delegate = self;
    }
    
    func textFieldDidBeginEditing(_ textObject: UITextField) {
        
        //Erase the default text when editing begins
        if textObject == topText && textObject.text == AppModel.defaultTopText {
            textObject.text = ""
        } else if textObject == bottomText && textObject.text == AppModel.defaultBottomText {
            textObject.text = ""
        }
    }
    
    
    
    func textField(_ textObject: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var text = textObject.text as NSString?
        text = text!.replacingCharacters(in: range, with: string) as NSString?
        
        //to ensure capitalization works even if someone pastes text
        textObject.text = text?.uppercased
        return false
    }
    
    
    func textFieldShouldReturn(_ textObject: UITextField) -> Bool {
        
        //Allows the user to use the return key to hide keyboard
        textObject.resignFirstResponder()
        return true
    }
    
    
    func textFieldDidEndEditing(_ textObject: UITextField) {
        
        //To set default text if textfields text is empty
        if textObject == topText && textObject.text!.isEmpty {
            
            textObject.text = AppModel.defaultTopText;
            
        }else if textObject == bottomText && textObject.text!.isEmpty {
            
            textObject.text = AppModel.defaultBottomText;
        }
    }
}
