//
//  Meme.swift
//  MemeMe
//
//  Created by OLIVER HAGER on 4/7/15.
//  Copyright (c) 2015 OLIVER HAGER. All rights reserved.
//
import UIKit

/// Meme data
class Meme {
    /// top text
    var topText: String!
    
    /// bottom text
    var bottomText: String
    
    /// image!
    var image: UIImage!
    
    /// memed image
    var memedImage: UIImage!
    
    /// initialize Meme data
    init(topText: String!, bottomText: String!, image: UIImage!, memedImage: UIImage!) {
        self.topText = topText
        self.bottomText = bottomText
        self.image = image
        self.memedImage = memedImage
    }
}
