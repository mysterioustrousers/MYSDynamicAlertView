//
//  MYSBackDropView.m
//  Pods
//
//  Created by Dan Willoughby on 6/16/14.
//
//

#define ALPHA 0.4
#define ALPHA_LAUNCH 1.0


#import "MYSBackDropView.h"


@interface MYSBackDropView ()
@property (nonatomic, strong) UIView *greenView;
@property (nonatomic, strong) UIView *redView;
@property (nonatomic, assign) CGFloat fourthHeight;
@property (nonatomic, assign) CGFloat launchTargetRectHeight;
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
        if (self.greenView == nil) {
            self.greenView                      = [[UIView alloc] init];
            self.greenView.layer.cornerRadius   = 15;
            [self addSubview:self.greenView];
        }
        
        if (self.redView == nil) {
            self.redView                    = [[UIView alloc] init];
            self.redView.layer.cornerRadius = 15;
            [self addSubview:self.redView];
        }
        
        // Top
        if (self.upLabel == nil) {
            self.upLabel               = [[UILabel alloc] init];
            self.upLabel.textAlignment = NSTextAlignmentCenter;
            self.upLabel.textColor     = [UIColor whiteColor];
            self.upLabel.font          = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
            [self addSubview:self.upLabel];
        }
        // Down
        if (self.downLabel == nil) {
            self.downLabel               = [[UILabel alloc] init];
            self.downLabel.textAlignment = NSTextAlignmentCenter;
            self.downLabel.textColor     = [UIColor whiteColor];
            self.downLabel.font          = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
            [self addSubview:self.downLabel];
        }
    }
    return self;
}

- (void)layoutSubviews
{
    CGRect bounds               = self.bounds;
    self.fourthHeight           = bounds.size.height/4;
    self.width                  = bounds.size.width;
    CGFloat centerY             = bounds.origin.y + bounds.size.height/2;
    self.launchTargetRectHeight = 44;
    
    self.greenView.backgroundColor  = [self darkerColorForColor:[UIColor greenColor]];
    self.greenView.frame            = CGRectMake(bounds.origin.x, centerY - self.fourthHeight, self.width, self.launchTargetRectHeight);
    
    self.redView.backgroundColor    = [self darkerColorForColor:[UIColor redColor]];
    self.redView.frame              = CGRectMake(bounds.origin.x, centerY + self.fourthHeight - self.launchTargetRectHeight, self.width, self.launchTargetRectHeight);
    
    // Top
    self.upLabel.frame      = CGRectMake(bounds.origin.x, bounds.origin.y + self.fourthHeight, self.width, self.launchTargetRectHeight/2);
    self.upLabelSnappedIn   = CGPointMake(bounds.origin.x + bounds.size.width/2, centerY - self.fourthHeight + self.upLabel.bounds.size.height/2);
    self.upLabelSnappedOut  = CGPointMake(bounds.origin.x + bounds.size.width/2, centerY - self.fourthHeight - self.upLabel.bounds.size.height);
    self.upLabel.center     = self.upLabelSnappedIn;
    // Down
    self.downLabel.frame        = CGRectMake(bounds.origin.x, bounds.origin.y, self.width, self.launchTargetRectHeight/2);
    self.downLabelSnappedIn     = CGPointMake(bounds.origin.x + bounds.size.width/2, centerY + self.fourthHeight - self.upLabel.bounds.size.height/2);
    self.downLabelSnappedOut    = CGPointMake(bounds.origin.x + bounds.size.width/2, centerY + self.fourthHeight + self.upLabel.bounds.size.height );
    self.downLabel.center       = self.downLabelSnappedIn;
}

- (void)setScrollViewOffset:(CGFloat)scrollViewOffset
{
    _scrollViewOffset   = scrollViewOffset;
    CGFloat centerY     = self.bounds.origin.y + self.bounds.size.height/2;
    CGFloat centerX     = self.bounds.origin.x + self.bounds.size.width/2;
    CGFloat fourth      = self.fourthHeight;
    CGFloat upLabelY    = centerY - fourth - self.upLabel.bounds.size.height;
    CGFloat downLabelY  = centerY + fourth +  self.downLabel.bounds.size.height;
    
    if (scrollViewOffset > 0) {
        self.greenView.hidden   = NO;
        self.redView.hidden     = YES;
        self.upLabel.hidden     = NO;
        if (scrollViewOffset < self.launchTargetRectHeight) {
            self.upLabel.center     = CGPointMake(centerX, upLabelY + scrollViewOffset);
            self.downLabel.hidden   = NO;
            self.isReadyToLaunch    = NO;
            [UIView animateWithDuration:0.4 animations:^{
                self.greenView.backgroundColor  = [self darkerColorForColor:[UIColor greenColor]];
            }];
        }
        else {
            self.isReadyToLaunch    = YES;
            self.direction          = MYSDynamicAlertViewDirectionUp;
            self.downLabel.hidden   = YES;
            self.upLabel.center     = CGPointMake(centerX, upLabelY + self.launchTargetRectHeight );
            [UIView animateWithDuration:0.4 animations:^{
                self.greenView.backgroundColor  = [UIColor greenColor];
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
        if (scrollViewOffset > self.launchTargetRectHeight * -1) {
            self.downLabel.center   = CGPointMake(centerX, downLabelY + scrollViewOffset);
            self.upLabel.hidden     = NO;
            self.isReadyToLaunch    = NO;
            [UIView animateWithDuration:0.4 animations:^{
                self.redView.backgroundColor    = [self darkerColorForColor:[UIColor redColor]];
            }];
        }
        else {
            self.downLabel.center   = CGPointMake(centerX, downLabelY - self.launchTargetRectHeight);
            self.upLabel.hidden     = YES;
            self.isReadyToLaunch    = YES;
            self.direction          = MYSDynamicAlertViewDirectionDown;
            [UIView animateWithDuration:0.4 animations:^{
                self.redView.backgroundColor    = [UIColor redColor];
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
    
    self.greenView.backgroundColor  = [self darkerColorForColor:[UIColor greenColor]];
    self.redView.backgroundColor    = [self darkerColorForColor:[UIColor redColor]];
    self.upLabel.hidden             = NO;
    self.downLabel.hidden           = NO;
    
    if (animated) {
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.3 initialSpringVelocity:20 options:0
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




#pragma mark - Private

- (UIColor *)lighterColorForColor:(UIColor *)c
{
    CGFloat r, g, b, a;
    if ([c getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MIN(r + 0.2, 1.0)
                               green:MIN(g + 0.2, 1.0)
                                blue:MIN(b + 0.2, 1.0)
                               alpha:a];
    return nil;
}

- (UIColor *)darkerColorForColor:(UIColor *)c
{
    CGFloat r, g, b, a;
    if ([c getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MAX(r - 0.2, 0.0)
                               green:MAX(g - 0.2, 0.0)
                                blue:MAX(b - 0.2, 0.0)
                               alpha:a];
    return nil;
}

@end
