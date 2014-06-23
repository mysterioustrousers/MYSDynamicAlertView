//
//  MYSContentView.m
//  Pods
//
//  Created by Dan Willoughby on 6/17/14.
//
//

#define CHEVRON_WHITE 0.85
#define CHEVRON_WHITE_MAX 0.95
#define CHEVRON_WHITE_MIN 0.65

#import "MYSContentView.h"
#import "MYSDynamicAlertViewController.h"


@interface MYSContentView ()
@property (nonatomic, assign) CGFloat topChevronWhite;
@property (nonatomic, assign) CGFloat bottomChevronWhite;
@end


@implementation MYSContentView

- (id)initWithFrame:(CGRect)aRect
{
    if ((self = [super initWithFrame:aRect])) {
        self.userInteractionEnabled = NO;                                               // scrollView deals with touches
        self.backgroundColor        = [UIColor groupTableViewBackgroundColor];
        self.topChevronWhite        = CHEVRON_WHITE;
        self.bottomChevronWhite     = CHEVRON_WHITE;
        
        CGFloat height = self.frame.size.height;
        self.messageLabel               = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width,height/2)];
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.messageLabel];
        
        self.messageLabel.numberOfLines = 0;
        self.messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.messageLabel.font = [UIFont systemFontOfSize:18];
        //self.messageLabel.preferredMaxLayoutWidth = 200;
        
        [self.messageLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [self.messageLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [self.messageLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:self.messageLabel];
        UILabel *messageLabel = self.messageLabel;
        //self.messageLabel.backgroundColor = [UIColor blueColor];
        [messageLabel sizeToFit];
        
        
        NSArray* constrs = [NSLayoutConstraint constraintsWithVisualFormat:@"|-[messageLabel]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(messageLabel)];
        [self addConstraints:constrs];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[messageLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(messageLabel)]];
        [self.messageLabel addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[messageLabel(200@300)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(messageLabel)]];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    CGFloat width   = 30;
    CGFloat height  = 4;
    CGFloat offset  = 10;
    CGFloat thick   = 6.5;
    [[UIColor colorWithWhite:self.topChevronWhite alpha:1.0] setStroke];
    UIBezierPath *upChevronPath = [self chevron:CGRectMake(rect.origin.x + rect.size.width/2 - width/2,  offset, width, height) direction:MYSDynamicAlertViewDirectionUp];
    [upChevronPath setLineWidth:thick];
    [upChevronPath stroke];
    
    [[UIColor colorWithWhite:self.bottomChevronWhite alpha:1.0] setStroke];
    UIBezierPath *downChevronPath = [self chevron:CGRectMake(rect.origin.x + rect.size.width/2 - width/2, rect.size.height - height - offset, width, height) direction:MYSDynamicAlertViewDirectionDown];
    [downChevronPath setLineWidth:thick];
    [downChevronPath stroke];
}

- (void)setScrollViewOffset:(CGFloat)scrollViewOffset
{
    _scrollViewOffset = scrollViewOffset;
    CGFloat fraction = fabs(scrollViewOffset) * 0.005;
    CGFloat darker  = CHEVRON_WHITE - fraction;
    CGFloat lighter = CHEVRON_WHITE + fraction;
    
    if (lighter > CHEVRON_WHITE_MAX)
        lighter = CHEVRON_WHITE_MAX;
    if (darker < CHEVRON_WHITE_MIN)
        darker = CHEVRON_WHITE_MIN;
    
    if (scrollViewOffset > 0) {
        self.bottomChevronWhite= lighter;
        self.topChevronWhite   =darker;
    }
    else if (scrollViewOffset < -1) {
        self.bottomChevronWhite= darker;
        self.topChevronWhite   = lighter;
    }
    else {
        self.bottomChevronWhite= CHEVRON_WHITE;
        self.topChevronWhite   = CHEVRON_WHITE;
    }
    [self setNeedsDisplay];
}



#pragma mark - private

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

@end
