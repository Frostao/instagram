//
//  UploadViewController.swift
//  Instagram
//
//  Created by Carl Chen on 2/21/16.
//  Copyright © 2016 Zhen Chen. All rights reserved.
//

import UIKit

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    @IBOutlet weak var caption: UITextField!
    @IBOutlet weak var pictureButton: UIButton!
    @IBOutlet weak var progress: UIProgressView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func pictureButtonTapped(sender: AnyObject) {
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
        pictureButton.setBackgroundImage(image, forState: .Normal)
        pictureButton.setTitle("", forState: .Normal)
    }
    @IBAction func uploadTapped(sender: AnyObject) {
        if pictureButton.backgroundImageForState(.Normal) != nil {
            UserMedia.postUserImage(pictureButton.backgroundImageForState(.Normal), withCaption: caption.text, withCompletion: { (success, error) -> Void in
                self.progress.hidden = true
                NSNotificationCenter.defaultCenter().postNotificationName("photoPosted", object: nil)
                self.dismissViewControllerAnimated(true, completion: nil)
                }, withProgress: { (prog) -> Void in
                    self.progress.hidden = false
                    if prog == 100 {
                        self.progress.setProgress(100, animated: false)
                    } else {
                        self.progress.setProgress(Float(prog), animated: true)
                    }
            })
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
