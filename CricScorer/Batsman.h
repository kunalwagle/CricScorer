//
//  Batsman.h
//  CricScorer
//
//  Created by Kunal Wagle on 04/07/2015.
//  Copyright (c) 2015 KMW13. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Dismissal;
@class Player;

@interface Batsman : NSObject<NSCoding>

-(Batsman *)initWithPlayer: (Player *)player2;
-(void)addRuns:(int)runs;
@property (nonatomic) int score;
@property (nonatomic) int balls;
@property (nonatomic) Dismissal *dismissal;
@property NSMutableArray *scoringDeliveries;
@property Player *player;

@end
