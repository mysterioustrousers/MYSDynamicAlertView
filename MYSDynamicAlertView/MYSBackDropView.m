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
@end


@implementation MYSBackDropView


- (id)initWithFrame:(CGRect)aRect
{
    if ((self = [super initWithFrame:aRect])) {
        CGFloat subHeight   = self.bounds.size.height/4;
        CGFloat width       = self.bounds.size.width;
        
        self.greenView                      = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.origin.x,self.bounds.origin.y + subHeight, width, subHeight)];
        self.greenView.backgroundColor      = [[UIColor greenColor] colorWithAlphaComponent:ALPHA];
        self.greenView.layer.cornerRadius   = 15;
        [self addSubview:self.greenView];
        
        self.redView                    = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.origin.x,self.bounds.origin.y + subHeight * 2, width, subHeight)];
        self.redView.backgroundColor    = [[UIColor redColor] colorWithAlphaComponent:ALPHA];
        self.redView.layer.cornerRadius = 15;
        [self addSubview:self.redView];
        
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
            self.isReadyToLaunch            = YES;
            self.downLabel.hidden           = YES;
            self.upLabel.center             = CGPointMake(centerX, upLabelY + fourth);
            [UIView animateWithDuration:0.4 animations:^{
                self.greenView.backgroundColor  = [[UIColor greenColor] colorWithAlphaComponent:ALPHA_LAUNCH];
            }];
        }
    }
    else {
        self.upLabel.center     = CGPointMake(centerX, upLabelY);
    }
    if (scrollViewOffset <= 0) {
        self.greenView.hidden   = YES;
        self.redView.hidden     = NO;
        self.downLabel.hidden   = NO;
        if (scrollViewOffset > (self.bounds.size.height/4) * -1) {
            self.downLabel.center   = CGPointMake(centerX, downLabelY + scrollViewOffset);
            self.upLabel.hidden     = NO;
            self.isReadyToLaunch    = NO;
            [UIView animateWithDuration:0.4 animations:^{
                self.redView.backgroundColor    = [[UIColor redColor] colorWithAlphaComponent:ALPHA];
            }];
        }
        else {
            self.downLabel.center           = CGPointMake(centerX, downLabelY - fourth);
            self.upLabel.hidden             = YES;
            self.isReadyToLaunch            = YES;
            [UIView animateWithDuration:0.4 animations:^{
                self.redView.backgroundColor    = [[UIColor redColor] colorWithAlphaComponent:ALPHA_LAUNCH];
            }];
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
    
    self.upLabel.center             = CGPointMake(self.bounds.origin.x + self.bounds.size.width/2, self.bounds.origin.y + self.bounds.size.height/2);
    self.greenView.backgroundColor  = [[UIColor greenColor] colorWithAlphaComponent:ALPHA];
    self.redView.backgroundColor    = [[UIColor redColor] colorWithAlphaComponent:ALPHA];
    self.upLabel.hidden             = NO;
    self.downLabel.hidden           = NO;
    
    if (animated) {
        [UIView animateWithDuration:1.4 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:10 options:0
                         animations:^{
                             self.upLabel.hidden    = NO;
                             self.downLabel.hidden  = NO;
                             self.upLabel.center    = CGPointMake(self.bounds.origin.x + self.bounds.size.width/2, self.bounds.origin.y + self.upLabel.bounds.size.height/2);
                             self.downLabel.center  = CGPointMake(self.bounds.origin.x + self.bounds.size.width/2, self.bounds.size.height - self.upLabel.bounds.size.height/2);
                         } completion:nil];
    }
    else {
        self.upLabel.center     = CGPointMake(self.bounds.origin.x + self.bounds.size.width/2, self.bounds.origin.y + self.upLabel.bounds.size.height/2);
        self.downLabel.center   = CGPointMake(self.bounds.origin.x + self.bounds.size.width/2, self.bounds.size.height - self.upLabel.bounds.size.height/2);
    }
}

- (void)snapIn:(BOOL)animated
{
    if (self.isLaunching) return;
    
    if (animated) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.upLabel.center        = CGPointMake(self.bounds.origin.x + self.bounds.size.width/2, self.bounds.origin.y + self.bounds.size.height/2);
                             self.downLabel.center      = CGPointMake(self.bounds.origin.x + self.bounds.size.width/2, self.bounds.origin.y + self.bounds.size.height/2);
                         } completion:^(BOOL completed) {
                             self.upLabel.hidden     = YES;
                             self.downLabel.hidden   = YES;
                         }];
    }
    else {
        self.upLabel.center     = CGPointMake(self.bounds.origin.x + self.bounds.size.width/2, self.bounds.origin.y + self.bounds.size.height/2);
        self.downLabel.center   = CGPointMake(self.bounds.origin.x + self.bounds.size.width/2, self.bounds.origin.y + self.bounds.size.height/2);
    }
}





@end
