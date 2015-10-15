//
//  Inning.m
//  CricScorer
//
//  Created by Kunal Wagle on 04/07/2015.
//  Copyright (c) 2015 KMW13. All rights reserved.
//

#import "Inning.h"
#import "Batsman.h"
#import "Bowler.h"

@implementation Inning

- (Inning*)initWithDict:(NSDictionary*)items {
    self.batsmen = [items objectForKey:@"batsmen"];
    self.bowlers = [items objectForKey:@"bowlers"];
    self.total = 0;
    self.wickets = 0;
    self.overs = 0;
    self.balls = 0;
    self.wides = 0;
    self.noBalls = 0;
    self.legByes = 0;
    self.byes = 0;
    self.currentBatsmen = [[items objectForKey:@"batsmen"] mutableCopy];
    self.currentBowler = 0;
    self.onStrike = 0;
    self.lastMan = 0;
    self.lead = 0;
    self.currentBowlers = [[items objectForKey:@"bowlers"] mutableCopy];
    self.complete = NO;
    return self;
}

- (void)updateScores:(NSDictionary *)dict {
    int runs = [[dict objectForKey:@"runs"] intValue];
    int delivery = [[dict objectForKey:@"delivery"] intValue];
    int type = [[dict objectForKey:@"typeOfRuns"] intValue];
    Bowler *bowler = [self.currentBowlers objectAtIndex:self.currentBowler];
    self.total += runs;
    self.lead += runs;
    if (runs > 0) {
    if (type==0) {
        Batsman *bat = [self.currentBatsmen objectAtIndex:self.onStrike];
        [bat addRuns:runs];
    } else {
        Batsman *bat = [self.currentBatsmen objectAtIndex:self.onStrike];
        bat.balls++;
        switch (type) {
            case 1:
                self.legByes += runs;
                break;
            case 2:
                self.byes += runs;
                break;
            default:
                self.wides += runs;
                break;
        }
    }

    } else {
        Batsman *bat = [self.currentBatsmen objectAtIndex:self.onStrike];
        bat.balls++;
    }
    if (delivery == 1) {
        self.noBalls++;
        self.total++;
        self.lead++;
    } else if (delivery == 2) {
        self.wides++;
        self.total++;
        self.lead++;
    }
    if (runs % 2 == 1) {
        self.onStrike = (self.onStrike+1)%2;
    }
    [bowler updateTotals:dict];
    if (delivery==0) {
        self.balls++;
        if (self.balls == 6) {
            self.balls = 0;
            self.overs++;
            self.onStrike = (self.onStrike+1)%2;
        }
    }
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.batsmen forKey:@"batsmen"];
    [coder encodeObject:self.bowlers forKey:@"bowlers"];
    [coder encodeInt:self.wickets forKey:@"wickets"];
    [coder encodeInt:self.overs forKey:@"overs"];
    [coder encodeInt:self.total forKey:@"total"];
    [coder encodeBool:self.firstInning forKey:@"firstInning"];
    [coder encodeInt:self.balls forKey:@"balls"];
    [coder encodeInt:self.wides forKey:@"wides"];
    [coder encodeObject:self.currentBatsmen forKey:@"currentBatsmen"];
    [coder encodeInt:self.noBalls forKey:@"noBalls"];
    [coder encodeObject:self.currentBowlers forKey:@"currentBowlers"];
    [coder encodeInt:self.currentBowler forKey:@"currentBowler"];
    [coder encodeInt:self.onStrike forKey:@"onStrike"];
    [coder encodeInt:self.legByes forKey:@"legByes"];
    [coder encodeInt:self.lastMan forKey:@"lastMan"];
    [coder encodeInt:self.byes forKey:@"byes"];
    [coder encodeInt:self.lead forKey:@"lead"];
    [coder encodeObject:self.justFinishedBowling forKey:@"justFinishedBowling"];
    [coder encodeInt:self.battingSide forKey:@"battingSide"];
    [coder encodeBool:self.complete forKey:@"complete"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [self init];
    self.batsmen = [coder decodeObjectForKey:@"batsmen"];
    self.bowlers = [coder decodeObjectForKey:@"bowlers"];
    self.wickets = [coder decodeIntForKey:@"wickets"];
    self.overs = [coder decodeIntForKey:@"overs"];
    self.total = [coder decodeIntForKey:@"total"];
    self.firstInning = [coder decodeBoolForKey:@"firstInning"];
    self.balls = [coder decodeIntForKey:@"balls"];
    self.wides = [coder decodeIntForKey:@"wides"];
    self.currentBatsmen = [coder decodeObjectForKey:@"currentBatsmen"];
    self.noBalls = [coder decodeIntForKey:@"noBalls"];
    self.currentBowlers = [coder decodeObjectForKey:@"currentBowlers"];
    self.currentBowler = [coder decodeIntForKey:@"currentBowler"];
    self.onStrike = [coder decodeIntForKey:@"onStrike"];
    self.legByes = [coder decodeIntForKey:@"legByes"];
    self.lastMan = [coder decodeIntForKey:@"lastMan"];
    self.byes = [coder decodeIntForKey:@"byes"];
    self.justFinishedBowling = [coder decodeObjectForKey:@"justFinishedBowling"];
    self.lead = [coder decodeIntForKey:@"lead"];
    self.battingSide = [coder decodeIntForKey:@"battingSide"];
    self.complete = [coder decodeBoolForKey:@"complete"];
    return self;
}

@end
