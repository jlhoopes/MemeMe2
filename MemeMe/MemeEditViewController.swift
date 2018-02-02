//
//  MemeEditViewController.swift
//  MemeMe
//
//  Created by Jason on 12/9/17.
//  Copyright © 2017 Jason. All rights reserved.
//

import UIKit

class MemeEditViewController: UIViewController, UINavigationControllerDelegate {
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        
        //Subscribe to keyboard notifications
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
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
                self.save(memedImage: memedImage)
                //Dismiss
                self.dismiss(animated: true, completion: nil)
                self.performSegue(withIdentifier: AppModel.memeTableSegueIdentifier, sender: nil)
            
            }
            
        }
        
        present(shareActivityViewController, animated: true, completion: nil)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        //clear the image and text
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Keyboard Functions
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if bottomText.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification: notification)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        //Get keyboard height from lesson
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
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
    
    // Save Meme to application
    func save(memedImage: UIImage){
        let meme = Meme(topText: (topText.text! as NSString!) as String!, bottomText: (bottomText.text! as NSString!) as String!, image:imagePickerView.image, memedImage: memedImage)
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
    }
    
    // MARK: Misc Functions
    func barVisibility(hidden: Bool){
        // Hide/show the bars and adjust the sizing of the image windows
        let shareFrame = shareBar.frame
        let selectFrame = selectBar.frame
        let height = shareFrame.size.height+selectFrame.size.height
        
        let offsetY = (hidden ? height : -height)
        shareBar.isHidden = hidden
        selectBar.isHidden = hidden
        scrollView.frame = CGRect(x:0,y:0,width: scrollView.frame.width, height: scrollView.frame.height + offsetY)
        imagePickerView.frame = CGRect(x:0,y:0,width: imagePickerView.frame.width, height: imagePickerView.frame.height + offsetY)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { (UIViewControllerTransitionCoordinatorContext) in
            self.topText.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.bottomText.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { (UIViewControllerTransitionCoordinatorContext) in
            UIView.animate(withDuration: 0.5, animations: {
                self.topText.transform = CGAffineTransform.identity
                self.bottomText.transform = CGAffineTransform.identity
            })
        }
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

extension MemeEditViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imagePickerView
    }
    
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerImage()
    }
    
    func setZoomScaleForImage(scrollViewSize: CGSize) {
        if let image = imagePickerView.image {
            let imageSize = image.size
            let widthScale = scrollViewSize.width / imageSize.width
            let heightScale = scrollViewSize.height / imageSize.height
            let minScale = min(widthScale, heightScale)
            scrollView.minimumZoomScale = minScale
            scrollView.maximumZoomScale = 3.0
        }
    }
    
    func centerImage() {
        if imagePickerView.image != nil {
            let scrollViewSize = scrollView.bounds.size
            let imageSize = imagePickerView.frame.size
            let horizontalSpace = imageSize.width < scrollViewSize.width ? (scrollViewSize.width - imageSize.width) / 2 : 0
            let verticalSpace = imageSize.height < scrollViewSize.height ? (scrollViewSize.height - imageSize.height) / 2 : 0
            scrollView.contentInset = UIEdgeInsets(top: verticalSpace, left: horizontalSpace, bottom: verticalSpace, right: horizontalSpace)
        }
    }
    
}
