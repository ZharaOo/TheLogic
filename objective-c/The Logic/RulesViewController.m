//
//  RulesViewController.m
//  The Logic
//
//  Created by babi4_97 on 05.11.2017.
//  Copyright © 2017 Ivan Babkin. All rights reserved.
//

#import "RulesViewController.h"

@interface RulesViewController () {
    
    __weak IBOutlet UIScrollView *_scrollView;
}
@end

@implementation RulesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Rules";
    CGFloat contentHeight = 0.0f;
    
    for (UIView *subview in _scrollView.subviews) {
        if (contentHeight < CGRectGetMaxY(subview.frame)) {
            contentHeight = CGRectGetMaxY(subview.frame);
        }
    }
    
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_scrollView.frame), contentHeight);
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillDisappear:animated];
}

@end
