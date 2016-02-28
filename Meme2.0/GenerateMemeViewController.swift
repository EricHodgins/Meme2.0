//
//  ViewController.swift
//  Meme2.0
//
//  Created by Eric Hodgins on 2015-12-21.
//  Copyright © 2015 Eric Hodgins. All rights reserved.
//

import UIKit

class GenerateMemeViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albumButton: UIBarButtonItem!
    @IBOutlet weak var mainImageView: UIImageView!
    
    var memeTextAttributes = [String: AnyObject]()
    var topTextFieldEdited = false
    var bottomTextFieldEdited = false
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navBar: UINavigationBar!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var shareMemeActivityButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextFieldConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomTextFieldConstraint: NSLayoutConstraint!
    var imageRectInImageView: CGRect?
    
    
    //MARK: Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        topTextField.delegate = self
        bottomTextField.delegate = self
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        
        shareMemeActivityButton.enabled = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        
        setupTextAttributesWithFontName("HelveticaNeue-CondensedBlack")
        subscribeToKeyboardNotifications()
        subscribeToDeviceOrientationNotifications()
    }
    
    override func viewDidDisappear(animated: Bool) {
        unscribeToKeyboardNotifications()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // Capitilize any input text.
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        textField.text = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string.uppercaseString)
        
        return false
    }
    
    func setupTextAttributesWithFontName(fontName: String) {
        memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: fontName, size: 40)!,
            NSStrokeWidthAttributeName : -5.0
        ]
        
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = .Center
        topTextField.adjustsFontSizeToFitWidth = true
        
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.textAlignment = .Center
        bottomTextField.adjustsFontSizeToFitWidth = true
    }
    
    //MARK: Orientation Change Notification
    func subscribeToDeviceOrientationNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "deviceRotated", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    func deviceRotated() {
        if mainImageView.image != nil {
            calculateImageRectInImageView()
        }
    }
    
    //MARK: Keyboard Notifications
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder() && view.frame.origin.y == 0 {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification?) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        
        return keyboardSize.CGRectValue().height
    }
    
    func unscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    //MARK: Picking an image
    @IBAction func camerWasPicked(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .Camera
        presentViewController(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func albumWasPicked(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .PhotoLibrary
        presentViewController(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            mainImageView.image = image
            
            // get the size of the actual image in the imageView
            calculateImageRectInImageView()
            shareMemeActivityButton.enabled = true
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: Get Image Rect
    func calculateImageRectInImageView() {
        let imageViewSize:CGSize = mainImageView.frame.size
        let imageSize:CGSize = (mainImageView.image?.size)!
        
        let scaleWidth:CGFloat = imageViewSize.width / imageSize.width
        let scaleHeight:CGFloat = imageViewSize.height / imageSize.height
        
        let aspect = min(scaleWidth, scaleHeight)
        let width = aspect * imageSize.width
        let height = aspect * imageSize.height
        
        var imageRect: CGRect = CGRectMake(0, 0, width, height)
        
        imageRect.origin.x = (imageViewSize.width - imageRect.width) / 2
        imageRect.origin.y = (imageViewSize.height - imageRect.height) / 2
        
        //
        imageRectInImageView = imageRect
        
        var top: CGFloat = 0
        var bottom: CGFloat = 0
        if UIDevice.currentDevice().orientation.isLandscape {
            top = navBar.frame.height
            bottom = toolBar.frame.height
        }
        topTextFieldConstraint.constant = imageRect.origin.y + top
        bottomTextFieldConstraint.constant = view.frame.height - (imageRect.origin.y + imageRect.height) + bottom
        
    }
    
    //MARK: Share meme
    @IBAction func shareMeme(sender: AnyObject) {
        
        let memedImage = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [memedImage as UIImage], applicationActivities: nil)
        
        activityViewController.completionWithItemsHandler = { (activity, success, items, error) in
            //print("\(activity), \(success), \(items), \(error)")
            if success {
                self.save()
            }
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        presentViewController(activityViewController, animated: true, completion: nil)
        
    }
    
    func generateMemedImage() -> UIImage {
        // hide tool bar and nav bar
        toolBar.hidden = true
        navBar.hidden = true
        
        //Render view an image
        //UIGraphicsBeginImageContext(view.frame.size)
        //view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        UIGraphicsBeginImageContextWithOptions(imageRectInImageView!.size, false, 0)
        view.drawViewHierarchyInRect(CGRectMake(-imageRectInImageView!.origin.x, -imageRectInImageView!.origin.y, view.bounds.size.width, view.bounds.size.height), afterScreenUpdates: true)
        
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        toolBar.hidden = false
        navBar.hidden = false
        
        return memedImage
    }
    
    //MARK: Save
    func save() {
        // save the meme
        let meme = Meme(topTextField: topTextField.text!, bottomTextField: bottomTextField.text!, image: mainImageView.image!, memedImage: generateMemedImage())
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    //MARK: Cancel was pressed
    @IBAction func cancelWasPressed(sender: AnyObject) {
        mainImageView.image = nil
        shareMemeActivityButton.enabled = false
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        topTextFieldEdited = false
        bottomTextFieldEdited = false
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //MARK: Font & Content Mode Options
    @IBAction func changeFont(sender: AnyObject) {
        let optionMenu = UIAlertController(title: nil, message: "Choose Font", preferredStyle: .ActionSheet)
        
        let copperFont = UIAlertAction(title: "Copperplate", style: .Default) { (alert: UIAlertAction!) -> Void in
            self.setupTextAttributesWithFontName("Copperplate")
        }
        
        let helveticaNeue = UIAlertAction(title: "HelveticaNeue", style: .Default) { (alert: UIAlertAction!) -> Void in
            self.setupTextAttributesWithFontName("HelveticaNeue-CondensedBlack")
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .Default) { (alert: UIAlertAction!) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        optionMenu.addAction(copperFont)
        optionMenu.addAction(helveticaNeue)
        optionMenu.addAction(cancel)
        
        presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    @IBAction func changePictureContentMode(sender: AnyObject) {
        let optionMenu = UIAlertController(title: nil, message: "Choose Content Mode", preferredStyle: .ActionSheet)
        let aspectFit = UIAlertAction(title: "Aspect Fit", style: .Default) { (alert: UIAlertAction!) -> Void in
            self.mainImageView.contentMode = .ScaleAspectFit
            self.calculateImageRectInImageView()
        }
        
        let aspectFill = UIAlertAction(title: "Aspect Fill", style: .Default) { (alert: UIAlertAction!) -> Void in
            self.mainImageView.contentMode = .ScaleAspectFill
            self.topTextFieldConstraint.constant = 85
            self.bottomTextFieldConstraint.constant = 87
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .Default) { (alert: UIAlertAction!) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        optionMenu.addAction(aspectFit)
        optionMenu.addAction(aspectFill)
        optionMenu.addAction(cancel)
        
        presentViewController(optionMenu, animated: true, completion: nil)
    }
    
}

extension GenerateMemeViewController {
    //MARK: Text Field Delegate Methods
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == topTextField && !topTextFieldEdited {
            textField.text = ""
            topTextFieldEdited = true
        }
        
        if textField == bottomTextField && !bottomTextFieldEdited {
            textField.text = ""
            bottomTextFieldEdited = true
        }
    }

}


