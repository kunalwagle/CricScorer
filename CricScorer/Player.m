//
//  Player.m
//  CricScorer
//
//  Created by Kunal Wagle on 04/07/2015.
//  Copyright (c) 2015 KMW13. All rights reserved.
//

#import "Player.h"

@implementation Player

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.team forKey:@"team"];
    [aCoder encodeObject:self.batting forKey:@"batting"];
    [aCoder encodeObject:self.bowling forKey:@"bowling"];
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    self.name = [aDecoder decodeObjectForKey:@"name"];
    self.team = [aDecoder decodeObjectForKey:@"team"];
    self.batting = [aDecoder decodeObjectForKey:@"batting"];
    self.bowling = [aDecoder decodeObjectForKey:@"bowling"];
    return self;
}

@end
