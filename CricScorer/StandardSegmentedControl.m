//
//  StandardSegmentedControl.m
//  CricScorer
//
//  Created by Kunal Wagle on 06/08/2015.
//  Copyright (c) 2015 KMW13. All rights reserved.
//

#import "StandardSegmentedControl.h"

@implementation StandardSegmentedControl

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithItems:(NSArray *)items {
self = [super initWithItems:items];
if (self) {
// Initialization code

// Set divider images
[self setDividerImage:[UIImage imageNamed:@"white_both_un.png"]
forLeftSegmentState:UIControlStateNormal
rightSegmentState:UIControlStateNormal
barMetrics:UIBarMetricsDefault];
[self setDividerImage:[UIImage imageNamed:@"white_selected_left.png"]
forLeftSegmentState:UIControlStateSelected
    rightSegmentState:UIControlStateNormal
           barMetrics:UIBarMetricsDefault];
    [self setDividerImage:[UIImage imageNamed:@"white_selected_right.png"]
      forLeftSegmentState:UIControlStateNormal
        rightSegmentState:UIControlStateSelected
               barMetrics:UIBarMetricsDefault];
    
    // Set background images
    UIImage *normalBackgroundImage = [UIImage imageNamed:@"white_unselected.png"];
    [self setBackgroundImage:normalBackgroundImage
                    forState:UIControlStateNormal
                  barMetrics:UIBarMetricsDefault];
    UIImage *selectedBackgroundImage = [UIImage imageNamed:@"white_selected.png"];
    [self setBackgroundImage:selectedBackgroundImage
                    forState:UIControlStateSelected
                  barMetrics:UIBarMetricsDefault];
    
    int dividerImageWidth = normalBackgroundImage.size.width;
    NSLog(@"%d", dividerImageWidth);
    dividerImageWidth = selectedBackgroundImage.size.width;
    NSLog(@"%d", dividerImageWidth);
    dividerImageWidth = [UIImage imageNamed:@"white_selected_left.png"].size.width;
    NSLog(@"%d", dividerImageWidth);
    
    [self setContentPositionAdjustment:UIOffsetMake(dividerImageWidth / 8, 0)
                        forSegmentType:UISegmentedControlSegmentLeft
                            barMetrics:UIBarMetricsDefault];
    [self setContentPositionAdjustment:UIOffsetMake(- dividerImageWidth / 8, 0)
                        forSegmentType:UISegmentedControlSegmentRight
                            barMetrics:UIBarMetricsDefault];
}
    return self;
}

@end

