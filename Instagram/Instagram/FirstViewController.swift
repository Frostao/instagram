//
//  FirstViewController.swift
//  Instagram
//
//  Created by Carl Chen on 2/21/16.
//  Copyright © 2016 Zhen Chen. All rights reserved.
//

import UIKit
import Parse

class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var photos: [PFObject]?
    
    @IBOutlet weak var tableview: UITableView!
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if let photos = photos {
            return photos.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! PhotoTableViewCell
        if let photos = photos {
            let photo = photos[indexPath.section]
            cell.caption.text = photo["caption"] as? String
            let file = photo["media"] as? PFFile
            file?.getDataInBackgroundWithBlock({ (data, error) -> Void in
                cell.imageview.image = UIImage(data: data!)
            })
        }
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.size.width, height: 60))
        headerView.userInteractionEnabled = true
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        let profileView = UIImageView(frame: CGRect(x: 10, y: 10, width: 45, height: 45))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 22.5;
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).CGColor
        profileView.layer.borderWidth = 1;
        
        let user = photos![section]["author"] as! PFUser
        
        let imageFile = user["profile"] as? PFFile
        imageFile?.getDataInBackgroundWithBlock({ (data, error) -> Void in
            
            profileView.image = UIImage(data: data!)
            
        })
        
        let username = UILabel(frame: CGRect(x: 70, y: 25, width: 50, height: 20))
        username.text = user.username
        headerView.addSubview(username)
        
        // Use the section number to get the right URL
        // profileView.setImageWithURL(...)
        headerView.addSubview(profileView)
        
        headerView.tag = section
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "headerTapped:")
        headerView.addGestureRecognizer(tapRecognizer)
        
        // Add a UILabel for the username here
        
        return headerView
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65
    }
    
    func headerTapped(recognizer: UIGestureRecognizer) {
        performSegueWithIdentifier("showProfile", sender: recognizer.view?.tag)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if segue.identifier == "showProfile" {
            let tag = sender as! Int
            let user = photos![tag]["author"] as! PFUser
            let destViewController = segue.destinationViewController as! SecondViewController
            destViewController.user = user
        }
    }
    
    
    func requestData(completion: (()-> Void)? ) {
        let query = PFQuery(className: "UserMedia")
        query.orderByDescending("createdAt")
        query.includeKey("author")
        query.limit = 20
        
        // fetch data asynchronously
        query.findObjectsInBackgroundWithBlock { (media: [PFObject]?, error: NSError?) -> Void in
            if let media = media {
                self.photos = media
                self.tableview.reloadData()
                if let completion = completion {
                    completion()
                }
                // do something with the data fetched
            } else {
                // handle error
            }
        }
    }
    
    
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        requestData { () -> Void in
            refreshControl.endRefreshing()
        }
        // ... Create the NSURLRequest (myRequest) ...
        
        // Configure session so that completion handler is executed on main UI thread

    }
    
    func photoPosted(notification: NSNotification) {
        requestData(nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        tableview.insertSubview(refreshControl, atIndex: 0)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "photoPosted:", name: "photoPosted", object: nil)
        requestData(nil)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

