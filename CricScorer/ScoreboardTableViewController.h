//
//  ScoreboardTableViewController.h
//  CricScorer
//
//  Created by Kunal Wagle on 22/07/2015.
//  Copyright (c) 2015 KMW13. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Inning.h"
#import "Game.h"
#import "Batsman.h"
#import "Bowler.h"
#import "Player.h"
#import "Dismissal.h"

@interface ScoreboardTableViewController : UITableViewController

@property Inning *inning;
@property Game *game;
@property int index;


@end
