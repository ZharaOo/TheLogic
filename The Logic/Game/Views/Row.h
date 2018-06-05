//
//  Row.h
//  The Logic
//
//  Created by babi4_97 on 05.11.2017.
//  Copyright © 2017 Ivan Babkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameConst.h"

@protocol RowDelegate <NSObject>
- (void)addRowToScrollView;
@end

@interface Row : UIView

@property (nonatomic, weak) id <RowDelegate> delegate;
@property (nonatomic, copy) NSArray <NSNumber *> *answer;

- (void)placeChip:(UIImage *)img withColor:(ChipColor)color;
- (void)placeAnswerChip:(NSArray <NSNumber *> *)nums;
- (bool)isFull;
- (NSArray *)getPlayerSequence;
@end
