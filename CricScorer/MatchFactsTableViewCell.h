//
//  MatchFactsTableViewCell.h
//  CricScorer
//
//  Created by Kunal Wagle on 21/07/2015.
//  Copyright (c) 2015 KMW13. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MatchFactsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *teamNames;
@property (weak, nonatomic) IBOutlet UILabel *ground;
@property (weak, nonatomic) IBOutlet UILabel *toss;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *matchResult;

@end
