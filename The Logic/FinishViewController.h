//
//  FinishViewController.h
//  The Logic
//
//  Created by babi4_97 on 05.11.2017.
//  Copyright © 2017 Ivan Babkin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Time;
@protocol FinishViewControllerDelegate <NSObject>
- (void)startNewGame;
@end

@interface FinishViewController : UIViewController
@property (nonatomic, weak) id <FinishViewControllerDelegate> delegate;
@property (nonatomic, copy) NSArray <UIImageView *> *rightSequense;
@property (nonatomic, assign) NSUInteger moves;
@property (nonatomic, weak) Time *time;
@end
