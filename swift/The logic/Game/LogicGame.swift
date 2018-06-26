//
//  LogicGame.swift
//  The logic
//
//  Created by Ivan Babkin on 12.06.2018.
//  Copyright © 2018 Ivan Babkin. All rights reserved.
//

import UIKit

enum AnswerType {
    case IncorrectColor
    case CorrectColor
    case CorrectColorAndPlace
}

protocol LogicGameDelegate: class {
    func endGame()
}

class LogicGame: NSObject {
    private var timer: Timer!
    private let sequence: Array<ChipColor>
    
    var time: Time
    var moves = 0
    
    weak var delegate: LogicGameDelegate!
    
    override init() {
        var hSequence = Array<ChipColor>()
        
        for _ in 0...3 {
            hSequence.append(ChipColor.getRandomColor())
        }
        
        print(hSequence)
        
        sequence = hSequence
        time = Time()
        
        super.init()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
    }
    
    @objc func timerTick() {
        time.increaseBySecond()
    }
    
    func checkAnswer(nums: Array<ChipColor>, sequenceImgs: Array<ChipImageView>) -> Array<AnswerType> {
        self.moves += 1
        var sequence: Array<ChipColor> =  self.sequence
        var answers = Array<AnswerType>()
        var nums = nums
        
        for i in 0...3 {
            if sequence[i] == nums[i] {
                answers.append(.CorrectColorAndPlace)
                nums[i] = .None
                sequence[i] = .None
            }
        }
        
        for i in 0...3 {
            for j in 0...3 {
                if sequence[i] == nums[j] && sequence[i] != .None {
                    answers.append(.CorrectColor)
                    nums[j] = .None
                    sequence[i] = .None
                }
            }
        }
        
        if endGame(answers: answers) {
            timer.invalidate()
            writeBestMoves()
            writeBestTime()
            delegate.endGame()
        }
        
        return answers
    }
    
    func checkAnswerOfPlayerSequence(_ sequenceImg: Array<ChipImageView>) -> Array<AnswerType> {
        var colors = Array<ChipColor>()
        for img in sequenceImg {
            colors.append(img.color)
        }
        
        return checkAnswer(nums: colors, sequenceImgs: sequenceImg)
    }
    
    private func endGame(answers: Array<AnswerType>) -> Bool {
        let a = AnswerType.CorrectColorAndPlace
        return [a, a, a, a] == answers
    }
    
    private func writeBestMoves() {
        let ud = UserDefaults.standard
        let bestMoves = ud.integer(forKey: Constants.kBestMoves)
        
        if bestMoves == 0 || self.moves < bestMoves {
            ud.set(self.moves, forKey: Constants.kBestMoves)
        }
    }
    
    private func writeBestTime() {
        let ud = UserDefaults.standard
        if let dataBestTime = ud.data(forKey: Constants.kBestTime) {
            let bestTime = NSKeyedUnarchiver.unarchiveObject(with: dataBestTime) as! Time
            if bestTime.biggerThan(time: time) {
                ud.set(NSKeyedArchiver.archivedData(withRootObject: time), forKey: Constants.kBestTime)
            }
        }
        else {
            ud.set(NSKeyedArchiver.archivedData(withRootObject: time), forKey: Constants.kBestTime)
        }
    }
}
