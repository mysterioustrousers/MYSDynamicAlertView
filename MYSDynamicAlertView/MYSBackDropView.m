//
//  MYSBackDropView.m
//  Pods
//
//  Created by Dan Willoughby on 6/16/14.
//
//

#define ALPHA 0.4
#define ALPHA_LAUNCH 0.9


#import "MYSBackDropView.h"


@interface MYSBackDropView ()
@property (nonatomic, strong) UIView *greenView;
@property (nonatomic, strong) UIView *redView;
@property (nonatomic, assign) CGFloat fourthHeight;
@property (nonatomic, assign) CGFloat eigthHeight;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGPoint upLabelSnappedIn;
@property (nonatomic, assign) CGPoint downLabelSnappedIn;
@property (nonatomic, assign) CGPoint upLabelSnappedOut;
@property (nonatomic, assign) CGPoint downLabelSnappedOut;
@end


@implementation MYSBackDropView


- (id)initWithFrame:(CGRect)aRect
{
    if ((self = [super initWithFrame:aRect])) {
        // To debug set the background color of self, upLabel, and downLabel to a solid color and set MYSContentView to clearColor
    }
    return self;
}

- (void)layoutSubviews
{
        CGRect bounds = self.bounds;
        self.fourthHeight   = bounds.size.height/4;
        self.eigthHeight    = bounds.size.height/8;
        self.width          = bounds.size.width;
        
        if (self.greenView == nil) {
            self.greenView                      = [[UIView alloc] init];
            [self addSubview:self.greenView];
            self.greenView.layer.cornerRadius   = 15;
        }
        self.greenView.backgroundColor      = [[UIColor greenColor] colorWithAlphaComponent:ALPHA];
        self.greenView.frame = CGRectMake(bounds.origin.x,bounds.origin.y + self.fourthHeight, self.width, self.fourthHeight);
        
        if (self.redView == nil) {
            self.redView                    = [[UIView alloc] init];
            self.redView.layer.cornerRadius = 15;
            [self addSubview:self.redView];
        }
        self.redView.backgroundColor    = [[UIColor redColor] colorWithAlphaComponent:ALPHA];
        self.redView.frame              = CGRectMake(bounds.origin.x,bounds.origin.y + self.fourthHeight * 2, self.width, self.fourthHeight);
        
        // Top
        if (self.upLabel == nil) {
            self.upLabel               = [[UILabel alloc] init];
            self.upLabel.text          = @"Ok";
            self.upLabel.textAlignment = NSTextAlignmentCenter;
            self.upLabel.textColor     = [UIColor whiteColor];
            self.upLabel.font          = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
            [self addSubview:self.upLabel];
        }
        self.upLabel.frame = CGRectMake(bounds.origin.x, bounds.origin.y + self.fourthHeight, self.width, self.eigthHeight);
        self.upLabelSnappedIn           = CGPointMake(bounds.origin.x + bounds.size.width/2, bounds.origin.y + self.fourthHeight + self.upLabel.bounds.size.height/2);
        self.upLabelSnappedOut          = CGPointMake(bounds.origin.x + bounds.size.width/2, bounds.origin.y + self.upLabel.bounds.size.height);
        self.upLabel.center             = self.upLabelSnappedIn;
        // Down
        if (self.downLabel == nil) {
            self.downLabel               = [[UILabel alloc] init];
            self.downLabel.text          = @"Cancel";
            self.downLabel.textAlignment = NSTextAlignmentCenter;
            self.downLabel.textColor     = [UIColor whiteColor];
            self.downLabel.font          = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
            [self addSubview:self.downLabel];
        }
        self.downLabel.frame     = CGRectMake(bounds.origin.x, bounds.origin.y + self.eigthHeight * 2, self.width, self.eigthHeight);
        self.downLabelSnappedIn  = CGPointMake(bounds.origin.x + bounds.size.width/2, bounds.origin.y + bounds.size.height - self.fourthHeight - self.upLabel.bounds.size.height/2);
        self.downLabelSnappedOut = CGPointMake(bounds.origin.x + bounds.size.width/2, bounds.size.height - self.upLabel.bounds.size.height);
        self.downLabel.center    = self.downLabelSnappedIn;
}

