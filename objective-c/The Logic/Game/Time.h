//
//  Time.h
//  The Logic
//
//  Created by babi4_97 on 05.11.2017.
//  Copyright © 2017 Ivan Babkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Time : NSObject

@property (nonatomic, assign) NSUInteger seconds;
@property (nonatomic, assign) NSUInteger minutes;

- (id)initWithCoder: (NSCoder *)decoder;
- (void)encodeWithCoder:(NSCoder *)encoder;

- (void)increaseBySecond;
- (BOOL)biggerThan:(Time *)time;

@end

