//
//  ChipImageView.swift
//  The logic
//
//  Created by Ivan Babkin on 12.06.2018.
//  Copyright © 2018 Ivan Babkin. All rights reserved.
//

import UIKit

enum ChipColor {
    case None
    case Yellow
    case Blue
    case Green
    case Black
    case White
    case Red
    
    static func getRandomColor() -> ChipColor {
        let c = arc4random() % 6
        
        switch c {
        case 0:
            return .Yellow
        case 1:
            return .Blue
        case 2:
            return .Green
        case 3:
            return .Black
        case 4:
            return .White
        case 5:
            return .Red
        default:
            return .None
        }
    }
}

class ChipImageView: UIImageView {
    var chipPlaced = false
    var color: ChipColor = .None
}

class ChipButton: UIButton {
    var color: ChipColor = .None
}
