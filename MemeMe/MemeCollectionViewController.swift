//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by OLIVER HAGER on 3/13/15.
//  Copyright (c) 2015 OLIVER HAGER. All rights reserved.
//
import Foundation

import UIKit

/// Meme collection view controller (handles display, addition and deletion of cells in a collection view)
class MemeCollectionViewController: UIViewController, UICollectionViewDataSource {
    
    // Get ahold of some memes, for the table
    // This is an array of Meme instances
    var allMemes: [Meme]! = []
    var myCollectionView: UICollectionView!
    var currentMeme: Meme!
    var editMode = false
    
    /// customize edit and add button in navigation bar
    /// :param: animated
    override func viewWillAppear(animated: Bool) {
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "add")
        if let tabBarController = tabBarController {
            tabBarController.navigationItem.rightBarButtonItem = addButton
        
            let editButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "edit")
            tabBarController.navigationItem.leftBarButtonItem = editButton
        
            tabBarController.navigationItem.title = "Sent Memes"
            tabBarController.navigationController?.navigationBar.hidden = false
        }
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        allMemes = appDelegate.memes
        if myCollectionView != nil {
            myCollectionView.reloadData()
        }
    }
    
    /// navigate to editor screen in order to add Meme
    func add() {
        performSegueWithIdentifier("add", sender: self)
    }
    
    /// delete the selected Meme
    /// :param: delete button
    func deleteButton(sender:UIButton!) {
        let pos = sender.layer.valueForKey("index") as! Int
        allMemes.removeAtIndex(pos)
        if myCollectionView != nil {
            myCollectionView.reloadData()
        }
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes=allMemes
        edit()
    }
    
    /// change into edit mode where a delete button is shown for each element
    func edit() {
        editMode = !editMode
        if(editMode == true) {
            for item in myCollectionView!.visibleCells() as [AnyObject] {
                let indexPath: NSIndexPath = myCollectionView!.indexPathForCell(item as! MemeCollectionViewCell)!
                let cell: MemeCollectionViewCell = myCollectionView.cellForItemAtIndexPath(indexPath) as! MemeCollectionViewCell
                cell.deleteButton.hidden = false
                cell.deleteButton.layer.setValue(indexPath.row, forKey: "index")
                cell.deleteButton.addTarget(self, action: "deleteButton:", forControlEvents: UIControlEvents.TouchUpInside)
            }
        }
        else {
            for item in myCollectionView!.visibleCells() as [AnyObject] {
                let indexPath: NSIndexPath = myCollectionView.indexPathForCell(item as! MemeCollectionViewCell)!
                let cell: MemeCollectionViewCell = myCollectionView!.cellForItemAtIndexPath(indexPath) as! MemeCollectionViewCell
                cell.deleteButton.hidden = true
            }
        }
    }
    
    /// return number of Memes in the collection
    /// :param: colleciton view
    /// :param: section (here only one section exists)
    /// :returns: number of Memes
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        myCollectionView = collectionView
        return allMemes.count
    }
    
    /// fill cell with content (Memed image)
    /// :param: collection view
    /// :param: index path to cell to filled with content
    /// :returns: filled collection view cell
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        myCollectionView = collectionView
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = allMemes[indexPath.row]
        
        // Set the image
        cell.memeImageView?.image = meme.memedImage
        return cell
    }
    
    /// show detail view for selected  cell
    /// :param: collection view
    /// :param: index path to selected cell
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    {
        myCollectionView = collectionView
        let detailController = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController")! as! MemeDetailViewController
        detailController.meme = allMemes[indexPath.row]
        currentMeme = allMemes[indexPath.row]
        performSegueWithIdentifier("showDetails", sender: detailController)
    }
    
    /// set selected Meme in segue
    /// :param: segue
    /// :param: sender
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "showDetails") {
            let controller = segue.destinationViewController as! MemeDetailViewController
            controller.meme = currentMeme
        }
        else if(segue.identifier == "add") {
            let controller = segue.destinationViewController as! MemeViewController
            controller.isInitialEntry = false
        }
    }
}
