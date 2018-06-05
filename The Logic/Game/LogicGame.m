//
//  LogicGame.m
//  The Logic
//
//  Created by babi4_97 on 05.11.2017.
//  Copyright © 2017 Ivan Babkin. All rights reserved.
//

#import "LogicGame.h"
#import "ChipImageView.h"
#import <UIKit/UIKit.h>
#import "GameConst.h"

@interface LogicGame() {
    NSTimer *_timer;
}
@property (nonatomic, strong) NSArray <NSNumber *> *sequence;
@end

@implementation LogicGame

- (id)init {
    self = [super init];
    if (self) {
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (int i = 0; i < 4; i++) {
            [arr addObject:[NSNumber numberWithInteger:arc4random() % 6]];
        }
        NSLog(@"Right answer: %@", arr);
        _time = [[Time alloc] init];
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
        _moves = 0;
        _sequence = [arr copy];
    }
    return self;
}

- (void)timerTick:(NSTimer *)timer {
    [self.time increaseBySecond];
}

- (NSArray *)checkAnswer:(NSMutableArray <NSNumber *> *)nums imgs:(NSArray *)sequenceImgs {
    self.moves++;
    NSMutableArray *answers = [[NSMutableArray alloc] init];
    NSMutableArray *sequence = [[NSMutableArray alloc] initWithArray:[self.sequence copy]];
    for (int i = 0; i < 4; i++) {
        if ([sequence[i] isEqual:nums[i]]) {
            [answers addObject:[NSNumber numberWithInt:CorrectColorAndPlace]];
            nums[i] = @(-1);
            sequence[i] = @(-1);
        }
    }
    
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
            if ([sequence[i] isEqual:nums[j]] && ![sequence[i] isEqual:@(-1)]) {
                [answers addObject:[NSNumber numberWithInt:CorrectColor]];
                nums[j] = @(-1);
                sequence[i] = @(-1);
            }
        }
    }
    
    if ([self endGame:answers]) {
        [_timer invalidate];
        _timer = nil;
        [self wrightBestMoves];
        [self wrightBestTime];
        [self.delegate endGame];
    }
    
    return answers;
}

- (NSArray *)checkAnswerOfPlayerSequence:(NSArray *)sequenceImgs {
    NSMutableArray *nums = [[NSMutableArray alloc] init];
    for (ChipImageView *img in sequenceImgs) {
        NSNumber *num = @(img.color);
        [nums addObject:num];
    }
    return [self checkAnswer:nums imgs:sequenceImgs];
}

- (bool)endGame:(NSArray *)nums {
    return [@[@2,@2,@2,@2] isEqual:nums];
}

- (void)wrightBestMoves {
    @autoreleasepool {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSInteger bestMoves = [ud integerForKey:kGameConstBestMoves];
        if (bestMoves == 0 || self.moves < bestMoves) {
            [ud setInteger:self.moves forKey:kGameConstBestMoves];
        }
    }
}

- (void)wrightBestTime {
    @autoreleasepool {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        Time *bestTime = (Time *)[NSKeyedUnarchiver unarchiveObjectWithData:[ud objectForKey:kGameConstBestTime]];
        
        if (bestTime) {
            if ([bestTime biggerThan:self.time]) {
                [ud setObject:[NSKeyedArchiver archivedDataWithRootObject:self.time] forKey:kGameConstBestTime];
            }
        }
        else {
            [ud setObject:[NSKeyedArchiver archivedDataWithRootObject:self.time] forKey:kGameConstBestTime];
        }
    }
}

@end
