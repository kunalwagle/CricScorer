//
//  ScoreboardBatsmanTableViewCell.h
//  CricScorer
//
//  Created by Kunal Wagle on 22/07/2015.
//  Copyright (c) 2015 KMW13. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreboardBatsmanTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *fielder;
@property (weak, nonatomic) IBOutlet UILabel *bowler;
@property (weak, nonatomic) IBOutlet UILabel *score;

@end
