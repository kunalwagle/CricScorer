//
//  ChooseBowlerViewController.h
//  CricScorer
//
//  Created by Kunal Wagle on 19/07/2015.
//  Copyright (c) 2015 KMW13. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"
#import "Bowler.h"

@interface ChooseBowlerViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *bowlerName;
@property (weak, nonatomic) IBOutlet UILabel *bowlerFigures;
@property Game *game;
@property Bowler *current;
@property (weak, nonatomic) IBOutlet UIButton *submit;
@property BOOL *newBowler;
- (IBAction)changeBowler:(id)sender;
- (IBAction)submit:(id)sender;

@end
