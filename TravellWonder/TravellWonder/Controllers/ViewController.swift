//
//  ViewController.swift
//  TravellWonder
//
//  Created by Jess Arschoot on 21/12/2017.
//  Copyright © 2017 JessArschoot. All rights reserved.
//

import UIKit

class ViewController: UITabBarController {
    @IBOutlet weak var tapbar: UITabBar!
    
    override func viewDidLoad() {
        //super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let username = UserDefaults.standard.string(forKey: "username")!
        self.tapbar.unselectedItemTintColor = .black
        tapbar.items![1].title = username
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

