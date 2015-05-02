//
//  MemeCollectionViewCell.swift
//  MemeMe
//
//  Created by OLIVER HAGER on 3/13/15.
//  Copyright (c) 2015 OLIVER HAGER. All rights reserved.
//
import UIKit

/// collection view cell
class MemeCollectionViewCell: UICollectionViewCell {
    /// Meme image view
    @IBOutlet weak var memeImageView: UIImageView!
    
    /// delete button (shown in edit mode)
    @IBOutlet weak var deleteButton: UIButton!
}
