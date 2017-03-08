//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Ash Duckett on 22/01/2017.
//  Copyright © 2017 Ash Duckett. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareMemeButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var navBarGapFromTop: NSLayoutConstraint!
    @IBOutlet weak var toolBar: UIToolbar!
    

    let topPlaceholderText = "TOP"
    let bottomPlaceholderText = "BOTTOM"
    
    @IBAction func shareMeme(_ sender: Any) {
        // Generate a memed image
        let memedImage = generateMemedImage()
        
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        present(activityController, animated: true, completion: nil)
        
        activityController.completionWithItemsHandler = {(activity, completed, items, error) in
            if completed {
                self.save()
            }
        }
    }
    
    func save() {
        let memedImage = generateMemedImage()
        
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func toggleToolAndNavBarVisibility() {
        self.navBar.isHidden = !self.navBar.isHidden
        self.toolBar.isHidden = !self.toolBar.isHidden
    }
    
    func generateMemedImage() -> UIImage {
        // Hide the toolbar and the navbar so they don't show up in the meme
        toggleToolAndNavBarVisibility()
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show the toolbar and navbar so they can be used as normal
        toggleToolAndNavBarVisibility()
        
        
        return memedImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shareMemeButton.isEnabled = false
        configureTextFields(textField: topTextField)
        configureTextFields(textField: bottomTextField)
    }
    
    func getTextAttributes() -> [String:Any] {
        let memeTextAttributes: [String:Any] = [
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: -3.0,
            
            ]
        return memeTextAttributes

    }
    
    
    func getAttributedString(string: String) -> NSAttributedString {
        return NSAttributedString(string: string, attributes: getTextAttributes())
    
    
    }
    @IBAction func cancelMeme(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func configureTextFields(textField: UITextField) {
        textField.delegate = self
        textField.defaultTextAttributes = getTextAttributes()
        
        // The alignment has to be set after the defaultTextAttributes property
        textField.textAlignment = NSTextAlignment.center

        let textForField = (textField == topTextField) ? topPlaceholderText : bottomPlaceholderText
        textField.attributedPlaceholder = getAttributedString(string: textForField)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = ""
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text == "" {
            if bottomTextField.isFirstResponder {
                bottomTextField.attributedPlaceholder = getAttributedString(string: bottomPlaceholderText)
            } else if topTextField.isFirstResponder {
                topTextField.attributedPlaceholder = getAttributedString(string: topPlaceholderText)
            }
        }
        return true
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func keyboardWillShow(notification: Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
            navBarGapFromTop.constant -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y += getKeyboardHeight(notification)
            navBarGapFromTop.constant += getKeyboardHeight(notification)
        }
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    
    }
    
    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            shareMemeButton.isEnabled = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func presentImagePicker(sourceType: UIImagePickerControllerSourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImage(_ sender: Any) {
        presentImagePicker(sourceType: .photoLibrary)
    }
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        presentImagePicker(sourceType: .camera)
    }

}

