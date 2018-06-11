//
//  GameViewController.m
//  The Logic
//
//  Created by babi4_97 on 05.11.2017.
//  Copyright © 2017 Ivan Babkin. All rights reserved.
//

#import "GameViewController.h"
#import "FinishViewController.h"
#import "PauseViewController.h"

#import "GameConst.h"

#import "Row.h"
#import "LogicGame.h"
#import "ChipButton.h"

@interface GameViewController () <FinishViewControllerDelegate, PauseViewControllerDelegate, LogicGameDelegate, RowDelegate> {
    
    __weak IBOutlet ChipButton *_yellowButton;
    __weak IBOutlet ChipButton *_greenButton;
    __weak IBOutlet ChipButton *_blueButton;
    __weak IBOutlet ChipButton *_blackButton;
    __weak IBOutlet ChipButton *_redButton;
    __weak IBOutlet ChipButton *_whiteButton;
    __weak IBOutlet UILabel *movesLabel;
    
    NSMutableArray<Row *> *rows;
    NSArray *playerSequence;
}

@property (nonatomic, strong) LogicGame *game;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation GameViewController

- (void)initButtons {
    _yellowButton.color = Yellow;
    _greenButton.color = Green;
    _blueButton.color = Blue;
    _blackButton.color = Black;
    _redButton.color = Red;
    _whiteButton.color = White;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initButtons];
    [self startNewGame];
}

- (void)startNewGame {
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.game = [[LogicGame alloc] init];
    self.game.delegate = self;
    
    rows = [[NSMutableArray alloc] init];
    [self addRowToScrollView];
}

- (void)addRowToScrollView {
    movesLabel.text = [NSString stringWithFormat:@"Moves: %ld", (long)self.game.moves];
    CGFloat width = CGRectGetWidth(self.scrollView.frame); 
    CGFloat height = width * 0.2;
    
    Row *row = [[Row alloc] initWithFrame:CGRectMake(0, rows.count * height, width, height)];
    row.delegate = self;
    [rows addObject:row];
    
    [self.scrollView addSubview:row];
    self.scrollView.contentSize = CGSizeMake(0, rows.count * height + height);
    
    if (![[NSUserDefaults standardUserDefaults] stringForKey:kGameConstRules]) {
        [self addRulesToScrollViewWithRowHeight:height];
    }
    else if ([[NSUserDefaults standardUserDefaults] boolForKey:kGameConstHint] && rows.count > 1) {
        [self addHintWithHeight:height];
    }
    
    CGPoint bottomOffset = CGPointMake(0, MAX(0.0f, self.scrollView.contentSize.height - self.scrollView.bounds.size.height));
    [self.scrollView setContentOffset:bottomOffset animated:YES];
}

- (void)addHintWithHeight:(CGFloat)height {
    [self removeRulesFromScrollView];
    
    NSString *rulesText = [self generateAnswerStringWithStartString:@"В предыдущем ответе" rowIndex:rows.count - 2];
    CGFloat rulesHeight = MAX(CGRectGetHeight(self.scrollView.frame) - rows.count * height, 115.0f);
    UIView *rulesView = [self createRulesViewWithText:rulesText frame:CGRectMake(0, rows.count * height, CGRectGetWidth(self.scrollView.frame), rulesHeight)];
    [self.scrollView addSubview:rulesView];
    
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(rulesView.frame));
}

- (void)addRulesToScrollViewWithRowHeight:(CGFloat)height {
        [self removeRulesFromScrollView];
        
        NSString *rulesText = nil;
        
        switch (rows.count) {
            case 1: {
                rulesText = @"iPhone загадал последовательность из четырех фишек. Нажимайте на кнопки внизу, чтобы выставить последовательность.";
                break;
            }
            case 2: {
                rulesText = @"Фишки справа вверху показывают правильность ответа. Черная фишка означает, что угадан какой-то цвет и он стоит на своем месте. Белая фишка означает, что был угадан цвет, но он стоит не на своем месте.";
                break;
            }
            case 3: {
                rulesText = [NSString stringWithFormat:@"%@\n%@", [self generateAnswerStringWithStartString:@"Например, в первом ответе " rowIndex:0], [self generateAnswerStringWithStartString:@"В предыдущем ответе" rowIndex:1]];
                break;
            }
            default: {
                rulesText = [self generateAnswerStringWithStartString:@"В предыдущем ответе" rowIndex:rows.count - 2];
                break;
            }
        }
        
        CGFloat rulesHeight = MAX(CGRectGetHeight(self.scrollView.frame) - rows.count * height, 115.0f);
        UIView *rulesView = [self createRulesViewWithText:rulesText frame:CGRectMake(0, rows.count * height, CGRectGetWidth(self.scrollView.frame), rulesHeight)];
        [self.scrollView addSubview:rulesView];
        
        self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(rulesView.frame));
}

