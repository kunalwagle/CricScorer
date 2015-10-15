//
//  SecondNewGamePageSheetViewController.h
//  CricScorer
//
//  Created by Kunal Wagle on 29/06/2015.
//  Copyright (c) 2015 KMW13. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondNewGamePageSheetViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *toss;
@property (weak, nonatomic) IBOutlet UISegmentedControl *batting;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
- (IBAction)adjustDate:(id)sender;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UISwitch *recordMinutes;
- (IBAction)pickerAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *dateButton;
@property NSMutableDictionary *info;
- (IBAction)startGame:(id)sender;

@end
