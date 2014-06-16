//
//  MYSViewController.m
//  MYSDynamicAlertViewDemo
//
//  Created by Dan Willoughby on 6/4/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSViewController.h"
#import "MYSDynamicAlertView.h"

@interface MYSViewController ()
@property (weak, nonatomic) IBOutlet UILabel *directionLabel;

@end

@implementation MYSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showAlertButtonWasTapped:(id)sender
{
    MYSDynamicAlertView *tossAlert = [[MYSDynamicAlertView alloc] init];
    [tossAlert setDismissBlock:^{ self.directionLabel.text = @"Left"; } direction:MYSTossAlertViewDirectionLeft];
    [tossAlert setDismissBlock:^{ self.directionLabel.text = @"Right"; } direction:MYSTossAlertViewDirectionRight];
    [tossAlert setDismissBlock:^{ self.directionLabel.text = @"Up"; } direction:MYSTossAlertViewDirectionUp];
    [tossAlert setDismissBlock:^{ self.directionLabel.text = @"Down"; } direction:MYSTossAlertViewDirectionDown];
    //[tossAlert setDismissBlock:nil direction:MYSTossAlertViewDirectionDown]; // can allow down direction with no block
    [tossAlert show];
    
}

@end
