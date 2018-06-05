//
//  PauseViewController.h
//  The Logic
//
//  Created by babi4_97 on 05.11.2017.
//  Copyright © 2017 Ivan Babkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PauseViewControllerDelegate <NSObject>
- (void)startNewGame;
@end

@interface PauseViewController : UIViewController

@property (nonatomic, weak) id <PauseViewControllerDelegate> delegate;

@end
