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
        CGFloat subHeight   = self.bounds.size.height/4;
        CGFloat width       = self.bounds.size.width;
        
        UIView *greenContainer          = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.origin.x,self.bounds.origin.y + subHeight, width, subHeight)];
        greenContainer.backgroundColor  = [UIColor greenColor];
        [self addSubview:greenContainer];
        
        UIView *redContainer            = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.origin.x,self.bounds.origin.y + subHeight * 2, width, subHeight)];
        redContainer.backgroundColor    = [UIColor redColor];
        [self addSubview:redContainer];
        
        // Top
        self.upLabel                = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y + subHeight, width, subHeight)];
        self.upLabel.text           = @"Ok";
        self.upLabel.textAlignment  = NSTextAlignmentCenter;
        self.upLabel.center         = CGPointMake(self.bounds.origin.x + self.bounds.size.width/2, self.bounds.origin.y + self.bounds.size.height/2);
        [self addSubview:self.upLabel];
        // Down
        self.downLabel                  = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.origin.x, self.bounds.origin.y + subHeight * 2, width, subHeight)];
        self.downLabel.text             = @"Cancel";
        self.downLabel.textAlignment    = NSTextAlignmentCenter;
        self.downLabel.center           = self.center;
        [self addSubview:self.downLabel];
    }
    return self;
}

- (void)setScrollViewOffset:(CGFloat)scrollViewOffset
{
    _scrollViewOffset   = scrollViewOffset;
    CGFloat centerX     = self.bounds.origin.x + self.bounds.size.width/2;
    CGFloat fourth      = self.bounds.size.height/4;
    CGFloat upLabelY    = self.bounds.origin.y + self.upLabel.bounds.size.height/2;
    CGFloat downLabelY  = self.bounds.size.height - self.downLabel.bounds.size.height/2;
    
    if (scrollViewOffset > 0) {
        if (scrollViewOffset < fourth) {
            self.upLabel.center     = CGPointMake(centerX, upLabelY + scrollViewOffset);
            self.isReadyToLaunch    = NO;
        }
        else {
            self.isReadyToLaunch    = YES;
            self.upLabel.center     = CGPointMake(centerX, upLabelY + fourth);
        }
    }
    else {
        self.upLabel.center     = CGPointMake(centerX, upLabelY);
    }
    if (scrollViewOffset <= 0) {
        if (scrollViewOffset > (self.bounds.size.height/4) * -1) {
            self.downLabel.center   = CGPointMake(centerX, downLabelY + scrollViewOffset);
            self.isReadyToLaunch    = NO;
        }
        else {
            self.downLabel.center   = CGPointMake(centerX, downLabelY - fourth);
            self.isReadyToLaunch    = YES;
        }
    }
    else {
        self.downLabel.center   = CGPointMake(centerX, downLabelY);
    }
}

- (void)snapOut:(BOOL)animated
{
    // Determine if all ready out
    CGPoint viewCenter = CGPointMake(self.bounds.origin.x + self.bounds.size.width/2, self.bounds.origin.y + self.bounds.size.height/2);
    if (!CGPointEqualToPoint(viewCenter, self.upLabel.center) || self.isLaunching) return;
    
    self.upLabel.center = CGPointMake(self.bounds.origin.x + self.bounds.size.width/2, self.bounds.origin.y + self.bounds.size.height/2);
    
    if (animated) {
        [UIView animateWithDuration:0.1 animations:^{
            self.upLabel.center = CGPointMake(self.bounds.origin.x + self.bounds.size.width/2, self.bounds.origin.y + self.upLabel.bounds.size.height/2);
            self.downLabel.center = CGPointMake(self.bounds.origin.x + self.bounds.size.width/2, self.bounds.size.height - self.upLabel.bounds.size.height/2);
        }];
    }
    else {
        self.upLabel.center = CGPointMake(self.bounds.origin.x + self.bounds.size.width/2, self.bounds.origin.y + self.upLabel.bounds.size.height/2);
        self.downLabel.center = CGPointMake(self.bounds.origin.x + self.bounds.size.width/2, self.bounds.size.height - self.upLabel.bounds.size.height/2);
    }
}

- (void)snapIn:(BOOL)animated
{
    // Determine if all ready in
    CGPoint viewCenter = CGPointMake(self.bounds.origin.x + self.bounds.size.width/2, self.bounds.origin.y + self.bounds.size.height/2);
    if (CGPointEqualToPoint(viewCenter, self.upLabel.center) || self.isLaunching) return;
    
    if (animated) {
        [UIView animateWithDuration:0.4 animations:^{
            self.upLabel.center     = CGPointMake(self.bounds.origin.x + self.bounds.size.width/2, self.bounds.origin.y + self.bounds.size.height/2);
            self.downLabel.center   = CGPointMake(self.bounds.origin.x + self.bounds.size.width/2, self.bounds.origin.y + self.bounds.size.height/2);
        }];
    }
    else {
        self.upLabel.center     = CGPointMake(self.bounds.origin.x + self.bounds.size.width/2, self.bounds.origin.y + self.bounds.size.height/2);
        self.downLabel.center   = CGPointMake(self.bounds.origin.x + self.bounds.size.width/2, self.bounds.origin.y + self.bounds.size.height/2);
    }
}

@end
