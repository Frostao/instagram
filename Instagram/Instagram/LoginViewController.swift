//
//  LoginViewController.swift
//  Instagram
//
//  Created by Carl Chen on 2/21/16.
//  Copyright © 2016 Zhen Chen. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func signinClicked(sender: AnyObject) {
        
        
        let usern = username.text ?? ""
        let passw = password.text ?? ""
        
        PFUser.logInWithUsernameInBackground(usern, password: passw) { (user: PFUser?, error: NSError?) -> Void in
            if let error = error {
                print("User login failed.")
                print(error.localizedDescription)
            } else {
                print("User logged in successfully")
                self.performSegueWithIdentifier("showPhoto", sender: nil)
                // display view controller that needs to shown after successful login
            }
        }
        
    }
    @IBAction func signupClicked(sender: AnyObject) {
        let user = PFUser()
        user.username = username.text
        user.password = password.text
        user.signUpInBackgroundWithBlock { (success, error) -> Void in
            if success {
                self.performSegueWithIdentifier("showPhoto", sender: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
