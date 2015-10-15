//
//  GameplayScoreboardViewController.h
//  CricScorer
//
//  Created by Kunal Wagle on 07/08/2015.
//  Copyright (c) 2015 KMW13. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameplayScoreboardViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *teamName;
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UILabel *matchSituation;
@property (weak, nonatomic) IBOutlet UILabel *b1name;
@property (weak, nonatomic) IBOutlet UILabel *bname;
@property (weak, nonatomic) IBOutlet UILabel *b2name;
@property (weak, nonatomic) IBOutlet UILabel *overs;
@property (weak, nonatomic) IBOutlet UILabel *b1score;
@property (weak, nonatomic) IBOutlet UILabel *b2score;
@property (weak, nonatomic) IBOutlet UILabel *bscore;

@end
