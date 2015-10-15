//
//  DismissalViewController.h
//  CricScorer
//
//  Created by Kunal Wagle on 19/07/2015.
//  Copyright (c) 2015 KMW13. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"
#import "StandardSegmentedControl.h"

@interface DismissalViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *batsmanName;
@property (weak, nonatomic) IBOutlet UILabel *dismissal;
@property (weak, nonatomic) IBOutlet UILabel *score;
- (IBAction)submit:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *howOut;
@property (weak, nonatomic) IBOutlet UILabel *fielderName;
@property (weak, nonatomic) IBOutlet UILabel *fielderActualName;
@property (weak, nonatomic) IBOutlet UIButton *changeFielder;
@property StandardSegmentedControl *batsmenNames;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)change:(id)sender;
@property Game *game;
- (IBAction)dismissalChanged:(id)sender;
- (IBAction)batsmanChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *balls;
@property (weak, nonatomic) IBOutlet UILabel *sr;
@property (weak, nonatomic) IBOutlet UILabel *fow;
@property (weak, nonatomic) IBOutlet UILabel *fielderLabel;

@end
