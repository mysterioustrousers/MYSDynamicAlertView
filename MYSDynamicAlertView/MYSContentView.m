//
//  MYSContentView.m
//  Pods
//
//  Created by Dan Willoughby on 6/17/14.
//
//

#import "MYSContentView.h"
#import "MYSDynamicAlertViewController.h"

@implementation MYSContentView

- (id)initWithFrame:(CGRect)aRect
{
    if ((self = [super initWithFrame:aRect])) {
        self.userInteractionEnabled = NO;                                           // scrollView deals with touches
        self.backgroundColor        = [UIColor groupTableViewBackgroundColor];
        
        CGFloat height = self.frame.size.height;
        self.messageLabel   = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width,height)];
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.messageLabel];
    }
    return self;
}



- (UIBezierPath *)chevron:(CGRect)frame direction:(MYSDynamicAlertViewDirection)direction
{
    UIBezierPath* bezierPath = [[UIBezierPath alloc]init];
    switch (direction) {
        case MYSDynamicAlertViewDirectionUp:
            [bezierPath setLineJoinStyle:kCGLineJoinRound];
            [bezierPath setLineCapStyle:kCGLineCapRound];
            [bezierPath moveToPoint:CGPointMake(CGRectGetMinX(frame), CGRectGetMaxY(frame))];
            [bezierPath addLineToPoint:CGPointMake(frame.origin.x + frame.size.width/2, frame.origin.y)];
            [bezierPath addLineToPoint:CGPointMake(CGRectGetMaxX(frame), CGRectGetMaxY(frame))];
            break;
            
        case MYSDynamicAlertViewDirectionDown:
            [bezierPath setLineJoinStyle:kCGLineJoinRound];
            [bezierPath setLineCapStyle:kCGLineCapRound];
            [bezierPath moveToPoint:CGPointMake(CGRectGetMinX(frame), CGRectGetMinY(frame))];
            [bezierPath addLineToPoint:CGPointMake(frame.origin.x + frame.size.width/2, frame.origin.y + frame.size.height)];
            [bezierPath addLineToPoint:CGPointMake(CGRectGetMaxX(frame), CGRectGetMinY(frame))];
            break;
            
        default:
            [bezierPath setLineJoinStyle:kCGLineJoinRound];
            [bezierPath setLineCapStyle:kCGLineCapRound];
            [bezierPath moveToPoint:CGPointMake(CGRectGetMinX(frame), CGRectGetMaxY(frame))];
            [bezierPath addLineToPoint:CGPointMake(CGRectGetMaxX(frame), CGRectGetMaxY(frame))];
            break;
    }
    return bezierPath;
}

-(void)drawRect:(CGRect)rect{
    CGFloat width = 30;
    CGFloat height = 4;
    CGFloat offset = 10;
    CGFloat thick = 6.5;
    [[UIColor redColor] setStroke];
    [[UIColor colorWithWhite:0.0 alpha:0.4] setStroke];
    UIBezierPath *upChevronPath = [self chevron:CGRectMake(rect.origin.x + rect.size.width/2 - width/2,  offset, width, height) direction:MYSDynamicAlertViewDirectionUp];
    [upChevronPath setLineWidth:thick];
    [upChevronPath stroke];
    UIBezierPath *downChevronPath = [self chevron:CGRectMake(rect.origin.x + rect.size.width/2 - width/2, rect.size.height - height - offset, width, height) direction:MYSDynamicAlertViewDirectionDown];
    [downChevronPath setLineWidth:thick];
    [downChevronPath stroke];
}

@end