- (NSString *)generateAnswerStringWithStartString:(NSString *)start rowIndex:(NSUInteger)i {
    if (rows[i].answer.count) {
        NSUInteger numberOfWhite = 0;
        NSUInteger numberOfBlack = 0;
        for (NSNumber *num in rows[i].answer) {
            if (num.intValue == CorrectColor) {
                numberOfWhite++;
            }
            else {
                numberOfBlack++;
            }
        }
        NSString *answerForBlack = (numberOfBlack ? [NSString stringWithFormat:@"%ld из них стоят на своем месте. ", (long)numberOfBlack] : @"");
        NSString *answerForWhite = nil;
        
        if ([answerForBlack isEqualToString:@""]) {
            answerForWhite = @"При этом все цвета стоят не на своем месте.";
        }
        else {
            answerForWhite = (numberOfWhite ? [NSString stringWithFormat:@"Для %ld цветов место неверно. ", (long)numberOfWhite] : @"");
        }
        
        return [NSString stringWithFormat:@"%@ вы правильно угадали %ld цветов. %@%@", start, (long)rows[i].answer.count, answerForBlack, answerForWhite];
    }
    else {
        return [NSString stringWithFormat:@"%@ вы не угадали ни одного цвета. ", start];
    }
}

- (UIView *)createRulesViewWithText:(NSString *)text frame:(CGRect)frame {
    UIView *rulesView = [[UIView alloc] initWithFrame:frame];
    rulesView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(rulesView.frame), 100.0f)];
    textView.backgroundColor = [UIColor clearColor];
    textView.editable = NO;
    textView.scrollEnabled = NO;
    textView.selectable = NO;
    textView.textAlignment = NSTextAlignmentCenter;
    textView.textColor = [UIColor whiteColor];
    [textView setFont:[UIFont systemFontOfSize:18]];
    textView.text = text;
    
    CGFloat fixedWidth = CGRectGetWidth(textView.frame);
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;
    textView.center = CGPointMake(CGRectGetWidth(rulesView.frame) * 0.5, CGRectGetHeight(rulesView.frame) * 0.5);
    NSLog(@"%@", NSStringFromCGSize(textView.frame.size));
    [rulesView addSubview:textView];
    
    return rulesView;
}

- (void)removeRulesFromScrollView {
    for (UIView *rv in self.scrollView.subviews) {
        for (UIView *textView in rv.subviews) {
            if ([textView isKindOfClass:[UITextView class]]) {
                [rv removeFromSuperview];
                break;
            }
        }
    }
}


- (IBAction)chipClick:(ChipButton *)sender {
    [rows.lastObject placeChip:sender.currentBackgroundImage withColor:sender.color];
    
    if ([rows.lastObject isFull]) {
        playerSequence = [rows.lastObject getPlayerSequence];
        [rows.lastObject placeAnswerChip:[self.game checkAnswerOfPlayerSequence:playerSequence]];
        [self addRowToScrollView];
    }
    
}

- (void)endGame {
    [self performSegueWithIdentifier:kGameConstGameToFinish sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kGameConstGameToFinish]) {
        FinishViewController *dvc = (FinishViewController *)segue.destinationViewController;
        dvc.delegate = self;
        dvc.rightSequense = playerSequence;
        dvc.moves = self.game.moves;
        dvc.time = self.game.time;
    }
    else if ([segue.identifier isEqualToString:kGameConstGameToPause]) {
        PauseViewController *dvc = (PauseViewController *)segue.destinationViewController;
        dvc.delegate = self;
    }
}


@end
