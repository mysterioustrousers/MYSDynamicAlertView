//
//  MYSDynamicContentView.m
//  Pods
//
//  Created by Dan Willoughby on 6/16/14.
//
//

#import "MYSTouchScrollView.h"

@interface MYSTouchScrollView ()
@property (nonatomic, strong) NSDate *start;
@property (nonatomic, strong) NSDate *end;
@end

@implementation MYSTouchScrollView

- (id)initWithFrame:(CGRect)aRect
{
    if ((self = [super initWithFrame:aRect])) {
        self.backgroundColor    = [UIColor clearColor];
        self.scrollEnabled      = YES;
        self.self.contentSize   = CGSizeMake(self.bounds.size.width, self.bounds.size.height + 1);
    }
    return self;
}




# pragma mark - touches

// handle the touches of the content view and scrolling
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch          = [touches anyObject];
    CGPoint pointOfContact  = [touch locationInView:self];
    pointOfContact          = [self.contentView convertPoint:pointOfContact fromView:self];
    
    if (CGRectContainsPoint(self.contentView.bounds, pointOfContact)) {
        [self.touchDelegate contentViewPressed:event];
        [self startTimer];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // do some button debouncing
        [self stopTimer];
        double time = [self timeElapsedInSeconds];
        if (time > 0.8) {
            [self.touchDelegate contentViewEndTap:event];
        }
    });
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // Only scroll when touching contentView
    CGPoint pointOfContact  = [gestureRecognizer locationInView:self];
    pointOfContact          = [self.contentView convertPoint:pointOfContact fromView:self];
    return (CGRectContainsPoint(self.contentView.bounds, pointOfContact));
}




# pragma mark - private

- (void) startTimer
{
    self.start = [NSDate date];
}

- (void) stopTimer
{
    self.end = [NSDate date];
}

- (double) timeElapsedInSeconds
{
    return [self.end timeIntervalSinceDate:self.start];
}

@end
