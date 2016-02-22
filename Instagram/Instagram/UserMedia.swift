//
//  UserMedia.swift
//  Instagram
//
//  Created by Carl Chen on 2/21/16.
//  Copyright © 2016 Zhen Chen. All rights reserved.
//

import UIKit
import Parse

class UserMedia: NSObject {
    /**
     * Other methods
     */
     
     /**
     Method to post user media to Parse by uploading image file
     
     - parameter image: Image that the user wants upload to parse
     - parameter caption: Caption text input by the user
     - parameter completion: Block to be executed after save operation is complete
     */
    class func postUserImage(image: UIImage?, withCaption caption: String?, withCompletion completion: PFBooleanResultBlock?, withProgress progress: PFProgressBlock?) {
        // Create Parse object PFObject
        let media = PFObject(className: "UserMedia")
        
        // Add relevant fields to the object
        let image = getPFFileFromImage(image)
        media["media"] = image // PFFile column type
        media["author"] = PFUser.currentUser() // Pointer column type that points to PFUser
        media["caption"] = caption
        media["likesCount"] = 0
        
        image?.saveInBackgroundWithBlock({ (success, error) -> Void in
            media.saveInBackgroundWithBlock(completion)
            }, progressBlock: progress)
        //image?.saveInBackgroundWithBlock(nil, progressBlock: progress)
        
        //media["commentsCount"] = 0
        
        // Save object (following function will save the object in Parse asynchronously)
       
    }
    
    /**
     Method to post user media to Parse by uploading image file
     
     - parameter image: Image that the user wants to upload to parse
     
     - returns: PFFile for the the data in the image
     */
    class func getPFFileFromImage(image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
}
