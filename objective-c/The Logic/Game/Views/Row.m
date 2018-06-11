//
//  Row.m
//  The Logic
//
//  Created by babi4_97 on 05.11.2017.
//  Copyright © 2017 Ivan Babkin. All rights reserved.
//

#import "Row.h"
#import "LogicGame.h"
#import "ChipImageView.h"

@interface Row() {
    NSArray <UIImageView *> *chipImageViews;
    NSArray <UIImageView *> *answerImageViews;
}

@property (weak, nonatomic) IBOutlet ChipImageView *chipImageView1;
@property (weak, nonatomic) IBOutlet ChipImageView *chipImageView2;
@property (weak, nonatomic) IBOutlet ChipImageView *chipImageView3;
@property (weak, nonatomic) IBOutlet ChipImageView *chipImageView4;

@property (weak, nonatomic) IBOutlet ChipImageView *answerImageView1;
@property (weak, nonatomic) IBOutlet ChipImageView *answerImageView2;
@property (weak, nonatomic) IBOutlet ChipImageView *answerImageView3;
@property (weak, nonatomic) IBOutlet ChipImageView *answerImageView4;

@end

@implementation Row

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"Row" owner:self options:nil] lastObject];
        self.frame = frame;
        chipImageViews = [[NSArray alloc] initWithObjects:self.chipImageView1, self.chipImageView2, self.chipImageView3, self.chipImageView4, nil];
        answerImageViews = [[NSArray alloc] initWithObjects:self.answerImageView1, self.answerImageView2, self.answerImageView3, self.answerImageView4, nil];
        
        for (UIImageView *civ in chipImageViews) {
            civ.image = [UIImage imageNamed:@"emptyChip40"];
        }
        
        for (UIImageView *aiv in answerImageViews) {
            aiv.image = [UIImage imageNamed:@"emptyChip20"];
        }
        self.alpha = 0;
        [self show];
    }
    return self;
}

- (void)show {
    [UIView animateWithDuration:0.2f animations:^(void) {
         self.alpha = 1.0;
     }];
}

- (void)placeChip:(UIImage *)img withColor:(ChipColor)color {
    for (ChipImageView *civ in chipImageViews) {
        if (!civ.chipPlaced) {
            [UIView transitionWithView:self
                              duration:0.2f
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
                                civ.image = img;
                                civ.chipPlaced = YES;
                                civ.color = color;
                            }
                            completion:nil];
            break;
        }
    }
}

- (void)placeAnswerChip:(NSArray <NSNumber *> *)nums {
    [UIView transitionWithView:self
                      duration:0.2f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        int i = 0;
                        self.answer = nums;
                        
                        for (NSNumber *num in nums) {
                            AnswerTypes answer = (AnswerTypes)[num integerValue];
                            if (answer == CorrectColorAndPlace) {
                                self->answerImageViews[i].image = [UIImage imageNamed:@"blackAnswer"];
                            }
                            else if (answer == CorrectColor) {
                                self->answerImageViews[i].image = [UIImage imageNamed:@"whiteAnswer"];
                            }
                            i++;
                        }
                    }
                    completion:nil];
}

- (bool)isFull {
    for (ChipImageView *civ in chipImageViews) {
        if (!civ.chipPlaced) {
            return NO;
        }
    }
    return YES;
}

- (NSArray *)getPlayerSequence {
    if ([self isFull]) {
        return chipImageViews;
    }
    return nil;
}

@end
