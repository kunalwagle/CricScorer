//
//  ScoreboardBowlerTableViewCell.h
//  CricScorer
//
//  Created by Kunal Wagle on 22/07/2015.
//  Copyright (c) 2015 KMW13. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreboardBowlerTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *overs;
@property (weak, nonatomic) IBOutlet UILabel *maidens;
@property (weak, nonatomic) IBOutlet UILabel *runs;
@property (weak, nonatomic) IBOutlet UILabel *wickets;

@end
