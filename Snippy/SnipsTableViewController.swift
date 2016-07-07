//
//  SnipsTableViewController.swift
//  Snippy
//
//  Created by Aditya Narayan on 6/16/16.
//  Copyright © 2016 TurnToTech. All rights reserved.
//

import UIKit

class SnipsTableViewController: UITableViewController {

    var snips = [Snip]()
    let fireBaseURL = NSURL(string: "https://project-4045948879616680024.firebaseio.com/snippy.json")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCloudData()
        
        let longPress = UILongPressGestureRecognizer(target: self, action:#selector(shareSnip))
        self.tableView.addGestureRecognizer(longPress)
    }
    
    func shareSnip(sender:UILongPressGestureRecognizer) {
        if sender.state == .Began {
            let point = sender.locationInView(self.tableView)
            guard let indexPath = self.tableView.indexPathForRowAtPoint(point)
                else { return }
            
            let snip = self.snips[indexPath.row]
            let activityVC = UIActivityViewController(activityItems:[snip.title, snip.url], applicationActivities: nil)
            self.presentViewController(activityVC, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snips.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel!.text = snips[indexPath.row].title
        cell.detailTextLabel!.text = snips[indexPath.row].url

        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {

        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            
            deleteSnip(snips[indexPath.row])
            self.snips.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let url = NSURL(string: snips[indexPath.row].url)
            else { return }
        
        UIApplication .sharedApplication().openURL(url)
    }

    func getCloudData() {
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: fireBaseURL)
        request.HTTPMethod = "GET"

        let task = session.dataTaskWithRequest(request) {
            (let data, let response, let error) in
            guard let myData:NSData = data
                else { return }
            let decodedJson:[String:AnyObject]
            
            do {
                decodedJson = try NSJSONSerialization.JSONObjectWithData(myData, options: [])
                    as! [String : AnyObject]
                
                self.snips.removeAll()
                
                for (key, value) in decodedJson {
                    let snipDictionary = value as! [String: String];
                    let snip = Snip(title: snipDictionary["title"]!, url: snipDictionary["url"]!)
                    snip.id = key
                    self.snips.append(snip)
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableView.reloadData()
                    })
                }
            } catch {
                print("error")
            }
        }
        task.resume()
    }
    
    func addSnip(snip:Snip) {
        
        self.snips.append(snip)
        self.tableView.reloadData()
        
        let snipDictionary = ["title":snip.title, "url":snip.url]
        
        var jsonData:NSData
        
        do {
            jsonData = try NSJSONSerialization.dataWithJSONObject(snipDictionary, options: .PrettyPrinted)
        } catch _ {
            print("Danger, Will Robinson")
            return
        }
        
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: fireBaseURL)
        request.HTTPMethod = "POST"
        request.HTTPBody = jsonData
        
        let task = session.dataTaskWithRequest(request) {
            (let data, let response, let error) in
            
            guard let myData:NSData = data
                else { return }
            let decodedJson:[String:AnyObject]
            
            do {
                decodedJson = try NSJSONSerialization.JSONObjectWithData(myData, options: []) as! [String : AnyObject]
                print(decodedJson)
                snip.id = decodedJson["name"]! as! String
            } catch {
                print("Danger, Will Robinson")
            }
        }
        task.resume()
    }
    
    func deleteSnip(snip:Snip) {
        
        let fireBaseURL = NSURL(string: "https://project-4045948879616680024.firebaseio.com/snippy/\(snip.id).json")!
        
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: fireBaseURL)
        request.HTTPMethod = "DELETE"
        
        let task = session.dataTaskWithRequest(request) {
            (let data, let response, let error) in
        }
        task.resume()
    }
    
    @IBAction func refresh(sender: AnyObject) {
        getCloudData()
    }
}
