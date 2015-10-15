//
//  Batsman.m
//  CricScorer
//
//  Created by Kunal Wagle on 04/07/2015.
//  Copyright (c) 2015 KMW13. All rights reserved.
//

#import "Batsman.h"
#import "Dismissal.h"

@implementation Batsman

-(Batsman *)initWithPlayer: (Player *)player2 {
    if (self = [super init]) {
        self.player = player2;
        self.dismissal = [[Dismissal alloc] initWithNotOut];
        self.score = 0;
        self.balls = 0;
        self.scoringDeliveries = [[NSMutableArray alloc] initWithObjects: nil];
        return self;
    }
    else {
        return nil;
    }
}

-(void)addRuns:(int)runs {
    self.score += runs;
    self.balls++;
    [self.scoringDeliveries addObject:[NSString stringWithFormat:@"%d", runs]];
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.player forKey:@"player"];
    [coder encodeObject:self.dismissal forKey:@"dismissal"];
    [coder encodeInt:self.score forKey:@"score"];
    [coder encodeInt:self.balls forKey:@"balls"];
    [coder encodeObject:self.scoringDeliveries forKey:@"scoringDeliveries"];
}

-(id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    self.player = [coder decodeObjectForKey:@"player"];
    self.dismissal = [coder decodeObjectForKey:@"dismissal"];
    self.score = [coder decodeIntForKey:@"score"];
    self.balls = [coder decodeIntForKey:@"balls"];
    self.scoringDeliveries = [coder decodeObjectForKey:@"scoringDeliveries"];
    return self;
}

@end
