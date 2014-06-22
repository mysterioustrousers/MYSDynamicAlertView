//
//  MYSViewController.m
//  MYSDynamicAlertViewDemo
//
//  Created by Dan Willoughby on 6/4/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//

#import "MYSViewController.h"
#import "MYSDynamicAlertViewController.h"

@interface MYSViewController ()
@property (weak, nonatomic) IBOutlet UILabel *directionLabel;
@property (nonatomic, strong) MYSDynamicAlertViewController *tossAlert;

@end

@implementation MYSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.tossAlert = [[MYSDynamicAlertViewController alloc] init];
    __weak MYSViewController *bself = self;
    [self.tossAlert setDismissBlock:^{ bself.directionLabel.text = @"Left"; } direction:MYSDynamicAlertViewDirectionLeft];
    [self.tossAlert setDismissBlock:^{ bself.directionLabel.text = @"Right"; } direction:MYSDynamicAlertViewDirectionRight];
    [self.tossAlert setDismissBlock:^{ bself.directionLabel.text = @"Up"; } direction:MYSDynamicAlertViewDirectionUp];
    [self.tossAlert setDismissBlock:^{ bself.directionLabel.text = @"Down"; } direction:MYSDynamicAlertViewDirectionDown];
    //[tossAlert setDismissBlock:nil direction:MYSTossAlertViewDirectionDown]; // can allow down direction with no block
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showAlertButtonWasTapped:(id)sender
{
    [self.tossAlert show];
    //[[[UIAlertView alloc] initWithTitle:@"hi" message:@"hi" delegate:nil cancelButtonTitle:@"hil" otherButtonTitles:nil, nil] show];
    
}

@end
