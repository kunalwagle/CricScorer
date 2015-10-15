//
//  BowlingStatistics.h
//  CricScorer
//
//  Created by Kunal Wagle on 23/07/2015.
//  Copyright (c) 2015 KMW13. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Bowler;

@interface BowlingStatistics : NSObject<NSCoding>

@property int balls;
@property int maidens;
@property int runs;
@property int wickets;
@property int bestWickets;
@property int bestRuns;
@property float average;
@property float economy;
@property float strikeRate;
@property int fiveWickets;

-(void)updateBowlingStats:(Bowler*)bowler;

@end
