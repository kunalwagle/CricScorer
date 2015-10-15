//
//  SelectPlayerViewController.h
//  CricScorer
//
//  Created by Kunal Wagle on 05/07/2015.
//  Copyright (c) 2015 KMW13. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectPlayerViewController : UIViewController<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSString *notificationName;
@property NSMutableArray *tableSource;
@property NSMutableArray *team;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
- (IBAction)changeSection:(id)sender;
@property NSMutableArray *bowlers;
- (IBAction)submit:(id)sender;
- (IBAction)textChanged:(id)sender;
@property int selected;


@end
