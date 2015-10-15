//
//  Dismissal.m
//  CricScorer
//
//  Created by Kunal Wagle on 04/07/2015.
//  Copyright (c) 2015 KMW13. All rights reserved.
//

#import "Dismissal.h"

@implementation Dismissal



-(Dismissal*) initWithNotOut {
    if (self = [super init]) {
        self.howOut = @"Not Out";
        self.bowler = nil;
        return self;
    }
    else {
        return nil;
    }
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.howOut forKey:@"howOut"];
    [aCoder encodeObject:self.bowler forKey:@"bowler"];
    [aCoder encodeObject:self.fielder forKey:@"fielder"];
    [aCoder encodeInt:self.fow forKey:@"fow"];
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    self.howOut = [aDecoder decodeObjectForKey:@"howOut"];
    self.bowler = [aDecoder decodeObjectForKey:@"bowler"];
    self.fielder = [aDecoder decodeObjectForKey:@"fielder"];
    self.fow = [aDecoder decodeIntForKey:@"fow"];
    return self;
}

@end
