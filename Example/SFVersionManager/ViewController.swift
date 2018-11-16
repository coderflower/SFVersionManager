//
//  ViewController.swift
//  SFVersionManager
//
//  Created by chriscaixx on 11/16/2018.
//  Copyright (c) 2018 chriscaixx. All rights reserved.
//

import UIKit
import SFVersionManager
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        SFVersionManager.shared.checkVersion()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

