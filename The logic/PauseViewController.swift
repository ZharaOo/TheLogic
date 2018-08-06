//
//  PauseViewController.swift
//  The logic
//
//  Created by Ivan Babkin on 13.06.2018.
//  Copyright © 2018 Ivan Babkin. All rights reserved.
//

import UIKit

protocol PauseViewControllerDelegate: class {
    func startGame()
}

class PauseViewController: UIViewController {
    
    weak var delegate: PauseViewControllerDelegate!

    @IBAction func resume(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func playAgain(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        delegate.startGame()
    }
    
    @IBAction func mainMenu(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
}
