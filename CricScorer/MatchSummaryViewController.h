//
//  MatchSummaryViewController.h
//  CricScorer
//
//  Created by Kunal Wagle on 21/07/2015.
//  Copyright (c) 2015 KMW13. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"

@interface MatchSummaryViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)loadGame:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *loadGame;
@property Game *game;
@property (weak, nonatomic) IBOutlet UILabel *matchSituation;

@end
