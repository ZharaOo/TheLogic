//
//  RowView.swift
//  The logic
//
//  Created by Ivan Babkin on 12.06.2018.
//  Copyright © 2018 Ivan Babkin. All rights reserved.
//

import UIKit

protocol RowViewDelegate: class {
    func addRowToScrollView()
}

class RowView: UIView {
    @IBOutlet weak var chipImageView1: ChipImageView!
    @IBOutlet weak var chipImageView2: ChipImageView!
    @IBOutlet weak var chipImageView3: ChipImageView!
    @IBOutlet weak var chipImageView4: ChipImageView!
    
    
    @IBOutlet weak var answerImageView1: ChipImageView!
    @IBOutlet weak var answerImageView2: ChipImageView!
    @IBOutlet weak var answerImageView3: ChipImageView!
    @IBOutlet weak var answerImageView4: ChipImageView!
    
    private var chipImageViews: [ChipImageView] = []
    private var answerImageViews: [ChipImageView] = []
    
    var answer: Array<AnswerType>?
    
    weak var delegate: RowViewDelegate!
    
    
    //MARK: - Initializatioin
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    class func instanceFromNib(frame: CGRect) -> RowView {
        let rv = UINib(nibName: "RowView", bundle: nil).instantiate(withOwner: nil, options:nil)[0] as! RowView
        rv.frame = frame
        rv.alpha = 0.0
        
        return rv
    }
    
    
    //MARK: - Preparations
    
    
    func setup() {
        chipImageViews = [chipImageView1, chipImageView2, chipImageView3, chipImageView4]
        answerImageViews = [answerImageView1, answerImageView2, answerImageView3, answerImageView4]
        
        chipImageViews.forEach() {civ in
            civ.image = UIImage.init(named: "emptyChip40")
            civ.color = .None
        }
        
        answerImageViews.forEach() {aiv in
            aiv.image = UIImage.init(named: "emptyChip20")
            aiv.color = .None
        }
        
        show()
    }
    
    func show() {
        self.alpha = 0.0
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1.0
        }
    }
    
    
    //MARK: - placing chips
    
    
    func placeChip(withImage image: UIImage, color: ChipColor) {
        for civ in chipImageViews {
            if !civ.chipPlaced {
                UIView.transition(with: self,
                                  duration: 0.2,
                                  options: UIViewAnimationOptions.transitionCrossDissolve,
                                  animations: {
                                    civ.image = image
                                    civ.chipPlaced = true
                                    civ.color = color
                },
                                  completion: nil)
                
                break
            }
        }
    }
    
    func placeAnswerChip(answer: [AnswerType]) {
        UIView.transition(with: self,
                          duration: 0.2,
                          options: UIViewAnimationOptions.transitionCrossDissolve,
                          animations: {
                            var i = 0
                            self.answer = answer
                            
                            for an in answer {
                                if an == .CorrectColorAndPlace {
                                    self.answerImageViews[i].image = UIImage.init(named: "blackAnswer")
                                }
                                else if an == .CorrectColor {
                                    self.answerImageViews[i].image = UIImage.init(named: "whiteAnswer")
                                }
                                
                                i += 1
                            }
        },
                          completion: nil)
    }
    
    
    //MARK: - user methods
    
    
    func isFull() -> Bool {
        for civ in chipImageViews {
            if !civ.chipPlaced {
                return false
            }
        }
        return true
    }
    
    func getPlayerSequence() -> [ChipImageView]? {
        if isFull() {
            return chipImageViews
        }
        
        return nil
    }
}
