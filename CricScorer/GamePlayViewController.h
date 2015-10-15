//
//  GamePlayViewController.h
//  CricScorer
//
//  Created by Kunal Wagle on 04/07/2015.
//  Copyright (c) 2015 KMW13. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"

@interface GamePlayViewController : UIViewController<UIAlertViewDelegate>

@property Game *game;
@property BOOL initialise;

@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UILabel *wickets;
@property (weak, nonatomic) IBOutlet UILabel *b1;
@property (weak, nonatomic) IBOutlet UILabel *b2;
@property (weak, nonatomic) IBOutlet UILabel *bowler;
@property (weak, nonatomic) IBOutlet UILabel *bowlerName;
@property (weak, nonatomic) IBOutlet UILabel *b1Name;
@property (weak, nonatomic) IBOutlet UILabel *b2Name;
@property (weak, nonatomic) IBOutlet UILabel *leadName;
@property (weak, nonatomic) IBOutlet UILabel *lead;
@property (weak, nonatomic) IBOutlet UILabel *overs;
@property (weak, nonatomic) IBOutlet UIView *standardDelivery;
@property (weak, nonatomic) IBOutlet UIView *chooseBowler;
@property (weak, nonatomic) IBOutlet UIView *initialiseInnings;
@property (weak, nonatomic) IBOutlet UIView *wicketTaken;
@property (weak, nonatomic) IBOutlet UIView *scoreboard;

@end
