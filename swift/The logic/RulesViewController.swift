//
//  RulesViewController.swift
//  The logic
//
//  Created by Ivan Babkin on 13.06.2018.
//  Copyright © 2018 Ivan Babkin. All rights reserved.
//

import UIKit

class RulesViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Rules"
        
        var contentHeight: CGFloat = 0.0
        
        scrollView.subviews.forEach() { subview in
            contentHeight = max(contentHeight, subview.frame.maxY)
        }
        
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: contentHeight)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}
