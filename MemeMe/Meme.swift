//
//  Meme.swift
//  MemeMe
//
//  Created by OLIVER HAGER on 4/7/15.
//  Copyright (c) 2015 OLIVER HAGER. All rights reserved.
//
import UIKit

/// Meme data (serializable)
class Meme: NSObject {
    /// top text
    var topText: String!
    
    /// bottom text
    var bottomText: String!
    
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
    
    /// offer initializer for deserializing Meme object
    /// :param: aDecoder deserializer
    required init(coder aDecoder: NSCoder) {
        topText = aDecoder.decodeObjectForKey("topText") as! String
        bottomText = aDecoder.decodeObjectForKey("bottomText") as! String
        image = aDecoder.decodeObjectForKey("image") as! UIImage
        memedImage = aDecoder.decodeObjectForKey("memedImage") as! UIImage
    }
    
    /// offer initializer for serializing Meme object
    /// :param: aCoder serializer
    func encodeWithCoder(aCoder: NSCoder!) {
        aCoder.encodeObject(topText, forKey: "topText")
        aCoder.encodeObject(bottomText, forKey: "bottomText")
        aCoder.encodeObject(image, forKey: "image")
        aCoder.encodeObject(memedImage, forKey: "memedImage")
    }
}
