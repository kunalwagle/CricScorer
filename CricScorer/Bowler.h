//
//  Bowler.h
//  CricScorer
//
//  Created by Kunal Wagle on 04/07/2015.
//  Copyright (c) 2015 KMW13. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Player;

@interface Bowler : NSObject<NSCoding>

-(void)updateTotals:(NSDictionary*)dict;
-(Bowler *)initWithPlayer: (Player *)player2;

@property Player *player;
@property int overs;
@property int maidens;
@property int runs;
@property int wickets;
@property int balls;
@property NSMutableArray *deliveries;
@property bool maidenPossible;

@end
