//
//  FinishViewController.swift
//  The logic
//
//  Created by Ivan Babkin on 12.06.2018.
//  Copyright © 2018 Ivan Babkin. All rights reserved.
//

import UIKit
import GoogleMobileAds
import GameKit

protocol FinishViewControllerDelegate: class {
    func startGame()
}

class FinishViewController: UIViewController, GADInterstitialDelegate, GKGameCenterControllerDelegate {
    
    @IBOutlet weak var chipImageView1: ChipImageView!
    @IBOutlet weak var chipImageView2: ChipImageView!
    @IBOutlet weak var chipImageView3: ChipImageView!
    @IBOutlet weak var chipImageView4: ChipImageView!
    
    @IBOutlet weak var movesLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var hintView: UIView!
    @IBOutlet weak var hintSwitch: UISwitch!
    
    weak var delegate: FinishViewControllerDelegate! = nil
    var rightSequense: [ChipImageView] = []
    var time = Time()
    var moves = 0
    var rateShown = false
    
    var interstitial: GADInterstitial?
    
    
    //MARK: - lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showRightSequence()
        showScore()
        
        if UserDefaults.standard.string(forKey: Constants.kRules) != nil {
            showAd()
        }
        
        reportTimeToGameCenter(time: time)
        checkForAchivements(moves: moves, time: time)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let ud = UserDefaults.standard
        
        if ud.string(forKey: Constants.kRules) == nil {
            ud.set("Passed", forKey: Constants.kRules)
            
            showAlert(title: NSLocalizedString("Подсказки", comment: ""), message: NSLocalizedString("Хотите ли вы оставить подсказки в игре?", comment: "")) { didCancel in
                if didCancel {
                    ud.set(false, forKey: Constants.kHint)
                    self.hintSwitch.isOn = false
                }
                else {
                    ud.set(true, forKey: Constants.kHint)
                    self.hintSwitch.isOn = true
                }
            }
        }
        else {
            if #available(iOS 10.3, *) {
                if !rateShown {
                    SKStoreReviewController.requestReview()
                    rateShown = true
                }
            }
            self.hintSwitch.isOn = ud.bool(forKey: Constants.kHint)
        }
    }
    
    
    //MARK: - IBActions
    
    
    @IBAction func playAgain(_ sender: Any) {
        delegate!.startGame()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func hintSwitched(_ sender: Any) {
        let ud = UserDefaults.standard
        ud.set(hintSwitch.isOn, forKey: Constants.kHint)
    }
    
    @IBAction func showLeaderboard(_ sender: UIButton) {
        let gcVC: GKGameCenterViewController = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = GKGameCenterViewControllerState.default
        self.present(gcVC, animated: true, completion: nil)
    }
    
    
    //MARK: - GADInterstitialDelegate
    
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        interstitial?.present(fromRootViewController: self)
    }
    
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        interstitial = nil
    }
    
    
    //MARK: - GKGameCenterControllerDelegate
    
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - Ad creation
    
    func showAd() {
        let gamesPlayed = UserDefaults.standard.integer(forKey: "GamesPlayed")
        if gamesPlayed % 3 == 0 {
            self.interstitial = self.createAndLoadInterstitial(id: Google.adID)
        }
        UserDefaults.standard.set(gamesPlayed + 1, forKey: "GamesPlayed")
    }
    
    func createAndLoadInterstitial(id: String) -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: id)
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    
    //MARK: - Show game information
    
    
    func showAlert(title: String, message: String, responce: ((_ didCancel: Bool) -> ())?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        if let r = responce {
            let alertActionCancel = UIAlertAction(title: "No", style: UIAlertActionStyle.cancel) {action in
                alertController.dismiss(animated: true, completion: nil)
                r(true)
            }
            alertController.addAction(alertActionCancel)
        }
        
        let alertActionOk = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) {action in
            alertController.dismiss(animated: true, completion: nil)
            if let r = responce {
                r(false)
            }
        }
        alertController.addAction(alertActionOk)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showRightSequence() {
        chipImageView1.image = rightSequense[0].image
        chipImageView2.image = rightSequense[1].image
        chipImageView3.image = rightSequense[2].image
        chipImageView4.image = rightSequense[3].image
    }
    
    func showScore() {
        let ud = UserDefaults.standard
        let bestMoves = ud.integer(forKey: Constants.kBestMoves)
        movesLabel.text = String(format: NSLocalizedString("Ходы: %ld\nЛучшие: %ld", comment: ""), moves, bestMoves)
        
        if let dataBestTime = ud.data(forKey: Constants.kBestTime) {
            let bestTime = NSKeyedUnarchiver.unarchiveObject(with: dataBestTime) as! Time
            timeLabel.text = String(format: NSLocalizedString("Время: %@\nЛучшее: %@", comment: ""), time.description(), bestTime.description())
        }
    }
    
    
    //MARK: - Game Center methods
    
    
    func reportTimeToGameCenter(time: Time) {
        let leaderboardID = "LogicBestTime"
        let sScore = GKScore(leaderboardIdentifier: leaderboardID)
        sScore.value = Int64(time.totalSeconds)
        
        GKScore.report([sScore], withCompletionHandler: { error in
            if error != nil {
                print(error!.localizedDescription)
            }
            else {
                print("Score submitted")
            }
        })
    }
    
    func checkForAchivements(moves: Int, time: Time) {
        
        var achievements = [GKAchievement]()
        
        achievements.append(configureAchievement(id: "begin001"))
        
        switch moves {
        case 1:
            achievements.append(configureAchievement(id: "oneturn001"))
        case 2:
            achievements.append(configureAchievement(id: "twoturn002"))
        case 3:
            achievements.append(configureAchievement(id: "threeturns003"))
        case 4:
            achievements.append(configureAchievement(id: "fourturn004"))
        case 5:
            achievements.append(configureAchievement(id: "fiveturn005"))
        case 6:
            achievements.append(configureAchievement(id: "sixturn006"))
        case 7:
            achievements.append(configureAchievement(id: "seventurn007"))
        default:
            return
        }
        
        if time.minutes == 0 {
            if time.seconds <= 10 {
                achievements.append(configureAchievement(id: "time10sec01"))
            }
            else if time.seconds <= 30 {
                achievements.append(configureAchievement(id: "time1020sec01"))
            }
            else if time.seconds <= 59 {
                achievements.append(configureAchievement(id: "time301min01"))
            }
        }
        else if time.minutes <= 2 {
            achievements.append(configureAchievement(id: "time12min01"))
        }
        else if time.minutes <= 3 {
            achievements.append(configureAchievement(id: "time23min03"))
        }
        else if time.minutes <= 5 {
            achievements.append(configureAchievement(id: "time35min01"))
        }
        
        GKAchievement.report(achievements) { error in
            if error != nil {
                print(error!.localizedDescription)
            }
            else {
                print("Score submitted")
            }
        }
    }
    
    func configureAchievement(id: String) -> GKAchievement {
        let achievement = GKAchievement(identifier: id)
        achievement.percentComplete = 100.0
        achievement.showsCompletionBanner = true
        
        return achievement
    }
    
}
