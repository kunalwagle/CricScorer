//
//  Game.m
//  CricScorer
//
//  Created by Kunal Wagle on 03/07/2015.
//  Copyright (c) 2015 KMW13. All rights reserved.
//

#import "Game.h"
#import "Player.h"
#import "Inning.h"


@implementation Game

-(Game*)initWithDict:(NSDictionary *)info {
    self.homeName = [info objectForKey:@"homeTeam"];
    self.awayName = [info objectForKey:@"awayTeam"];
    self.homeTeam = [[NSMutableArray alloc] initWithCapacity:11];
    self.homeToss = [info objectForKey:@"homeToss"];
    self.awayTeam = [[NSMutableArray alloc] initWithCapacity:11];
    self.ground = [info objectForKey:@"ground"];
    self.type = [info objectForKey:@"fixtureType"];
    self.limited = ![[info objectForKey:@"declaration"] intValue];
    if (self.limited) {
        self.overs = [[info objectForKey:@"overCount"] intValue];
    }
    self.complete = NO;
    self.currentInning = 0;
    self.innings = [[NSMutableArray alloc] initWithCapacity:2*[[info objectForKey:@"inningsCount"] intValue]];
    self.inningsCount = [[info objectForKey:@"inningsCount"] intValue];
    NSString *dateString = [info objectForKey:@"date"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // this is important - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSDate *dateFromString = [[NSDate alloc] init];
    // voila!
    dateFromString = [dateFormatter dateFromString:dateString];
    //NSString *date2 = [dateFormatter stringFromDate:dateFromString];
    self.title = [NSString stringWithFormat:@"%@ vs %@, %@", self.homeName, self.awayName, dateString];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH-mm"];
    self.date = [[NSDate alloc] init];
    self.date = [dateFormatter dateFromString:dateString];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.homeName forKey:@"homeName"];
    [coder encodeObject:self.awayName forKey:@"awayName"];
    [coder encodeObject:self.homeTeam forKey:@"homeTeam"];
    [coder encodeBool:self.homeToss forKey:@"homeToss"];
    [coder encodeObject:self.awayTeam forKey:@"awayTeam"];
    [coder encodeInt:self.overs forKey:@"overs"];
    [coder encodeObject:self.ground forKey:@"ground"];
    [coder encodeObject:self.date forKey:@"time"];
    [coder encodeBool:self.limited forKey:@"limited"];
    [coder encodeInt:self.currentInning forKey:@"currentInning"];
    [coder encodeObject:self.innings forKey:@"innings"];
    [coder encodeObject:self.title forKey:@"title"];
    [coder encodeObject:self.type forKey:@"type"];
    [coder encodeBool:self.homeBatFirst forKey:@"homeBatFirst"];
    [coder encodeInt:self.inningsCount forKey:@"inningsCount"];
    [coder encodeBool:self.complete forKey:@"complete"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    self.homeName = [coder decodeObjectForKey:@"homeName"];
    self.awayName = [coder decodeObjectForKey:@"awayName"];
    self.homeTeam = [coder decodeObjectForKey:@"homeTeam"];
    self.homeToss = [coder decodeBoolForKey:@"homeToss"];
    self.awayTeam = [coder decodeObjectForKey:@"awayTeam"];
    self.overs = [coder decodeIntForKey:@"overs"];
    self.ground = [coder decodeObjectForKey:@"ground"];
    self.date = [coder decodeObjectForKey:@"time"];
    self.limited = [coder decodeBoolForKey:@"limited"];
    self.currentInning = [coder decodeIntForKey:@"currentInning"];
    self.innings = [coder decodeObjectForKey:@"innings"];
    self.title = [coder decodeObjectForKey:@"title"];
    self.type = [coder decodeObjectForKey:@"type"];
    self.homeBatFirst = [coder decodeBoolForKey:@"homeBatFirst"];
    self.inningsCount = [coder decodeIntForKey:@"inningsCount"];
    self.complete = [coder decodeBoolForKey:@"complete"];
    return self;
}

-(NSString*)computeResult {
    NSString *resultString;
    NSString *winningSide;
    Inning *prevInning = [self.innings objectAtIndex:self.currentInning];
    if (prevInning.lead>0) {
        if (prevInning.battingSide==0) {
            winningSide = self.homeName;
        } else {
            winningSide = self.awayName;
        }
    } else {
        if (prevInning.battingSide==0) {
            winningSide = self.awayName;
        } else {
            winningSide = self.homeName;
        }
    }
    if (![prevInning complete]) {
        resultString = @"Match Drawn";
    } else {
        if ([self.innings count] == self.inningsCount*2) {
            if (prevInning.lead>0) {
                resultString = [NSString stringWithFormat:@"%@ won by %d wickets", winningSide, 10-prevInning.wickets];
            } else {
                resultString = [NSString stringWithFormat:@"%@ won by %d runs", winningSide, 0-prevInning.lead];
            }
        } else {
            if (prevInning.lead < 0) {
                resultString = [NSString stringWithFormat:@"%@ won by an innings and %d runs", winningSide, 0-prevInning.lead];
            }
        }
    }
    return resultString;
}

-(NSString*)matchStatus {
    NSString *winningSide;
    NSString *resultString;
    Inning *prevInning = [self.innings objectAtIndex:self.currentInning];
    if (prevInning.battingSide==0) {
        winningSide = self.homeName;
    } else {
        winningSide = self.awayName;
    }
    if (prevInning.lead>=0) {
        resultString = [NSString stringWithFormat:@"%@ lead by %d runs", winningSide, prevInning.lead];
    } else {
        if (self.limited) {
            int ballsLeft = (self.overs*6)-(prevInning.overs*6+prevInning.balls);
            float requiredRunRate = (float)ballsLeft / 6;
            requiredRunRate = (0-prevInning.lead+1)/requiredRunRate;
            resultString = [NSString stringWithFormat:@"%@ require %d runs in %d balls at a run rate of %.2f", winningSide, 0-prevInning.lead+1, ballsLeft, requiredRunRate];
        } else if (self.currentInning!=self.inningsCount*2-1) {
            resultString = [NSString stringWithFormat:@"%@ trails by %d runs", winningSide, 0-prevInning.lead];
        } else {
            resultString = [NSString stringWithFormat:@"%@ require %d runs", winningSide, 0-prevInning.lead+1];

        }
    }
    return resultString;
}

-(BOOL)inHomeTeam:(Player*)player {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name ==[c] %@", player.name];
    NSArray *searchArray = [self.homeTeam filteredArrayUsingPredicate:predicate];
    return [searchArray count]>0;
}

-(BOOL)inAwayTeam:(Player*)player {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name ==[c] %@", player.name];
    NSArray *searchArray = [self.awayTeam filteredArrayUsingPredicate:predicate];
    return [searchArray count]>0;
}

-(Player*)getHomePlayer:(Player*)player {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name ==[c] %@", player.name];
    NSArray *searchArray = [self.homeTeam filteredArrayUsingPredicate:predicate];
    return [searchArray objectAtIndex:0];
}

-(Player*)getAwayPlayer:(Player*)player {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name ==[c] %@", player.name];
    NSArray *searchArray = [self.awayTeam filteredArrayUsingPredicate:predicate];
    return [searchArray objectAtIndex:0];
}

@end
