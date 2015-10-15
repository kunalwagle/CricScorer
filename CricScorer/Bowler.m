//
//  Bowler.m
//  CricScorer
//
//  Created by Kunal Wagle on 04/07/2015.
//  Copyright (c) 2015 KMW13. All rights reserved.
//

#import "Bowler.h"

@implementation Bowler

-(void)updateTotals:(NSDictionary *)dict {
    int runs = [[dict objectForKey:@"runs"] intValue];
    int delivery = [[dict objectForKey:@"delivery"] intValue];
    int type = [[dict objectForKey:@"typeOfRuns"] intValue];
    if (runs>0 || delivery!=0) {
        self.maidenPossible = NO;
    }
    NSString *script = @"";
    if (runs==0) {
        script = @".";
    } else {
        script = [NSString stringWithFormat:@"%d", runs];
    }
    switch (type) {
        case 1:
            script = [script stringByAppendingString:@"lb"];
            break;
        case 2:
            script = [script stringByAppendingString:@"b"];
            break;
        default:
            self.runs += runs;
            break;
    }
    if (delivery==1) {
        script = [script stringByAppendingString:@"o"];
        self.runs ++;
    } else if (delivery==2) {
        script = [script stringByAppendingString:@"+"];
        self.runs++;
    } else {
        self.balls++;
    }
    if (self.balls==6) {
        self.balls = 0;
        self.overs ++;
        if (self.maidenPossible) {
            self.maidens++;
        }
        self.maidenPossible = YES;
    }
    [self.deliveries addObject:script];
}

-(void)addWicket {
    
}

-(Bowler *)initWithPlayer: (Player *)player2 {
    if (self = [super init]) {
        self.player = player2;
        self.overs = 0;
        self.maidens = 0;
        self.runs = 0;
        self.wickets = 0;
        self.balls = 0;
        self.deliveries = [[NSMutableArray alloc] initWithObjects: nil];
        self.maidenPossible = YES;
        return self;
    }
    else {
        return nil;
    }
}

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.player forKey:@"player"];
    [aCoder encodeObject:self.deliveries forKey:@"deliveries"];
    [aCoder encodeInt:self.overs forKey:@"overs"];
    [aCoder encodeInt:self.maidens forKey:@"maidens"];
    [aCoder encodeInt:self.runs forKey:@"runs"];
    [aCoder encodeInt:self.wickets forKey:@"wickets"];
    [aCoder encodeInt:self.balls forKey:@"balls"];
    [aCoder encodeBool:self.maidenPossible forKey:@"maidenPossible"];
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    self.player = [aDecoder decodeObjectForKey:@"player"];
    self.deliveries = [aDecoder decodeObjectForKey:@"deliveries"];
    self.overs = [aDecoder decodeIntForKey:@"overs"];
    self.maidens = [aDecoder decodeIntForKey:@"maidens"];
    self.runs = [aDecoder decodeIntForKey:@"runs"];
    self.wickets = [aDecoder decodeIntForKey:@"wickets"];
    self.balls = [aDecoder decodeIntForKey:@"balls"];
    self.maidenPossible = [aDecoder decodeBoolForKey:@"maidenPossible"];
    return self;
}

@end
