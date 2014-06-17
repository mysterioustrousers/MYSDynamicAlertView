//
//  MYSBackDropView.m
//  Pods
//
//  Created by Dan Willoughby on 6/16/14.
//
//

#import "MYSBackDropView.h"

@implementation MYSBackDropView

- (id)initWithFrame:(CGRect)aRect
{
    if ((self = [super initWithFrame:aRect])) {
        //self.backgroundColor = [UIColor blueColor];
        CGFloat subHeight = self.bounds.size.height/4;
        CGFloat width = self.bounds.size.width;
        UIView *greenContainer = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.origin.x,self.bounds.origin.y + subHeight, width, subHeight)];
        greenContainer.backgroundColor = [UIColor greenColor];
        [self addSubview:greenContainer];
        UIView *redContainer = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.origin.x,self.bounds.origin.y + subHeight * 2, width, subHeight)];
        redContainer.backgroundColor = [UIColor redColor];
        [self addSubview:redContainer];
        // Top
        self.upLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y + subHeight, width, subHeight)];
        self.upLabel.text = @"Ok";
        self.upLabel.textAlignment = NSTextAlignmentCenter;
        self.upLabel.center = self.center;
        //[self addSubview:self.upLabel];
        // Down
        self.downLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y + subHeight * 2, width, subHeight)];
        self.downLabel.text = @"Cancel";
        self.downLabel.textAlignment = NSTextAlignmentCenter;
        self.downLabel.center = self.center;
        //[self addSubview:self.downLabel];
    }
    return self;
}

- (void)snapOut
{
    /*
    [self.animator removeAllBehaviors];
    self.upLabel.hidden = NO;
    self.downLabel.hidden = NO;
    CGFloat subHeight = self.bounds.size.height/8;
    UISnapBehavior *snap    = [[UISnapBehavior alloc] initWithItem:self.upLabel snapToPoint:CGPointMake(self.center.x, self.frame.origin.y + subHeight)];
    [self.animator addBehavior:snap];
    snap    = [[UISnapBehavior alloc] initWithItem:self.downLabel snapToPoint:CGPointMake(self.center.x,self.frame.origin.y +  self.frame.size.height - subHeight)];
    [self.animator addBehavior:snap];
     */
 
}

- (void)snapIn
{
    /*
    [self.animator removeAllBehaviors];
    UISnapBehavior *snap            = [[UISnapBehavior alloc] initWithItem:self.upLabel snapToPoint:self.center];
    snap.action = ^{
        CGPoint content = self.upLabel.center;
        CGPoint view = self.center;
        if (CGPointEqualToPoint(content, view)) {
            self.upLabel.hidden = YES;
        };
    };
    [self.animator addBehavior:snap];
    snap = [[UISnapBehavior alloc] initWithItem:self.downLabel snapToPoint:self.center];
    snap.action = ^{
        CGPoint content = self.upLabel.center;
        CGPoint view = self.center;
        if (CGPointEqualToPoint(content, view)) {
            self.downLabel.hidden = YES;
        };
    };
    [self.animator addBehavior:snap];
     */
}


@end
