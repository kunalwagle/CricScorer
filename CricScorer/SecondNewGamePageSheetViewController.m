//
//  SecondNewGamePageSheetViewController.m
//  CricScorer
//
//  Created by Kunal Wagle on 29/06/2015.
//  Copyright (c) 2015 KMW13. All rights reserved.
//

#import "SecondNewGamePageSheetViewController.h"

@interface SecondNewGamePageSheetViewController ()

@end

@implementation SecondNewGamePageSheetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.toss setTitle:[self.info objectForKey:@"homeTeam"] forSegmentAtIndex:0];
    [self.toss setTitle:[self.info objectForKey:@"awayTeam"] forSegmentAtIndex:1];
    [self.batting setTitle:[self.info objectForKey:@"homeTeam"] forSegmentAtIndex:0];
    [self.batting setTitle:[self.info objectForKey:@"awayTeam"] forSegmentAtIndex:1];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    NSString *formattedDate = [dateFormatter stringFromDate:self.datePicker.date];
    self.dateLabel.text =formattedDate;
    self.navigationItem.title = @"Initialise Game";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)adjustDate:(id)sender {
    if (self.datePicker.hidden) {
        self.datePicker.hidden = NO;
        [self.dateButton setTitle:@"Confirm Date" forState:UIControlStateNormal];
    } else {
        self.datePicker.hidden = YES;
        [self.dateButton setTitle:@"Adjust Date" forState:UIControlStateNormal];
    }

}

- (IBAction)pickerAction:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    NSString *formattedDate = [dateFormatter stringFromDate:self.datePicker.date];
    self.dateLabel.text =formattedDate;
    
}
- (IBAction)startGame:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [self.info setObject:[NSNumber numberWithInt:([self.toss selectedSegmentIndex]+1)%2] forKey:@"homeToss"];
        [self.info setObject:[NSNumber numberWithInt:([self.batting selectedSegmentIndex]+1)%2] forKey:@"homeBatFirst"];
        [self.info setObject:self.dateLabel.text forKey:@"date"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"createNewGame" object:nil userInfo:self.info];
    }];
}
@end
