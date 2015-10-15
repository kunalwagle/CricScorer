//
//  BowlingStatistics.m
//  CricScorer
//
//  Created by Kunal Wagle on 23/07/2015.
//  Copyright (c) 2015 KMW13. All rights reserved.
//

#import "BowlingStatistics.h"
#import "Bowler.h"

@implementation BowlingStatistics

-(void)updateBowlingStats:(Bowler *)bowler {
    self.balls += [bowler balls] + 6*[bowler overs];
    self.runs += [bowler runs];
    self.wickets += [bowler wickets];
    if ([bowler wickets]>self.bestWickets) {
        self.bestWickets = [bowler wickets];
        self.bestRuns = [bowler runs];
    } else if ([bowler wickets]==self.bestWickets) {
        if ([bowler runs] < self.bestRuns) {
            self.bestRuns = [bowler runs];
        }
    }
    self.maidens += [bowler maidens];
    self.average = (float)self.runs / self.wickets;
    self.economy = (float)self.runs/((float)self.balls / 6);
    self.strikeRate = (float)self.wickets/self.balls;
    if ([bowler wickets]>=5) {
        self.fiveWickets++;
    }
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInt:self.wickets forKey:@"wickets"];
    [aCoder encodeInt:self.runs forKey:@"runs"];
    [aCoder encodeInt:self.bestWickets forKey:@"bestWickets"];
    [aCoder encodeInt:self.bestRuns forKey:@"bestRuns"];
    [aCoder encodeFloat:self.average forKey:@"average"];
    [aCoder encodeInt:self.balls forKey:@"balls"];
    [aCoder encodeFloat:self.strikeRate forKey:@"strikeRate"];
    [aCoder encodeInt:self.fiveWickets forKey:@"fiveWickets"];
    [aCoder encodeFloat:self.economy forKey:@"economy"];
    [aCoder encodeInt:self.maidens forKey:@"maidens"];
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    self.wickets = [aDecoder decodeIntForKey:@"wickets"];
    self.runs = [aDecoder decodeIntForKey:@"runs"];
    self.bestWickets = [aDecoder decodeIntForKey:@"bestWickets"];
    self.bestRuns = [aDecoder decodeIntForKey:@"bestRuns"];
    self.average = (float)self.runs / self.wickets;
    self.balls = [aDecoder decodeIntForKey:@"balls"];
    //self.strikeRate = [aDecoder decodeFloatForKey:@"strikeRate"];
    self.fiveWickets = [aDecoder decodeIntForKey:@"fiveWickets"];
    self.economy = (float)self.runs/((float)self.balls / 6);
    self.strikeRate = (float)self.balls/self.wickets;
    self.maidens = [aDecoder decodeIntForKey:@"maidens"];
    return self;
}

@end
