//
//  MYSDynamicContentView.m
//  Pods
//
//  Created by Dan Willoughby on 6/16/14.
//
//

#import "MYSTouchScrollView.h"


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
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.touchDelegate contentViewEndTap:event];
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    // Only scroll when touching contentView
    CGPoint pointOfContact  = [gestureRecognizer locationInView:self];
    pointOfContact          = [self.contentView convertPoint:pointOfContact fromView:self];
    return (CGRectContainsPoint(self.contentView.bounds, pointOfContact));
}

@end
