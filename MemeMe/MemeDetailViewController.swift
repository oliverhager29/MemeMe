//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by OLIVER HAGER on 3/13/15.
//  Copyright (c) 2015 OLIVER HAGER. All rights reserved.
//
import UIKit

/// Memem detail view controller
class MemeDetailViewController: UIViewController {
    /// image view
    @IBOutlet weak var imageView: UIImageView!
    
    /// Meme shown in details view (set with viewDetails segue)
    var meme: Meme!
    
    /// initialize details view
    /// :param: animated
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let imageView = imageView {
            imageView.image = meme.memedImage
        }
        let backButton = UIBarButtonItem(title: "＜Sent Memes", style: UIBarButtonItemStyle.Plain, target: self, action: "goBack")
        if let tabBarController = tabBarController {
            tabBarController.navigationItem.leftBarButtonItem = backButton
            tabBarController.navigationItem.title = ""
        
            let emptyButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: navigationController, action: nil)
            tabBarController.navigationItem.rightBarButtonItem = emptyButton
        }
    }
    
    /// navigate back to the collection/table view
    func goBack() {
        performSegueWithIdentifier("goBack", sender: self)
    }
    
    /// navigate to edit Meme view
    /// :param: edit button
    func editMeme(sender: UIBarButtonItem) {
        performSegueWithIdentifier("editMeme", sender: self)
    }
    
    /// delete Meme
    /// :param: sender pressed delete button
    @IBAction func deleteMeme(sender: UIButton) {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        var allMemes = appDelegate.memes
        var index = (allMemes as NSArray).indexOfObject(meme)
        if(index >= 0) {
            allMemes.removeAtIndex(index)
            appDelegate.memes = allMemes
            goBack()
        }
    }

    /// set Meme to edit
    /// :param: segue segue
    /// :param: sender sender
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "editMeme") {
            let controller = segue.destinationViewController as! MemeViewController
            controller.meme = meme
            controller.isInitialEntry = false
            controller.enableShareButton = true
            controller.isEditMode = true
        }
    }
}