- (void)setScrollViewOffset:(CGFloat)scrollViewOffset
{
    _scrollViewOffset   = scrollViewOffset;
    CGFloat centerX     = self.bounds.origin.x + self.bounds.size.width/2;
    CGFloat fourth      = self.fourthHeight;
    CGFloat upLabelY    = self.bounds.origin.y + self.upLabel.bounds.size.height;
    CGFloat downLabelY  = self.bounds.size.height - self.downLabel.bounds.size.height;
    
    if (scrollViewOffset > 0) {
        self.greenView.hidden   = NO;
        self.redView.hidden     = YES;
        self.upLabel.hidden     = NO;
        if (scrollViewOffset < fourth) {
            self.upLabel.center     = CGPointMake(centerX, upLabelY + scrollViewOffset);
            self.downLabel.hidden   = NO;
            self.isReadyToLaunch    = NO;
            [UIView animateWithDuration:0.4 animations:^{
                self.greenView.backgroundColor  = [[UIColor greenColor] colorWithAlphaComponent:ALPHA];
            }];
        }
        else {
            self.isReadyToLaunch    = YES;
            self.direction          = MYSDynamicAlertViewDirectionUp;
            self.downLabel.hidden   = YES;
            self.upLabel.center     = CGPointMake(centerX, upLabelY + fourth);
            [UIView animateWithDuration:0.4 animations:^{
                self.greenView.backgroundColor  = [[UIColor greenColor] colorWithAlphaComponent:ALPHA_LAUNCH];
            }];
        }
    }
    else {
        self.upLabel.center     = self.upLabelSnappedOut;
    }
    if (scrollViewOffset <= 0) {
        self.greenView.hidden   = YES;
        self.redView.hidden     = NO;
        self.downLabel.hidden   = NO;
        if (scrollViewOffset > fourth * -1) {
            self.downLabel.center   = CGPointMake(centerX, downLabelY + scrollViewOffset);
            self.upLabel.hidden     = NO;
            self.isReadyToLaunch    = NO;
            [UIView animateWithDuration:0.4 animations:^{
                self.redView.backgroundColor    = [[UIColor redColor] colorWithAlphaComponent:ALPHA];
            }];
        }
        else {
            self.downLabel.center   = CGPointMake(centerX, downLabelY - fourth);
            self.upLabel.hidden     = YES;
            self.isReadyToLaunch    = YES;
            self.direction          = MYSDynamicAlertViewDirectionDown;
            [UIView animateWithDuration:0.4 animations:^{
                self.redView.backgroundColor    = [[UIColor redColor] colorWithAlphaComponent:ALPHA_LAUNCH];
            }];
        }
    }
    else {
        self.downLabel.center   = self.downLabelSnappedOut;
    }
}

- (void)snapOut:(BOOL)animated
{
    // Determine if all ready out
    if (CGPointEqualToPoint(self.upLabel.center,self.upLabelSnappedOut) || self.isLaunching) return;
    
    self.greenView.backgroundColor  = [[UIColor greenColor] colorWithAlphaComponent:ALPHA];
    self.redView.backgroundColor    = [[UIColor redColor] colorWithAlphaComponent:ALPHA];
    self.upLabel.hidden             = NO;
    self.downLabel.hidden           = NO;
    
    if (animated) {
        [UIView animateWithDuration:1.4 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:10 options:0
                         animations:^{
                             self.upLabel.hidden    = NO;
                             self.downLabel.hidden  = NO;
                             self.upLabel.center    = self.upLabelSnappedOut;
                             self.downLabel.center  = self.downLabelSnappedOut;
                         } completion:nil];
    }
    else {
        self.upLabel.center     = self.upLabelSnappedOut;
        self.downLabel.center   = self.downLabelSnappedOut;
    }
}

- (void)snapIn:(BOOL)animated
{
    if (self.isLaunching) return;
    
    if (animated) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.upLabel.center        = self.upLabelSnappedIn;
                             self.downLabel.center      = self.downLabelSnappedIn;
                         } completion:^(BOOL completed) {
                             //self.upLabel.hidden     = YES;
                             //self.downLabel.hidden   = YES;
                         }];
    }
    else {
        self.upLabel.center     = self.upLabelSnappedIn;
        self.downLabel.center   = self.downLabelSnappedIn;
    }
}

@end
