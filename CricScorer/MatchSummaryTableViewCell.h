//
//  MatchSummaryTableViewCell.h
//  CricScorer
//
//  Created by Kunal Wagle on 21/07/2015.
//  Copyright (c) 2015 KMW13. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MatchSummaryTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *colour;
@property (weak, nonatomic) IBOutlet UILabel *overs;
@property (weak, nonatomic) IBOutlet UILabel *battingTeam;
@property (weak, nonatomic) IBOutlet UILabel *inningsNumber;
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UILabel *bat1name;
@property (weak, nonatomic) IBOutlet UILabel *bat2name;
@property (weak, nonatomic) IBOutlet UILabel *bat3name;
@property (weak, nonatomic) IBOutlet UILabel *bat1score;
@property (weak, nonatomic) IBOutlet UILabel *bat2score;
@property (weak, nonatomic) IBOutlet UILabel *bat3score;
@property (weak, nonatomic) IBOutlet UILabel *bowl1name;
@property (weak, nonatomic) IBOutlet UILabel *bowl2name;
@property (weak, nonatomic) IBOutlet UILabel *bowl3name;
@property (weak, nonatomic) IBOutlet UILabel *bowl1score;
@property (weak, nonatomic) IBOutlet UILabel *bowl2score;
@property (weak, nonatomic) IBOutlet UILabel *bowl3score;

@end
