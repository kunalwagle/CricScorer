//
//  Game.h
//  CricScorer
//
//  Created by Kunal Wagle on 03/07/2015.
//  Copyright (c) 2015 KMW13. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Player;

@interface Game : NSObject<NSCoding>



-(Game*)initWithDict:(NSDictionary*)info;

@property NSString *title;
@property NSString *homeName;
@property NSString *awayName;
@property bool limited;
@property NSString *type;
@property int overs;
@property NSString *ground;
@property NSString *weather;
@property bool homeToss;
@property bool homeBatFirst;
@property NSMutableArray *homeTeam;
@property NSMutableArray *awayTeam;
@property int currentInning;
@property NSMutableArray *innings;
@property NSDate *date;
@property int inningsCount;
@property BOOL complete;

-(BOOL)inHomeTeam:(Player*)player;
-(BOOL)inAwayTeam:(Player*)player;
-(Player*)getHomePlayer:(Player*)player;
-(Player*)getAwayPlayer:(Player*)player;
-(NSString*)computeResult;
-(NSString*)matchStatus;

@end
