//
//  BattingStatistics.m
//  CricScorer
//
//  Created by Kunal Wagle on 23/07/2015.
//  Copyright (c) 2015 KMW13. All rights reserved.
//

#import "BattingStatistics.h"
#import "Batsman.h"
#import "Dismissal.h"

@implementation BattingStats

-(void)updateBattingStats:(Batsman *)batsman {
    self.innings++;
    self.runs += [batsman score];
    if ([[[batsman dismissal] howOut] isEqualToString:@"Not Out"]) {
        self.notOuts++;
    }
    if ([batsman score]>self.highScore) {
        self.highScore = [batsman score];
    }
    self.average = (float)self.runs / (self.innings-self.notOuts);
    self.balls += [batsman balls];
    //TODO Float division for this and for self.average
    self.strikeRate = (((float)self.runs/self.balls))*100;
    if ([batsman score]>=100) {
        self.hundreds++;
    } else if ([batsman score]>=50) {
        self.fifties++;
    }
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInt:self.innings forKey:@"innings"];
    [aCoder encodeInt:self.runs forKey:@"runs"];
    [aCoder encodeInt:self.notOuts forKey:@"notOuts"];
    [aCoder encodeInt:self.highScore forKey:@"highScore"];
    [aCoder encodeFloat:self.average forKey:@"average"];
    [aCoder encodeInt:self.balls forKey:@"balls"];
    [aCoder encodeFloat:self.strikeRate forKey:@"strikeRate"];
    [aCoder encodeInt:self.hundreds forKey:@"hundreds"];
    [aCoder encodeInt:self.fifties forKey:@"fifties"];
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    self.innings = [aDecoder decodeIntForKey:@"innings"];
    self.runs = [aDecoder decodeIntForKey:@"runs"];
    self.notOuts = [aDecoder decodeIntForKey:@"notOuts"];
    self.highScore = [aDecoder decodeIntForKey:@"highScore"];
    self.average = (float)self.runs / (self.innings-self.notOuts);
    self.balls = [aDecoder decodeIntForKey:@"balls"];
    self.strikeRate = (((float)self.runs/self.balls))*100;
    self.hundreds = [aDecoder decodeIntForKey:@"hundreds"];
    self.fifties = [aDecoder decodeIntForKey:@"fifties"];
    return self;
}

@end
