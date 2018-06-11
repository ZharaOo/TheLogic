//
//  GameConst.h
//  The Logic
//
//  Created by Ivan Babkin on 03.06.2018.
//  Copyright © 2018 Ivan Babkin. All rights reserved.
//
#import <Foundation/Foundation.h>
#ifndef GameConst_h
#define GameConst_h

typedef NS_ENUM(NSUInteger, ChipColor) {
    Yellow,
    Green,
    Blue,
    Black,
    Red,
    White
};

static NSString *const kGameConstRules = @"Rules";
static NSString *const kGameConstHint = @"Hint";
static NSString *const kGameConstBestTime = @"BestTime";
static NSString *const kGameConstBestMoves = @"BestMoves";

static NSString *const kGameConstGameToFinish = @"gameToFinishSegue";
static NSString *const kGameConstGameToPause = @"gameToPauseSegue";

#endif /* GameConst_h */
