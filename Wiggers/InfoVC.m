//
//  InfoViewViewController.m
//  Wiggers
//
//  Created by Ben Smith on 9/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InfoVC.h"

@interface InfoVC ()

@end

@implementation InfoVC
@synthesize backButton;
@synthesize textView1;
@synthesize textView2,secondaryView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [textView1 setFont:[UIFont fontWithName:@"AEnigmaScrawl4BRK" size:15]];
    textView2.font = [UIFont fontWithName:@"AEnigmaScrawl4BRK" size:15];
    backButton.titleLabel.font = [UIFont fontWithName:@"AEnigmaScrawl4BRK" size:20];
    backButton.titleLabel.text = @"BACK";
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setBackButton:nil];
    [self setTextView1:nil];
    [self setTextView2:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}

- (IBAction)buttonPressed:(id)sender {
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.80];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight 
                           forView:self.navigationController.view cache:NO];
    
    [self.navigationController popViewControllerAnimated:YES];
    [UIView commitAnimations];
}
@end
