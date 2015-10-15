//
//  Player.h
//  CricScorer
//
//  Created by Kunal Wagle on 04/07/2015.
//  Copyright (c) 2015 KMW13. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BattingStats;
@class BowlingStatistics;


@interface Player : NSObject<NSCoding>

@property NSString *name;
@property NSString *team;
@property BowlingStatistics *bowling;
@property BattingStats *batting;



@end
