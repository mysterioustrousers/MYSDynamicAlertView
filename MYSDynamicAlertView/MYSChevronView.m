//
//  MYSChevronView.m
//  Pods
//
//  Created by Matt Bettinson on 2014-06-25.
//
//

#import "MYSChevronView.h"


#define CHEVRON_WHITE 0.85
#define CHEVRON_WHITE_MAX 0.95
#define CHEVRON_WHITE_MIN 0.65


@interface MYSChevronView ()
@end


@implementation MYSChevronView


- (void)drawRect:(CGRect)rect
{
    // Perhaps in the future make the chevron draw more to match the size of rect, but this is fine for what its used for.
    CGFloat width   = 30;
    CGFloat height  = 4;
    CGFloat offset  = 10;
    CGFloat thick   = 6.5;
    [[UIColor colorWithWhite:self.whiteColorLevel alpha:1.0] setStroke];
    UIBezierPath *chevronPath = [self chevron:CGRectMake(rect.origin.x + rect.size.width/2 - width/2,  offset, width, height) direction:self.direction];
    [chevronPath setLineWidth:thick];
    [chevronPath stroke];
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




#pragma mark - Setter

- (void)setWhiteColorLevel:(CGFloat)whiteColorLevel
{
    _whiteColorLevel = whiteColorLevel;
    [self setNeedsDisplay];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
