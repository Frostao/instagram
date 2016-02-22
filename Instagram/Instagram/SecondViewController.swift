//
//  SecondViewController.swift
//  Instagram
//
//  Created by Carl Chen on 2/21/16.
//  Copyright © 2016 Zhen Chen. All rights reserved.
//

import UIKit
import Parse

class SecondViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var profile: UIButton!
    
    @IBOutlet weak var logoutButton: UIButton!
    var user:PFUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if user == nil {
            user = PFUser.currentUser()
        }
        profile.clipsToBounds = true
        profile.layer.masksToBounds = true
        profile.layer.cornerRadius = profile.frame.width/4;


        
        username.text = user?.username
        let imageFile = user!["profile"] as? PFFile
        imageFile?.getDataInBackgroundWithBlock({ (data, error) -> Void in
            
            let image = UIImage(data: data!)
            self.profile.setBackgroundImage(image, forState: .Normal)
            self.profile.setTitle("", forState: .Normal)
        })
        
        
        if user != PFUser.currentUser() {
            profile.userInteractionEnabled = false
            logoutButton.hidden = true
        }
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func logoutTapped(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("logout", object: nil)
    }

    @IBAction func profileTapped(sender: AnyObject) {
        let actionSheet = UIAlertController(title: "Pick a source", message: nil, preferredStyle: .ActionSheet)
        let action1 = UIAlertAction(title: "Take a picture", style: .Default) { (action) -> Void in
            //take a picture
            let vc = UIImagePickerController()
            vc.delegate = self
            vc.allowsEditing = true
            vc.sourceType = UIImagePickerControllerSourceType.Camera
            
            self.presentViewController(vc, animated: true, completion: nil)
        }
        let action2 = UIAlertAction(title: "From Camera roll", style: .Default) { (action) -> Void in
            //pick from camera roll
            let vc = UIImagePickerController()
            vc.delegate = self
            vc.allowsEditing = true
            vc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            
            self.presentViewController(vc, animated: true, completion: nil)
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        actionSheet.addAction(cancel)
        actionSheet.addAction(action1)
        actionSheet.addAction(action2)
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.dismissViewControllerAnimated(true, completion: nil)
        profile.setTitle("", forState: .Normal)
        profile.setBackgroundImage(image, forState: .Normal)
        
        if let imageData = UIImagePNGRepresentation(image) {
            PFUser.currentUser()!["profile"] = PFFile(name: "image.png", data: imageData)
            PFUser.currentUser()!.saveInBackground()
        }
        
        
    }

}

