//
//  ViewController.swift
//  The logic
//
//  Created by Ivan Babkin on 12.06.2018.
//  Copyright © 2018 Ivan Babkin. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var hintView: UIView!
    @IBOutlet weak var hintSwitch: UISwitch!
    
    override func viewWillAppear(_ animated: Bool) {
        let ud = UserDefaults.standard
        if ud.string(forKey: Constants.kRules) != nil {
            hintView.isHidden = true
        }
        else {
            hintSwitch.isOn = ud.bool(forKey: Constants.kHint)
        }
    }
    
    @IBAction func hintSwitched(_ sender: UISwitch) {
        let ud = UserDefaults.standard
        ud.set(hintSwitch.isOn, forKey: Constants.kHint)
    }
    
}

