//
//  Dismissal.h
//  CricScorer
//
//  Created by Kunal Wagle on 04/07/2015.
//  Copyright (c) 2015 KMW13. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Bowler;
@class Player;

@interface Dismissal : NSObject<NSCoding>

-(Dismissal*)initWithNotOut;

@property (nonatomic) NSString* howOut;
@property (nonatomic) Bowler *bowler;
@property (nonatomic) Player *fielder;
@property (nonatomic) int fow;

@end
