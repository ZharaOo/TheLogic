//
//  Time.swift
//  The logic
//
//  Created by Ivan Babkin on 12.06.2018.
//  Copyright © 2018 Ivan Babkin. All rights reserved.
//

import UIKit

class Time: NSObject, NSCoding {
    var seconds = 0
    var minutes = 0
    
    var totalSeconds: Int {
        return minutes * 60 + seconds
    }
    
    override init() {super.init()}
    
    required init?(coder aDecoder: NSCoder) {
        self.seconds = aDecoder.decodeInteger(forKey:"seconds")
        self.minutes = aDecoder.decodeInteger(forKey:"minutes")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.seconds, forKey:"seconds")
        aCoder.encode(self.minutes, forKey:"minutes")
    }
    
    func biggerThan(time: Time) -> Bool {
        if minutes > time.minutes {
            return true;
        }
        else if minutes == time.minutes && seconds > time.seconds {
            return true;
        }
        return false;
    }
    
    func increaseBySecond() {
        seconds += 1;
        if seconds == 60 {
            minutes += 1;
            seconds = 0;
        }
    }
    
    func description() -> String {
        if seconds < 10 {
            return String(format:"0%d:0%d", minutes, seconds);
        }
        else {
            return String(format:"0%d:%d", minutes, seconds);
        }
    }
}
