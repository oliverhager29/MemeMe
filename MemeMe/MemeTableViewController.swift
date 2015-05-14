//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by OLIVER HAGER on 3/13/15.
//  Copyright (c) 2015 OLIVER HAGER. All rights reserved.
//
import UIKit

/// Meme table view controller (handles display, addition and deletion of cells in a table view)
class MemeTableViewController: UIViewController, UITableViewDataSource {
    /// all Memes
    var allMemes: [Meme]! = []
    
    /// table view
    var myTableView: UITableView!
    
    /// current Meme
    var currentMeme: Meme!
    
    /// customize edit and add button in navigation bar
    /// :param: animated
    override func viewWillAppear(animated: Bool) {
        let editButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "edit")
        if let tabBarController = tabBarController {
            tabBarController.navigationItem.leftBarButtonItem = editButton
        
            let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "add")
            tabBarController.navigationItem.rightBarButtonItem = addButton
            tabBarController.navigationItem.title = "Sent Memes"
            tabBarController.navigationController?.navigationBar.hidden = false
        }
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        allMemes = appDelegate.memes
        if myTableView != nil {
            myTableView.reloadData()
        }
        
    }
    
    func add() {
        performSegueWithIdentifier("add", sender: self)
    }
    
    func edit() {
        myTableView.setEditing(!myTableView.editing, animated: true)
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        var itemToMove = allMemes[sourceIndexPath.row]
        allMemes.removeAtIndex(sourceIndexPath.row)
        allMemes.insert(itemToMove, atIndex: destinationIndexPath.row)
    }
    
    // MARK: Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        myTableView = tableView
        return allMemes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        myTableView = tableView
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as! UITableViewCell
        let meme = allMemes[indexPath.row]
        
        // Set the name and image
        if let textLabel = cell.textLabel {
            textLabel.text = "\(meme.topText)...\(meme.bottomText)"
        }
        if let imageView = cell.imageView {
            imageView.image = meme.memedImage
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        myTableView = tableView
        let detailController = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController")! as! MemeDetailViewController
        detailController.meme = allMemes[indexPath.row]
        currentMeme = allMemes[indexPath.row]
        if let tabBarController = detailController.tabBarController {
            tabBarController.hidesBottomBarWhenPushed=true
        }
        performSegueWithIdentifier("showDetails", sender: detailController)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "showDetails") {
            if let controller = segue.destinationViewController as? MemeDetailViewController {
                controller.meme = currentMeme
            }
        }
        else if(segue.identifier == "add") {
            if let controller = segue.destinationViewController as? MemeViewController {
                controller.isInitialEntry = false
            }
        }
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let pos = indexPath.row
        allMemes.removeAtIndex(pos)
        if myTableView != nil {
            myTableView.reloadData()
        }
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes=allMemes
    }
    
}
