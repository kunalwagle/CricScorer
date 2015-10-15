//
//  PDFViewController.h
//  CricScorer
//
//  Created by Kunal Wagle on 29/07/2015.
//  Copyright (c) 2015 KMW13. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface PDFViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)shareButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *shareButton;

@end
