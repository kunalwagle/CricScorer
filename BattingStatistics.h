//
//  BattingStatistics.h
//  CricScorer
//
//  Created by Kunal Wagle on 23/07/2015.
//  Copyright (c) 2015 KMW13. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Batsman;

@interface BattingStats : NSObject<NSCoding>

@property int innings;
@property int runs;
@property int notOuts;
@property int highScore;
@property float average;
@property int balls;
@property float strikeRate;
@property int fifties;
@property int hundreds;

-(void)updateBattingStats:(Batsman*)batsman;


@end
