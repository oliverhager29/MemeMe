//
//  MemeViewController.swift
//  MemeMe
//
//  Created by OLIVER HAGER on 4/5/15.
//  Copyright (c) 2015 OLIVER HAGER. All rights reserved.
//
import UIKit

/// Meme view controller (controller for creating/editing a meme)
class MemeViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {
    /// bottom tool bar with camera and album
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    /// Meme to create/edit
    var meme: Meme! = nil
    var isEditMode = false
    /// in bottom text field
    var inBottomTextField = false
    
    /// share button enabled (after image has been selected for Meme)
    var enableShareButton = false
    
    /// all Memes
    var memes: [Meme]!
    
    /// memed image (i.e. image with top and bottom label)
    var memedImage: UIImage!
    
    /// is initial entry
    var isInitialEntry = true
    
    /// top text field
    @IBOutlet weak var topTextField: UITextField!
    
    /// bottom text field
    @IBOutlet weak var bottomTextField: UITextField!
    
    /// share button
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    /// cancel button
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    /// camera button
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    /// image view
    @IBOutlet weak var imageView: UIImageView!
    
    /// activity controller (for sharing Meme)
    var activityController: UIActivityViewController!
    
    /// text attributes for the top/bottom text fields
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSBackgroundColorAttributeName: UIColor.clearColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -5.0
    ]

    /// share Meme button has been pressed
    /// :param: share button
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        memedImage = generateMemedImage()
        activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityController.completionWithItemsHandler = { activity, success, items, error in
            self.completeActivityController()
        }
        presentViewController(activityController, animated: true, completion: nil)
    }
    
    /// save shared/sent Meme in application delegate
    func saveSentMeme() {
        if(meme == nil) {
            meme = Meme(topText: topTextField.text, bottomText: bottomTextField.text, image: imageView.image, memedImage: memedImage)
        }
        else {
            meme.topText = topTextField.text
            meme.bottomText = bottomTextField.text
            meme.image = imageView.image
            meme.memedImage = memedImage
        }
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.sharedApplication().delegate
        if let appDelegate = object as? AppDelegate {
            if(!isEditMode) {
                appDelegate.memes.append(meme)
            }
        }
    }
    
    /// after share activity has been completed the Meme shall be saved and the sent Memes shall be displayed
    func completeActivityController() {
        activityController.dismissViewControllerAnimated(true, completion: nil)
        performSegueWithIdentifier("sentMemes", sender: self)
        saveSentMeme()
    }
    
    /// if the cancel button has been pressed then go to Sent Memes page (table view)
    @IBAction func pressCancelButton(sender: UIBarButtonItem) {
        if(isEditMode) {
            memedImage = generateMemedImage()
            saveSentMeme()
        }
        performSegueWithIdentifier("sentMemes", sender: self)
    }
    
    override func viewDidLoad() {
        // if there are already store Memes then navigate to the Sent Meme page (table view)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        if(appDelegate.memes.count > 0 && isInitialEntry) {
            isInitialEntry = false
            performSegueWithIdentifier("sentMemes", sender: self)
        }
        else {
            isInitialEntry = false
        }
    }

    /// initialize Meme editor
    /// :params: animated
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        subscribeToKeyboardNotifications()
        topTextField.textAlignment = NSTextAlignment.Center
        bottomTextField.textAlignment = NSTextAlignment.Center
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes

        topTextField.delegate = self
        bottomTextField.delegate = self
        shareButton.enabled = enableShareButton
        if(meme != nil) {
            topTextField.text = meme.topText
            bottomTextField.text = meme.bottomText
            imageView.image = meme.image
        }
        tabBarController?.tabBar.hidden = true
        navigationController?.navigationBar.hidden = false
        let emptyButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: navigationController, action: nil)
        if let tabBarController = tabBarController {
            tabBarController.navigationItem.leftBarButtonItem = emptyButton
            tabBarController.navigationItem.title = ""
            tabBarController.navigationItem.rightBarButtonItem = emptyButton
            tabBarController.navigationController?.navigationBar.hidden = true
        }
    }
    
    /// unsubscribe from keyboard notifications
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    /// subscribe to keyboard notifications in order to shift the bottum textfield above the keyboard so that it is not covered by the keyboard
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    /// unsubscribe from keyboard notifications
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    /// shift bottom textfield above the keyboard so that it is not covered by the keyboard
    /// :param: show keyboard notification
    func keyboardWillShow(notification: NSNotification) {
        if(inBottomTextField) {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    /// shift bottom textfield down to the original position after keyboard has been hidden
    /// :param: hide keyboard notification
    func keyboardWillHide(notification: NSNotification) {
        if(inBottomTextField) {
            view.frame.origin.y += getKeyboardHeight(notification)
            inBottomTextField = false
        }
    }
    
    /// get height of keyboard
    /// :param: keyboard notification
    /// :returns: height
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }

    /// pick image button has been pressed and the image picker is shown in order to select a Meme picture from the album
    /// :param: pick image button
    @IBAction func pickAnImageFromAlbum(sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: completePick)
    }
    
    
    /// camera button has been pressed and camera window is shown in order to take a Meme picture
    /// :param: camera button
    @IBAction func pickAnImageFromCamera(sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: completePick)
    }

    
    /// image has been selected from the album and the share button can be enabled
    func completePick() {
        enableShareButton = true
    }
    
    /// image has been taken with the camera and the share button can be enabled
    /// :param: image picker
    /// :param: finish info
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject: AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /// handle cancellation of image picker
    /// :param: image picker
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /// empty text field before start editing
    /// :param: text field
    func textFieldDidBeginEditing(textField: UITextField) {
        inBottomTextField = (textField == bottomTextField)
        textField.text = ""
    }
    
    /// leaves text field focus after return key has been pressed
    /// :param: text field
    /// :returns: true
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    /// generate memed image by hiding the top and bottom bar and making a screen shot
    /// :return: memed image (i.e. image with top and bottom text)
    func generateMemedImage() -> UIImage {
        // Hide toolbar and navbar
        if let navigationController = navigationController {
            navigationController.setNavigationBarHidden(true, animated: true)
        }
        if let bottomToolbar = bottomToolbar {
            bottomToolbar.hidden = true
        }
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame,
            afterScreenUpdates: true)
        let memedImage: UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        // Show toolbar and navbar
        if let bottomToolbar = bottomToolbar {
            bottomToolbar.hidden = false
        }
        if let navigationController = navigationController {
            navigationController.setNavigationBarHidden(false, animated: true)
        }
        return memedImage
    }
}