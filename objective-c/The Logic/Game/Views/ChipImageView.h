//
//  ChipImageView.h
//  The Logic
//
//  Created by Ivan Babkin on 02.06.2018.
//  Copyright © 2018 Ivan Babkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameConst.h"

@interface ChipImageView : UIImageView

@property (nonatomic) BOOL chipPlaced;
@property (nonatomic) ChipColor color;

@end
