//
//  Time.m
//  The Logic
//
//  Created by babi4_97 on 05.11.2017.
//  Copyright © 2017 Ivan Babkin. All rights reserved.
//

#import "Time.h"

@implementation Time

- (id)init {
    self = [super init];
    if (self) {
        _minutes = 0;
        _seconds = 0;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        self.seconds = [decoder decodeDoubleForKey:@"Seconds"];
        self.minutes = [decoder decodeDoubleForKey:@"Minutes"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeDouble:self.seconds forKey:@"Seconds"];
    [encoder encodeDouble:self.minutes forKey:@"Minutes"];
}

- (BOOL)biggerThan:(Time *)time {
    if (self.minutes > time.minutes) {
        return YES;
    }
    else if (self.minutes == time.minutes && self.seconds > time.seconds) {
        return YES;
    }
    return NO;
}

- (void)increaseBySecond {
    self.seconds += 1;
    if (self.seconds == 60) {
        self.minutes += 1;
        self.seconds = 0;
    }
}

@end
