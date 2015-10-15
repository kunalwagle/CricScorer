//
//  FirstNewGamePageSheetViewController.h
//  CricScorer
//
//  Created by Kunal Wagle on 28/06/2015.
//  Copyright (c) 2015 KMW13. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstNewGamePageSheetViewController : UIViewController<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *homeTeam;
@property (weak, nonatomic) IBOutlet UITextField *awayTeam;
@property (weak, nonatomic) IBOutlet UITextField *fixtureType;
@property (weak, nonatomic) IBOutlet UITextField *ground;
@property (weak, nonatomic) IBOutlet UISegmentedControl *inningsCount;
@property (weak, nonatomic) IBOutlet UISegmentedControl *limitedBoolean;
@property (weak, nonatomic) IBOutlet UIStepper *overCounter;
@property (weak, nonatomic) IBOutlet UILabel *overText;
@property (weak, nonatomic) IBOutlet UILabel *overLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *explanationLabel;
- (IBAction)next:(id)sender;
- (IBAction)limitedSelected:(id)sender;
- (IBAction)overCounterChanged:(id)sender;
- (IBAction)homeChanged:(id)sender;
- (IBAction)fixtureChanged:(id)sender;
- (IBAction)awayChanged:(id)sender;
- (IBAction)groundChanged:(id)sender;
- (IBAction)cancel:(id)sender;



@end
