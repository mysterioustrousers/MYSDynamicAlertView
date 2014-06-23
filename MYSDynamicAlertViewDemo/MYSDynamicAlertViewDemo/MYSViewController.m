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
@property (nonatomic, strong) MYSDynamicAlertView *tossAlert;

@end

@implementation MYSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.tossAlert = [[MYSDynamicAlertView alloc] init];
    __weak MYSViewController *bself = self;
    [self.tossAlert setTitle:@"Ok" dismissBlock:^{ bself.directionLabel.text = @"Up"; } direction:MYSDynamicAlertViewDirectionUp];
    [self.tossAlert setTitle:@"Cancel" dismissBlock:^{ bself.directionLabel.text = @"Down"; } direction:MYSDynamicAlertViewDirectionDown];
    //[tossAlert setDismissBlock:nil direction:MYSTossAlertViewDirectionDown]; // can allow down direction with no block
    self.tossAlert.message = @"Hello World! ";
    self.tossAlert.title = @"Are you sure?";
    //self.tossAlert.message = @"Hello World! Hello World! Hello World! Hello World! Hello World! Hello World!  Hello World! Hello World! Hello World! Hello World! Hello World! Hello World! Hello World! Hello World! Hello World! Hello World! Hello World! Hello World! Hello World! Hello World! Hello World! Hello World! Hello World! Hello World! Hello World! Hello World! Hello World! Hello World! Hello World! Hello World! Hello World! Hello World! Hello World! Hello World! Hello World! Hello World! Hello World! Hello World! Hello World! Hello World! Hello World! Hello World! Hello World! Hello World! Hello World! Hello World! Hello World! Hello World! Hello World! Hello World! Hello World! Hello World! Hello World! ";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showAlertButtonWasTapped:(id)sender
{
    [self.tossAlert show];
    //[[[UIAlertView alloc] initWithTitle:@"hi" message:self.tossAlert.message delegate:nil cancelButtonTitle:@"hil" otherButtonTitles:nil, nil] show];
    
}

@end
