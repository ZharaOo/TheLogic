//
//  FinishViewController.m
//  The Logic
//
//  Created by babi4_97 on 05.11.2017.
//  Copyright © 2017 Ivan Babkin. All rights reserved.
//

#import "FinishViewController.h"
#import "Time.h"
#import "GameConst.h"

#import <StoreKit/StoreKit.h>

@import GoogleMobileAds;

@interface FinishViewController () <GADInterstitialDelegate> {
    
    __weak IBOutlet UIView *_hintView;
    __weak IBOutlet UISwitch *_hintSwitch;
}
@property (strong, nonatomic) GADInterstitial *interstitial;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@property (weak, nonatomic) IBOutlet UIImageView *imageView4;
@property (weak, nonatomic) IBOutlet UILabel *movesLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation FinishViewController

- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message withResponse:(void (^)(BOOL didCancel))response {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if (response) {
        UIAlertAction *cancelar = [UIAlertAction actionWithTitle:@"Нет" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
            response(YES);
        }];
        [alertController addAction:cancelar];
    }
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Да" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
        if (response) {
            response(NO);
        }
    }];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showRightSequense];
    [self showScore];
    
    if ([[NSUserDefaults standardUserDefaults] stringForKey:kGameConstRules]) {
        self.interstitial = [self createAndLoadInterstitialWithId:@"ca-app-pub-8013517248040410/5289313347"];
        [self showHintView];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (![[NSUserDefaults standardUserDefaults] stringForKey:kGameConstRules]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"Passed" forKey:kGameConstRules];
        
        [self showAlertWithTitle:@"Подсказки" message:@"Хотите ли вы оставить подсказки в игре?" withResponse:^(BOOL didCancel) {
            if(!didCancel) {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kGameConstHint];
                [self showHintView];
            } else {
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kGameConstHint];
            }
        }];
    }
    else {
        if (@available(iOS 10.3, *)) {
            [SKStoreReviewController requestReview];
        }
    }
}

- (void)showHintView {
    if (![[NSUserDefaults standardUserDefaults] stringForKey:kGameConstRules]) {
        _hintView.hidden = YES;
    }
    else {
        _hintSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:kGameConstHint];
    }
}

- (IBAction)hintSwitched:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:_hintSwitch.on forKey:kGameConstHint];
}

- (GADInterstitial *)createAndLoadInterstitialWithId:(NSString *)gadId {
    GADInterstitial *interstitial =
    [[GADInterstitial alloc] initWithAdUnitID:gadId];
    interstitial.delegate = self;
    GADRequest *request = [GADRequest request];
    request.testDevices = @[ @"949b17fecd9d70701e7cf6fc9bd8b1f6" ];
    [interstitial loadRequest:[GADRequest request]];
    return interstitial;
}

- (void)showRightSequense {
    self.imageView1.image = self.rightSequense[0].image;
    self.imageView2.image = self.rightSequense[1].image;
    self.imageView3.image = self.rightSequense[2].image;
    self.imageView4.image = self.rightSequense[3].image;
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
    [self.interstitial presentFromRootViewController:self];
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    self.interstitial = nil;
}

- (void)showScore {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSInteger bestScore = [ud integerForKey:kGameConstBestMoves];
    self.movesLabel.text = [NSString stringWithFormat:@"Moves: %lu\nBest: %lu", self.moves, bestScore];
    
    Time *bestTime = (Time *)[NSKeyedUnarchiver unarchiveObjectWithData:[ud objectForKey:kGameConstBestTime]];
    if (self.time.seconds < 10) {
        self.timeLabel.text = [NSString stringWithFormat:@"Time: 0%lu:0%lu\n", (unsigned long)self.time.minutes, self.time.seconds];
    }
    else {
        self.timeLabel.text = [NSString stringWithFormat:@"Time: 0%lu:%lu\n", self.time.minutes, self.time.seconds];
    }
    
    if (bestTime.seconds < 10) {
        self.timeLabel.text = [NSString stringWithFormat:@"%@Best: 0%lu:0%lu", self.timeLabel.text, bestTime.minutes, bestTime.seconds];
    }
    else {
        self.timeLabel.text = [NSString stringWithFormat:@"%@Best: 0%lu:%lu", self.timeLabel.text, bestTime.minutes, bestTime.seconds];
    }
}

- (IBAction)playAgain:(id)sender {
    [self.delegate startNewGame];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
