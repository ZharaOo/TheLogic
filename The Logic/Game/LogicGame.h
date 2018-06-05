//
//  LogicGame.h
//  The Logic
//
//  Created by babi4_97 on 05.11.2017.
//  Copyright © 2017 Ivan Babkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Time.h"

@protocol LogicGameDelegate <NSObject>
- (void)endGame;
@end

@interface LogicGame : NSObject

typedef enum {
    IncorrectColor,
    CorrectColor,
    CorrectColorAndPlace
} AnswerTypes;

@property (nonatomic, weak) id <LogicGameDelegate> delegate;
@property (nonatomic, assign) NSInteger moves;
@property (nonatomic, strong) Time *time;

- (NSArray *)checkAnswerOfPlayerSequence:(NSArray *)sequenceImgs;

@end
