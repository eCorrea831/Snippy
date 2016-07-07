//
//  AddSnipViewController.swift
//  Snippy
//
//  Created by Aditya Narayan on 6/16/16.
//  Copyright © 2016 TurnToTech. All rights reserved.
//

import UIKit

class AddSnipViewController: UIViewController {


    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func addSnip(sender: AnyObject) {
        let snip = Snip(title: titleTextField.text!, url: websiteTextField.text!)
        
        let rootViewController = self.navigationController?.viewControllers[0] as! SnipsTableViewController
        rootViewController.addSnip(snip)
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
}

