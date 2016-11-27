//
//  ContentViewController.swift
//  DemoPageVC
//
//  Created by Duc Minh on 8/27/16.
//  Copyright © 2016 Duc Minh. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {

    var pageIndex = 0
    var imageFile = ""
    var backgroundColor: UIColor = UIColor.red
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = backgroundColor
        // Do any additional setup after loading the view.
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
