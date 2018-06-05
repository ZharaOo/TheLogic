//
//  ViewController.m
//  The Logic
//
//  Created by babi4_97 on 05.11.2017.
//  Copyright © 2017 Ivan Babkin. All rights reserved.
//

#import "StartViewController.h"
#import "GameConst.h"

@interface StartViewController () {
    
    __weak IBOutlet UIView *_hintView;
    __weak IBOutlet UISwitch *_hintSwitch;
}

@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (![[NSUserDefaults standardUserDefaults] stringForKey:kGameConstRules]) {
        _hintView.hidden = YES;
    }
    else {
        _hintSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:kGameConstHint];
    }
}

- (IBAction)hintsSwitched:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:_hintSwitch.on forKey:kGameConstHint];
}

- (IBAction)startGame:(id)sender {
}

- (IBAction)rules:(id)sender {
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
