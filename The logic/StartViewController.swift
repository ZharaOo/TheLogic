//
//  ViewController.swift
//  The logic
//
//  Created by Ivan Babkin on 12.06.2018.
//  Copyright © 2018 Ivan Babkin. All rights reserved.
//

import UIKit
import GameKit

class StartViewController: UIViewController, GKGameCenterControllerDelegate {

    @IBOutlet weak var hintView: UIView!
    @IBOutlet weak var hintSwitch: UISwitch!
    
    private var gcEnabled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateLocalPlayer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let ud = UserDefaults.standard
        if ud.string(forKey: Constants.kRules) == nil {
            hintView.isHidden = true
        }
        else {
            hintView.isHidden = false
            hintSwitch.isOn = ud.bool(forKey: Constants.kHint)
        }
    }
    
    @IBAction func hintSwitched(_ sender: UISwitch) {
        let ud = UserDefaults.standard
        ud.set(hintSwitch.isOn, forKey: Constants.kHint)
    }
    
    @IBAction func showLeaderboard(_ sender: UIButton) {
        let gcVC: GKGameCenterViewController = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = GKGameCenterViewControllerState.default
//        gcVC.leaderboardIdentifier = "LogicBestTime"
        self.present(gcVC, animated: true, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = { ViewController, error in
            if ViewController != nil {
                self.present(ViewController!, animated: true, completion: nil)
            }
        }
    }
}

