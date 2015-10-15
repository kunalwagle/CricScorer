//
//  StandardDeliveryViewController.h
//  CricScorer
//
//  Created by Kunal Wagle on 18/07/2015.
//  Copyright (c) 2015 KMW13. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StandardSegmentedControl.h"

@interface StandardDeliveryViewController : UIViewController

@property StandardSegmentedControl *numberOfRuns;
@property StandardSegmentedControl *typeOfDelivery;
@property StandardSegmentedControl *outOrNot;
@property StandardSegmentedControl *typeOfRun;
- (IBAction)submitDelivery:(id)sender;
- (IBAction)declare:(id)sender;
- (IBAction)endMatch:(id)sender;
- (IBAction)exit:(id)sender;

@end
