//
//  Inning.h
//  CricScorer
//
//  Created by Kunal Wagle on 04/07/2015.
//  Copyright (c) 2015 KMW13. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Player;

@interface Inning : NSObject<NSCoding>

-(Inning*)initWithDict:(NSDictionary*)dict;

-(void)updateScores:(NSDictionary*)dict;

@property NSMutableArray *batsmen;
@property NSMutableArray *bowlers;
@property int battingSide;
@property int total;
@property int wickets;
@property int overs;
@property int balls;
@property int wides;
@property int noBalls;
@property int legByes;
@property int byes;
@property bool firstInning;
@property NSMutableArray *currentBatsmen;
@property int currentBowler;
@property int onStrike;
@property int lastMan;
@property int lead;
@property NSMutableArray *currentBowlers;
@property Player* justFinishedBowling;
@property BOOL complete;

@end
